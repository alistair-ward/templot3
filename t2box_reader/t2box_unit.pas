
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
  SysUtils,
  Classes,
  Dialogs,
  Forms,
  TLoggerUnit;

type
  ExImportT2 = class(Exception)
  end;

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
  Messages,
  Graphics,
  Controls,
  Generics.Collections,
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
  t2box_parsers_unit,
  template_records,
  template,
  wait_message,
  switch_select,
  curve_parameters_interface,
  curve,
  OTUndoRedoManager,
  project,
  shovedTimber,
  BoxDims,
  RailInfo,
  ProtoInfo,
  TransformInfo,
  point_ex,
  NotchInfo,
  PlatformTrackbedInfo,
  AlignmentInfo,
  CheckDiffs,
  CheckEndDiff,
  TurnoutInfo1,
  TurnoutInfo2,
  SwitchInfo,
  CrossingInfo,
  PlainTrackInfo,
  HdkCheckRailInfo,
  VeeCheckRailInfo,
  Centreline;


  {$R *.lfm}

const
  shovedim_c_048: integer = 29;

type

  TGridInfo = record
    unitsCode: integer;
    spaceX: double;
    spaceY: double;
  end;

  TBox2PointEx = record
    x: double;
    y: double;
  end;

  TBox2Notch = record      //  a notch position.
    notch_x: double;
    notch_y: double;
    notch_k: double;
  end;


  TBox2SnapPegPositions = record
    // snapping positions for F7 shift mouse action  0.79.a  27-05-06
    // and background popup snap options.

    ctrl_peg_now_pos: TBox2Notch;
    ctrl_0_pos: TBox2Notch;
    ctrl_1_pos: TBox2Notch;

    ctrl_2_pos: TBox2Notch;  // added 205c

    ctrl_planing_pos: TBox2Notch;
    // added 205e for obtain turnout radius to control
    ctrl_heel_pos: TBox2Notch;
    // added 205e for obtain turnout radius to control

    ctrl_3_pos: TBox2Notch;

    ctrl_cesp_pos: TBox2Notch;
    // added 205e for obtain turnout radius to control

    ctrl_4_pos: TBox2Notch;
    ctrl_5_pos: TBox2Notch;
    ctrl_6_pos: TBox2Notch;
    ctrl_7_pos: TBox2Notch;
    ctrl_8_pos: TBox2Notch;
    ctrl_9_pos: TBox2Notch;
    ctrl_tcp_pos: TBox2Notch;   // TCP
    ctrl_mcp_pos: TBox2Notch;   // MCP
    ctrl_tolp_pos: TBox2Notch;  // TOLP

    ctrl_tminp_pos: TBox2Notch;     // TMINP     // 213b
    ctrl_texitp_pos: TBox2Notch;    // TEXITP    // 213b

    ctrl_mminp_pos: TBox2Notch;     // MMINP     // 217a
    ctrl_mexitp_pos: TBox2Notch;    // MEXITP    // 217a

    ctrl_tsmidp_pos: TBox2Notch;    // TS curve mid-point  218a

    ctrl_knucklebend_pos: TBox2Notch;  // start of knuckle bend  218a

    ctrl_atimb_pos: TBox2Notch;     // "A" timber 218a

    ctrl_mid_pos: TBox2Notch;      // mid-length  216a

    ctrl_user_pos: TBox2Notch;  // user-defined peg pos    added 205c

  end;//record

  TBox3BoundaryInfo = record            // 213b  for extend to boundary function

    loc_0: TBox2Notch;     // CTRL-0
    loc_6: TBox2Notch;     // CTRL-6
    loc_9: TBox2Notch;     // CTRL-9
    loc_240: TBox2Notch;   // TMINP
    loc_241: TBox2Notch;   // TEXITP
    loc_260: TBox2Notch;   // MMINP     // 217a
    loc_261: TBox2Notch;   // MEXITP    // 217a
    loc_600: TBox2Notch;   // TOLP

    boundary_diag: double; // diagonal length between boundaries
  end;


  TBox2ProtoInfo = record              // was Tgauge_info.

    name_str_pi: string[15];       // gauge designation: 9 chars max actually used

    spare_str_pi: string[75];      // now spares 215a   was  list_str_pi

    scale_pi: double;       // mm per ft.
    gauge_pi: double;       // mm.
    fw_pi: double;       // mm flangeway.
    fwe_pi: double;       // mm flangeway end (flangeway+flare).
    xing_fl_pi: double;       // mm length of flares (not h-d).
    railtop_pi: double;       // mm width of rail top (and bottom if bullhead).
    trtscent_pi: double;       // mm track centres, turnout side.
    trmscent_pi: double;       // mm ditto, main side.
    retcent_pi: double;       // mm ditto, return curve.
    min_radius_pi: double;       // mm minimum radius for check.


    // these 6 wing/check rail lengths used only in pre 0.71.a versions...

    old_winglongs_pi: double;
    // inches full-size length of short wing rail from centre of timber A.
    old_winglongl_pi: double;
    // inches full-size length of long wing rail from centre of timber A.

    old_cklongs_pi: double;
    // inches full-size length of short check rails.
    old_cklongm_pi: double;
    // inches full-size length of medium check rails.
    old_cklongl_pi: double;
    // inches full-size length of long check rails.
    old_cklongxl_pi: double;
    // inches full_size length of extra long check rails.

    tbwide_pi: double;       // inches full-size width of turnout timbers.
    slwide_pi: double;
    // inches full-size width of plain sleepers (not at rail joints 212a).

    xtimbsp_pi: double;
    // !!! disused in 0.75.a 14-10-01. inches full-size timber-spacing at crossing.
    // retained in files when loaded by versions prior to 0.75.a

    ftimbspmax_pi: double;
    // inches full-size max timber-spacing for closure space.

    tb_pi: double;       // plain sleeper length mm.

    // added in version 0.71.a 11-5-01...

    // !!! 11-5-01 - v:0.71.a
    // !!! exhaustive testing done to get file match with previous version.
    // !!! Due to Delphi aligning boundaries. Don't change anything!!! ...

    mainside_ends_pi: boolean;    //  True=main side ends in line,
    //  False=ends centralized.


    jt_slwide_pi: single;
    // !!! single. inches full-size width of plain sleepers at rail joints. // 212a


    alignment_byte_1: byte;   // D5 0.81 12-06-05

    random_end_pi: double;    //  amount of timber-end randomising.
    timber_thick_pi: double;    //  timber thickness (for DXF 3D).
    random_angle_pi: double;    //  amount of timber_angle randomising.

    // new check and wing dimensioning : v:0.71.a 24-5-01...

    ck_ms_working1_pi: double;
    // full-size inches - size 1 MS check rail working length (back from "A").
    ck_ms_working2_pi: double;
    // full-size inches - size 2 MS check rail working length (back from "A").
    ck_ms_working3_pi: double;
    // full-size inches - size 3 MS check rail working length (back from "A").

    ck_ts_working_mod_pi: double;
    // full-size inches - TS check rail working length modifier.
    // out of use 0.94.a but loaded in old files.

    ck_ms_ext1_pi: double;
    // full-size inches - size 1 MS check rail extension length (forward from "A").
    ck_ms_ext2_pi: double;
    // full-size inches - size 2 MS check rail extension length (forward from "A").

    ck_ts_ext_mod_pi: double;
    // full-size inches - TS check rail extension length modifier.
    // out of use 0.94.a but loaded in old files.

    wing_ms_reach1_pi: double;
    // full-size inches - size 1 MS wing rail reach length (forward from "A").
    wing_ms_reach2_pi: double;
    // full-size inches - size 2 MS wing rail reach length (forward from "A").

    wing_ts_reach_mod_pi: double;
    // full-size inches - TS wing rail reach length modifier.
    // out of use 0.94.a but loaded in old files.

    // new rail section dims 0.71.a...

    railbottom_pi: double;
    // mm width of railfoot (FB).                                   // spare_float4:double;

    // these are for 3-D in DXF...

    rail_height_pi: double;
    // full-size inches rail height (for 3D in DXF).
    seat_thick_pi: double;
    // full-size inches chair seating thickness (for 3D in DXF).

    old_tb_pi: double;
    // inches full-size (unlike tb_pi which is mm). used internally for gauge changes (no meaning in file).

    rail_inclination_pi: double;    // radians.
    foot_height_pi: double;    // inches full-size  edge thickness.
    chair_outlen_pi: double;    // inches full-size  from rail gauge-face
    chair_inlen_pi: double;    // inches full-size
    chair_width_pi: double;    // inches full-size
    chair_corner_pi: double;    // inches full-size  corner rad.

    spare_byte1: byte;   //  !!! don't replace these an integer !!!
    spare_byte2: byte;
    //  !!! Delphi will upset the align boundaries for proto_info within template_info. !!!
    spare_byte3: byte;
    spare_byte4: byte;
    spare_byte5: byte;

    alignment_byte_2: byte;   // D5 0.81 12-06-05

  end;


  //-----------------------

  TBox2TransformInfo = record             //  datums, shifts and rotations ...
    //  (yes I know the plural of datum is data !)

    datum_y: double;  // y_datum, y datum point (green dot).

    x_go_limit: double;  // (nyi) print cropping limits (paper inches)...
    x_stop_limit: double;

    transforms_apply: boolean; // !!! no longer used.  // False = ignore transform data.

    alignment_byte_1: byte;   // D5 0.81 12-06-05

    x1_shift: double;  //  mm    shift info...
    y1_shift: double;  //  mm
    k_shift: double;  //  radians.
    x2_shift: double;  //  mm
    y2_shift: double;  //  mm

    peg_pos: TBox2PointEx;      //  mm  peg position.

    alignment_byte_2: byte;   // D5 0.81 12-06-05
    alignment_byte_3: byte;   // D5 0.81 12-06-05

    peg_point_code: integer;   //  peg_code.
    peg_point_rail: integer;   //  peg_rail.

    mirror_on_x: boolean;   //  True= invert on x.
    mirror_on_y: boolean;   //  True= invert on y. (swap hand).

    alignment_byte_4: byte;   // D5 0.81 12-06-05
    alignment_byte_5: byte;   // D5 0.81 12-06-05

    spare_int1: integer;
    spare_int2: integer;

    spare_flag1: boolean;
    spare_flag2: boolean;
    spare_flag3: boolean;
    spare_flag4: boolean;

    notch_info: TBox2Notch;      {spare_float1:double;}    // 11-4-00 version 0.53
    {spare_float2:double;}
    {spare_float3:double;}

    spare_str: string[10];

    alignment_byte_6: byte;   // D5 0.81 12-06-05
    alignment_byte_7: byte;   // D5 0.81 12-06-05
    alignment_byte_8: byte;   // D5 0.81 12-06-05

  end;//record

  TBox2PlatformTrackbedInfo = record   // 0.93.a was  Tcheck_rail_mints=record

    adjacent_edges_keep: boolean;
    // False=adjacent tracks,  True=trackbed edges and platform edges.

    draw_ms_trackbed_edge_keep: boolean;
    draw_ts_trackbed_edge_keep: boolean;

    spare_bool1: boolean;

    OUT_OF_USE_trackbed_width_ins_keep: double;
    // 180 inches full-size 15ft.  // not used 215a  TS and MS separated, see below

    draw_ts_platform_keep: boolean;
    draw_ts_platform_start_edge_keep: boolean;
    draw_ts_platform_end_edge_keep: boolean;
    draw_ts_platform_rear_edge_keep: boolean;

    platform_ts_front_edge_ins_keep: double;
    // centre-line to platform front edge 57 inches   4ft-9in  215a
    platform_ts_start_width_ins_keep: double;
    platform_ts_end_width_ins_keep: double;

    platform_ts_start_mm_keep: double;
    platform_ts_length_mm_keep: double;


    draw_ms_platform_keep: boolean;
    draw_ms_platform_start_edge_keep: boolean;
    draw_ms_platform_end_edge_keep: boolean;
    draw_ms_platform_rear_edge_keep: boolean;

    platform_ms_front_edge_ins_keep: double;
    // centre-line to platform front edge 57 inches   4ft-9in  215a
    platform_ms_start_width_ins_keep: double;
    platform_ms_end_width_ins_keep: double;

    platform_ms_start_mm_keep: double;
    platform_ms_length_mm_keep: double;

    OUT_OF_USE_cess_width_ins_keep: double;
    // 206a     // not used 215a  TS and MS separated, see below
    OUT_OF_USE_draw_trackbed_cess_edge_keep: boolean;
    // 206a     // not used 215a  TS and MS separated, see below

    // platform skews added 207a...

    platform_ms_start_skew_mm_keep: double;      // 207a
    platform_ms_end_skew_mm_keep: double;        // 207a

    platform_ts_start_skew_mm_keep: double;      // 207a
    platform_ts_end_skew_mm_keep: double;        // 207a


    spare_bool2: boolean;
    spare_bool3: boolean;
    spare_bool4: boolean;
    spare_bool5: boolean;
    spare_bool6: boolean;
    spare_bool7: boolean;
    spare_bool8: boolean;


    // new trackbed edge functions 215a ...   split MS and TS settings  -  using Single floats to fit available file space ...

    trackbed_ms_width_ins_keep: Single;
    trackbed_ts_width_ins_keep: Single;

    cess_ms_width_ins_keep: Single;
    cess_ts_width_ins_keep: Single;

    draw_ms_trackbed_cess_edge_keep: boolean;
    draw_ts_trackbed_cess_edge_keep: boolean;

    spare1: boolean;
    spare2: boolean;
    // 215a spare_extended1:double; spare_extended2:double;

    trackbed_ms_start_mm_keep: double;
    // 215a spare_extended3:double;    // need to be extendeds for def_req
    trackbed_ms_length_mm_keep: double;   // 215a spare_extended4:double;

    trackbed_ts_start_mm_keep: double;    // 215a spare_extended5:double;
    trackbed_ts_length_mm_keep: double;   // 215a spare_extended6:double;

  end;


  TBox2AlignmentInfo = record              //  curving and transition info...

    curving_flag: boolean;
    // !!! no longer used 0.77.a !!! True=curved, False=straight.
    // but needed for check on loading older files.
    // - all templates now curved (straight=max_rad).

    trans_flag: boolean;    // True=transition, False=fixed radius curving.

    fixed_rad: double;   // fixed radius mm.
    trans_rad1: double;   // first transition radius mm.
    trans_rad2: double;   // second transition radius mm.
    trans_length: double;   // length of transition mm.
    trans_start: double;   // start of transition mm.
    rad_offset: double;   // curving line offset mm. no longer used

    alignment_byte_1: byte;   // D5 0.81 12-06-05
    alignment_byte_2: byte;   // D5 0.81 12-06-05

    tanh_kmax: double;          {spare_int1:integer;}   // factor for mode 2 slews.
    {spare_int2:integer;}
    // !!! double used because only 8 bytes available in existing file format (2 integers).

    slewing_flag: boolean;   {spare_flag1:boolean;}  // slewing flag.
    cl_only_flag: boolean;
    {spare_flag2:boolean;}// draw track centre-line only for bgnd

    slew_type: byte;            {spare_flag3:boolean;}
    // !!! byte used because only 1 byte available in existing file format 1-11-99.

    dummy_template_flag: boolean;  // 212a       //spare_flag4:boolean;

    slew_start: double;  {spare_float1:double;}  // slewing zone start mm.
    slew_length: double;  {spare_float2:double;}  // slewing zone length mm.
    slew_amount: double;  {spare_float3:double;}  // amount of slew mm.


    cl_options_code_int: integer;            // 206a
    cl_options_custom_offset_ext: double;  // 206a

    // 216a ...

    reminder_flag: boolean;
    reminder_colour: integer;

    reminder_str: string[200];


    spare_float1: double;
    spare_float2: double;
    spare_float3: double;

    spare_int: integer;

  end;//record


  TBox2RailInfo = record     // rail switch settings.  23-5-01.

    // !!! 17-1-00 - exhaustive testing done to get file match with previous version.
    // !!! with both same file size and correct reading of bgnd_flag.
    // !!! Due to Delphi2 aligning boundaries. Don't change anything!!! ...

    flared_ends_ri: integer;  // 0=straight bent, 1=straight machined

    // spares..

    spare_int1: integer;

    knuckle_code_ri: integer;
    // 214a spare_int2:integer;     0=normal, -1=sharp, 1=use custom knuckle_radius_ri
    knuckle_radius_ri: double;
    // 214a spare_float1:double;  custom setting - inches full-size

    spare_float2: double;

    spare_bool1: boolean;
    spare_bool2: boolean;

    isolated_crossing_sw: boolean;            //  217a   spare_bool3:boolean;

    // rail switches ..

    k_diagonal_side_check_rail_sw: boolean;    // added 0.93.a
    k_main_side_check_rail_sw: boolean;        // added 0.93.a

    switch_drive_sw: boolean;   // 0.82.a  13-10-06

    // rail switches...

    track_centre_lines_sw: boolean;
    turnout_road_stock_rail_sw: boolean;
    turnout_road_check_rail_sw: boolean;
    turnout_road_crossing_rail_sw: boolean;
    crossing_vee_sw: boolean;
    main_road_crossing_rail_sw: boolean;
    main_road_check_rail_sw: boolean;
    main_road_stock_rail_sw: boolean;

    alignment_byte_1: byte;   // D5 0.81 12-06-05
    alignment_byte_2: byte;   // D5 0.81 12-06-05


  end;


  // plain-track record includes user-defined peg data...

  TBox2PlainTrackInfo = record

    pt_custom: boolean;        // custom plain track flag.

    alignment_byte_1: byte;   // D5 0.81 12-06-05
    alignment_byte_2: byte;   // D5 0.81 12-06-05
    alignment_byte_3: byte;   // D5 0.81 12-06-05

    list_index: integer;
    rail_length: double;         // rail length in inches.

    alignment_byte_4: byte;   // D5 0.81 12-06-05
    alignment_byte_5: byte;   // D5 0.81 12-06-05

    sleepers_per_length: integer;                     // number of sleepers per length.
    sleeper_centres: array[0..psleep_c] of double;  // spacings in inches for custom.

    rail_joints_code: integer;   // 0=normal, 1=staggered, -1=none (cwr).

    user_peg_rail: integer;   // was pt_spare_int2:integer; 13-3-01.

    pt_spare_flag1: boolean;
    pt_spare_flag2: boolean;
    pt_spare_flag3: boolean;

    user_peg_data_valid: boolean;    // was pt_spare_flag4:boolean;  13-3-01

    user_pegx: double;          // was pt_spare_float1:double;  13-3-01
    user_pegy: double;          // was pt_spare_float2:double;  13-3-01
    user_pegk: double;          // was pt_spare_float3:double;  13-3-01

    pt_spacing_name_str: string[200];     // was spare_str:string[250];   17-1-01.

    alignment_byte_6: byte;   // D5 0.81 12-06-05

    pt_tb_rolling_percent: double;      // 0.76.a  17-5-02.

    gaunt_sleeper_mod_inches: double;       // 0.93.a ex 0.81 pt_spare_ext4:double;

    pt_spare_ext3: double;
    pt_spare_ext2: double;
    pt_spare_ext1: double;

    alignment_byte_7: byte;   // D5 0.81 12-06-05
    alignment_byte_8: byte;   // D5 0.81 12-06-05

  end;//record

  //________________________________________________

  //  these record types apply to turnouts only...

  TBox2SwitchInfo = record      // switch stuff...

    old_size: integer;       // old index into list of switches (pre 0.77.a).
    sw_name_str: string[100];   // name of switch.

    alignment_byte_1: byte;   // D5 0.81 12-06-05
    alignment_byte_2: byte;   // D5 0.81 12-06-05
    alignment_byte_3: byte;   // D5 0.81 12-06-05

    sw_pattern: integer;    // type of switch.
    planing: double;   // (B) planing length (inches).
    planing_angle: double;   // unit planing angle.
    switch_radius_inchormax: double;
    // switch radius (inches!) (or max_rad (in mm) for straight switch).
    switch_rail: double;   // (C) length of switch rail (inches).
    stock_rail: double;   // (S) length of stock rail (inches).
    heel_lead_inches: double;   // (L) lead to heel (incl. planing) (inches).
    heel_offset_inches: double;   // (H) heel-offset (inches).
    switch_front_inches: double;   // stock-rail-end to toe (inches).
    planing_radius: double;   // planing radius for double-curved switch.
    sleeper_j1: double;
    // first switch-front sleeper spacing back from TOE (NEGATIVE inches).
    sleeper_j2: double;
    // second switch-front sleeper spacing back from the first (NEGATIVE inches).

    timber_centres: array[0..swtimbco_c] of double;
    // list of timber centres (in inches).

    group_code: integer;    //  which group of switches.        0.77.a  7-6-02.
    size_code: integer;    //  size within group (1=shortest). 0.77.a  7-6-02.

    joggle_depth: double;   //  depth of joggle. 0.71.a 13-4-01.
    joggle_length: double;   //  length of joggle in front of toe (+ve). 0.71.a 13-4-01.

    group_count: integer;
    // number of switches in this group (max size_code in this group, min size is always 1).

    joggled_stock_rail: boolean;    //  True = joggled stock rail.

    alignment_byte_4: byte;   // D5 0.81 12-06-05
    alignment_byte_5: byte;   // D5 0.81 12-06-05
    alignment_byte_6: byte;   // D5 0.81 12-06-05

    spare_int2: integer;
    spare_int1: integer;

    valid_data: boolean;    // True = valid data here. 0.77.a 9-6-02...
    front_timbered: boolean;    // True = switch front sleepers are timber width.

    num_bridge_chairs_main_rail: byte;
    // not used in experimental chairing   // 214a              spare_byte
    num_bridge_chairs_turnout_rail: byte;
    // not used in experimental chairing   // 214a              spare_byte

    fb_tip_offset: double;
    // 0.76.a  2-1-02. fbtip dimension (FB foot from gauge-face at tip).

    sleeper_j3: double;
    //  third switch-front sleeper spacing back from the second (NEGATIVE inches).
    sleeper_j4: double;
    //  fourth switch-front sleeper spacing back from the third (NEGATIVE inches).
    sleeper_j5: double;
    //  fifth switch-front sleeper spacing back from the fourth (NEGATIVE inches).

    spare_float4: double;
    spare_float3: double;
    spare_float2: double;
    spare_float1: double;

    spare_str: string[200];

    num_slide_chairs: byte;           // 214a alignment_byte_7:byte;   // D5 0.81 12-06-05
    num_block_slide_chairs: byte;     // 214a alignment_byte_8:byte;   // D5 0.81 12-06-05
    num_block_heel_chairs: byte;      // 214a alignment_byte_9:byte;   // D5 0.81 12-06-05

  end;//record

  TBox2CheckFlareInfo_081 = record
    // not used 0.93.a

    // 0.81 new flare lengths.  04-08-03.

    check_flare_ext_ms: double;
    // flare length (inches), MS check rail extension end.
    check_flare_ext_ts: double;
    // flare length (inches), TS check rail extension end.
    check_flare_work_ms: double;
    // flare length (inches), MS check rail working end.
    check_flare_work_ts: double;
    // flare length (inches), TS check rail working end.
    wing_flare_ms: double;           // flare length (inches), MS wing rail.
    wing_flare_ts: double;           // flare length (inches), TS wing rail.
    check_flare_k_ms: double;        // flare length (inches), MS K-crossing check rail.
    check_flare_k_ds: double;        // flare length (inches), DS K-crossing check rail.

    // 0.81 new flare offsets (flangeway end gap).  04-08-03.

    check_fwe_ext_ms: double;
    // flangeway end gap (mm), MS check rail extension end.
    check_fwe_ext_ts: double;
    // flangeway end gap (mm), TS check rail extension end.
    check_fwe_work_ms: double;     // flangeway end gap (mm), MS check rail working end.
    check_fwe_work_ts: double;     // flangeway end gap (mm), TS check rail working end.
    wing_fwe_ms: double;           // flangeway end gap (mm), MS wing rail.
    wing_fwe_ts: double;           // flangeway end gap (mm), TS wing rail.
    check_fwe_k_ms: double;        // flangeway end gap (mm), MS K-crossing check rail.
    check_fwe_k_ds: double;        // flangeway end gap (mm), DS K-crossing check rail.

  end;//record

  TBox2CrossingInfo = record        // crossing stuff...

    pattern: integer;     // 0=straight, 1=curviform, 2=parallel, -1=generic.

    sl_mode: integer;     // 0=auto_fit, 1=use fixed_sl.
    retcent_mode: integer;
    // 0=return centres as adjacent track, 1=use custom centres.
    k3n_unit_angle: double;    // k3n angle in units.
    fixed_st: double;    // length of knuckle straight. mm.

    spare_int3: integer;

    hd_timbers_code: integer;     // extended half-diamond timbers for slip road.
    hd_vchecks_code: integer;
    // shortening code for half-diamond v-crossing check rails.

    k_check_length_1: double;    // length of size 1 k-crossing check rail (inches).
    k_check_length_2: double;    // length of size 2 k-crossing check rail (inches).
    k_check_mod_ms: double;    // main side modifer.
    k_check_mod_ds: double;    // diamond side modifer.
    k_check_flare: double;    // length of flare on k-crossing check rails.

    curviform_timbering_keep: boolean;
    // 215a                           alignment_byte_1:byte;   // D5 0.81 12-06-05

    alignment_byte_2: byte;   // D5 0.81 12-06-05

    main_road_code: integer;
    //  length of main-side exit road.      //  217a  spare_int2:integer;

    tandem_timber_code: integer;   //   218a      spare_int1:        integer;

    // 0.75.a  9-10-01...

    blunt_nose_width: double;    // full-size inches.
    blunt_nose_to_timb: double;    // full-size inches - to "A" timber centre.

    vee_joint_half_spacing: double;
    // full-size inches - rail overlap at vee point rail joint.
    wing_joint_spacing: double;
    // full-size inches - timber spacing at wing rail joint.

    wing_timber_spacing: double;
    // full-size inches - timber spacing for wing rail front part of crossing (up to "A").
    vee_timber_spacing: double;
    // full-size inches - timber spacing for vee point rail part of crossing (on from "A").

    // number of timbers spanned by vee rail incl. "A" timber.

    vee_joint_space_co1: byte;
    vee_joint_space_co2: byte;
    vee_joint_space_co3: byte;
    vee_joint_space_co4: byte;
    vee_joint_space_co5: byte;
    vee_joint_space_co6: byte;

    // number of timbers spanned by wing rail front excl. "A" timber...

    wing_joint_space_co1: byte;
    wing_joint_space_co2: byte;
    wing_joint_space_co3: byte;
    wing_joint_space_co4: byte;
    wing_joint_space_co5: byte;
    wing_joint_space_co6: byte;

    spare_flag1: boolean;
    spare_flag2: boolean;

    main_road_endx_infile: double;  // 217a

    hdkn_unit_angle: double;    // half-diamond hdkn angle in units.

    check_flare_info_081: TBox2CheckFlareInfo_081;   // not used 0.93.a

    k_custom_wing_long_keep: double;   // 0.95.a inches full-size k-crossing wing rails
    k_custom_point_long_keep: double;
    // 0.95.a inches full-size k-crossing point rails   NYI

    use_k_custom_wing_rails_keep: boolean;   // 0.95.a
    use_k_custom_point_rails_keep: boolean;  // 0.95.a  NYI

    spare_str: string[10];    // 0.95.a was 30

    alignment_byte_3: byte;   // D5 0.81 12-06-05

  end;//record

  TBox2TurnoutInfo1 = record          // data for the turnout size...

    plain_track_flag: boolean;      //  True=plain track only.

    rolled_in_sleepered_flag: boolean;
    // 223a  alignment_byte_1:byte;   // D5 0.81 12-06-05

    front_timbers_flag: boolean;
    //  218a    alignment_byte_2:byte;   // D5 0.81 12-06-05

    approach_rails_only_flag: boolean;
    //  218a    alignment_byte_3:byte;   // D5 0.81 12-06-05

    hand: integer;      //  hand of turnout.
    timbering_flag: boolean;      //  True = equalized timbering.

    switch_timbers_flag: boolean;
    //  218a    alignment_byte_4:byte;   // D5 0.81 12-06-05
    closure_timbers_flag: boolean;
    //  218a    alignment_byte_5:byte;   // D5 0.81 12-06-05
    xing_timbers_flag: boolean;
    //  218a    alignment_byte_6:byte;   // D5 0.81 12-06-05

    exit_timbering: integer;      //  exit timbering style.
    turnout_road_code: integer;      //  length of turnout exit road.

    turnout_length: double;     //  turnoutx.
    origin_to_toe: double;     //  xorg.
    step_size: double;
    //  incx. (use saved step-size on reloading - not default).

    turnout_road_is_adjustable: boolean;
    // 211a    alignment_byte_7:byte;   // D5 0.81 12-06-05

    turnout_road_is_minimum: boolean;
    // 217a    alignment_byte_8:byte;   // D5 0.81 12-06-05

  end;//tturnout_info1 record

  TBox2HdkCheckRailInfo = record         // K-crossing check and wing rail lengths. 0.79.a

    k_check_ms_1: double;
    // full-size inches - size 1 MS k-crossing check rail length.
    k_check_ms_2: double;
    // full-size inches - size 2 MS k-crossing check rail length.

    k_check_ds_1: double;
    // full-size inches - size 1 DS k-crossing check rail length.
    k_check_ds_2: double;
    // full-size inches - size 2 DS k-crossing check rail length.
  end;

  TBox2VeeCheckRailInfo = record         // V-crossing check and wing rail lengths. 0.79.a

    v_check_ms_working1: double;
    // full-size inches - size 1 MS check rail working length (back from "A").
    v_check_ms_working2: double;
    // full-size inches - size 2 MS check rail working length (back from "A").
    v_check_ms_working3: double;
    // full-size inches - size 3 MS check rail working length (back from "A").

    v_check_ts_working1: double;
    // full-size inches - size 1 TS check rail working length (back from "A").
    v_check_ts_working2: double;
    // full-size inches - size 2 TS check rail working length (back from "A").
    v_check_ts_working3: double;
    // full-size inches - size 3 TS check rail working length (back from "A").

    v_check_ms_ext1: double;
    // full-size inches - size 1 MS check rail extension length (forward from "A").
    v_check_ms_ext2: double;
    // full-size inches - size 2 MS check rail extension length (forward from "A").

    v_check_ts_ext1: double;
    // full-size inches - size 1 TS check rail extension length (forward from "A").
    v_check_ts_ext2: double;
    // full-size inches - size 2 TS check rail extension length (forward from "A").

    v_wing_ms_reach1: double;
    // full-size inches - size 1 MS wing rail reach length (forward from "A").
    v_wing_ms_reach2: double;
    // full-size inches - size 2 MS wing rail reach length (forward from "A").

    v_wing_ts_reach1: double;
    // full-size inches - size 1 TS wing rail reach length (forward from "A").
    v_wing_ts_reach2: double;
    // full-size inches - size 2 TS wing rail reach length (forward from "A").
  end;

  TBox2CheckEndDiff = record    // 0.94.a
    len_diff: double;   // length differ  inches f-s
    flr_diff: double;   // flare length   inches f-s
    gap_diff: double;   // end gap        model mm

    type_diff: byte;
    // 0=no diff   1=change to bent flare    2=change to machined flare   3= change to no flare
  end;

  TBox2CheckDiffs = record    // 0.94.a
    end_diff_mw: TBox2CheckEndDiff;
    end_diff_me: TBox2CheckEndDiff;
    end_diff_mr: TBox2CheckEndDiff;
    end_diff_tw: TBox2CheckEndDiff;
    end_diff_te: TBox2CheckEndDiff;
    end_diff_tr: TBox2CheckEndDiff;
    end_diff_mk: TBox2CheckEndDiff;
    end_diff_dk: TBox2CheckEndDiff;
  end;

  TBox2TurnoutInfo2 = record
    switch_info: TBox2SwitchInfo;      //  all the switch dimensions.
    crossing_info: TBox2CrossingInfo;    //  all the crossing dimensions.
    plain_track_info: TBox2PlainTrackInfo;
    //  need the plain track info for approach and exit tracks.

    diamond_auto_code: integer;
    // 0.77.a 0=auto, 1=fixed diamond, 2=switch diamond.

    bonus_timber_count: integer;     // 0.76.a number of bonus timbers.

    equalizing_fixed_flag: boolean;
    {spare_flag1:boolean;}// equalizing style 1-4-00
    no_timbering_flag: boolean;
    {spare_flag2:boolean;}// no timbering option 7-9-00

    angled_on_flag: boolean;
    {spare_flag3:boolean;}// angled-on style 29-7-01.

    chairing_flag: boolean;          // 214a    //spare_flag2:boolean;

    start_draw_x: double;          {spare_float3:double;}   // startx.

    timber_length_inc: double;     // timbinc timber length step size.

    //------
    omit_switch_front_joints: boolean;  // 0.79.a spare_float1:double;...
    omit_switch_rail_joints: boolean;
    omit_stock_rail_joints: boolean;
    omit_wing_rail_joints: boolean;
    omit_vee_rail_joints: boolean;
    omit_k_crossing_stock_rail_joints: boolean;

    spare_flag14: boolean;
    spare_flag13: boolean;
    spare_flag12: boolean;

    diamond_switch_timbering_flag: boolean;  // 213a spare_flag11:boolean;

    //------


    gaunt_flag: boolean;    // True = gaunt template 0.81.a   //spare_flag10:boolean;

    diamond_proto_timbering_flag: boolean;    // 0.77.b

    semi_diamond_flag: boolean;      // True = half-diamond template.
    diamond_fixed_flag: boolean;     // True = fixed-diamond.


    hdk_check_rail_info: TBox2HdkCheckRailInfo;

    vee_check_rail_info: TBox2VeeCheckRailInfo;

    turnout_road_endx_infile: double;
    // 209a length of turnout road from CTRL-1   //spare_float:double;

    // 208c added to aid debugging of box files in text editor (never read):

    template_type_str: string[6];
    // 208c was spare_str[16]        208a was spare_str:string[56]

    smallest_radius_stored: double;
    // 208a needed for box data -- not loaded to the control

    dpx_stored: double;
    // 208a needed for ID number creation -- not loaded to the control
    ipx_stored: double;
    // 208a needed for ID number creation -- not loaded to the control
    fpx_stored: double;
    // 208a needed for ID number creation -- not loaded to the control


    gaunt_offset_inches: double;  // 0.81

    // 219a  include connectors for XTrackCAD in export DXF file  -- not loaded to the control  ...

    dxf_connector_0: boolean;
    // CTRL-0   // alignment_byte_1:byte;   // D5 0.81 12-06-05
    dxf_connector_t: boolean;
    // TEXITP   // alignment_byte_2:byte;   // D5 0.81 12-06-05
    dxf_connector_9: boolean;
    // CTRL-9   // alignment_byte_3:byte;   // D5 0.81 12-06-05

  end;//Tturnout_info2 record


  TBox2Dims1 = record

    box_ident: string[10];   // first 11 bytes. in BOX3,   (string[11], 12 bytes in BOX)

    id_byte: byte;          // set to 255  $FF in BOX3 files - not read.

    now_time: integer;
    // date/time/random code at which template added to keep box. (from Delphi float format - fractional days since 1-1-1900).
    // this is used to detect duplicates on loading.

    keep_date: string[20];   // ditto as conventional strings.
    keep_time: string[20];

    top_label: string[100];  // template info label.
    project_for: string[50];
    // his project title string for the boxful. (only read from the last template in the box).

    reference_string: string[100];  // template name.

    this_was_control_template: boolean;
    // 0.93.a // alignment_byte_2:byte;   // D5 0.81 12-06-05

    rail_info: TBox2RailInfo;  // 23-5-01.

    auto_restore_on_startup: boolean;
    // these two only read from the first keep in the file..
    ask_restore_on_startup: boolean;

    //---------------------

    pre077_bgnd_flag: boolean;
    // no longer used, 0.77.a 2-sep-02. When true, this keep is to be drawn on the background.

    alignment_byte_3: byte;   // D5 0.81 12-06-05

    templot_version: integer;
    // program version number (*100, e.g Templot0 v:1.3 = 130).

    file_format_code: integer;  // 0= D5 format,    1= OT format  //spare_int1

    gauge_index: integer;      // current index into the gauge list.

    gauge_exact: Boolean;      // nyi  // If true this is an exact-scale template.
    gauge_custom: Boolean;
    // nyi  // If true this is (or was when saved) a custom gauge setting.

    proto_info: TBox2ProtoInfo;
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


    transform_info: TBox2TransformInfo;

    platform_trackbed_info: TBox2PlatformTrackbedInfo;
    // 0.93.a  was check_rail_mints:Tcheck_rail_mints;

    align_info: TBox2AlignmentInfo;


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

    check_diffs: TBox2CheckDiffs;      // 0.94.a check rail end modifiers - 248 bytes


    retain_diffs_on_make_flag: boolean;    // 0.94.a check rail diffs
    retain_diffs_on_mint_flag: boolean;    // 0.94.a check rail diffs

    retain_entry_straight_on_make_flag: boolean;
    // 213a  spare_byte1:byte;   // 0.94.a
    retain_entry_straight_on_mint_flag: boolean;
    // 213a  spare_byte2:byte;   // 0.94.a

    // 0.94.a timber shoving mods..

    retain_shoves_on_make_flag: boolean;
    retain_shoves_on_mint_flag: boolean;

    turnout_info1: TBox2TurnoutInfo1;

  end;//record

  TBox2KeepDims1 = record
    box_dims1: TBox2Dims1;
  end;

  TBox2KeepDims2 = record
    turnout_info2: TBox2TurnoutInfo2;
  end;

  TBox2KeepDims = record
    old_keep_dims1: TBox2KeepDims1;
    old_keep_dims2: TBox2KeepDims2;
  end;


  TBox2ShoveData = record     // shove data for a single timber ( version 0.71 11-4-01 ).

    sv_code: integer;
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

  TBox2ShoveForFile = record    // Used in the SHOVE DATA BLOCKS in the 071 files.
    // But not used within the program - see Ttimber_shove.shove_data instead.
    // Conversion takes place in 071 on loading.

    sf_str: string[6];           // timber number string.

    alignment_byte_1: byte;   // D5 0.81 12-06-05

    sf_shove_data: TBox2ShoveData;  // all the data.

  end;//record

  TBox2Template = class
    Name: string;
    memo: string;
    keepDims: TBox2KeepDims;
    shovedTimbers: array of TBox2ShoveForFile;
  end;

  TBox2TemplateList = class(TObjectList<TBox2Template>)
  end;

  // start record for trailing data blocks...
  TBox2BlockStart = record
    versionNumber: integer; // the Templot0 version number.
    zero1: integer;          // 12 spares (zero)...
    zero2: integer;
    zero3: integer;
  end;

  TBox2BlockIdent = record
    segmentLength: integer;
    templateIndex: integer;
    blockCode: integer;   // 10 = timber shove data.
    spareZeroes: integer;
  end;

  //______________________________________________________________________________

