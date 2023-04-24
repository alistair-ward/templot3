
(*
    This file is part of OpenTemplot, a computer program for the design of
    model railway track.

    Copyright (C) 2019  OpenTemplot project contributors

    This program is free software: you may redistribute it and/or modify
    it under the terms of the GNU General Public Licence as published by
    the Free Software Foundation, either version 3 of the Licence, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU General Public Licence for more details.

    You should have received a copy of the GNU General Public Licence
    along with this program. See the files: licence.txt or opentemplot.lpr

    Or if not, refer to the web site: https://www.gnu.org/licenses/

                >>>     NOTE TO DEVELOPERS     <<<
                     DO NOT EDIT THIS COMMENT
              It is inserted in this file by running
                  'python3 scripts/addComment.py'
         The original text lives in scripts/addComment.py.

====================================================================================
*)

unit t2box_unit;          // Loading a Templot2 '.box' format

{$MODE Delphi}

{$ALIGN OFF}

interface

uses
  Classes,
  Dialogs,
  Forms,
  TLoggerUnit;

type
  Tt2box_form = class(TForm)
    load_t2box_dialog: TOpenDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  t2box_form: Tt2box_form;
  t2box_log: ILogger;

//function import_t2box(file_name: string): boolean; // 290a
function import_t2box(normal_load: boolean; file_name: string;
  make_lib: boolean; var append: boolean;
  var last_bgnd_loaded_index: integer): boolean;

//______________________________________________________________________________

implementation

uses
  Messages, SysUtils, Graphics, Controls,

  alert_unit,
  box_file_unit,
  config_unit,
  control_room,
  help_sheet,
  info_unit,
  keep_select,
  math_unit,
  pad_unit,
  rail_options_unit,
  shove_timber,
  shoved_timber,
  t2box_parsers_unit,
  template_records,
  template,
  wait_message,
  OTUndoRedoManager;


{$R *.lfm}

type
  TShoveData = record     // shove data for a single timber ( version 0.71 11-4-01 ).

    sv_code: TShoveCode;
    sv_x: double;    // xtb modifier.
    sv_k: double;    // angle modifier.
    sv_o: double;    // offset modifier (near end).
    sv_l: double;    // length modifier (far end).
    sv_w: double;    // width modifier (per side).
    sv_c: double;    // crab modifier.  0.78.c  01-02-03.
    sv_t: double;    // spare (thickness 3-D modifier - nyi).

    alignment_byte_1: byte;   // D5 0.81 12-06-05
    alignment_byte_2: byte;   // D5 0.81 12-06-05

    sv_sp_int: integer;     // spare integer.

  end;//record

  Tshove_for_file = record    // Used in the SHOVE DATA BLOCKS in the 071 files.
    // But not used within the program - see Ttimber_shove.shove_data instead.
    // Conversion takes place in 071 on loading.

    sf_str: string[6];           // timber number string.

    alignment_byte_1: byte;   // D5 0.81 12-06-05

    sf_shove_data: TShoveData;  // all the data.

    procedure copy_from(src: TShovedTimber);
    procedure copy_to(dest: TShovedTimber);

  end;//record


procedure Tshove_for_file.copy_from(src: TShovedTimber);
begin
  sf_str := src.timberString;
  sf_shove_data.sv_code := src.shoveCode;
  sf_shove_data.sv_x := src.xtbModifier;
  sf_shove_data.sv_k := src.angleModifier;
  sf_shove_data.sv_o := src.offsetModifier;
  sf_shove_data.sv_l := src.lengthModifier;
  sf_shove_data.sv_w := src.widthModifier;
  sf_shove_data.sv_c := src.crabModifier;
  sf_shove_data.sv_t := 0;
  sf_shove_data.sv_sp_int := 0;
end;


procedure Tshove_for_file.copy_to(dest: TShovedTimber);
begin
  dest.timberString := sf_str;
  dest.shoveCode := sf_shove_data.sv_code;
  dest.xtbModifier := sf_shove_data.sv_x;
  dest.angleModifier := sf_shove_data.sv_k;
  dest.offsetModifier := sf_shove_data.sv_o;
  dest.lengthModifier := sf_shove_data.sv_l;
  dest.widthModifier := sf_shove_data.sv_w;
  dest.crabModifier := sf_shove_data.sv_c;
