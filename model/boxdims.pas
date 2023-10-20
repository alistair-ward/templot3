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
  ProtoInfo,
  TransformInfo,
  PlatformTrackbedInfo,
  AlignmentInfo,
  CheckDiffs,
  TurnoutInfo1;


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

(/) this_was_control_template: boolean;
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

(x)railtop_inches: double;
// full-size inches railtop width - was spare_float1:double;
(x)railbottom_inches: double;
// full-size inches railbottom width - was spare_float2:double;

(x)alignment_byte_4: byte;   // D5 0.81 12-06-05
(x)alignment_byte_5: byte;   // D5 0.81 12-06-05

(x)version_as_loaded: integer;
// mod 0.78.d  14-Feb-2003. the version number as loaded.

(/)bgnd_code_077: integer;          // 0=unused, 1=bgnd, -1=library   0.77.a  2-Sep-02.

(/)print_mapping_colour: integer;   // 0.76.a  27-10-01 //spare_inta:integer;
(/)pad_marker_colour: integer;      // 0.76.a  27-10-01 //spare_intb:integer;

(/)use_print_mapping_colour: boolean;  //spare_boola:boolean;
(/)use_pad_marker_colour: boolean;     //spare_boolb:boolean;

//-------------------------

//  0.79.a 20-05-06  -- saved grid info -- read from last template only...

(x)spare_bool1: boolean;

(x)spare_bool2: boolean;  // out 0.93.a   was show_page_margins_on_pad:boolean;

(x)spare_int2: integer;

(x - moved to TProject)grid_units_code: integer;

(x - moved to TProject)x_grid_spacing: double;
(x - moved to TProject)y_grid_spacing: double;

(x - calculated value)total_length_of_timbering: double;  // 0.96.a


(/)id_number: integer;         // 208a
(/)id_number_str: string[7];   // 208a     -N00000

(x)spare_boolean1: boolean;    // 208a
(x)spare_boolean2: boolean;    // 208a      //spare_str:string[13];


(/) transform_info: Ttransform_info;

(/) platform_trackbed_info: Tplatform_trackbed_info;
// 0.93.a  was check_rail_mints:Tcheck_rail_mints;

(/) align_info: Talignment_info;


(/) rail_type: integer;
// 0=no rails, 1=head only (bullhead), 2=head+foot (flatbottom).   // spare_int1:integer

(/) fb_kludge_template_code: integer;
// 0.94.a   0=normal template, 1=inner foot lines, 2=outer foot lines   //spare_int3:integer;

(x - move to TProject) box_save_done: boolean;
// read only from first keep on restore previous contents. 23-6-00 v:0.62.a      //spare_flag1:boolean;

(/)uninclined_rails: boolean;      // True = rails vertical.

(/)disable_f7_snap: boolean;       //  0.82.a  spare_bool3:boolean;

(x)spare_bool4: boolean;

(/)mod_text_x: double;
// (mm) label position modifiers..   //spare_float1:double;
(/)mod_text_y: double;
//spare_float2:double;

(/)flatbottom_width: double;
// width of flatbottom rail base (mm).    //spare_float3:double;

(/)check_diffs: Tcheck_diffs;      // 0.94.a check rail end modifiers - 248 bytes


(/)retain_diffs_on_make_flag: boolean;    // 0.94.a check rail diffs
(/)retain_diffs_on_mint_flag: boolean;    // 0.94.a check rail diffs

(/)retain_entry_straight_on_make_flag: boolean;
// 213a  spare_byte1:byte;   // 0.94.a
(/)retain_entry_straight_on_mint_flag: boolean;
// 213a  spare_byte2:byte;   // 0.94.a

// 0.94.a timber shoving mods..

(/)retain_shoves_on_make_flag: boolean;
(/)retain_shoves_on_mint_flag: boolean;

(/)turnout_info1: Tturnout_info1;
}