function ConvertBox2Hand(hand: Integer): TTurnoutHand;
begin
  case hand of
    1:
      Result := thLeft;
    0:
      Result := thY;
    -1:
      Result := thRight;
    else
      raise Exception.Create('Unexpected hand value');
  end;
end;


function version_mismatch(var okd: TBox2KeepDims): boolean;
  // check loaded template matches current program version.

  // use the old_keep_data format for compatibility when reloading old files.
  // return True if there is a version mismatch (re-save needed).
var
  n, list_index: integer;

  ////////////////////////////////////////////////////////

  function any_loaded_rails_omitted: boolean;  // 208a
  var
    pt_all, turnout_all, hd_all: boolean;
  begin
    Result := False;  // init

    with okd do begin

      with old_keep_dims1.box_dims1.rail_info do begin

        pt_all :=
          turnout_road_stock_rail_sw and main_road_stock_rail_sw;

        turnout_all := pt_all and turnout_road_check_rail_sw and
          turnout_road_crossing_rail_sw and crossing_vee_sw and
          main_road_check_rail_sw and main_road_crossing_rail_sw;

        hd_all := turnout_all and k_diagonal_side_check_rail_sw and
          k_main_side_check_rail_sw;

      end;//with

      if old_keep_dims1.box_dims1.turnout_info1.plain_track_flag = True
      // plain track template
      then
        Result := not pt_all
      else
      if old_keep_dims2.turnout_info2.semi_diamond_flag = True    // half-diamond template
      then
        Result := not hd_all
      else
        Result := not turnout_all;             // turnout template

    end;//with okd
  end;
  ////////////////////////////////////////////////////////