end;


//______________________________________________________________________________


// We do not allow
//    - use of old templot folder
//    - loading as a library
//    - appending to already-loaded templates
// and we do not report last loaded index
//
// These will all be reviewed when the basic import is working satisfactorily.

function import_t2box(normal_load: boolean; file_name: string;
  make_lib: boolean; var append: boolean;
  var last_bgnd_loaded_index: integer): boolean;
  // load a file of templates into the keeps box.

  // normal_load True = for use. False = for file viewer.
  // if file_name not empty it is the file name to load.
  // return True any templates loaded/added.
  // also return any change to append.
  // also return last_bgnd_loaded_index, highest bgnd template loaded (for minting).

const
  ask_restore_str: string = '      `0Restore On Startup`9' +
    '||Your work in progress can be restored from your previous working session with Templot0.'
    +
    '||This means restoring your storage box contents `0(if any)`7, background track plan drawing `0(if any)`7, and control template.'
    +
    '||This is done independently of any saving to data files which you may have performed.' +
    '||If you answer "no thanks" the previous data can be restored later by selecting the `0FILES > RESTORE PREVIOUS`1 menu item on the storage box menus.' + '||tree.gif The restore feature works correctly even if your previous session terminated abnormally as a result of a power failure or system malfunction, so there is no need to perform repeated saves as a precaution against these events.' + '||rp.gif The restore feature does not include your Background Shapes or Sketchboard files, which must be saved and reloaded separately as required.' + '||rp.gif If you run two instances of Templot0 concurrently (not recommended for Windows 95/98/ME) from the same `0\TEMPLOT\`2 folder,' + ' the restore data will be held in common between the two. To prevent this happening, create and run the second instance from a different folder (directory).';

  shovedim_c_048: integer = 29;