{# class TBoxDims
---
class: TBoxDims
attributes:
- name: uniqueId
  type: Integer
  access: [get]
- name: timestamp
  type: TDateTime
  access: [get]
- name: thisWasControlTemplate
  type: Boolean
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
- name: backgroundCode
  type: TBackgroundCode
- name: printMappingColour
  type: Integer
- name: padMarkerColour
  type: Integer
- name: usePrintMappingColour
  type: Boolean
- name: usePadMarkerColour
  type: Boolean
- name: idNumber
  type: Integer
- name: idNumberStr
  type: String
- name: transformInfo
  type: TTransformInfo
  owns: create
  access: [get]
- name: platformTrackbedInfo
  type: TPlatformTrackbedInfo
  owns: create
  access: [get]
- name: alignmentInfo
  type: TAlignmentInfo
  owns: create
  access: [get]
- name: railSection
  type: TRailSection
- name: flatbottomKludge
  type: Integer
  comment: 0=normal template, 1=inner foot lines, 2=outer foot lines
- name: railsInclined
  type: TRailsInclined
- name: disableF7Snap
  type: Boolean
- name: labelModifierX
  type: Double
  comment: (mm) label position modifier
- name: labelModifierY
  type: Double
  comment: (mm) label position modifier
- name: flatbottomWidth
  type: Double
  comment: width of flatbottom rail base (mm)
- name: checkDiffs
  type: TCheckDiffs
  owns: create
  access: [get]
- name: retainDiffsOnMake
  type: Boolean
- name: retainDiffsOnMint
  type: Boolean
- name: retainEntryStraightOnMake
  type: Boolean
- name: retainEntryStraightOnMint
  type: Boolean
- name: retainShovesOnMake
  type: Boolean
- name: retainShovesOnMint
  type: Boolean
- name: turnoutInfo1
  type: TTurnoutInfo1
  owns: create
  access: [get]
}