begin
  Result := False;      // init return, no mismatch

  with okd do begin
    with old_keep_dims1.box_dims1 do begin
      version_as_loaded := templot_version;
      // 0.78.d keep a note in the template of the version it was loaded as.

      if loaded_version > templot_version then
        loaded_version := templot_version;
      // loaded_version is a global reminder of the earliest loaded template.
      if templot_version > file_version then
        later_file := True;                 // file was produced by a later file than this.

      if templot_version <> file_version              // template not saved by this version.
      then begin
        if templot_version = 0 then
          align_info.cl_only_flag := False;  // so update the file..

        if templot_version < 33     // slew mods not in earlier versions than 0.33...
        then begin
          // so update the file with defaults...

          with align_info do begin
            tanh_kmax := 2;
            {:double;}{spare_int1:integer;}// stretch factor for mode 2 slews.
            {spare_int2:integer;}
            // !!! double used because only 8 bytes available in existing file format (2 integers).
            slew_type := 1;
            {:byte;}{spare_flag3:boolean;}
            // !!! byte used because only 1 byte available in existing file format 1-11-99.
          end;//with
        end;

        if templot_version < 35 then
          old_keep_dims2.turnout_info2.start_draw_x := 0;
        {spare_float1:double;}// startx  not in earlier than version 0.35

        if templot_version < 38 then begin
          mod_text_x := 0;      // position modifiers for labels.
          mod_text_y := 0;
        end;

        if templot_version < 52 then
          old_keep_dims2.turnout_info2.equalizing_fixed_flag := False;
        {spare_flag1:boolean;}// equalizing style 1-4-00 not before 0.52.

        if templot_version < 53         // notch info not in file.  pre 11-4-00.
        then begin
          with transform_info.notch_info do begin
            notch_x := 0;
            notch_y := 0;
            notch_k := 0;
          end;//with
        end;

        if templot_version < 65 then
          old_keep_dims2.turnout_info2.no_timbering_flag := False;
        {spare_flag2:boolean;}// 8-9-00 not before 0.65.

        if templot_version < 67 then
          old_keep_dims2.turnout_info2.plain_track_info.pt_spacing_name_str :=
            '  plain track rail length settings as loaded';  // 17-1-01.

        if templot_version < 68 then begin
          with old_keep_dims2.turnout_info2.plain_track_info do begin
            user_pegx := 0;
            // user-defined peg data (here to use former spare floats in file)
            user_pegy := 0;
            user_pegk := 0;
            user_peg_data_valid := False;
            user_peg_rail := 8;                // ms centre.
          end;//with
        end;

        if templot_version < 71 then begin

          with rail_info do begin

            flared_ends_ri := 0;  // 0=straight bent  1=straight machined.

            // rail switches...

            track_centre_lines_sw := True;

            turnout_road_stock_rail_sw := True;
            turnout_road_check_rail_sw := True;
            turnout_road_crossing_rail_sw := True;
            crossing_vee_sw := True;
            main_road_crossing_rail_sw := True;
            main_road_check_rail_sw := True;
            main_road_stock_rail_sw := True;

          end;//with

          with proto_info do begin

            old_tb_pi := 102;
            // 8ft-6in sleepers default (used internally for gauge changes - no meaning in file). (was 108in - 9ft pre 0.93.a)

            // convert old check rail lengths loaded..
            // to new check and wing dimensioning : v:0.71.a 24-5-01...

            ck_ms_working1_pi := old_cklongs_pi - old_winglongs_pi;
            // full-size inches - size 1 MS check rail working length (back from "A").
            ck_ms_working2_pi := old_cklongm_pi - old_winglongs_pi;
            // full-size inches - size 2 MS check rail working length (back from "A").
            ck_ms_working3_pi := old_cklongxl_pi - old_winglongl_pi;
            // full-size inches - size 3 MS check rail working length (back from "A").

            ck_ms_ext1_pi := old_winglongs_pi;
            // full-size inches - size 1 MS check rail extension length (forward from "A").
            ck_ms_ext2_pi := old_winglongl_pi;
            // full-size inches - size 2 MS check rail extension length (forward from "A").

            ck_ts_working_mod_pi := 0;
            // full-size inches - TS check rail working length modifier.
            ck_ts_ext_mod_pi := 0;
            // full-size inches - TS check rail extension length modifier.

            wing_ms_reach1_pi := old_winglongs_pi;
            // full-size inches - size 1 MS wing rail length.
            wing_ms_reach2_pi := old_winglongl_pi;
            // full-size inches - size 2 MS wing rail length.
            wing_ts_reach_mod_pi := 0;
            // full-size inches - TS wing rail reach length modifier.
          end;//with

          with old_keep_dims2.turnout_info2.switch_info do begin

            case old_size of   // was called size

              0..5:
                list_index := get_switch_list_index(1, old_size + 1);  // straight switches (6).
              6:
                list_index := -1;                                   // custom switch in file.
              7..12:
                list_index := get_switch_list_index(2, old_size - 6);  // REA switches A-F (6).
              13..20:
                list_index := get_switch_list_index(4, old_size - 12);
              // GWR old_type heel switches. 9ft - 20ft (8).
              21..24:
                list_index := get_switch_list_index(3, old_size - 20);
                // GWR curved switches B-D + 30ft straight switch (4).
              else
                list_index := -1;            //  ???
            end;//case

            if list_index < 0   // custom switch or switch not found in listbox...
            then begin
              planing_radius := 0;
              // planing radius for double-curved switch.
              joggle_depth := 0.375;
              // 3/8" depth of joggle. 0.71.a 13-4-01.
              joggle_length := 6;
              // 6" length of joggle in front of toe (+ve). 0.71.a 13-4-01.
              joggled_stock_rail := False;  // no joggle default.
            end
            else begin
              with Tswitch(switch_select_form.switch_selector_listbox.
                  Items.Objects[list_index]) do begin
                planing_radius := list_switch_info.planing_radius;
                // planing radius for double-curved switch.
                joggle_depth := list_switch_info.joggle_depth;
                // depth of joggle. 0.71.a 13-4-01.
                joggle_length := list_switch_info.joggle_length;
                // length of joggle in front of toe (+ve). 0.71.a 13-4-01.
                joggled_stock_rail := list_switch_info.joggled_stock_rail;
              end;//with
            end;
          end;//with
        end;

        if templot_version < 72 then
          old_keep_dims2.turnout_info2.angled_on_flag := False;  // 29-7-01.

        if templot_version < 74 then begin
          rail_type := 1;   // head only (bullhead rail).

          with proto_info do begin
            railbottom_pi := 5.5 * scale_pi / 12;   // 5.5" FB rail foot (mm).
            rail_height_pi := 5.71875;
            // 5.23/32" BS95R bullhead rail height (for 3D in DXF). (F-S inches).
            seat_thick_pi := 1.750;
            // bullhead chair seating thickness (for 3D in DXF). (F-S inches).

            rail_inclination_pi := 0.0499584;    // radians (1:20).
            foot_height_pi := 7 / 16;
            // 7/16" inches full-size  edge thickness.

            chair_outlen_pi := 9.25;
            // 9.25 inches full-size  from rail gauge-face
            chair_inlen_pi := 5.25;     // 5.25 inches full-size
            chair_width_pi := 8.0;      // 8 inches full-size
            chair_corner_pi := 1;       // 1 inch full-size  corner rad.

            timber_thick_pi := 5.0;    // 5 inches full-size timber thickness.
          end;//with
        end;

        if templot_version < 76 then begin
          uninclined_rails := True;      // True = rails vertical.

          print_mapping_colour := cur_prmap_col;
          // 0.76.a  27-10-01 //spare_inta:integer;
          pad_marker_colour := cur_padmark_col;
          // 0.76.a  27-10-01 //spare_intb:integer;

          use_print_mapping_colour := False;
          // 0.76.a  27-10-01 //spare_boola:boolean;
          use_pad_marker_colour := False;
          // 0.76.a  27-10-01 //spare_boolb:boolean;

          old_keep_dims2.turnout_info2.bonus_timber_count := 0;
          old_keep_dims2.turnout_info2.plain_track_info.rail_joints_code := 0;
          // 0=normal, 1=staggered, -1=none (cwr).

          with old_keep_dims2.turnout_info2.crossing_info do begin

            blunt_nose_width := 0.75;         // 3/4" full-size inches.
            blunt_nose_to_timb := 4.0;
            // full-size inches - 4" to A timber centre.

            vee_timber_spacing := proto_info.xtimbsp_pi;
            // full-size inches - timber spacing for vee point rail part of crossing (on from "A").
            wing_timber_spacing := proto_info.xtimbsp_pi;
            // full-size inches - timber spacing for wing rail front part of crossing (up to "A").

            vee_joint_half_spacing := 12.5;
            // full-size inches - 12.5" overlap at vee point rail joint.
            wing_joint_spacing := 25;
            // full-size inches - 25" timber spacing at wing rail joint.

            // number of timbers spanned by vee rail incl. "A" timber...

            vee_joint_space_co1 := 4;
            vee_joint_space_co2 := 5;
            vee_joint_space_co3 := 6;
            vee_joint_space_co4 := 7;
            vee_joint_space_co5 := 8;
            vee_joint_space_co6 := 9;

            // number of timbers spanned by wing rail front excl. "A" timber...

            wing_joint_space_co1 := 2;
            wing_joint_space_co2 := 3;
            wing_joint_space_co3 := 3;
            wing_joint_space_co4 := 4;
            wing_joint_space_co5 := 5;
            wing_joint_space_co6 := 6;

          end;//with

          with old_keep_dims2.turnout_info2.switch_info do begin
            fb_tip_offset := 0;
            // 0.76.a  2-1-02. fbtip dimension (FB foot from gauge-face at tip).
          end;//with

          old_keep_dims2.turnout_info2.plain_track_info.pt_tb_rolling_percent := 0;
          // timber rolling;
        end;

        if templot_version < 77 then begin

          if pre077_bgnd_flag = True then
            bgnd_code_077 := 1    // on bgnd.
          else
            bgnd_code_077 := 0;   // unused.

          with old_keep_dims2.turnout_info2.crossing_info do begin

            hd_vchecks_code := 0;
            // no shortening for half-diamond v-crossing check rails.

            k_check_length_1 := 185;
            // length of size 1 k-crossing check rail (inches).
            k_check_length_2 := 197;
            // length of size 2 k-crossing check rail (inches).
            k_check_mod_ms := 0;      // main side modifer.
            k_check_mod_ds := 0;      // diamond side modifer.
            k_check_flare := 36;
            // length of flare on k-crossing check rails (inches).
          end;//with

          with transform_info do begin
            if transforms_apply = False        // no longer used..
            then begin
              transforms_apply := True;
              x1_shift := 0;
              y1_shift := 0;
              k_shift := 0;
              x2_shift := 0;
              y2_shift := 0;
            end;
          end;//with

          with align_info do begin
            if curving_flag = False          // straight turnout..
            then begin
              curving_flag := True;
              trans_flag := False;
              fixed_rad := max_rad;  // now curved at max_rad.
              rad_offset := 0;
            end;
          end;//with

          with old_keep_dims2.turnout_info2 do begin

            diamond_auto_code := 0;
            // auto select switch-diamond or fixed-diamond.
            semi_diamond_flag := False;
            // not a half-diamond template, calc a normal switch.
            diamond_fixed_flag := True;  // default is a fixed diamond.

          end;//with

          with old_keep_dims2.turnout_info2.switch_info do begin

            if (ABS(switch_radius_inchormax) > (max_rad /
              20)) // buggy? in older files. 20 arbitrary.
              and (sw_pattern = 0)
            // straight or curved switch.
            then
              switch_radius_inchormax := max_rad;        // straight switch.

            case old_size of
              0..5: begin                    // straight switches (6).
                group_code := 1;
                size_code := old_size + 1;
                group_count := 6;
                front_timbered := False; // assume pre-grouping.
              end;

              6: begin                    // custom switch.
                group_code := 0;
                size_code := 1;
                group_count := 1;
                front_timbered := False;
              end;

              7..12: begin                    // REA switches A-F (6).
                group_code := 2;
                size_code := old_size - 6;
                group_count := 6;
                front_timbered := True;
              end;

              13..20: begin
                // GWR heel switches. 9ft - 20ft (8).
                group_code := 4;
                size_code := old_size - 12;
                group_count := 8;
                front_timbered := False; // assume pre-grouping.
              end;

              21..24: begin
                // GWR curved switches B-D + 30ft straight switch (4).
                group_code := 3;
                size_code := old_size - 20;
                group_count := 4;
                front_timbered := True;
              end;

              else begin
                // ???  No other sizes should be in file before 0.77.a
                group_code := 0;
                size_code := 0;
                group_count := 0;
                front_timbered := False;
              end;
            end;//case

            sleeper_j3 := 0;
            //  third switch-front sleeper spacing back from the second (NEGATIVE inches).
            sleeper_j4 := 0;
            //  fourth switch-front sleeper spacing back from the third (NEGATIVE inches).
            sleeper_j5 := 0;
            //  fifth switch-front sleeper spacing back from the fourth (NEGATIVE inches).

            valid_data := True;     //  True = valid data here. 0.77.a 9-6-02.

          end;//with
        end;

        if templot_version < 78       // 0.78.a 11-11-02.
        then begin
          with old_keep_dims2.turnout_info2 do begin
            timber_length_inc := 6.0;                    // 6" timber increments.
            diamond_proto_timbering_flag := True;
            // use prototype timbering for a diamond.
            crossing_info.hd_timbers_code := 0;
            // no extending of half-diamond timbers for slips.
          end;//with
        end;

        if templot_version < 79       // 0.79.a
        then begin
          with old_keep_dims2.turnout_info2 do begin
            omit_switch_front_joints := False;
            omit_switch_rail_joints := False;
            omit_stock_rail_joints := False;
            omit_wing_rail_joints := False;
            omit_vee_rail_joints := False;
            omit_k_crossing_stock_rail_joints := False;
          end;//with

          grid_units_code := 0;  // this means the following will not be used..
          x_grid_spacing := 50;
          y_grid_spacing := 50;
        end;

        if templot_version < 82 then begin

          rail_info.switch_drive_sw := True;   // 0.82.a

          disable_f7_snap := False;            //  0.82.a

        end;

        if templot_version < 93    // 0.93.a mods...    04-07-10
        then begin

          this_was_control_template := False;
          // all older versions don't save the control template

          with platform_trackbed_info do begin

            adjacent_edges_keep := True;
            // False=adjacent tracks,  True=trackbed edges and platform edges.

            draw_ms_trackbed_edge_keep := False;
            draw_ts_trackbed_edge_keep := False;

            OUT_OF_USE_trackbed_width_ins_keep := 180;
            // 180 inches full-size 15ft.      out of use 215a

            draw_ts_platform_keep := False;
            draw_ts_platform_start_edge_keep := True;
            draw_ts_platform_end_edge_keep := True;
            draw_ts_platform_rear_edge_keep := True;

            platform_ts_front_edge_ins_keep := 28.75;
            // 2ft-4.3/4" from rail 093a    changed to 57" from centre-line in 215a below
            platform_ts_start_width_ins_keep := 144;      // 12ft default
            platform_ts_end_width_ins_keep := 144;        // 12ft default

            platform_ts_start_mm_keep := 0;
            platform_ts_length_mm_keep := def_req;     // set to template end

            draw_ms_platform_keep := False;
            draw_ms_platform_start_edge_keep := True;
            draw_ms_platform_end_edge_keep := True;
            draw_ms_platform_rear_edge_keep := True;

            platform_ms_front_edge_ins_keep := 28.75;
            // 2ft-4.3/4" from rail 093a    changed to 57" from centre-line in 215a below
            platform_ms_start_width_ins_keep := 144;      // 12ft default
            platform_ms_end_width_ins_keep := 144;        // 12ft default

            platform_ms_start_mm_keep := 0;
            platform_ms_length_mm_keep := def_req;     // set to template end

          end;//with platform_trackbed_info

          with old_keep_dims2.turnout_info2 do begin

            gaunt_flag := False;
            gaunt_offset_inches := 12.0;
            // default offset 12" if converted to gaunt.
            plain_track_info.gaunt_sleeper_mod_inches := 12.0;
            // extend approach sleepers by 12" to match.

            with crossing_info do
              hdkn_unit_angle := k3n_unit_angle;
            // only regular half-diamonds in earlier versions.

          end;//with

          with rail_info do begin
            k_diagonal_side_check_rail_sw := main_road_check_rail_sw;
            // diagonal-side check rail is in main road.
            k_main_side_check_rail_sw := turnout_road_check_rail_sw;
            // main-side check rail is in diagonal road.
          end;//with

        end;

        if templot_version < 94    // 0.94.a mods...    11-08-11
        then begin

          with check_diffs do begin         // check-rail mouse modifiers
            end_diff_mw.len_diff := 0;
            end_diff_mw.flr_diff := 0;
            end_diff_mw.gap_diff := 0;
            end_diff_mw.type_diff := 0; // byte

            end_diff_me.len_diff := 0;
            end_diff_me.flr_diff := 0;
            end_diff_me.gap_diff := 0;
            end_diff_me.type_diff := 0; // byte

            end_diff_mr.len_diff := 0;
            end_diff_mr.flr_diff := 0;
            end_diff_mr.gap_diff := 0;
            end_diff_mr.type_diff := 0; // byte

            // set the V-crossing turnout-side check length diffs from the old...
            // old no longer used in the program.

            end_diff_tw.len_diff := proto_info.ck_ts_working_mod_pi;
            end_diff_tw.flr_diff := 0;
            end_diff_tw.gap_diff := 0;
            end_diff_tw.type_diff := 0; // byte

            end_diff_te.len_diff := proto_info.ck_ts_ext_mod_pi;
            end_diff_te.flr_diff := 0;
            end_diff_te.gap_diff := 0;
            end_diff_te.type_diff := 0; // byte

            end_diff_tr.len_diff := proto_info.wing_ts_reach_mod_pi;
            end_diff_tr.flr_diff := 0;
            end_diff_tr.gap_diff := 0;
            end_diff_tr.type_diff := 0; // byte

            // set the K-crossing check length diffs from the old...

            end_diff_mk.len_diff :=
              old_keep_dims2.turnout_info2.crossing_info.k_check_mod_ms;
            end_diff_mk.flr_diff := 0;
            end_diff_mk.gap_diff := 0;
            end_diff_mk.type_diff := 0; // byte

            end_diff_dk.len_diff :=
              old_keep_dims2.turnout_info2.crossing_info.k_check_mod_ds;
            end_diff_dk.flr_diff := 0;
            end_diff_dk.gap_diff := 0;
            end_diff_dk.type_diff := 0; // byte

          end;

          retain_diffs_on_make_flag := False;    // 0.94.a check rail diffs
          retain_diffs_on_mint_flag := False;    // 0.94.a check rail diffs

          // 0.94.a timber shoving mods..

          retain_shoves_on_make_flag := False;
          retain_shoves_on_mint_flag := False;

          fb_kludge_template_code := 0;  // normal template.  rail-foot kludge 0.94.a

        end;

        if templot_version < 95    // 0.95.a mods...    12-11-11
        then begin
          with old_keep_dims2.turnout_info2.crossing_info do begin

            // 0.95.a K wing rails ..

            k_custom_wing_long_keep := 185;
            // inches full-size 15'5" k-crossing wing rails, BH 1:6.5 - 1:8
            k_custom_point_long_keep := 144;
            // inches full-size 12' k-crossing point rails   NYI

            use_k_custom_wing_rails_keep := False;
            use_k_custom_point_rails_keep := False;

          end;//with

        end;

        if templot_version < 206    // 2.06.a mods...    18-10-2012
        then begin

          align_info.cl_options_code_int := 0;
          // 206a    // draw centre-line on main road
          align_info.cl_options_custom_offset_ext := 0;

          platform_trackbed_info.OUT_OF_USE_cess_width_ins_keep := 27;
          // 206a   was 30    out of use 215a
          platform_trackbed_info.OUT_OF_USE_draw_trackbed_cess_edge_keep := False;
          // 206a             out of use 215a

        end;


        if templot_version < 207    // 207a mods...    08-04-2013
        then begin

          with platform_trackbed_info do begin    // end skewing added...

            platform_ms_start_skew_mm_keep := 0;      // 207a
            platform_ms_end_skew_mm_keep := 0;        // 207a

            platform_ts_start_skew_mm_keep := 0;      // 207a
            platform_ts_end_skew_mm_keep := 0;        // 207a

          end;

        end;

        if templot_version < 208    // 208a mods...    28-04-2013
        then begin

          old_keep_dims2.turnout_info2.smallest_radius_stored := max_rad;
          // not available before 208a -- not loaded to the control, always calculated fresh

          old_keep_dims2.turnout_info2.dpx_stored := 0;
          // not available before 208a -- not loaded to the control, always calculated fresh
          old_keep_dims2.turnout_info2.ipx_stored := 0;
          // not available before 208a -- not loaded to the control, always calculated fresh
          old_keep_dims2.turnout_info2.fpx_stored := 0;
          // not available before 208a -- not loaded to the control, always calculated fresh

          // update template names to ID numbers...

          if Trim(reference_string) = 'no-name' then
            reference_string := '';   // 208a

          id_number := highest_id_number + 1;                                  // 208a
          id_number_str :=
            create_id_number_str(id_number, ConvertBox2Hand(turnout_info1.hand),
            old_keep_dims2.turnout_info2.start_draw_x, turnout_info1.turnout_length,
            old_keep_dims2.turnout_info2.ipx_stored,   // 0
            old_keep_dims2.turnout_info2.fpx_stored,   // 0
            turnout_info1.plain_track_flag,
            old_keep_dims2.turnout_info2.semi_diamond_flag,
            any_loaded_rails_omitted);

        end;


        if templot_version < 209    // 209a mods...    23-04-2014
        then begin

          old_keep_dims2.turnout_info2.turnout_road_endx_infile :=
            turnout_info1.turnout_length - turnout_info1.origin_to_toe;
          //  mm default to overall length (from CTRL-1)

        end;

        // 210 does not exist !!!

        if templot_version < 211    // 211a mods...    3-07-2014
        then begin
          // adjustable turnout road compatibility mods 211a ...

          if turnout_info1.turnout_road_code = 2
          // adjustable - will be from 209 only
          then
            turnout_info1.turnout_road_is_adjustable := True
          else
            turnout_info1.turnout_road_is_adjustable := False;  // from 208 and earlier

        end;

        if templot_version < 212    // 212a mods...    5-03-2015
        then begin

          align_info.dummy_template_flag := False;   // 212a

          with proto_info do begin
            jt_slwide_pi := slwide_pi;
            // !!! single. inches full-size width of plain sleepers at rail joints. // 212a

            if name_str_pi = ' 00-SF    '    // 10 chars
            then begin
              name_str_pi := ' 4-SF     ';    // 10 chars
              //list_str_pi:=StringReplace(list_str_pi,'00-SF','4-SF ',[rfReplaceAll, rfIgnoreCase]);
              if fwe_pi = 1.75 then
                fwe_pi := 1.7;
            end;

            if name_str_pi = ' 00-BF    '    // 10 chars
            then begin
              if fw_pi = 1.25 then
                fw_pi := 1.3;
              if fwe_pi = 2.0 then
                fwe_pi := 1.9;
            end;

            if name_str_pi = ' 00-D0GAF '    // 10 chars
            then begin
              if fwe_pi = 1.75 then
                fwe_pi := 1.7;
            end;

            if name_str_pi = ' EM       '    // 10 chars
            then begin
              if fwe_pi = 1.75 then
                fwe_pi := 1.7;
            end;

            if name_str_pi = ' EM-18    '    // 10 chars
            then begin
              if fwe_pi = 1.75 then
                fwe_pi := 1.7;
            end;

          end;//with
        end;

        if templot_version < 213    // 213a mods...    13-10-2015
        then begin
          retain_entry_straight_on_make_flag := False;
          retain_entry_straight_on_mint_flag := False;

          old_keep_dims2.turnout_info2.diamond_switch_timbering_flag := False;
          // not a dummy Y-turnout
        end;

        if templot_version < 214    // 214a mods...    18-1-2016
        then begin

          with rail_info do begin
            knuckle_code_ri := 0;
            // integer;   0=normal, -1=sharp, 1=use custom knuckle_radius_ri
            knuckle_radius_ri := 72;
            // extended;  custom  - default 72 inches full-size
          end;

          with old_keep_dims2.turnout_info2.switch_info do begin

            num_slide_chairs := 0;                // byte 214a
            num_block_slide_chairs := 0;          // byte 214a
            num_block_heel_chairs := 0;           // byte 214a
            num_bridge_chairs_main_rail := 0;     // byte 214a
            num_bridge_chairs_turnout_rail := 0;  // byte 214a

          end;//with

          old_keep_dims2.turnout_info2.chairing_flag := False;

        end;

        if templot_version < 215    // 215a mods...    14-AUG-2017
        then begin

          with platform_trackbed_info do begin

            platform_ts_front_edge_ins_keep := platform_ts_front_edge_ins_keep + 28.25;
            // adjust to track centre-line   //  was :=28.75 from rail 093a  changed to 57" from centre-line in 215a
            platform_ms_front_edge_ins_keep := platform_ms_front_edge_ins_keep + 28.25;
            // adjust to track centre-line   //  was :=28.75 from rail 093a  changed to 57" from centre-line in 215a

            // 215a modified trackbed info, TS and MS separated ...

            trackbed_ms_width_ins_keep := OUT_OF_USE_trackbed_width_ins_keep / 2;
            //Single;
            trackbed_ts_width_ins_keep := OUT_OF_USE_trackbed_width_ins_keep / 2;
            //Single;

            cess_ms_width_ins_keep := OUT_OF_USE_cess_width_ins_keep;
            //Single;
            cess_ts_width_ins_keep := OUT_OF_USE_cess_width_ins_keep;
            //Single;

            if cess_ms_width_ins_keep = 30 then
              cess_ms_width_ins_keep := 27;  // update if still on default
            if cess_ts_width_ins_keep = 30 then
              cess_ts_width_ins_keep := 27;  // update if still on default

            draw_ms_trackbed_cess_edge_keep := OUT_OF_USE_draw_trackbed_cess_edge_keep;
            //boolean;
            draw_ts_trackbed_cess_edge_keep := OUT_OF_USE_draw_trackbed_cess_edge_keep;
            //boolean;

            trackbed_ms_start_mm_keep := 0;            //extended;
            trackbed_ms_length_mm_keep := def_req;     //extended;

            trackbed_ts_start_mm_keep := 0;            //extended;
            trackbed_ts_length_mm_keep := def_req;     //extended;

          end;//with


          with proto_info do begin

            name_str_pi := Copy(Trim(name_str_pi), 1, 9);
            // max 9 chars     gauge list name

            if fwe_pi > (fw_pi + 1.75 * scale_pi / 12) then
              fwe_pi := fw_pi + 1.75 * scale_pi / 12;
            // 215a  flangeway end gaps reduced to prototype flare angle if wider.

          end;//with


          old_keep_dims2.turnout_info2.crossing_info.curviform_timbering_keep :=
            False;   // 215a

        end;

        if templot_version < 216    // 216a mods...    15-NOV-2017
        then begin

          with align_info do begin

            reminder_flag := False;
            reminder_colour := clYellow;
            reminder_str := '';

          end;//with

        end;

        if templot_version < 217    // 217a mods...    4-12-2017
        then begin

          turnout_info1.turnout_road_is_minimum := False;

          old_keep_dims2.turnout_info2.crossing_info.main_road_endx_infile :=
            turnout_info1.turnout_length - turnout_info1.origin_to_toe;
          //  mm default to overall length (from CTRL-1)

          old_keep_dims2.turnout_info2.crossing_info.main_road_code := 0;
          // normal main-side exit

          rail_info.isolated_crossing_sw := False;
        end;

        if templot_version < 218    // 218a mods...    25-12-2017
        then begin

          turnout_info1.front_timbers_flag := True;
          turnout_info1.switch_timbers_flag := True;
          turnout_info1.closure_timbers_flag := True;
          turnout_info1.xing_timbers_flag := True;

          turnout_info1.approach_rails_only_flag := False;

          old_keep_dims2.turnout_info2.crossing_info.tandem_timber_code := 0;

        end;

        if templot_version < 219    // 219a mods...    06-03-2018
        then begin

          // include connectors for XTrackCAD in export DXF -- file only, not loaded to the control  ...

          with old_keep_dims2.turnout_info2 do begin

            dxf_connector_0 := False;   // CTRL-0
            dxf_connector_t := False;   // TEXITP
            dxf_connector_9 := False;   // CTRL-9

          end;//with

        end;

        if templot_version < 290   // OpenTemplot
        then begin
          turnout_info1.rolled_in_sleepered_flag := True;
          // default was True pre-223a
          file_format_code := 0;                             // D5 format
        end;

        if templot_version < 292   // OpenTemplot
        then begin
          //
        end;

        templot_version := file_version;      // file now corresponds to current.
        Result := True;                          // and flag not saved.
      end;// if version differs

    end;//with old_keep_dims1
  end;//with okd