var
  test_box_file: file;                 // untyped file for testing format.
  i, n, fsize{,timb_index}: integer;
  loaded_str, box_str, ixt_str, ident: string;
  no_ixt: boolean;
  old_count: integer;                // for append.
  resave_needed: boolean;
  s, info_string, memo_string, _str: string;
  saved_cursor: TCursor;
  restored_save_done: boolean;

  old_next_data: Told_keep_data;
  new_next_data: Tnew_keep_data;

  thisTemplate: TTemplate;

  _071_format: boolean;
  number_read: integer;

  inbyte: byte;

  loadDialog: TOpenDialog;
  waitMessage: IAutoWaitMessage;

  ///////////////////////////////////////////////////////////////

  function load_new_format: boolean;

  var
    box_file: file;                // new format untyped file.
    n, i, len, ix: integer;
    block_start: Tblock_start;
    block_ident: Tblock_ident;

    /////////////////////////////////

    procedure read_file_error;

    begin
      try
        CloseFile(box_file);
      except
        on EInOutError do
      end;  // close file if it's open.

      {xxx      if append = False then}
      clear_keeps(False, False);     // error reloading, clear all.
{xxx      else
        clear_keep(n);               // error adding, we already created the list entry for it.
}
      file_error(box_str);
    end;
    /////////////////////////////////

    function load_shove_block(t_index, seg_len: integer): boolean;
      // for a single template.

    var
      shove_timber_data: Tshove_for_file;
      shovedTimber: TShovedTimber;

      shove_count, st: integer;
      total_read: integer;

    begin
      Result := False;    // default init.
      total_read := 0;    // number of bytes read.

      // first get the count of shoved timbers for this template...

      if EOF(box_file) = True then
        EXIT;
      BlockRead(box_file, shove_count,
        SizeOf(integer), number_read);
      total_read := total_read + number_read;
      if (number_read <> SizeOf(integer)) or (total_read > seg_len) then begin
        try
          CloseFile(box_file);
        except
          on EInOutError do
        end;  // close file if it's open.
        {xxx        if load_backup = False then}
        file_error(box_str);
        EXIT;
      end;

      if seg_len <> (SizeOf(integer) + shove_count * SizeOf(Tshove_for_file)) then
        EXIT;  // the integer is the shove count just read.

      if (t_index < 0) or (t_index > (keeps_list.Count - 1)) then
        EXIT;

      if shove_count > 0
      // now get the data for each shoved timber...
      then begin
        st := 0;    // keep compiler happy.

        with keeps_list[t_index].template_info.keep_shove_list do begin

          if Count <> 0 then
            EXIT;   // !!! shove list should be empty (created in init_ttemplate).

          repeat

            if EOF(box_file) = True then
              EXIT;
            BlockRead(box_file,
              shove_timber_data, SizeOf(Tshove_for_file), number_read);
            total_read := total_read + number_read;
            if (number_read <> SizeOf(Tshove_for_file)) or
              (total_read > seg_len) then begin
              try
                CloseFile(box_file);
              except
                on EInOutError do
              end;  // close file if it's open.
              {              if load_backup = False then}
              file_error(box_str);
              EXIT;
            end;

            try
              shovedTimber := TShovedTimber.Create;
              shove_timber_data.copy_to(shovedTimber);
              st := Add(shovedTimber);
            except
              EXIT;       // memory problem?
            end;//try
          until (st = shove_count - 1) or (total_read = seg_len);
        end;//with
      end;
      Result := True;
    end;
    ///////////////////////////////////

  begin
    Result := False;    // init default
    try
      n := old_count;     // keep compiler happy.
      try
        AssignFile(box_file, box_str);
        Reset(box_file, 1);              // open for reading, record size = 1 byte.

        repeat
          try
            n := keeps_list.Add(TTemplate.Create(nil));
          except
            alert(1, '      memory  problem',
              '|||Unable to load templates from the file into your storage box because of memory problems.'
              + '||(Loading terminated after  ' + IntToStr(n - old_count) +
              '  templates.)',
              '', '', '', '', '', 'cancel  reload', 0);
            try
              CloseFile(box_file);
            except
              on EInOutError do
            end;  // close file if it's open.
            {xxx            if append = False then}
            clear_keeps(False, False);
            EXIT;
          end;//try

          init_ttemplate(n);

          //BlockRead(box_file, old_next_data, SizeOf(Told_keep_data), number_read);
          with old_next_data do begin
            {$I load_t2keep_data}
          end;
          // read bytes.


          s := old_next_data.old_keep_dims1.box_dims1.box_ident;

          if {xxx (number_read <> SizeOf(Told_keep_data)) or}
          ((s <> ('N ' + IntToStr(n - old_count))) and (s <> ('NX' + IntToStr(n - old_count))))
          // error reading, or this is not a template.
          then begin
            read_file_error;
            EXIT;
          end;

          if version_mismatch(old_next_data) = True then
            resave_needed := True;  // check for version mismatch.

          // !!! version_mismatch must be done first - sets bgnd_code_077...


          // copy the data into the new template
          keeps_list[n].template_info.keep_dims := Tkeep_dims(old_next_data);

        until Copy(s, 1, 2) = 'NX';      // last template marker.

        Result := True;   // return good result, even if we don't get the texts.

        if EOF(box_file) = True then begin
          try
            CloseFile(box_file);
          except
            on EInOutError do
          end;  // close file if it's open.
          EXIT;
          // there was no text in the file
        end;

      except
        on EInOutError do begin
          try
            CloseFile(box_file);
          except
            on EInOutError do
          end;  // close file if it's open.
          {xxx          if load_backup = False then}
          file_error(box_str);

          clear_keeps(False, False);                   // error reloading, clear all.
          EXIT;
        end;
      end;//try-except

      // got the data, now load the text strings (don't clear the data if it fails) ...

      for n := old_count to keeps_list.Count - 1 do begin
        // now get the proper texts.

        BlockRead(box_file, len, SizeOf(integer), number_read);
        // first get the length as an integer (4 bytes)

        if number_read <> SizeOf(integer) then begin
          try
            CloseFile(box_file);
          except
            on EInOutError do
          end;  // close file if it's open.
          {xxx          if load_backup = False then}
          file_error(box_str);
          EXIT;
        end;

        // read len bytes into string s...

        s := '';
        while Length(s) < (len div SizeOf(Char)) do
          s := s + '0';

        s := s + '00';        // two more for safety.

        UniqueString(s);  // make sure it's in continuous memory

        if Length(s) > (len div SizeOf(Char)) then
          BlockRead(box_file, s[1], len, number_read);

        if number_read <> len then begin
          try
            CloseFile(box_file);
          except
            on EInOutError do
          end;  // close file if it's open.
          {xxx          if load_backup = False then}
          file_error(box_str);
          EXIT;
        end;

        i := Pos(Char($1B), s);          // find info part terminator.

        if i <> 0 then begin
          info_string := Copy(s, 1, i - 1);
          // info string (don't include the ESC).
          Delete(s, 1, i);
          // remove info string and terminator from input.

          i := Pos(Char($1B), s);             // find memo part terminator.

          if i <> 0 then begin
            memo_string := Copy(s, 1, i - 1);
            // memo string (don't incude the ESC).

            // we don't change either unless we've got both..

            keeps_list[n].Name := remove_esc_str(info_string);
            // remove any ESC is belt and braces...
            keeps_list[n].Memo := remove_esc_str(memo_string);
          end;
        end;
      end;//next n
      // now can load any trailing data blocks...

      if (_071_format = True) and (EOF(box_file) = False) then begin

        // The 071 file format is the same as the 048 format with the addition of "Data Blocks" at the end of the file.
        // To create the 048 format the shove timber data is duplicated in the template data record (first 30 shoved timbers only).

        // The Data Blocks section commences with a byte containing an underscore character '_',
        // Then 7 more bytes containing '85A_|.x' , where x is the version build letter  (ASCII single-byte characters).
        // Then a 16-byte starter record containing the version info and 12 bytes of zeroes (spares):

        //        Tblock_start=record
        //                       version_number:integer; // the Templot0 version number.
        //                       zero1:integer;          // 12 spares (zero)...
        //                       zero2:integer;
        //                       zero3:integer;
        //                     end;

        // Each DATA BLOCK comprises:

        // 16 byte Tblock_ident comprising...

        // 4 bytes = length of data segment x.
        // 4 bytes = template index count.
        // 4 bytes = code indicating content of block.
        // 4 bytes = spare - set to zero.

        // then x bytes = data segment.

        // DATA BLOCKS are then repeated until the END BLOCK, which comprises

        // 16 byte Tblock_ident comprising all zeroes (segment length=0).

        // first find the starting underscore character for the trailing data blocks...

        inbyte := 0;
        repeat
          if EOF(box_file) = True then
            EXIT;
          BlockRead(box_file, inbyte, 1, number_read);  // read 1 byte
          if number_read <> 1 then begin
            try
              CloseFile(box_file);
            except
              on EInOutError do
            end;  // close file if it's open.
            {xxx            if load_backup = False then}
            file_error(box_str);
            EXIT;
          end;
        until Chr(inbyte) = '_';

        // then the magic number...

        s := '12345678';    // 8 bytes  (1 extra for safety).
        UniqueString(s);  // make sure it's in continuous memory

        if EOF(box_file) = True then
          EXIT;
        BlockRead(box_file, s[1], 7, number_read);
        if number_read <> 7 then begin
          try
            CloseFile(box_file);
          except
            on EInOutError do
          end;  // close file if it's open.
          {xxx          if load_backup = False then}
          file_error(box_str);
          EXIT;
        end;

        if Copy(s, 1, 5) <> '85A_|' then
          EXIT;  // magic number - ignore the final '.x' build letter.

        if EOF(box_file) = True then
          EXIT;
        BlockRead(box_file, block_start, SizeOf(Tblock_start), number_read);
        if number_read <> SizeOf(Tblock_start) then begin
          try
            CloseFile(box_file);
          except
            on EInOutError do
          end;  // close file if it's open.
          {xxx          if load_backup = False then}
          file_error(box_str);
          EXIT;
        end;

        if block_start.version_number <> loaded_version then
          EXIT; // double check we are ok to continue.

        // ...ignore any other data in the block start record in this version (071).

        repeat     // get all the data blocks

          // get the ident for the next data block..

          if EOF(box_file) = True then
            EXIT;
          BlockRead(box_file, block_ident, SizeOf(Tblock_ident), number_read);
          if number_read <> SizeOf(Tblock_ident) then begin
            try
              CloseFile(box_file);
            except
              on EInOutError do
            end;  // close file if it's open.
            {xxx            if load_backup = False then}
            file_error(box_str);
            EXIT;
          end;

          if block_ident.segment_length = 0 then
            EXIT;    // end of data blocks.

          n := old_count + block_ident.f_index;   // loaded template list index.

          case block_ident.block_code of

            10:
              if load_shove_block(n, block_ident.segment_length) = False then
                EXIT;  // code 10 = shove data block for this template.

            else begin    // no other codes defined for version 071. 6-5-01.

              for i := 0 to (block_ident.segment_length - 1) do begin
                // so skip this block (later version file?).

                if EOF(box_file) = True then
                  EXIT;
                BlockRead(box_file, inbyte, 1, number_read);
                if number_read <> 1 then begin
                  try
                    CloseFile(box_file);
                  except
                    on EInOutError do
                  end;  // close file if it's open.
                  {xxx                  if load_backup = False then}
                  file_error(box_str);
                  EXIT;
                end;
              end;//next i
            end;
          end;//case  // no other codes defined for version 071. 6-5-01.

        until EOF(box_file) = True;
        // shouldn't get here, EXITs on a zero segment length.

      end;//if 071 format

    finally
      try
        CloseFile(box_file);
      except
        on EInOutError do
      end;  // close file if it's open.

      if keep_form.ignore_unused_menu_entry.Checked = True
      // finally remove any unwanted unused templates which got loaded...
      then begin
        n := old_count;
        while n < keeps_list.Count do begin
          if (keeps_list[n].template_info.keep_dims.box_dims1.bgnd_code_077 =
            0) and (keeps_list[n].template_info.keep_dims.box_dims1.this_was_control_template =
            False)  // 0.93.a

          then
            clear_keep(n)
          else
            Inc(n);
        end;//while
      end;
    end;//try
  end;
  /////////////////////////////////////////////////////////////