type
  TBackgroundCode = (bkcLibrary = -1, bkcUnused = 0, bkcBackground = 1);
  TRailSection = (rsNoRails, rsBullhead, rsFlatbottom);
  TRailsInclined = (riVertical, riInclined);

  TBoxDims = class(TOTPersistent)
  private
    //# genMemberVars
    FUniqueId: Integer;
    FTimestamp: TDateTime;
    FThisWasControlTemplate: Boolean;
    FRailInfo: TOID;
    FGaugeIndex: Integer;
    FGaugeExact: Boolean;
    FGaugeCustom: Boolean;
    FProtoInfo: TOID;
    FBackgroundCode: TBackgroundCode;
    FPrintMappingColour: Integer;
    FPadMarkerColour: Integer;
    FUsePrintMappingColour: Boolean;
    FUsePadMarkerColour: Boolean;
    FIdNumber: Integer;
    FIdNumberStr: String;
    FTransformInfo: TOID;
    FPlatformTrackbedInfo: TOID;
    FAlignmentInfo: TOID;
    FRailSection: TRailSection;
    FFlatbottomKludge: Integer;
    FRailsInclined: TRailsInclined;
    FDisableF7Snap: Boolean;
    FLabelModifierX: Double;
    FLabelModifierY: Double;
    FFlatbottomWidth: Double;
    FCheckDiffs: TOID;
    FRetainDiffsOnMake: Boolean;
    FRetainDiffsOnMint: Boolean;
    FRetainEntryStraightOnMake: Boolean;
    FRetainEntryStraightOnMint: Boolean;
    FRetainShovesOnMake: Boolean;
    FRetainShovesOnMint: Boolean;
    FTurnoutInfo1: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    function GetRailInfo: TRailInfo;
    function GetProtoInfo: TProtoInfo;
    function GetTransformInfo: TTransformInfo;
    function GetPlatformTrackbedInfo: TPlatformTrackbedInfo;
    function GetAlignmentInfo: TAlignmentInfo;
    function GetCheckDiffs: TCheckDiffs;
    function GetTurnoutInfo1: TTurnoutInfo1;
    procedure SetThisWasControlTemplate(const AValue: Boolean);
    procedure SetGaugeIndex(const AValue: Integer);
    procedure SetGaugeExact(const AValue: Boolean);
    procedure SetGaugeCustom(const AValue: Boolean);
    procedure SetBackgroundCode(const AValue: TBackgroundCode);
    procedure SetPrintMappingColour(const AValue: Integer);
    procedure SetPadMarkerColour(const AValue: Integer);
    procedure SetUsePrintMappingColour(const AValue: Boolean);
    procedure SetUsePadMarkerColour(const AValue: Boolean);
    procedure SetIdNumber(const AValue: Integer);
    procedure SetIdNumberStr(const AValue: String);
    procedure SetRailSection(const AValue: TRailSection);
    procedure SetFlatbottomKludge(const AValue: Integer);
    procedure SetRailsInclined(const AValue: TRailsInclined);
    procedure SetDisableF7Snap(const AValue: Boolean);
    procedure SetLabelModifierX(const AValue: Double);
    procedure SetLabelModifierY(const AValue: Double);
    procedure SetFlatbottomWidth(const AValue: Double);
    procedure SetRetainDiffsOnMake(const AValue: Boolean);
    procedure SetRetainDiffsOnMint(const AValue: Boolean);
    procedure SetRetainEntryStraightOnMake(const AValue: Boolean);
    procedure SetRetainEntryStraightOnMint(const AValue: Boolean);
    procedure SetRetainShovesOnMake(const AValue: Boolean);
    procedure SetRetainShovesOnMint(const AValue: Boolean);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
      ALoader: TOTPersistentLoader); override;
    procedure SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property uniqueId: Integer read FUniqueId;
    property timestamp: TDateTime read FTimestamp;
    property thisWasControlTemplate: Boolean read FThisWasControlTemplate write SetThisWasControlTemplate;
    property railInfo: TRailInfo read GetRailInfo;

    // current index into the gauge list.
    property gaugeIndex: Integer read FGaugeIndex write SetGaugeIndex;

    // NYI - If true this is an exact-scale template...
    property gaugeExact: Boolean read FGaugeExact write SetGaugeExact;

    // NYI - If true this is (or was when saved) a custom gauge setting
    property gaugeCustom: Boolean read FGaugeCustom write SetGaugeCustom;
    property protoInfo: TProtoInfo read GetProtoInfo;
    property backgroundCode: TBackgroundCode read FBackgroundCode write SetBackgroundCode;
    property printMappingColour: Integer read FPrintMappingColour write SetPrintMappingColour;
    property padMarkerColour: Integer read FPadMarkerColour write SetPadMarkerColour;
    property usePrintMappingColour: Boolean read FUsePrintMappingColour write SetUsePrintMappingColour;
    property usePadMarkerColour: Boolean read FUsePadMarkerColour write SetUsePadMarkerColour;
    property idNumber: Integer read FIdNumber write SetIdNumber;
    property idNumberStr: String read FIdNumberStr write SetIdNumberStr;
    property transformInfo: TTransformInfo read GetTransformInfo;
    property platformTrackbedInfo: TPlatformTrackbedInfo read GetPlatformTrackbedInfo;
    property alignmentInfo: TAlignmentInfo read GetAlignmentInfo;
    property railSection: TRailSection read FRailSection write SetRailSection;

    // 0=normal template, 1=inner foot lines, 2=outer foot lines
    property flatbottomKludge: Integer read FFlatbottomKludge write SetFlatbottomKludge;
    property railsInclined: TRailsInclined read FRailsInclined write SetRailsInclined;
    property disableF7Snap: Boolean read FDisableF7Snap write SetDisableF7Snap;

    // (mm) label position modifier
    property labelModifierX: Double read FLabelModifierX write SetLabelModifierX;

    // (mm) label position modifier
    property labelModifierY: Double read FLabelModifierY write SetLabelModifierY;

    // width of flatbottom rail base (mm)
    property flatbottomWidth: Double read FFlatbottomWidth write SetFlatbottomWidth;
    property checkDiffs: TCheckDiffs read GetCheckDiffs;
    property retainDiffsOnMake: Boolean read FRetainDiffsOnMake write SetRetainDiffsOnMake;
    property retainDiffsOnMint: Boolean read FRetainDiffsOnMint write SetRetainDiffsOnMint;
    property retainEntryStraightOnMake: Boolean read FRetainEntryStraightOnMake write SetRetainEntryStraightOnMake;
    property retainEntryStraightOnMint: Boolean read FRetainEntryStraightOnMint write SetRetainEntryStraightOnMint;
    property retainShovesOnMake: Boolean read FRetainShovesOnMake write SetRetainShovesOnMake;
    property retainShovesOnMint: Boolean read FRetainShovesOnMint write SetRetainShovesOnMint;
    property turnoutInfo1: TTurnoutInfo1 read GetTurnoutInfo1;
    //# endGenProperty

  end;

  TBoxDimsOwningList = class(TOTOwningList<TBoxDims>);
  TBoxDimsReferenceList = class(TOTReferenceList<TBoxDims>);