end;
//__________________________________________________________________________________________

function BoxFileIsNewFormat(filename: String): Boolean;
var
  test_box_file: file;                 // untyped file for testing format.
  old_next_data: TBox2KeepDims;
  s: String;
begin
  try
    AssignFile(test_box_file, filename);      // set the file name (untyped file).

    // read only (this is a global setting for all subsequent Resets).
    FileMode := 0;
    Reset(test_box_file, 1);                 // open for reading, record size = 1 byte.

    //  Tkeep_dims1=record      // first part of a Tkeep_dims record.

    //BlockRead(test_box_file, old_next_data.old_keep_dims1, SizeOf(Tkeep_dims1), number_read);
    with old_next_data do begin
      {$I load_t2keep_dims1}
    end;

    // read bytes.
    CloseFile(test_box_file);    // and close the file. (Re-open later.)
  except
    on EInOutError do begin
      file_error(filename);
      clear_keeps(False, False);
      Exit(False);
    end;
  end;//try-except

  s := old_next_data.old_keep_dims1.box_dims1.box_ident;
  Exit(s[1] = 'N');
end;

/////////////////////////////////

procedure ReadFileError;
begin
  raise ExImportT2.Create('Error reading file');
end;


procedure ReadTemplateRecords(var box_file: file; var box2Templates: TBox2TemplateList);
var
  n: integer;
  template_records: TBox2Template;
  numberRead: integer;
  s: string;
  ix: Integer;