begin

  t2box_log := Logger.GetInstance('T2-box');

  Result := False;               // init.
  last_bgnd_loaded_index := -1;  // init.

  if (append = False) and (keeps_list.Count > 0) {xxx and (load_backup = False)} and
    (file_name = '') // something already there ?
  then begin
    if save_done = False                 // and not saved...
    then begin
      i := alert(7, '      reload  storage  box  -  save  first ?',
        'Your storage box contains one or more templates which have not yet been saved.' +
        ' Reloading your storage box will replace all of the existing contents and background drawing.'
        + '||These templates can be restored by clicking the `0UNDO RELOAD / UNDO CLEAR`1 menu item.'
        + ' But if any of these templates may be needed again, you should save them in a named data file.'
        + '||Do you want to save the existing contents before reloading?' +
        '||Or add the new templates to the existing contents instead?', '',
        '', 'add  new  templates  to  existing    ',
        'replace  existing  contents  without  saving    ', 'cancel  reload    ',
        'save  existing  contents  before  reloading      ', 0);
      case i of
        3:
          append := True;
        5:
          EXIT;
        6:
          if save_box(0, eSB_SaveAll, eSO_Normal, '') = False then
            EXIT;     // go save all the keeps box.
      end;//case
    end
    else begin      //  it has been saved...
      i := alert(7, '      reload  storage  box  -  clear  first ?',
        'Your storage box contains one or more existing templates.' +
        ' Reloading your storage box will replace all of the existing contents and background drawing.'
        + ' These templates can be restored by clicking the `0UNDO RELOAD / UNDO CLEAR`1 menu item.'
        + '||Are you sure you want to replace the existing templates?' +
        '||Or add the new templates to the existing contents instead?', '',
        '', '', 'add  new  templates  to  existing  ', 'cancel  reload    ',
        'reload  and  replace  existing  contents      ', 0);
      case i of
        4:
          append := True;
        5:
          EXIT;
      end;//case
    end;
  end;

