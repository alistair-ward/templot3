unit BoxDims;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  RailInfo,
  ProtoInfo;


{ Tbox_dims record...

(x) box_ident: string[10];   // first 11 bytes. in BOX3,   (string[11], 12 bytes in BOX)

(x) id_byte: byte;          // set to 255  $FF in BOX3 files - not read.

(/ replace with uniqueId) now_time: integer;
// date/time/random code at which template added to keep box. (from Delphi float format - fractional days since 1-1-1900).
// this is used to detect duplicates on loading.

(/ replace with keepTimestamp) keep_date: string[20];   // ditto as conventional strings.
(/ replace with keepTimestamp) keep_time: string[20];

(x - in TTemplate) top_label: string[100];  // template info label.
(x - moved to TProject) project_for: string[50];
// his project title string for the boxful. (only read from the last template in the box).

(x - in TTemplate) reference_string: string[100];  // template name.

(x - don't care) this_was_control_template: boolean;
// 0.93.a // alignment_byte_2:byte;   // D5 0.81 12-06-05

(/) rail_info: Trail_info;  // 23-5-01.

(x - move to TProject) auto_restore_on_startup: boolean;
// these two only read from the first keep in the file..
(x - move to TProject) ask_restore_on_startup: boolean;

//---------------------

(x - not used)pre077_bgnd_flag: boolean;
// no longer used, 0.77.a 2-sep-02. When true, this keep is to be drawn on the background.

(x - not used) alignment_byte_3: byte;   // D5 0.81 12-06-05

(x - moved to TProject) templot_version: integer;
// program version number (*100, e.g Templot0 v:1.3 = 130).

(x - not used) file_format_code: integer;  // 0= D5 format,    1= OT format  //spare_int1

(/)gauge_index: integer;      // current index into the gauge list.

(/)gauge_exact: Boolean;      // nyi  // If true this is an exact-scale template.
(/)gauge_custom: Boolean;
// nyi  // If true this is (or was when saved) a custom gauge setting.

(/)proto_info: Tproto_info;
// !!! modified for 0.71.a 11-5-01. was Tgauge_info.

railtop_inches: double;
// full-size inches railtop width - was spare_float1:double;
railbottom_inches: double;
// full-size inches railbottom width - was spare_float2:double;

alignment_byte_4: byte;   // D5 0.81 12-06-05
alignment_byte_5: byte;   // D5 0.81 12-06-05

version_as_loaded: integer;
// mod 0.78.d  14-Feb-2003. the version number as loaded.

bgnd_code_077: integer;          // 0=unused, 1=bgnd, -1=library   0.77.a  2-Sep-02.

print_mapping_colour: integer;   // 0.76.a  27-10-01 //spare_inta:integer;
pad_marker_colour: integer;      // 0.76.a  27-10-01 //spare_intb:integer;

use_print_mapping_colour: boolean;  //spare_boola:boolean;
use_pad_marker_colour: boolean;     //spare_boolb:boolean;

//-------------------------

//  0.79.a 20-05-06  -- saved grid info -- read from last template only...

spare_bool1: boolean;

spare_bool2: boolean;  // out 0.93.a   was show_page_margins_on_pad:boolean;

spare_int2: integer;

grid_units_code: integer;

x_grid_spacing: double;
y_grid_spacing: double;

total_length_of_timbering: double;  // 0.96.a


id_number: integer;         // 208a
id_number_str: string[7];   // 208a     -N00000

spare_boolean1: boolean;    // 208a
spare_boolean2: boolean;    // 208a      //spare_str:string[13];


transform_info: Ttransform_info;

platform_trackbed_info: Tplatform_trackbed_info;
// 0.93.a  was check_rail_mints:Tcheck_rail_mints;

align_info: Talignment_info;


rail_type: integer;
// 0=no rails, 1=head only (bullhead), 2=head+foot (flatbottom).   // spare_int1:integer

fb_kludge_template_code: integer;
// 0.94.a   0=normal template, 1=inner foot lines, 2=outer foot lines   //spare_int3:integer;

box_save_done: boolean;
// read only from first keep on restore previous contents. 23-6-00 v:0.62.a      //spare_flag1:boolean;

uninclined_rails: boolean;      // True = rails vertical.

disable_f7_snap: boolean;       //  0.82.a  spare_bool3:boolean;

spare_bool4: boolean;

mod_text_x: double;
// (mm) label position modifiers..   //spare_float1:double;
mod_text_y: double;
//spare_float2:double;

flatbottom_width: double;
// width of flatbottom rail base (mm).    //spare_float3:double;

check_diffs: Tcheck_diffs;      // 0.94.a check rail end modifiers - 248 bytes


retain_diffs_on_make_flag: boolean;    // 0.94.a check rail diffs
retain_diffs_on_mint_flag: boolean;    // 0.94.a check rail diffs

retain_entry_straight_on_make_flag: boolean;
// 213a  spare_byte1:byte;   // 0.94.a
retain_entry_straight_on_mint_flag: boolean;
// 213a  spare_byte2:byte;   // 0.94.a

// 0.94.a timber shoving mods..

retain_shoves_on_make_flag: boolean;
retain_shoves_on_mint_flag: boolean;

turnout_info1: Tturnout_info1;
}


{# class TBoxDims
---
class: TBoxDims
attributes:
- name: uniqueId
  type: Integer
  access: [get]
- name: keepTimestamp
  type: TDateTime
  access: [get]
- name: railInfo
  type: TRailInfo
  owns: create
  access: [get]
- name: gaugeIndex
  type: Integer
  comment: current index into the gauge list.
- name: gaugeExact
  type: Boolean
  comment: NYI - If true this is an exact-scale template...
- name: gaugeCustom
  type: Boolean
  comment: NYI - If true this is (or was when saved) a custom gauge setting
- name: protoInfo
  type: TProtoInfo
  owns: create
  access: [get]
}

type

  TBoxDims = class(TOTPersistent)
  private
    //# genMemberVars
    FUniqueId: Integer;
    FKeepTimestamp: TDateTime;
    FRailInfo: TOID;
    FGaugeIndex: Integer;
    FGaugeExact: Boolean;
    FGaugeCustom: Boolean;
    FProtoInfo: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetRailInfo: TRailInfo;
    function GetProtoInfo: TProtoInfo;
    procedure SetGaugeIndex(const AValue: Integer);
    procedure SetGaugeExact(const AValue: Boolean);
    procedure SetGaugeCustom(const AValue: Boolean);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property uniqueId: Integer read FUniqueId;
    property keepTimestamp: TDateTime read FKeepTimestamp;
    property railInfo: TRailInfo read GetRailInfo;

    // current index into the gauge list.
    property gaugeIndex: Integer read FGaugeIndex write SetGaugeIndex;

    // NYI - If true this is an exact-scale template...
    property gaugeExact: Boolean read FGaugeExact write SetGaugeExact;

    // NYI - If true this is (or was when saved) a custom gauge setting
    property gaugeCustom: Boolean read FGaugeCustom write SetGaugeCustom;
    property protoInfo: TProtoInfo read GetProtoInfo;
    //# endGenProperty
  end;

  TBoxDimsOwningList = class(TOTOwningList<TBoxDims>);
  TBoxDimsReferenceList = class(TOTReferenceList<TBoxDims>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TBoxDims }

constructor TBoxDims.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FRailInfo := TRailInfo.Create(nil).oid
  else
    FRailInfo := 0;
  if AOID = 0 then
    FProtoInfo := TProtoInfo.Create(nil).oid
  else
    FProtoInfo := 0;
  //# endGenCreate
end;

destructor TBoxDims.Destroy;
begin
  //# genDestroy
  SetOwned(FRailInfo, nil);
  SetOwned(FProtoInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TBoxDims.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TBoxDims.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'uniqueId' then
    FUniqueId := StrToInteger(AValue)
  else
  if AName = 'keepTimestamp' then
    FKeepTimestamp := StrToTDateTime(AValue)
  else
  if AName = 'railInfo' then
    RestoreYamlObjectOwn(FRailInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'gaugeIndex' then
    FGaugeIndex := StrToInteger(AValue)
  else
  if AName = 'gaugeExact' then
    FGaugeExact := StrToBoolean(AValue)
  else
  if AName = 'gaugeCustom' then
    FGaugeCustom := StrToBoolean(AValue)
  else
  if AName = 'protoInfo' then
    RestoreYamlObjectOwn(FProtoInfo, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TBoxDims.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FUniqueId, sizeof(Integer));
  AStream.ReadBuffer(FKeepTimestamp, sizeof(TDateTime));
  AStream.ReadBuffer(FRailInfo, sizeof(TOID));
  AStream.ReadBuffer(FGaugeIndex, sizeof(Integer));
  AStream.ReadBuffer(FGaugeExact, sizeof(Boolean));
  AStream.ReadBuffer(FGaugeCustom, sizeof(Boolean));
  AStream.ReadBuffer(FProtoInfo, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TBoxDims.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FUniqueId, sizeof(Integer));
  AStream.WriteBuffer(FKeepTimestamp, sizeof(TDateTime));
  AStream.WriteBuffer(FRailInfo, sizeof(TOID));
  AStream.WriteBuffer(FGaugeIndex, sizeof(Integer));
  AStream.WriteBuffer(FGaugeExact, sizeof(Boolean));
  AStream.WriteBuffer(FGaugeCustom, sizeof(Boolean));
  AStream.WriteBuffer(FProtoInfo, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TBoxDims.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlInteger(AEmitter, 'uniqueId', FUniqueId);
  SaveYamlTDateTime(AEmitter, 'keepTimestamp', FKeepTimestamp);
  SaveYamlObject(AEmitter, 'railInfo', FRailInfo);
  SaveYamlInteger(AEmitter, 'gaugeIndex', FGaugeIndex);
  SaveYamlBoolean(AEmitter, 'gaugeExact', FGaugeExact);
  SaveYamlBoolean(AEmitter, 'gaugeCustom', FGaugeCustom);
  SaveYamlObject(AEmitter, 'protoInfo', FProtoInfo);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TBoxDims.GetRailInfo: TRailInfo;
begin
  Result := TRailInfo(FromOID(FRailInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetGaugeIndex(const AValue: Integer);
begin
  if AValue <> FGaugeIndex then begin
    SetModified;
    FGaugeIndex := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetGaugeExact(const AValue: Boolean);
begin
  if AValue <> FGaugeExact then begin
    SetModified;
    FGaugeExact := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetGaugeCustom(const AValue: Boolean);
begin
  if AValue <> FGaugeCustom then begin
    SetModified;
    FGaugeCustom := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TBoxDims.GetProtoInfo: TProtoInfo;
begin
  Result := TProtoInfo(FromOID(FProtoInfo));
end;

//# endGenGetSetMethods

initialization
  TBoxDims.RegisterClass;
  TBoxDimsOwningList.RegisterClass;
  TBoxDimsReferenceList.RegisterClass;

  //log := Logger.GetInstance('TBoxDims');
end.