begin
  repeat
    n := box2Templates.Add(TBox2Template.Create());
    template_records := box2Templates[n];
    with template_records.keepDims do begin
      {$I load_t2keep_data}
    end;

    s := template_records.keepDims.old_keep_dims1.box_dims1.box_ident;
    if ((s <> ('N ' + IntToStr(n))) and (s <> ('NX' + IntToStr(n)))) then begin
      // error reading, or this is not a template.
      ReadFileError;
    end;
  until Copy(s, 1, 2) = 'NX';      // last template marker.
end;

procedure ReadStrings(var boxFile: file; var box2Templates: TBox2TemplateList);
var
  n: integer;
  numberRead: integer;
  stringLength: integer;
  s: string;
  i: integer;
  infoString: string;
  memoString: string;
begin
  for n := 0 to box2Templates.Count - 1 do begin
    // now get the proper texts.

    // first get the length as an integer (4 bytes)
    stringLength := parse_integer(boxFile, 'stringLength');

    // read len bytes into string s...

    s := StringOfChar('0', stringLength);
    BlockRead(boxFile, s[1], stringLength, numberRead);

    if numberRead <> stringLength then begin
      ReadFileError;
    end;

    i := Pos(Char($1B), s);          // find info part terminator.

    if i <> 0 then begin
      infoString := Copy(s, 1, i - 1); // info string (don't include the ESC).
      Delete(s, 1, i);          // remove info string and terminator from input.

      i := Pos(Char($1B), s);             // find memo part terminator.

      if i <> 0 then begin
        memoString := Copy(s, 1, i - 1); // memo string (don't incude the ESC).

        // we don't change either unless we've got both..
        box2Templates[n].Name := remove_esc_str(infoString);
        // remove any ESC is belt and braces...
        box2Templates[n].Memo := remove_esc_str(memoString);
      end;
    end;
  end;//next n