{xxx  if load_backup = True then begin
    box_str := '';
    if FileExists(ebk1_str) = True then
      box_str := ebk1_str;
    if FileExists(ebk2_str) = True then
      box_str := ebk2_str;

    if box_str = '' then
      EXIT;    // no file to load.
  end
  else} begin
    if file_name = '' then begin
      loadDialog := TOpenDialog.Create(nil);
      try
        if not append then
          loadDialog.Title := '    load  or  reload  storage  box  from  file ..'
        else begin
          if make_lib = True then
            loadDialog.Title := '    add  library  templates  from  file ..'
          else
            loadDialog.Title := '    add  templates  from  file ..';
        end;

        if his_load_file_name <> '' then
          loadDialog.InitialDir := ExtractFilePath(his_load_file_name)
        else
          loadDialog.InitialDir := Config.GetDir(cudiBoxes);

        loadDialog.Filter := ' storage  box  contents  (*.box)|*.box';
        loadDialog.Filename := '*.box';

        if not loadDialog.Execute then
          EXIT;          // get the file name.

        box_str := loadDialog.FileName;
        his_load_file_name := box_str;

      finally
        loadDialog.Free;
      end;
    end
    else
      box_str := file_name;                       // file name supplied by caller.

    ixt_str := ChangeFileExt(box_str, '.ixt');

    if FileExists(box_str) = False then begin
      alert(5, '    error  -  file  not  found',
        '||The file :' + '||' + box_str +
        '||is not available. Please check that the file you require exists in the named folder. Then try again.'
        + '||No changes have been made to your storage box.',
        '', '', '', '', 'cancel  reload', '', 0);
      EXIT;
    end;
  end;

  // added 0.78.d 19-02-03...
  UndoRedoManager.SetMark('Import');

  resave_needed := False;                         // init.
  restored_save_done := False;                    // init.
  loaded_version := 50000;                        // init for lowest template version in the file.
  later_file := False;                            // init.

  loading_in_progress := True;
  // 208c lock out any auto backups while loading -- in case any dialogs shown and OnIdle fires

  try // 208c

    if (append = True) and (keep_form.add_new_group_menu_entry.Checked = True) then
      clear_all_selections;   // he wants added templates to form a new group.

    // begin loading...

    saved_cursor := Screen.Cursor;

    try
      Screen.Cursor := crHourGlass;        // could take a while if big file.
      if Application.Terminated = False then
        Application.ProcessMessages;       // so let the form repaint.

      if append = False then
        clear_keeps(False, True);
      // first clear all existing (sets save_done:=True), and save existing for undo.

      old_count := keeps_list.Count;          // for append.

      try
        AssignFile(test_box_file, box_str);      // set the file name (untyped file).
        FileMode := 0;
        // read only (this is a global setting for all subsequent Resets).
        Reset(test_box_file, 1);                 // open for reading, record size = 1 byte.

        //  Tkeep_dims1=record      // first part of a Tkeep_dims record.

        //BlockRead(test_box_file, old_next_data.old_keep_dims1, SizeOf(Tkeep_dims1), number_read);
        with old_next_data do begin
          {$I load_t2keep_dims1}
        end;

        // read bytes.
{xxx        if number_read <> SizeOf(Tkeep_dims1) then begin
          try
            CloseFile(test_box_file);
          except
            on EInOutError do
          end;  // close file if it's open.
          if load_backup = False then
            file_error(box_str);
          EXIT;
        end;
}
        CloseFile(test_box_file);    // and close the file. (Re-open later.)
      except
        on EInOutError do begin
          {xxx          if load_backup = False then}
          file_error(box_str);
          if append = False then
            clear_keeps(False, False);
          EXIT;
        end;
      end;//try-except

      with old_next_data.old_keep_dims1.box_dims1 do begin
        s := box_ident;
        if Copy(s, 1, 1) = 'N'              // it's in new file format (v:0.48 on, 17-2-00)
        then begin

          if templot_version > 70
          // mods for v:0.71.a  (shove-timber data blocks appended to file). 2-5-01.
          then
            _071_format := True
          else
            _071_format := False;