function StrToTBackgroundCode(AValue: String): TBackgroundCode;
procedure SaveYamlTBackgroundCode(AEmitter: TYamlEmitter; const AName: String;
  AValue: TBackgroundCode);
function StrToTRailSection(AValue: String): TRailSection;
procedure SaveYamlTRailSection(AEmitter: TYamlEmitter; const AName: String;
  AValue: TRailSection);
function StrToTRailsInclined(AValue: String): TRailsInclined;
procedure SaveYamlTRailsInclined(AEmitter: TYamlEmitter; const AName: String;
  AValue: TRailsInclined);


implementation

uses
  TLoggerUnit,
  Typinfo;

var
  log: ILogger;


function StrToTBackgroundCode(AValue: String): TBackgroundCode;
begin
  Result := TBackgroundCode(GetEnumValue(TypeInfo(TBackgroundCode), AValue));
end;

procedure SaveYamlTBackgroundCode(AEmitter: TYamlEmitter; const AName: String;
  AValue: TBackgroundCode);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TBackgroundCode), Ord(AValue)));
end;

function StrToTRailSection(AValue: String): TRailSection;
begin
  Result := TRailSection(GetEnumValue(TypeInfo(TRailSection), AValue));
end;

procedure SaveYamlTRailSection(AEmitter: TYamlEmitter; const AName: String; AValue: TRailSection);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TRailSection), Ord(AValue)));
end;

function StrToTRailsInclined(AValue: String): TRailsInclined;
begin
  Result := TRailsInclined(GetEnumValue(TypeInfo(TRailsInclined), AValue));
end;

procedure SaveYamlTRailsInclined(AEmitter: TYamlEmitter; const AName: String;
  AValue: TRailsInclined);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TRailsInclined), Ord(AValue)));
end;

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
  if AOID = 0 then
    FTransformInfo := TTransformInfo.Create(nil).oid
  else
    FTransformInfo := 0;
  if AOID = 0 then
    FPlatformTrackbedInfo := TPlatformTrackbedInfo.Create(nil).oid
  else
    FPlatformTrackbedInfo := 0;
  if AOID = 0 then
    FAlignmentInfo := TAlignmentInfo.Create(nil).oid
  else
    FAlignmentInfo := 0;
  if AOID = 0 then
    FCheckDiffs := TCheckDiffs.Create(nil).oid
  else
    FCheckDiffs := 0;
  if AOID = 0 then
    FTurnoutInfo1 := TTurnoutInfo1.Create(nil).oid
  else
    FTurnoutInfo1 := 0;
  //# endGenCreate
end;

destructor TBoxDims.Destroy;
begin
  //# genDestroy
  SetOwned(FRailInfo, nil);
  SetOwned(FProtoInfo, nil);
  SetOwned(FTransformInfo, nil);
  SetOwned(FPlatformTrackbedInfo, nil);
  SetOwned(FAlignmentInfo, nil);
  SetOwned(FCheckDiffs, nil);
  SetOwned(FTurnoutInfo1, nil);
  //# endGenDestroy
  inherited;
end;