end;

procedure ReadOneShoveData(var boxFile: file; var shoveData: TBox2ShoveForFile);
begin
  shoveData.sf_str := parse_string(boxFile, 'sf_str', 6);
  shoveData.alignment_byte_1 := parse_byte(boxFile, 'alignment_byte_1');
  shoveData.sf_shove_data.sv_code := parse_integer(boxFile, 'sv_code');
  shoveData.sf_shove_data.sv_x := parse_extended(boxFile, 'sv_x');
  shoveData.sf_shove_data.sv_k := parse_extended(boxFile, 'sv_k');
  shoveData.sf_shove_data.sv_o := parse_extended(boxFile, 'sv_o');
  shoveData.sf_shove_data.sv_l := parse_extended(boxFile, 'sv_l');
  shoveData.sf_shove_data.sv_w := parse_extended(boxFile, 'sv_w');
  shoveData.sf_shove_data.sv_c := parse_extended(boxFile, 'sv_c');
  shoveData.sf_shove_data.sv_t := parse_extended(boxFile, 'sv_t');
  shoveData.sf_shove_data.alignment_byte_1 :=
    parse_byte(boxFile, 'alignment_byte_1');
  shoveData.sf_shove_data.alignment_byte_2 :=
    parse_byte(boxFile, 'alignment_byte_2');
  shoveData.sf_shove_data.sv_sp_int := parse_integer(boxFile, 'sv_sp_int');
end;

procedure ReadShoveBlock(var boxFile: file; box2Template: TBox2Template; segmentLength: integer);
var
  numberRead: integer;
  shoveCount: integer;
  i: Integer;
  filePosition: Int64;
begin
  // first get the count of shoved timbers for this template...
  shoveCount := parse_integer(boxFile, 'shoveCount');

  if shoveCount > 0 then begin
    // now get the data for all the shoved timbers...
    SetLength(box2Template.shovedTimbers, shoveCount);
    filePosition := FilePos(boxFile);
    for i := 0 to shoveCount - 1 do begin
      ReadOneShoveData(boxFile, box2Template.shovedTimbers[i]);
    end;
    numberRead := FilePos(boxFile) - filePosition;

    if numberRead <> segmentLength then
      ReadFileError;
  end;
end;

procedure ReadBlockStart(var boxFile: file; var blockStart: TBox2BlockStart);
begin
  blockStart.versionNumber := parse_integer(boxFile, 'versionNumber');
  blockStart.zero1 := parse_integer(boxFile, 'zero1');
  blockStart.zero2 := parse_integer(boxFile, 'zero2');
  blockStart.zero3 := parse_integer(boxFile, 'zero3');
end;

procedure ReadBlockIdent(var boxFile: file; var blockIdent: TBox2BlockIdent);
begin
  blockIdent.segmentLength := parse_integer(boxFile, 'segmentLength');
  blockIdent.templateIndex := parse_integer(boxFile, 'templateIndex');
  blockIdent.blockCode := parse_integer(boxFile, 'blockCode');
  blockIdent.spareZeroes := parse_integer(boxFile, 'spareZeroes');
end;

procedure ReadDataBlocks(var boxFile: file; var box2Templates: TBox2TemplateList);
var
  s: string;
  numberRead: integer;
  blockStart: TBox2BlockStart;
  blockIdent: TBox2BlockIdent;
begin
  s := StringOfChar(' ', 8);
  BlockRead(boxFile, s[1], 8, numberRead);
  if numberRead <> 8 then begin
    ReadFileError;
  end;

  if Copy(s, 1, 6) <> '_85A_|' then begin
    ReadFileError;
  end;

  ReadBlockStart(boxFile, blockStart);

  // get all the data blocks
  while not EOF(boxFile) do begin
    // get the ident for the next data block..

    ReadBlockIdent(boxFile, blockIdent);
    if blockIdent.segmentLength = 0 then
      Exit;    // end of data blocks.

    if (blockIdent.templateIndex < 0) or (blockIdent.templateIndex >= box2Templates.Count) then
    begin
      ReadFileError;
    end;

    case blockIdent.blockCode of

      10:
        ReadShoveBlock(boxFile, box2Templates[blockIdent.templateIndex], blockIdent.segmentLength);
      else begin    // no other codes defined for version 071. 6-5-01.
        Seek(boxFile, FilePos(boxFile) + blockIdent.segmentLength);
      end;
    end;//case  // no other codes defined for version 071. 6-5-01.
  end;
  // shouldn't get here, EXITs on a zero segment length.
end;

function ExtractProjectTitle(box2: TBox2TemplateList): string;
begin
  if box2.Count > 0 then
    Result := box2[0].keepDims.old_keep_dims1.box_dims1.project_for
  else
    Result := '';
end;

function ExtractGridInfo(box2: TBox2TemplateList): TGridInfo;
var
  b: TBox2Template;
begin
  if box2.Count > 0 then begin
    b := box2[0];
    Result.unitsCode := b.keepDims.old_keep_dims1.box_dims1.grid_units_code;
    Result.spaceX := b.keepDims.old_keep_dims1.box_dims1.x_grid_spacing;
    Result.spaceY := b.keepDims.old_keep_dims1.box_dims1.y_grid_spacing;
  end
  else begin
    Result.unitsCode := 0; // this means the following will not be used..
    Result.spaceX := 50;
    Result.spaceY := 50;
  end;

end;

function ConvertBox2ToShovedTimber(const box2Timber: TBox2ShoveForFile): TShovedTimber;
begin
  Result := TShovedTimber.Create(nil);
  try
    Result.timberString := box2Timber.sf_str;
    Result.shoveCode := TShoveCode(box2Timber.sf_shove_data.sv_code);
    Result.xtbModifier := box2Timber.sf_shove_data.sv_x;
    Result.angleModifier := box2Timber.sf_shove_data.sv_k;
    Result.offsetModifier := box2Timber.sf_shove_data.sv_o;
    Result.lengthModifier := box2Timber.sf_shove_data.sv_l;
    Result.widthModifier := box2Timber.sf_shove_data.sv_w;
    Result.crabModifier := box2Timber.sf_shove_data.sv_c;
  except
    Result.Free;
    raise;
  end;
end;

procedure ConvertBox2ToShovedTimbers(const box2Timbers: array of TBox2ShoveForFile;
  template: TTemplate);
var
  i: integer;
  t: TShovedTimber;
begin
  for i := 0 to High(box2Timbers) do begin
    template.shovedTimbers.Add(ConvertBox2ToShovedTimber(box2Timbers[i]));
  end;
end;

function ConvertBox2BackgroundCode(bgnd_code_077: Integer): TBackgroundCode;
begin
  case bgnd_code_077 of
    -1:
      Result := bkcLibrary;
    0:
      Result := bkcUnused;
    1:
      Result := bkcBackground;
    else
      raise Exception.CreateFmt('Unknown bgnd_code_077: %d', [bgnd_code_077]);
  end;
end;

function ConvertBox2RailType(rail_type: Integer): TRailSection;
begin
  case rail_type of
    0:
      Result := rsNoRails;
    1:
      Result := rsBullhead;
    2:
      Result := rsFlatbottom;
    else
      raise Exception.CreateFmt('Unknown rail_type: %d', [rail_type]);
  end;
end;

function ConvertBox2UninclinedRails(uninclined_rails: Boolean): TRailsInclined;
begin
  if uninclined_rails then
    Result := riVertical
  else
    Result := riInclined;
end;

function ConvertBox2FlaredEnd(flared_ends: Integer): TFlaredEnd;
begin
  case flared_ends of
    0:
      Result := feBent;
    1:
      Result := feMachined;
    else
      raise Exception.CreateFmt('Unknown flared_ends: %d', [flared_ends]);
  end;
end;

function ConvertBox2KnuckleCode(knuckle_code: Integer): TKnuckleCode;
begin
  case knuckle_code of
    -1:
      Result := kcSharp;
    0:
      Result := kcNormal;
    1:
      Result := kcCustom;
    else
      raise Exception.CreateFmt('Unknown knuckle_code: %d', [knuckle_code]);
  end;
end;

function ConvertBox2CentrelineOptionCode(option_code: Integer): TCentrelineOption;
begin
  case option_code of
    -3:
      Result := cloMainSideSleeperEnds;
    -2:
      Result := cloMainSideTrack;
    -1:
      Result := cloMainSideDouble;
    0:
      Result := cloNormal;
    1:
      Result := cloTurnoutSideDouble;
    2:
      Result := cloTurnoutSideTrack;
    3:
      Result := cloMainSideSleeperEnds;
    99:
      Result := cloCustom;
    else
      raise Exception.CreateFmt('Unknown centreline option_code: %d', [option_code]);
  end;
end;

procedure ConvertBox2ToRailInfo(rail_info: TBox2RailInfo; template: TTemplate);
var
  ri: TRailInfo;
begin
  ri := template.boxDims.railInfo;

  ri.flaredEnds := ConvertBox2FlaredEnd(rail_info.flared_ends_ri);
  ri.knuckleCode := ConvertBox2KnuckleCode(rail_info.knuckle_code_ri);
  ri.knuckleRadius := rail_info.knuckle_radius_ri;
  ri.isolatedCrossing := rail_info.isolated_crossing_sw;
  ri.kDiagonalSideCheckRail := rail_info.k_diagonal_side_check_rail_sw;
  ri.kMainSideCheckRail := rail_info.k_main_side_check_rail_sw;
  ri.switchDrive := rail_info.switch_drive_sw;
  ri.trackCentreLines := rail_info.track_centre_lines_sw;
  ri.turnoutRoadStockRail := rail_info.turnout_road_stock_rail_sw;
  ri.turnoutRoadCheckRail := rail_info.turnout_road_check_rail_sw;
  ri.turnoutRoadCrossingRail := rail_info.turnout_road_crossing_rail_sw;
  ri.crossingVee := rail_info.crossing_vee_sw;
  ri.mainRoadCrossingRail := rail_info.main_road_crossing_rail_sw;
  ri.mainRoadCheckRail := rail_info.main_road_check_rail_sw;
  ri.mainRoadStockRail := rail_info.main_road_stock_rail_sw;
end;

procedure ConvertBox2ToProtoInfo(proto_info: TBox2ProtoInfo; template: TTemplate);
var
  pi: TProtoInfo;
begin
  pi := template.boxDims.protoInfo;

  pi.Name := proto_info.name_str_pi;
  pi.scale := proto_info.scale_pi;
  pi.gauge := proto_info.gauge_pi;
  pi.flangeway := proto_info.fw_pi;
  pi.flangewayEnd := proto_info.fwe_pi;
  pi.flareLength := proto_info.xing_fl_pi;
  pi.railtopWidth := proto_info.railtop_pi;
  pi.turnoutSideTrackCentres := proto_info.trtscent_pi;
  pi.mainSideTrackCentres := proto_info.trmscent_pi;
  pi.returnCurveTrackCentres := proto_info.retcent_pi;
  pi.minimumRadius := proto_info.min_radius_pi;
  pi.turnoutTimberWidth := proto_info.tbwide_pi;
  pi.sleeperWidth := proto_info.slwide_pi;
  pi.maxTimberSpacing := proto_info.ftimbspmax_pi;
  pi.sleeperLength := proto_info.tb_pi;
  pi.mainsideEnds := proto_info.mainside_ends_pi;
  pi.sleeperWidthAtRailJoint := proto_info.jt_slwide_pi;
  pi.timberEndRandomising := proto_info.random_end_pi;
  pi.timberThickness := proto_info.timber_thick_pi;
  pi.timberEndRandomising := proto_info.random_angle_pi;

  pi.checkRailLengthMainSide1 := proto_info.ck_ms_working1_pi;
  pi.checkRailLengthMainSide2 := proto_info.ck_ms_working2_pi;
  pi.checkRailLengthMainSide3 := proto_info.ck_ms_working3_pi;

  pi.checkRailExtensionMainSide1 := proto_info.ck_ms_ext1_pi;
  pi.checkRailExtensionMainSide2 := proto_info.ck_ms_ext2_pi;
  pi.wingRailReachMainSide1 := proto_info.wing_ms_reach1_pi;
  pi.wingRailReachMainSide2 := proto_info.wing_ms_reach2_pi;
  pi.railBottom := proto_info.railbottom_pi;
  pi.railHeight := proto_info.rail_height_pi;
  pi.seatThick := proto_info.seat_thick_pi;

  pi.oldPlainSleeperLength := proto_info.old_tb_pi;
  pi.railInclination := proto_info.rail_inclination_pi;
  pi.footHeight := proto_info.foot_height_pi;
  pi.chairOutLength := proto_info.chair_outlen_pi;
  pi.chairInLength := proto_info.chair_inlen_pi;
  pi.chairWidth := proto_info.chair_width_pi;
  pi.chairCornerRadius := proto_info.chair_corner_pi;

end;

function ConvertBox2Point(pt: TBox2PointEx): Tpex;
begin
  Result.set_xy(pt.x, pt.y);
end;

procedure ConvertBox2ToNotchInfo(const notch: TBox2Notch; template: TTemplate);
var
  ni: TNotchInfo;
begin
  ni := template.boxDims.transformInfo.notchInfo;

  ni.x := notch.notch_x;
  ni.y := notch.notch_y;
  ni.k := notch.notch_k;
end;

procedure ConvertBox2ToTransformInfo(const transform: TBox2TransformInfo; template: TTemplate);
var
  ti: TTransformInfo;
begin
  ti := template.boxDims.transformInfo;

  ti.datumY := transform.datum_y;
  ti.x1Shift := transform.x1_shift;
  ti.y1Shift := transform.y1_shift;
  ti.kShift := transform.k_shift;
  ti.x2Shift := transform.x2_shift;
  ti.y2Shift := transform.y2_shift;
  ti.pegPos := ConvertBox2Point(transform.peg_pos);
  ti.pegPointCode := transform.peg_point_code;
  ti.pegPointRail := transform.peg_point_rail;
  ti.mirrorOnX := transform.mirror_on_x;
  ti.mirrorOnY := transform.mirror_on_y;

  ConvertBox2ToNotchInfo(transform.notch_info, template);