{xxx          if load_backup = True then begin

            if templot_version > 62 then
              restored_save_done := box_save_done;     // mods 23-6-00 for version 0.63

            if startup_restore_pref = 1 then
              EXIT;   //%%%%   0=ask, 1=don't restore, 2=restore without asking

            if (auto_restore_on_startup = False) or (ask_restore_on_startup = False)
            // if both True??? - must have been abnormal termination, so reload without asking.
            then begin

              if startup_restore_pref = 0
              //%%%%   0=ask, 1=don't restore, 2=restore without asking
              then begin
                if auto_restore_on_startup = False
                // these two only read from the first keep in the file..
                then begin
                  if ask_restore_on_startup = True
                  // he wanted to be asked first.
                  then begin

                    alert_box.
                      preferences_checkbox.Checked := False;       //%%%%
                    if user_prefs_in_use = True then
                      alert_box.preferences_checkbox.Show;

                    repeat
                      i :=
                        alert(4, '    restore  previous  work ?',
                        ' |Do you want to restore your work in progress from your previous Templot0 session?| ',
                        '', '', '', 'more  information', 'no  thanks',
                        'yes  please  -  restore  previous  work', 4);
                      case i of
                        4:
                          alert_help(0, ask_restore_str, '');
                        //%%%%% 5: EXIT;
                      end;//case
                    until i <> 4;

                    //%%%%   0=ask, 1=don't restore, 2=restore without asking

                    if alert_box.preferences_checkbox.Checked   //%%%%
                    then
                      startup_restore_pref := (i - 4)         // 5 or 6 = 1 or 2
                    else
                      startup_restore_pref := 0;

                    alert_box.
                      preferences_checkbox.Hide;

                    if i = 5 then
                      EXIT;  //%%%%

                  end
                  else
                    EXIT;     // restore not wanted.
                end;
                // 0.93.a else keep_form.auto_ebk_load_menu_entry.Checked:=True;      // radio item (maintain this option only for next time).

              end;// ask startup pref
            end;//not abnormal termination
          end;//reload backup   }

          // load the file...

          if normal_load = True then
            waitMessage := TWaitForm.ShowWaitMessage('loading  templates ...');

          if Application.Terminated = False then
            Application.ProcessMessages;           // let the wait form fully paint.
          if load_new_format = False then
            EXIT;    // go get file in new format.
        end;

      end;//with
      // file loaded...

      if (file_name = '') then
        loaded_str := box_str     // file name from the "open" dialog.
      else begin
        if ExtractFileExt(file_name) = '.box' then
          loaded_str := file_name
        else
          loaded_str := 'data file';        // don't confuse him with internal file names.
      end;

      if (ExtractFileExt(loaded_str) = '.box') and (normal_load = True)
      // 208d not for file viewer
      then
        boxmru_update(loaded_str);                              // 0.82.a  update the mru list.

      // file loaded, check it and update the background drawing...

      if append = False then begin
        with old_next_data.old_keep_dims1.box_dims1 do begin

          box_project_title_str := project_for;  // change the title to the one loaded last.

          //     0.79.a 20-05-06  -- saved grid info -- read from last template only...
          //     0.91.d -- read these only if prefs not being used on startup.

          if (grid_units_code <> 0) and (user_prefs_in_use = False)
          // 0.79 file or later --- change grid to as loaded...
          then begin

            grid_labels_code_i := grid_units_code;

            grid_spacex := x_grid_spacing;
            grid_spacey := y_grid_spacing;

            if ruler_units = 0 then
              update_ruler_div;   // 0.93.a ruler as grid option

          end;// if 0.79 or later

        end;//with old_next_data.old_keep_dims1

        save_done := not resave_needed;        // this boxful matches file.
        {xxx        if load_backup = False then} begin
          keep_form.box_file_label.Caption := ' last reloaded from :  ' + loaded_str;
          keep_form.box_file_label.Hint := keep_form.box_file_label.Caption;
          // in case too long for caption

          saved_box_str := loaded_str;
          // for print of box contents list.
          reloaded_box_str := '|    ' + loaded_str;
          // ditto.
        end;
{xxx        else begin
          save_done := restored_save_done;
          // had it been saved?
          keep_form.box_file_label.Caption := ' restored on startup';
          keep_form.box_file_label.Hint := keep_form.box_file_label.Caption;
          // in case too long for caption

          saved_box_str := 'startup restore';
          // for print of box contents list.
          reloaded_box_str := '|    startup restore';               // ditto.
        end; }
      end
      else begin                 // appending...
        //save_done:=False;
        keep_form.box_file_label.Caption := ' last added from :  ' + loaded_str;
        keep_form.box_file_label.Hint := keep_form.box_file_label.Caption;
        // in case too long for caption

        reloaded_box_str := reloaded_box_str + '|    ' + loaded_str;
        // for print of box contents list.
      end;

      if append = False then
        current_state(0)       // update or create listbox entries, need names for refresh...
      else
        current_state(-1);

      // refresh or clear backgrounds for newly loaded keeps...

      if keeps_list.Count <= old_count then
        EXIT;   // cleared on error or nothing loaded.

      with keep_form do begin

        if append = False then
          i := 0
        else
          i := old_count;

        for n := i to (keeps_list.Count - 1) do begin
          if keeps_list[n].template_info.keep_dims.box_dims1.bgnd_code_077 =
            1 then begin
            if update_background_menu_entry.Checked = True then begin
              last_bgnd_loaded_index := n;
              // update index to highest loaded bgnd (for minting).
              list_position := n;
              // put new keep on background.
              copy_keep_to_background(n, False, True);
              // don't update info, reloading=True.
            end
            else begin
              with keeps_list[n].template_info.keep_dims.box_dims1 do begin
                bgnd_code_077 := 0;          // make it unused instead.
                pre077_bgnd_flag := False;
                // in case reloaded in older version than 0.77.a
              end;//with
            end;
          end;
        end;//for

        if update_background_menu_entry.Checked = True then
          pad_form.fit_bgnd_menu_entry.Click;  // show the new background.

      end;//with

      backup_wanted := True;                    // file loaded ok, update the backup.
      Result := True;                           // file loaded.

    finally
      waitMessage := nil;
      Screen.Cursor := saved_cursor;
      current_state(-1);                   // tidy up after any error exits.

    end;//try

    if (later_file = True) and (normal_load = True)   // normal_load 208d (off for file viewer)
    then begin
      alert(1, 'php/980    later  file   -   ( from  version  ' + FormatFloat(
        '0.00', loaded_version / 100) + ' )',
        'The file which you just reloaded contained one or more templates from a later version of Templot0 than this one.'
        +
        ' Some features may not be available or may be drawn differently.' +
        '||The earliest loaded template was from version  ' +
        FormatFloat('0.00', loaded_version / 100) +
        '|This version of Templot0 is  ' + GetVersionString(voShort) +
        '||Please refer to the Templot web site at  templot.com  for information about upgrading to the latest version, or click| <A HREF="online_ref980.85a">more information online</A> .',
        '', '', '', '', '', 'continue', 0);
    end;

    if (loaded_version < 200) and (normal_load = True)   // normal_load 208d (off for file viewer)
    then begin
      i := alert(2, 'php/980    old  file   -   ( from  version  ' +
        FormatFloat('0.00', loaded_version / 100) + ' )',
        'The file which you just reloaded contained one or more templates from an earlier version of Templot0.'
        + '||These have been modified to make them compatible with this version, but some features may now be drawn differently or require adjustment.'
        //+'||To re-create the templates from scratch in line with this version, click the blue bar below or select the PROGRAM > NORMALIZE ALL TEMPLATES menu item on the PROGRAM PANEL window.'
        + '||The earliest loaded template was from version  ' +
        FormatFloat('0.00', loaded_version / 100) + '|This version of Templot0 is  ' +
        GetVersionString(voShort) +
        '||Click for <A HREF="online_ref980.85a">more information online</A> about the differences between these two versions.'
        //+'||Please refer to the Templot web site at  templot.com  for information about the differences between these two versions.'
        + '||green_panel_begin tree.gif The template name labels are now shown in the boxed style by default.'
        + ' To revert to the previous style click the `0trackpad > trackpad background options > background name labels > transparent`1 menu item,|or click below.' + '||To hide the name labels, press the `0END`2 key on the keyboard, or the `0SHIFT+ENTER`2 keys, or click the `0trackpad > hide name labels`1 menu item, or click below.green_panel_end', '', '', 'hide  name  labels', 'change  to  transparent  name  labels', '', 'continue', 0);

      if i = 3 then
        hide_name_labels := True;

      if i = 4 then
        pad_form.transparent_names_menu_entry.Checked := True;    // radio item.
    end;

  finally
    loading_in_progress := False;  // 208c allow backups only after dialogs
  end;//try
end;


end.