procedure TBoxDims.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TBoxDims.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'uniqueId' then
    FUniqueId := StrToInteger(AValue)
  else
  if AName = 'timestamp' then
    FTimestamp := StrToTDateTime(AValue)
  else
  if AName = 'thisWasControlTemplate' then
    FThisWasControlTemplate := StrToBoolean(AValue)
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
  if AName = 'backgroundCode' then
    FBackgroundCode := StrToTBackgroundCode(AValue)
  else
  if AName = 'printMappingColour' then
    FPrintMappingColour := StrToInteger(AValue)
  else
  if AName = 'padMarkerColour' then
    FPadMarkerColour := StrToInteger(AValue)
  else
  if AName = 'usePrintMappingColour' then
    FUsePrintMappingColour := StrToBoolean(AValue)
  else
  if AName = 'usePadMarkerColour' then
    FUsePadMarkerColour := StrToBoolean(AValue)
  else
  if AName = 'idNumber' then
    FIdNumber := StrToInteger(AValue)
  else
  if AName = 'idNumberStr' then
    FIdNumberStr := StrToString(AValue)
  else
  if AName = 'transformInfo' then
    RestoreYamlObjectOwn(FTransformInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'platformTrackbedInfo' then
    RestoreYamlObjectOwn(FPlatformTrackbedInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'alignmentInfo' then
    RestoreYamlObjectOwn(FAlignmentInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'railSection' then
    FRailSection := StrToTRailSection(AValue)
  else
  if AName = 'flatbottomKludge' then
    FFlatbottomKludge := StrToInteger(AValue)
  else
  if AName = 'railsInclined' then
    FRailsInclined := StrToTRailsInclined(AValue)
  else
  if AName = 'disableF7Snap' then
    FDisableF7Snap := StrToBoolean(AValue)
  else
  if AName = 'labelModifierX' then
    FLabelModifierX := StrToDouble(AValue)
  else
  if AName = 'labelModifierY' then
    FLabelModifierY := StrToDouble(AValue)
  else
  if AName = 'flatbottomWidth' then
    FFlatbottomWidth := StrToDouble(AValue)
  else
  if AName = 'checkDiffs' then
    RestoreYamlObjectOwn(FCheckDiffs, StrToInteger(AValue), ALoader)
  else
  if AName = 'retainDiffsOnMake' then
    FRetainDiffsOnMake := StrToBoolean(AValue)
  else
  if AName = 'retainDiffsOnMint' then
    FRetainDiffsOnMint := StrToBoolean(AValue)
  else
  if AName = 'retainEntryStraightOnMake' then
    FRetainEntryStraightOnMake := StrToBoolean(AValue)
  else
  if AName = 'retainEntryStraightOnMint' then
    FRetainEntryStraightOnMint := StrToBoolean(AValue)
  else
  if AName = 'retainShovesOnMake' then
    FRetainShovesOnMake := StrToBoolean(AValue)
  else
  if AName = 'retainShovesOnMint' then
    FRetainShovesOnMint := StrToBoolean(AValue)
  else
  if AName = 'turnoutInfo1' then
    RestoreYamlObjectOwn(FTurnoutInfo1, StrToInteger(AValue), ALoader)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TBoxDims.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FUniqueId, sizeof(Integer));
  AStream.ReadBuffer(FTimestamp, sizeof(TDateTime));
  AStream.ReadBuffer(FThisWasControlTemplate, sizeof(Boolean));
  AStream.ReadBuffer(FRailInfo, sizeof(TOID));
  AStream.ReadBuffer(FGaugeIndex, sizeof(Integer));
  AStream.ReadBuffer(FGaugeExact, sizeof(Boolean));
  AStream.ReadBuffer(FGaugeCustom, sizeof(Boolean));
  AStream.ReadBuffer(FProtoInfo, sizeof(TOID));
  AStream.ReadBuffer(FBackgroundCode, sizeof(TBackgroundCode));
  AStream.ReadBuffer(FPrintMappingColour, sizeof(Integer));
  AStream.ReadBuffer(FPadMarkerColour, sizeof(Integer));
  AStream.ReadBuffer(FUsePrintMappingColour, sizeof(Boolean));
  AStream.ReadBuffer(FUsePadMarkerColour, sizeof(Boolean));
  AStream.ReadBuffer(FIdNumber, sizeof(Integer));
  FIdNumberStr := AStream.ReadAnsiString;
  AStream.ReadBuffer(FTransformInfo, sizeof(TOID));
  AStream.ReadBuffer(FPlatformTrackbedInfo, sizeof(TOID));
  AStream.ReadBuffer(FAlignmentInfo, sizeof(TOID));
  AStream.ReadBuffer(FRailSection, sizeof(TRailSection));
  AStream.ReadBuffer(FFlatbottomKludge, sizeof(Integer));
  AStream.ReadBuffer(FRailsInclined, sizeof(TRailsInclined));
  AStream.ReadBuffer(FDisableF7Snap, sizeof(Boolean));
  AStream.ReadBuffer(FLabelModifierX, sizeof(Double));
  AStream.ReadBuffer(FLabelModifierY, sizeof(Double));
  AStream.ReadBuffer(FFlatbottomWidth, sizeof(Double));
  AStream.ReadBuffer(FCheckDiffs, sizeof(TOID));
  AStream.ReadBuffer(FRetainDiffsOnMake, sizeof(Boolean));
  AStream.ReadBuffer(FRetainDiffsOnMint, sizeof(Boolean));
  AStream.ReadBuffer(FRetainEntryStraightOnMake, sizeof(Boolean));
  AStream.ReadBuffer(FRetainEntryStraightOnMint, sizeof(Boolean));
  AStream.ReadBuffer(FRetainShovesOnMake, sizeof(Boolean));
  AStream.ReadBuffer(FRetainShovesOnMint, sizeof(Boolean));
  AStream.ReadBuffer(FTurnoutInfo1, sizeof(TOID));
  //# endGenRestoreVars
end;

procedure TBoxDims.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FUniqueId, sizeof(Integer));
  AStream.WriteBuffer(FTimestamp, sizeof(TDateTime));
  AStream.WriteBuffer(FThisWasControlTemplate, sizeof(Boolean));
  AStream.WriteBuffer(FRailInfo, sizeof(TOID));
  AStream.WriteBuffer(FGaugeIndex, sizeof(Integer));
  AStream.WriteBuffer(FGaugeExact, sizeof(Boolean));
  AStream.WriteBuffer(FGaugeCustom, sizeof(Boolean));
  AStream.WriteBuffer(FProtoInfo, sizeof(TOID));
  AStream.WriteBuffer(FBackgroundCode, sizeof(TBackgroundCode));
  AStream.WriteBuffer(FPrintMappingColour, sizeof(Integer));
  AStream.WriteBuffer(FPadMarkerColour, sizeof(Integer));
  AStream.WriteBuffer(FUsePrintMappingColour, sizeof(Boolean));
  AStream.WriteBuffer(FUsePadMarkerColour, sizeof(Boolean));
  AStream.WriteBuffer(FIdNumber, sizeof(Integer));
  AStream.WriteAnsiString(FIdNumberStr);
  AStream.WriteBuffer(FTransformInfo, sizeof(TOID));
  AStream.WriteBuffer(FPlatformTrackbedInfo, sizeof(TOID));
  AStream.WriteBuffer(FAlignmentInfo, sizeof(TOID));
  AStream.WriteBuffer(FRailSection, sizeof(TRailSection));
  AStream.WriteBuffer(FFlatbottomKludge, sizeof(Integer));
  AStream.WriteBuffer(FRailsInclined, sizeof(TRailsInclined));
  AStream.WriteBuffer(FDisableF7Snap, sizeof(Boolean));
  AStream.WriteBuffer(FLabelModifierX, sizeof(Double));
  AStream.WriteBuffer(FLabelModifierY, sizeof(Double));
  AStream.WriteBuffer(FFlatbottomWidth, sizeof(Double));
  AStream.WriteBuffer(FCheckDiffs, sizeof(TOID));
  AStream.WriteBuffer(FRetainDiffsOnMake, sizeof(Boolean));
  AStream.WriteBuffer(FRetainDiffsOnMint, sizeof(Boolean));
  AStream.WriteBuffer(FRetainEntryStraightOnMake, sizeof(Boolean));
  AStream.WriteBuffer(FRetainEntryStraightOnMint, sizeof(Boolean));
  AStream.WriteBuffer(FRetainShovesOnMake, sizeof(Boolean));
  AStream.WriteBuffer(FRetainShovesOnMint, sizeof(Boolean));
  AStream.WriteBuffer(FTurnoutInfo1, sizeof(TOID));
  //# endGenSaveVars
end;

procedure TBoxDims.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlInteger(AEmitter, 'uniqueId', FUniqueId);
  SaveYamlTDateTime(AEmitter, 'timestamp', FTimestamp);
  SaveYamlBoolean(AEmitter, 'thisWasControlTemplate', FThisWasControlTemplate);
  SaveYamlObject(AEmitter, 'railInfo', FRailInfo);
  SaveYamlInteger(AEmitter, 'gaugeIndex', FGaugeIndex);
  SaveYamlBoolean(AEmitter, 'gaugeExact', FGaugeExact);
  SaveYamlBoolean(AEmitter, 'gaugeCustom', FGaugeCustom);
  SaveYamlObject(AEmitter, 'protoInfo', FProtoInfo);
  SaveYamlTBackgroundCode(AEmitter, 'backgroundCode', FBackgroundCode);
  SaveYamlInteger(AEmitter, 'printMappingColour', FPrintMappingColour);
  SaveYamlInteger(AEmitter, 'padMarkerColour', FPadMarkerColour);
  SaveYamlBoolean(AEmitter, 'usePrintMappingColour', FUsePrintMappingColour);
  SaveYamlBoolean(AEmitter, 'usePadMarkerColour', FUsePadMarkerColour);
  SaveYamlInteger(AEmitter, 'idNumber', FIdNumber);
  SaveYamlString(AEmitter, 'idNumberStr', FIdNumberStr);
  SaveYamlObject(AEmitter, 'transformInfo', FTransformInfo);
  SaveYamlObject(AEmitter, 'platformTrackbedInfo', FPlatformTrackbedInfo);
  SaveYamlObject(AEmitter, 'alignmentInfo', FAlignmentInfo);
  SaveYamlTRailSection(AEmitter, 'railSection', FRailSection);
  SaveYamlInteger(AEmitter, 'flatbottomKludge', FFlatbottomKludge);
  SaveYamlTRailsInclined(AEmitter, 'railsInclined', FRailsInclined);
  SaveYamlBoolean(AEmitter, 'disableF7Snap', FDisableF7Snap);
  SaveYamlDouble(AEmitter, 'labelModifierX', FLabelModifierX);
  SaveYamlDouble(AEmitter, 'labelModifierY', FLabelModifierY);
  SaveYamlDouble(AEmitter, 'flatbottomWidth', FFlatbottomWidth);
  SaveYamlObject(AEmitter, 'checkDiffs', FCheckDiffs);
  SaveYamlBoolean(AEmitter, 'retainDiffsOnMake', FRetainDiffsOnMake);
  SaveYamlBoolean(AEmitter, 'retainDiffsOnMint', FRetainDiffsOnMint);
  SaveYamlBoolean(AEmitter, 'retainEntryStraightOnMake', FRetainEntryStraightOnMake);
  SaveYamlBoolean(AEmitter, 'retainEntryStraightOnMint', FRetainEntryStraightOnMint);
  SaveYamlBoolean(AEmitter, 'retainShovesOnMake', FRetainShovesOnMake);
  SaveYamlBoolean(AEmitter, 'retainShovesOnMint', FRetainShovesOnMint);
  SaveYamlObject(AEmitter, 'turnoutInfo1', FTurnoutInfo1);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetThisWasControlTemplate(const AValue: Boolean);
begin
  if AValue <> FThisWasControlTemplate then begin
    SetModified;
    FThisWasControlTemplate := AValue;
  end;
end;

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

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetBackgroundCode(const AValue: TBackgroundCode);
begin
  if AValue <> FBackgroundCode then begin
    SetModified;
    FBackgroundCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetPrintMappingColour(const AValue: Integer);
begin
  if AValue <> FPrintMappingColour then begin
    SetModified;
    FPrintMappingColour := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetPadMarkerColour(const AValue: Integer);
begin
  if AValue <> FPadMarkerColour then begin
    SetModified;
    FPadMarkerColour := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetUsePrintMappingColour(const AValue: Boolean);
begin
  if AValue <> FUsePrintMappingColour then begin
    SetModified;
    FUsePrintMappingColour := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetUsePadMarkerColour(const AValue: Boolean);
begin
  if AValue <> FUsePadMarkerColour then begin
    SetModified;
    FUsePadMarkerColour := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetIdNumber(const AValue: Integer);
begin
  if AValue <> FIdNumber then begin
    SetModified;
    FIdNumber := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetIdNumberStr(const AValue: String);
begin
  if AValue <> FIdNumberStr then begin
    SetModified;
    FIdNumberStr := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TBoxDims.GetTransformInfo: TTransformInfo;
begin
  Result := TTransformInfo(FromOID(FTransformInfo));
end;

// GENERATED METHOD - DO NOT EDIT
function TBoxDims.GetPlatformTrackbedInfo: TPlatformTrackbedInfo;
begin
  Result := TPlatformTrackbedInfo(FromOID(FPlatformTrackbedInfo));
end;

// GENERATED METHOD - DO NOT EDIT
function TBoxDims.GetAlignmentInfo: TAlignmentInfo;
begin
  Result := TAlignmentInfo(FromOID(FAlignmentInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRailSection(const AValue: TRailSection);
begin
  if AValue <> FRailSection then begin
    SetModified;
    FRailSection := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetFlatbottomKludge(const AValue: Integer);
begin
  if AValue <> FFlatbottomKludge then begin
    SetModified;
    FFlatbottomKludge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRailsInclined(const AValue: TRailsInclined);
begin
  if AValue <> FRailsInclined then begin
    SetModified;
    FRailsInclined := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetDisableF7Snap(const AValue: Boolean);
begin
  if AValue <> FDisableF7Snap then begin
    SetModified;
    FDisableF7Snap := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetLabelModifierX(const AValue: Double);
begin
  if AValue <> FLabelModifierX then begin
    SetModified;
    FLabelModifierX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetLabelModifierY(const AValue: Double);
begin
  if AValue <> FLabelModifierY then begin
    SetModified;
    FLabelModifierY := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetFlatbottomWidth(const AValue: Double);
begin
  if AValue <> FFlatbottomWidth then begin
    SetModified;
    FFlatbottomWidth := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TBoxDims.GetCheckDiffs: TCheckDiffs;
begin
  Result := TCheckDiffs(FromOID(FCheckDiffs));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRetainDiffsOnMake(const AValue: Boolean);
begin
  if AValue <> FRetainDiffsOnMake then begin
    SetModified;
    FRetainDiffsOnMake := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRetainDiffsOnMint(const AValue: Boolean);
begin
  if AValue <> FRetainDiffsOnMint then begin
    SetModified;
    FRetainDiffsOnMint := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRetainEntryStraightOnMake(const AValue: Boolean);
begin
  if AValue <> FRetainEntryStraightOnMake then begin
    SetModified;
    FRetainEntryStraightOnMake := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRetainEntryStraightOnMint(const AValue: Boolean);
begin
  if AValue <> FRetainEntryStraightOnMint then begin
    SetModified;
    FRetainEntryStraightOnMint := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRetainShovesOnMake(const AValue: Boolean);
begin
  if AValue <> FRetainShovesOnMake then begin
    SetModified;
    FRetainShovesOnMake := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TBoxDims.SetRetainShovesOnMint(const AValue: Boolean);
begin
  if AValue <> FRetainShovesOnMint then begin
    SetModified;
    FRetainShovesOnMint := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TBoxDims.GetTurnoutInfo1: TTurnoutInfo1;
begin
  Result := TTurnoutInfo1(FromOID(FTurnoutInfo1));
end;

//# endGenGetSetMethods

initialization
  TBoxDims.RegisterClass;
  TBoxDimsOwningList.RegisterClass;
  TBoxDimsReferenceList.RegisterClass;

  //log := Logger.GetInstance('TBoxDims');
end.