end;

procedure ConvertBox2ToPlatformTrackbedInfo(platform: TBox2PlatformTrackbedInfo;
  template: TTemplate);
var
  pi: TPlatformTrackbedInfo;
begin
  pi := template.boxDims.platformTrackbedInfo;

  pi.adjacentEdges := platform.adjacent_edges_keep;
  pi.drawMSTrackbedEdge := platform.draw_ms_trackbed_edge_keep;
  pi.drawTSTrackbedEdge := platform.draw_ts_trackbed_edge_keep;

  pi.drawTSPlatform := platform.draw_ts_platform_keep;
  pi.drawTSPlatformEndEdge := platform.draw_ts_platform_end_edge_keep;
  pi.drawTSPlatformRearEdge := platform.draw_ts_platform_end_edge_keep;

  pi.platformTSFrontEdgeIns := platform.platform_ts_front_edge_ins_keep;
  pi.platformTSStartWidthIns := platform.platform_ts_start_width_ins_keep;
  pi.platformTSEndWidthIns := platform.platform_ts_end_width_ins_keep;
  pi.platformTSStartMM := platform.platform_ts_start_mm_keep;
  pi.platformTSLengthMM := platform.platform_ts_length_mm_keep;

  pi.drawMSPlatform := platform.draw_ms_platform_keep;
  pi.drawMSPlatformStartEdge := platform.draw_ms_platform_start_edge_keep;
  pi.drawMSPlatformEndEdge := platform.draw_ms_platform_end_edge_keep;
  pi.drawMSPlatformRearEdge := platform.draw_ms_platform_rear_edge_keep;

  pi.platformMSFrontEdgeIns := platform.platform_ms_front_edge_ins_keep;
  pi.platformMSStartWidthIns := platform.platform_ms_start_width_ins_keep;
  pi.platformMSEndWidthIns := platform.platform_ms_end_width_ins_keep;
  pi.platformMSStartMM := platform.platform_ms_start_mm_keep;
  pi.platformMSLengthMM := platform.platform_ms_length_mm_keep;

  pi.platformMSStartSkewMM := platform.platform_ms_start_skew_mm_keep;
  pi.platformMSEndSkewMM := platform.platform_ms_end_skew_mm_keep;
  pi.platformTSStartSkewMM := platform.platform_ts_start_skew_mm_keep;
  pi.platformTSEndSkewMM := platform.platform_ts_end_skew_mm_keep;

  pi.trackbedMSWidthIns := platform.trackbed_ms_width_ins_keep;
  pi.trackbedTSWidthIns := platform.trackbed_ts_width_ins_keep;
  pi.cessMSWidthIns := platform.cess_ms_width_ins_keep;
  pi.cessTSWidthIns := platform.cess_ts_width_ins_keep;
  pi.drawMSTrackbedCessEdge := platform.draw_ms_trackbed_cess_edge_keep;
  pi.drawTSTrackbedCessEdge := platform.draw_ts_trackbed_cess_edge_keep;

  pi.trackbedMSStartMM := platform.trackbed_ms_start_mm_keep;
  pi.trackbedMSLengthMM := platform.trackbed_ms_length_mm_keep;
  pi.trackbedTSStartMM := platform.trackbed_ts_start_mm_keep;
  pi.trackbedTSLengthMM := platform.trackbed_ts_length_mm_keep;
end;

procedure ConvertBox2ToAlignmentInfo(const align: TBox2AlignmentInfo; template: TTemplate);
var
  ai: TAlignmentInfo;
  cl: TCentreline;
begin
  ai := template.boxDims.alignmentInfo;

  ai.drawCentrelineOnly := align.cl_only_flag;
  ai.dummyTemplateFlag := align.dummy_template_flag;
  ai.reminderFlag := align.reminder_flag;
  ai.reminderColour := align.reminder_colour;
  ai.reminderStr := align.reminder_str;

  cl := template.centreline;
  cl.option := ConvertBox2CentrelineOptionCode(align.cl_options_code_int);
  cl.customOffset := align.cl_options_custom_offset_ext;
end;

function ConvertBox2SlewMode(slew_type: Byte): ESlewMode;
begin
  case slew_type of
    1:
      Result := smCosine;
    2:
      Result := smTanH;
    else
      raise Exception.CreateFmt('Unknown slew_type: %d', [slew_type]);
  end;
end;

procedure ConvertBox2ToCurve(const align: TBox2AlignmentInfo; template: TTemplate);
var
  c: TCurve;
begin
  c := template.curve;

  c.isSpiral := align.trans_flag;
  c.fixedRadius := align.fixed_rad;
  c.transitionStartRadius := align.trans_rad1;
  c.transitionEndRadius := align.trans_rad2;
  c.transitionLength := align.trans_length;
  c.distanceToTransition := align.trans_start;

  c.isSlewing := align.slewing_flag;
  c.slewMode := ConvertBox2SlewMode(align.slew_type);
  c.slewFactor := align.tanh_kmax;
  c.distanceToStartOfSlew := align.slew_start;
  c.slewLength := align.slew_length;
  c.slewAmount := align.slew_amount;

  //
  // TODO: perform some magic to make T2 slew parameters match
  //       OT slew parameters...
  //
end;

function ConvertBox2TypeDiff(type_diff: Integer): TDiffType;
begin
  case type_diff of
    0:
      Result := dtNoDiff;
    1:
      Result := dtBentFlare;
    2:
      Result := dtMachinedFlare;
    3:
      Result := dtNoFlare;
    else
      raise Exception.CreateFmt('Unknown type_diff: %d', [type_diff]);
  end;
end;

procedure ConvertBox2CheckEndDiffs(const end_diff: TBox2CheckEndDiff; ed: TCheckEndDiff);
begin
  ed.lenDiff := end_diff.len_diff;
  ed.flareDiff := end_diff.flr_diff;
  ed.gapDiff := end_diff.gap_diff;
  ed.typeDiff := ConvertBox2TypeDiff(end_diff.type_diff);
end;

procedure ConvertBox2ToCheckDiffs(const check_diffs: TBox2CheckDiffs; template: TTemplate);
var
  cd: TCheckDiffs;
begin
  cd := template.boxDims.checkDiffs;

  ConvertBox2CheckEndDiffs(check_diffs.end_diff_mw, cd.endDiffMW);
  ConvertBox2CheckEndDiffs(check_diffs.end_diff_me, cd.endDiffME);
  ConvertBox2CheckEndDiffs(check_diffs.end_diff_mr, cd.endDiffMR);
  ConvertBox2CheckEndDiffs(check_diffs.end_diff_tw, cd.endDiffTW);
  ConvertBox2CheckEndDiffs(check_diffs.end_diff_te, cd.endDiffTE);
  ConvertBox2CheckEndDiffs(check_diffs.end_diff_tr, cd.endDiffTR);
  ConvertBox2CheckEndDiffs(check_diffs.end_diff_mk, cd.endDiffMK);
  ConvertBox2CheckEndDiffs(check_diffs.end_diff_dk, cd.endDiffDK);
end;

procedure ConvertBox2ToTurnoutInfo1(const turnout_info1: TBox2TurnoutInfo1; template: TTemplate);
var
  ti: TTurnoutInfo1;
begin
  ti := template.boxDims.turnoutInfo1;

  ti.plainTrack := turnout_info1.plain_track_flag;
  ti.rolledInSleepered := turnout_info1.rolled_in_sleepered_flag;
  ti.frontTimbers := turnout_info1.front_timbers_flag;
  ti.approachRailsOnly := turnout_info1.approach_rails_only_flag;
  ti.hand := ConvertBox2Hand(turnout_info1.hand);
  ti.timbering := turnout_info1.timbering_flag;
  ti.switchTimbers := turnout_info1.switch_timbers_flag;
  ti.closureTimbers := turnout_info1.closure_timbers_flag;
  ti.xingTimbers := turnout_info1.xing_timbers_flag;
  ti.exitTimbering := turnout_info1.exit_timbering;
  ti.turnoutRoadCode := turnout_info1.turnout_road_code;
  ti.turnoutLength := turnout_info1.turnout_length;
  ti.originToToe := turnout_info1.origin_to_toe;
  ti.stepSize := turnout_info1.step_size;
  ti.turnoutRoadIsAdjustable := turnout_info1.turnout_road_is_adjustable;
  ti.turnoutRoadIsMinimum := turnout_info1.turnout_road_is_minimum;
end;

function ConvertBox2DateTime(keepDate, keepTime: String): TDateTime;
begin

end;

procedure ConvertBox2ToBoxDims1(const boxDims1: TBox2Dims1; template: TTemplate);
var
  bd: TBoxDims;
begin
  bd := template.boxDims;

  //bd.keepTimestamp := ConvertBox2DateTime(boxDims1.keep_date, boxDims1.keep_time);

  bd.thisWasControlTemplate := boxDims1.this_was_control_template;
  bd.gaugeIndex := boxDims1.gauge_index;
  bd.gaugeExact := boxDims1.gauge_exact;
  bd.gaugeCustom := boxDims1.gauge_custom;

  bd.backgroundCode := ConvertBox2BackgroundCode(boxDims1.bgnd_code_077);
  bd.printMappingColour := boxDims1.print_mapping_colour;
  bd.padMarkerColour := boxDims1.pad_marker_colour;
  bd.usePrintMappingColour := boxDims1.use_print_mapping_colour;
  bd.usePadMarkerColour := boxDims1.use_pad_marker_colour;

  bd.idNumber := boxDims1.id_number;
  bd.idNumberStr := boxDims1.id_number_str;
  bd.railSection := ConvertBox2RailType(boxDims1.rail_type);
  bd.flatbottomKludge := boxDims1.fb_kludge_template_code;
  bd.railsInclined := ConvertBox2UninclinedRails(boxDims1.uninclined_rails);
  bd.disableF7Snap := boxDims1.disable_f7_snap;
  bd.labelModifierX := boxDims1.mod_text_x;
  bd.labelModifierY := boxDims1.mod_text_y;
  bd.flatbottomWidth := boxDims1.flatbottom_width;

  bd.retainDiffsOnMake := boxDims1.retain_diffs_on_make_flag;
  bd.retainDiffsOnMint := boxDims1.retain_diffs_on_mint_flag;
  bd.retainEntryStraightOnMake := boxDims1.retain_entry_straight_on_make_flag;
  bd.retainEntryStraightOnMint := boxDims1.retain_entry_straight_on_mint_flag;
  bd.retainShovesOnMake := boxDims1.retain_shoves_on_make_flag;
  bd.retainShovesOnMint := boxDims1.retain_shoves_on_mint_flag;

  ConvertBox2ToRailInfo(boxDims1.rail_info, template);
  ConvertBox2ToProtoInfo(boxDims1.proto_info, template);
  ConvertBox2ToTransformInfo(boxDims1.transform_info, template);
  ConvertBox2ToPlatformTrackbedInfo(boxDims1.platform_trackbed_info, template);
  ConvertBox2ToAlignmentInfo(boxDims1.align_info, template);
  ConvertBox2ToCurve(boxDims1.align_info, template);
  ConvertBox2ToCheckDiffs(boxDims1.check_diffs, template);
  ConvertBox2ToTurnoutInfo1(boxDims1.turnout_info1, template);
end;

procedure ConvertBox2SwitchTimberCentres(const switch_info: TBox2SwitchInfo; sw: TSwitchInfo);
var
  i: Integer;
begin
  sw.ClearTimberCentres;
  for i := 0 to swtimbco_c do begin
    if switch_info.timber_centres[i] = 0 then
      Exit;

    sw.AddTimberCentres(switch_info.timber_centres[i]);
  end;
end;

procedure ConvertBox2ToSwitchInfo(const switch_info: TBox2SwitchInfo; template: TTemplate);
var
  sw: TSwitchInfo;
begin
  sw := template.turnoutInfo2.switchInfo;

  sw.switchPattern := switch_info.sw_pattern;
  sw.planingLength := switch_info.planing;
  sw.planingAngle := switch_info.planing_angle;
  sw.switchRadius := switch_info.switch_radius_inchormax;
  sw.switchRailLength := switch_info.switch_rail;
  sw.stockRailLength := switch_info.stock_rail;
  sw.heelLead := switch_info.heel_lead_inches;
  sw.heelOffset := switch_info.heel_offset_inches;
  sw.switchFront := switch_info.switch_front_inches;
  sw.planingRadius := switch_info.planing_radius;
  sw.sleeperJ1 := switch_info.sleeper_j1;
  sw.sleeperJ2 := switch_info.sleeper_j2;
  sw.groupCode := switch_info.group_code;
  sw.sizeCode := switch_info.size_code;
  sw.joggleDepth := switch_info.joggle_depth;
  sw.joggleLength := switch_info.joggle_length;
  sw.groupCount := switch_info.group_count;
  sw.joggledStockRail := switch_info.joggled_stock_rail;
  sw.validData := switch_info.valid_data;
  sw.frontTimbered := switch_info.front_timbered;
  sw.numBridgeChairsMainRail := switch_info.num_bridge_chairs_main_rail;
  sw.numBridgeChairsTurnoutRail := switch_info.num_bridge_chairs_turnout_rail;
  sw.fbTipOffset := switch_info.fb_tip_offset;
  sw.sleeperJ3 := switch_info.sleeper_j3;
  sw.sleeperJ4 := switch_info.sleeper_j4;
  sw.sleeperJ5 := switch_info.sleeper_j5;
  sw.numSlideChairs := switch_info.num_slide_chairs;
  sw.numBlockSlideChairs := switch_info.num_block_slide_chairs;
  sw.numBlockHeelChairs := switch_info.num_block_heel_chairs;

  ConvertBox2SwitchTimberCentres(switch_info, sw);
end;

procedure ConvertBox2ToCrossingInfo(const crossing: TBox2CrossingInfo; template: TTemplate);
var
  ci: TCrossingInfo;
begin
  ci := template.turnoutInfo2.crossingInfo;

  ci.pattern := crossing.pattern;
  ci.slMode := crossing.sl_mode;
  ci.returnCentresMode := crossing.retcent_mode;
  ci.k3nUnitAngle := crossing.k3n_unit_angle;
  ci.fixedSt := crossing.fixed_st;
  ci.hdTimbersCode := crossing.hd_timbers_code;
  ci.hdVchecksCode := crossing.hd_vchecks_code;
  ci.kCheckLength1 := crossing.k_check_length_1;
  ci.kCheckLength2 := crossing.k_check_length_2;
  ci.kCheckModDS := crossing.k_check_mod_ds;
  ci.kCheckModMS := crossing.k_check_mod_ms;
  ci.kCheckFlare := crossing.k_check_flare;
  ci.curviformTimbering := crossing.curviform_timbering_keep;
  ci.mainRoadCode := crossing.main_road_code;
  ci.tandemTimberCode := crossing.tandem_timber_code;
  ci.bluntNoseWidth := crossing.blunt_nose_width;
  ci.bluntNoseToTimber := crossing.blunt_nose_to_timb;
  ci.veeJointHalfSpacing := crossing.vee_joint_half_spacing;
  ci.wingJointSpacing := crossing.wing_joint_spacing;
  ci.wingTimberSpacing := crossing.wing_timber_spacing;
  ci.veeTimberSpacing := crossing.vee_timber_spacing;
  ci.veeJointSpaceCo1 := crossing.vee_joint_space_co1;
  ci.veeJointSpaceCo2 := crossing.vee_joint_space_co2;
  ci.veeJointSpaceCo3 := crossing.vee_joint_space_co3;
  ci.veeJointSpaceCo4 := crossing.vee_joint_space_co4;
  ci.veeJointSpaceCo5 := crossing.vee_joint_space_co5;
  ci.veeJointSpaceCo6 := crossing.vee_joint_space_co6;
  ci.wingJointSpaceCo1 := crossing.wing_joint_space_co1;
  ci.wingJointSpaceCo2 := crossing.wing_joint_space_co2;
  ci.wingJointSpaceCo3 := crossing.wing_joint_space_co3;
  ci.wingJointSpaceCo4 := crossing.wing_joint_space_co4;
  ci.wingJointSpaceCo5 := crossing.wing_joint_space_co5;
  ci.wingJointSpaceCo6 := crossing.wing_joint_space_co6;
  ci.mainRoadEndX := crossing.main_road_endx_infile;
  ci.hdkn := crossing.hdkn_unit_angle;
  ci.kCustomWingLong := crossing.k_custom_wing_long_keep;
  ci.kCustomPointLong := crossing.k_custom_point_long_keep;
  ci.useKCustomWingRails := crossing.use_k_custom_wing_rails_keep;
  ci.useKCustomPointRails := crossing.use_k_custom_point_rails_keep;
end;

procedure ConvertBox2SleeperCentres(const track: TBox2PlainTrackInfo; pi: TPlainTrackInfo);
var
  i: Integer;
begin
  for i := 0 to psleep_c do
    pi.sleeperCentres[i] := track.sleeper_centres[i];
end;

procedure ConvertBox2ToPlainTrackInfo(const track: TBox2PlainTrackInfo; template: TTemplate);
var
  pi: TPlainTrackInfo;
begin
  pi := template.turnoutInfo2.plainTrackInfo;

  pi.customPlainTrack := track.pt_custom;
  pi.listIndex := track.list_index;
  pi.railLength := track.rail_length;
  pi.sleepersPerLength := track.sleepers_per_length;
  pi.railJointsCode := track.rail_joints_code;
  pi.userPegRail := track.user_peg_rail;
  pi.userPegX := track.user_pegx;
  pi.userPegY := track.user_pegy;
  pi.userPegK := track.user_pegk;
  pi.plainTrackSpacingName := track.pt_spacing_name_str;
  pi.gauntSleeperModInches := track.gaunt_sleeper_mod_inches;

  ConvertBox2SleeperCentres(track, pi);
end;

procedure ConvertBox2ToHdkCheckRailInfo(const hdk: TBox2HdkCheckRailInfo; template: TTemplate);
var
  h: THdkCheckRailInfo;
begin
  h := template.turnoutInfo2.hdkCheckRailInfo;

  h.kCheckMS1 := hdk.k_check_ms_1;
  h.kCheckMS2 := hdk.k_check_ms_2;
  h.kCheckDS1 := hdk.k_check_ds_1;
  h.kCheckDS2 := hdk.k_check_ds_2;
end;

procedure ConvertBox2ToVeeCheckRailInfo(const vee: TBox2VeeCheckRailInfo; template: TTemplate);
var
  v: TVeeCheckRailInfo;
begin
  v := template.turnoutInfo2.veeCheckRailInfo;

  v.vCheckMSWorking1 := vee.v_check_ms_working1;
  v.vCheckMSWorking2 := vee.v_check_ms_working2;
  v.vCheckMSWorking3 := vee.v_check_ms_working3;
  v.vCheckTSWorking1 := vee.v_check_ts_working1;
  v.vCheckTSWorking2 := vee.v_check_ts_working2;
  v.vCheckTSWorking3 := vee.v_check_ts_working3;
  v.vCheckMSExt1 := vee.v_check_ms_ext1;
  v.vCheckMSExt2 := vee.v_check_ms_ext2;
  v.vCheckTSExt1 := vee.v_check_ts_ext1;
  v.vCheckTSExt2 := vee.v_check_ts_ext2;
  v.vWingMSReach1 := vee.v_wing_ms_reach1;
  v.vWingMSReach2 := vee.v_wing_ms_reach2;
  v.vWingTSReach1 := vee.v_wing_ts_reach1;
  v.vWingTSReach2 := vee.v_wing_ts_reach2;
end;

procedure ConvertBox2ToTurnoutInfo2(const info2: TBox2TurnoutInfo2; template: TTemplate);
var
  ti: TTurnoutInfo2;
begin
  ti := template.turnoutInfo2;

  ti.diamondAutoCode := info2.diamond_auto_code;
  ti.bonusTimberCount := info2.bonus_timber_count;
  ti.equalizingFixed := info2.equalizing_fixed_flag;
  ti.noTimbering := info2.no_timbering_flag;
  ti.angledOn := info2.angled_on_flag;
  ti.chairing := info2.chairing_flag;
  ti.startDrawX := info2.start_draw_x;
  ti.timberLengthInc := info2.timber_length_inc;
  ti.omitSwitchFrontJoints := info2.omit_switch_front_joints;
  ti.omitSwitchRailJoints := info2.omit_switch_rail_joints;
  ti.omitStockRailJoints := info2.omit_stock_rail_joints;
  ti.omitWingRailJoints := info2.omit_wing_rail_joints;
  ti.omitVeeRailJoints := info2.omit_vee_rail_joints;
  ti.omitKCrossingStockRailJoints := info2.omit_k_crossing_stock_rail_joints;
  ti.diamondSwitchTimbering := info2.diamond_switch_timbering_flag;
  ti.gaunt := info2.gaunt_flag;
  ti.diamondProtoTimbering := info2.diamond_proto_timbering_flag;
  ti.semiDiamond := info2.semi_diamond_flag;
  ti.diamondFixed := info2.diamond_fixed_flag;
  ti.turnoutRoadEndX := info2.turnout_road_endx_infile;
  ti.templateType := info2.template_type_str;
  ti.smallestRadius := info2.smallest_radius_stored;
  ti.dpx := info2.dpx_stored;
  ti.ipx := info2.ipx_stored;
  ti.fpx := info2.fpx_stored;
  ti.gauntOffsetInches := info2.gaunt_offset_inches;
  ti.dxfConnector0 := info2.dxf_connector_0;
  ti.dxfConnectorT := info2.dxf_connector_t;
  ti.dxfConnector9 := info2.dxf_connector_9;

  ConvertBox2ToSwitchInfo(info2.switch_info, template);
  ConvertBox2ToCrossingInfo(info2.crossing_info, template);
  ConvertBox2ToPlainTrackInfo(info2.plain_track_info, template);
  ConvertBox2ToHdkCheckRailInfo(info2.hdk_check_rail_info, template);
  ConvertBox2ToVeeCheckRailInfo(info2.vee_check_rail_info, template);
end;

function ConvertBox2ToTemplate(box2Template: TBox2Template): TTemplate;
begin
  Result := TTemplate.Create(nil);
  try
    Result.Name := box2Template.Name;
    Result.memo := box2Template.memo;

    ConvertBox2ToBoxDims1(box2Template.keepDims.old_keep_dims1.box_dims1, Result);
    ConvertBox2ToTurnoutInfo2(box2Template.keepDims.old_keep_dims2.turnout_info2, Result);
    ConvertBox2ToShovedTimbers(box2Template.shovedTimbers, Result);
  except
    Result.Free;
    raise;
  end;
end;


function ConvertBox2ToProject(box2Templates: TBox2TemplateList): TProject;
var
  project: TProject;
  b: TBox2Template;
begin
  project := TProject.Create(nil);
  try
    for b in box2Templates do begin
      project.templates.Add(ConvertBox2ToTemplate(b));
    end;
  except
    project.Free;
    raise;
  end;
  Result := project;
end;


procedure LoadNewFormat(
  const boxFilename: string;
  out projectTitle: string;
  out gridInfo: TGridInfo;
  out newProject: TProject);
var
  boxFile: file;                // new format untyped file.
  n, i, len: integer;
  box2Templates: TBox2TemplateList;
begin
  newProject := nil;
  box2Templates := nil;
  try
    try
      AssignFile(boxFile, boxFilename);
      Reset(boxFile, 1);              // open for reading, record size = 1 byte.
      try
        box2Templates := TBox2TemplateList.Create;

        ReadTemplateRecords(boxFile, box2Templates);
        ReadStrings(boxFile, box2Templates);
        ReadDataBlocks(boxFile, box2Templates);
      finally
        CloseFile(boxFile);
      end;

      projectTitle := ExtractProjectTitle(box2Templates);
      gridInfo := ExtractGridInfo(box2Templates);
      newProject := ConvertBox2ToProject(box2Templates);
    except
      newProject.Free;
      newProject := nil;
      raise;
    end
  finally
    box2Templates.Free;
  end;
end;

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
var
  i, n, fsize{,timb_index}: integer;
  loaded_str, box_str, ixt_str, ident: string;
  no_ixt: boolean;
  resave_needed: boolean;
  s, info_string, memo_string, _str: string;
  saved_cursor: TCursor;
  restored_save_done: boolean;

  old_next_data: TBox2KeepDims;

  thisTemplate: TTemplate;

  number_read: integer;

  inbyte: byte;

  loadDialog: TOpenDialog;
  waitMessage: IAutoWaitMessage;

  projectTitle: string;
  gridInfo: TGridInfo;
  newProject: TProject;
  t: TTemplate;
begin

  t2box_log := Logger.GetInstance('T2-box');

  Result := False;               // init.
  last_bgnd_loaded_index := -1;  // init.

  if (append = False) and (keeps_list.Count > 0) {xxx and (load_backup = False)} and
    (file_name = '') // something already there ?
  then begin
    if not save_done then begin
      i := alert(7, '      reload  storage  box  -  save  first ?',
        'Your storage box contains one or more templates which have not yet been saved.' +
        ' Importing a box file will replace all of the existing contents and background drawing.'
        + '||These templates can be restored by clicking the `0UNDO RELOAD / UNDO CLEAR`1 menu item.'
        + ' But if any of these templates may be needed again, you should save them in a named data file.'
        + '||Do you want to replace all templates or cancel importing?', '',
        '', 'cancel import    ',
        'replace  existing  contents  without  saving    ', '',
        '', 0);
      if i = 3 then begin
        Exit;
      end;
    end
    else begin      //  it has been saved...
      i := alert(7, '      reload  storage  box  -  clear  first ?',
        'Your storage box contains one or more existing templates.' +
        ' Importing a box file will replace all of the existing contents and background drawing.'
        + '||Are you sure you want to replace the existing templates?', '',
        '', '', '', 'cancel import    ',
        'import and replace existing contents      ', 0);
      if i = 5 then begin
        Exit;
      end;
    end;
  end;

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

  if not FileExists(box_str) then begin
    alert(5, '    error  -  file  not  found',
      '||The file :' + '||' + box_str +
      '||is not available. Please check that the file you require exists in the named folder. Then try again.'
      + '||No changes have been made to your storage box.',
      '', '', '', '', 'cancel  reload', '', 0);
    EXIT;
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

    // begin loading...

    saved_cursor := Screen.Cursor;

    try
      Screen.Cursor := crHourGlass;        // could take a while if big file.
      if Application.Terminated = False then
        Application.ProcessMessages;       // so let the form repaint.

      // first clear all existing (sets save_done:=True), and save existing for undo.
      clear_keeps(False, True);

      if not BoxFileIsNewFormat(box_str) then
        Exit;

      // load the file...
      if normal_load then
        waitMessage := TWaitForm.ShowWaitMessage('loading  templates ...');

      if not Application.Terminated then
        Application.ProcessMessages;           // let the wait form fully paint.

      LoadNewFormat(box_str, projectTitle, gridInfo, newProject);

      // file loaded...

      if (file_name = '') then
        loaded_str := box_str     // file name from the "open" dialog.
      else begin
        if ExtractFileExt(file_name) = '.box' then
          loaded_str := file_name
        else
          loaded_str := 'data file';        // don't confuse him with internal file names.
      end;

      if (ExtractFileExt(loaded_str) = '.box') and (normal_load) then begin
        // 208d not for file viewer
        boxmru_update(loaded_str);                              // 0.82.a  update the mru list.

        box_project_title_str := projectTitle;  // change the title to the one loaded last.

        // file loaded, check it and update the background drawing...
        with old_next_data.old_keep_dims1.box_dims1 do begin

          //     0.79.a 20-05-06  -- saved grid info -- read from last template only...
          //     0.91.d -- read these only if prefs not being used on startup.

          // 0.79 file or later --- change grid to as loaded...
          if (grid_units_code <> 0) and (user_prefs_in_use = False) then begin

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
      end;

      current_state(0);       // update or create listbox entries, need names for refresh...

      // refresh or clear backgrounds for newly loaded keeps...

      if keeps_list.Count <= 0 then
        EXIT;   // cleared on error or nothing loaded.

      with keep_form do begin

        i := 0;

        for n := i to (keeps_list.Count - 1) do begin
          t := keeps_list[n];
          if t.boxDims.backgroundCode = bkcBackground then begin
            if update_background_menu_entry.Checked then begin
              last_bgnd_loaded_index := n;
              // update index to highest loaded bgnd (for minting).
              list_position := n;
              // put new keep on background.
              copy_keep_to_background(n, False, True);
              // don't update info, reloading=True.
            end
            else begin
              t.boxDims.backgroundCode := bkcUnused;          // make it unused instead.
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
