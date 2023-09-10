unit ProtoInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;

(*
Tproto_info = record              // was Tgauge_info.

(/)  name_str_pi: string[15];       // gauge designation: 9 chars max actually used

(x)  spare_str_pi: string[75];      // now spares 215a   was  list_str_pi

(/)  scale_pi: double;       // mm per ft.
(/)  gauge_pi: double;       // mm.
(/)  fw_pi: double;       // mm flangeway.
(/)  fwe_pi: double;       // mm flangeway end (flangeway+flare).
(/)  xing_fl_pi: double;       // mm length of flares (not h-d).
(/)  railtop_pi: double;       // mm width of rail top (and bottom if bullhead).
(/)  trtscent_pi: double;       // mm track centres, turnout side.
(/)  trmscent_pi: double;       // mm ditto, main side.
(/)  retcent_pi: double;       // mm ditto, return curve.
(/)  min_radius_pi: double;       // mm minimum radius for check.


  // these 6 wing/check rail lengths used only in pre 0.71.a versions...

(x)  old_winglongs_pi: double;
  // inches full-size length of short wing rail from centre of timber A.
(x)  old_winglongl_pi: double;
  // inches full-size length of long wing rail from centre of timber A.

(x)  old_cklongs_pi: double;
  // inches full-size length of short check rails.
(x)  old_cklongm_pi: double;
  // inches full-size length of medium check rails.
(x)  old_cklongl_pi: double;
  // inches full-size length of long check rails.
(x)  old_cklongxl_pi: double;
  // inches full_size length of extra long check rails.

  tbwide_pi: double;       // inches full-size width of turnout timbers.
  slwide_pi: double;
  // inches full-size width of plain sleepers (not at rail joints 212a).

(x)  xtimbsp_pi: double;
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
*)

{# class TProtoInfo
---
class: TProtoInfo
attributes:
- name: name
  type: String
  comment: "gauge designation: 9 chars max actually used"
- name: scale
  type: Double
  comment: mm per ft.
- name: gauge
  type: Double
  comment: mm.
- name: flangeway
  type: Double
  comment: mm flangeway.
- name: flangewayEnd
  type: Double
  comment: "mm flangeway end (flangeway+flare)."
- name: flareLength
  type: Double
  comment: "mm length of flares (not h-d)."
- name: railtopWidth
  type: Double
  comment: "mm width of rail top (and bottom if bullhead)."
- name: turnoutSideTrackCentres
  type: Double
  comment: mm track centres, turnout side.
- name: mainSideTrackCentres
  type: Double
  comment: mm track centres, main side.
- name: returnCurveTrackCentres
  type: Double
  comment: mm track centres, return curve.
- name: minimumRadius
  type: Double
  comment: mm minimum radius for check.
- name: turnoutTimberWidth
  type: Double
  comment: inches full-size width of turnout timbers.
- name: sleeperWidth
  type: Double
  comment: inches full-size width of plain sleepers (not at rail joints 212a).
- name: maxTimberSpacing
  type: Double
  comment: inches full-size max timber-spacing for closure space.
- name: sleeperLength
  type: Double
  comment: plain sleeper length mm.
- name: mainsideEnds
  type: Boolean
  comment: True=main side ends in line, False=ends centralized.
- name: sleeperWidthAtRailJoint
  type: Double
  comment: inches full-size width of plain sleepers at rail joints.
- name: timberEndRandomising
  type: Double
  comment: amount of timber-end randomising.
- name: timberThickness
  type: Double
  comment: timber thickness (for DXF 3D).
- name: timberAngleRandomising
  type: Double
  comment: amount of timber_angle randomising.
- name: checkRailLengthMainSide1
  type: Double
  comment: full-size inches - size 1 MS check rail working length (back from "A").
- name: checkRailLengthMainSide2
  type: Double
  comment: full-size inches - size 2 MS check rail working length (back from "A").
- name: checkRailLengthMainSide3
  type: Double
  comment: full-size inches - size 3 MS check rail working length (back from "A").
- name: checkRailExtensionMainSide1
  type: Double
  comment: full-size inches - size 1 MS check rail extension length (forward from "A").
- name: checkRailExtensionMainSide2
  type: Double
  comment: full-size inches - size 2 MS check rail extension length (forward from "A").
- name: wingRailReachMainSide1
  type: Double
  comment: full-size inches - size 1 MS wing rail reach length (forward from "A").
- name: wingRailReachMainSide2
  type: Double
  comment: full-size inches - size 2 MS wing rail reach length (forward from "A").
- name:  railBottom
  type: Double
  comment: mm width of railfoot (FB).
- name: railHeight
  type: Double
  comment: full-size inches rail height (for 3D in DXF).
- name: seatThick
  type: Double
  comment: full-size inches chair seating thickness (for 3D in DXF).
- name: oldPlainSleeperLength
  type: Double
  comment: inches full-size (unlike tb_pi which is mm). used internally for gauge changes (no meaning in file).
- name: railInclination
  type: Double
  comment: radians
- name: footHeight
  type: Double
  comment: inches full-size edge thickness
- name: chairOutLength
  type: Double
  comment: inches full-size from rail gauge-face
- name: chairInLength
  type: Double
  comment: inches full-size
- name: chairWidth
  type: Double
  comment: inches full-size
- name: chairCornerRadius
  type: Double
  comment: inches full-size
...
}

type

  TProtoInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FName: String;
    FScale: Double;
    FGauge: Double;
    FFlangeway: Double;
    FFlangewayEnd: Double;
    FFlareLength: Double;
    FRailtopWidth: Double;
    FTurnoutSideTrackCentres: Double;
    FMainSideTrackCentres: Double;
    FReturnCurveTrackCentres: Double;
    FMinimumRadius: Double;
    FTurnoutTimberWidth: Double;
    FSleeperWidth: Double;
    FMaxTimberSpacing: Double;
    FSleeperLength: Double;
    FMainsideEnds: Boolean;
    FSleeperWidthAtRailJoint: Double;
    FTimberEndRandomising: Double;
    FTimberThickness: Double;
    FTimberAngleRandomising: Double;
    FCheckRailLengthMainSide1: Double;
    FCheckRailLengthMainSide2: Double;
    FCheckRailLengthMainSide3: Double;
    FCheckRailExtensionMainSide1: Double;
    FCheckRailExtensionMainSide2: Double;
    FWingRailReachMainSide1: Double;
    FWingRailReachMainSide2: Double;
    FRailBottom: Double;
    FRailHeight: Double;
    FSeatThick: Double;
    FOldPlainSleeperLength: Double;
    FRailInclination: Double;
    FFootHeight: Double;
    FChairOutLength: Double;
    FChairInLength: Double;
    FChairWidth: Double;
    FChairCornerRadius: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetName(const AValue: String);
    procedure SetScale(const AValue: Double);
    procedure SetGauge(const AValue: Double);
    procedure SetFlangeway(const AValue: Double);
    procedure SetFlangewayEnd(const AValue: Double);
    procedure SetFlareLength(const AValue: Double);
    procedure SetRailtopWidth(const AValue: Double);
    procedure SetTurnoutSideTrackCentres(const AValue: Double);
    procedure SetMainSideTrackCentres(const AValue: Double);
    procedure SetReturnCurveTrackCentres(const AValue: Double);
    procedure SetMinimumRadius(const AValue: Double);
    procedure SetTurnoutTimberWidth(const AValue: Double);
    procedure SetSleeperWidth(const AValue: Double);
    procedure SetMaxTimberSpacing(const AValue: Double);
    procedure SetSleeperLength(const AValue: Double);
    procedure SetMainsideEnds(const AValue: Boolean);
    procedure SetSleeperWidthAtRailJoint(const AValue: Double);
    procedure SetTimberEndRandomising(const AValue: Double);
    procedure SetTimberThickness(const AValue: Double);
    procedure SetTimberAngleRandomising(const AValue: Double);
    procedure SetCheckRailLengthMainSide1(const AValue: Double);
    procedure SetCheckRailLengthMainSide2(const AValue: Double);
    procedure SetCheckRailLengthMainSide3(const AValue: Double);
    procedure SetCheckRailExtensionMainSide1(const AValue: Double);
    procedure SetCheckRailExtensionMainSide2(const AValue: Double);
    procedure SetWingRailReachMainSide1(const AValue: Double);
    procedure SetWingRailReachMainSide2(const AValue: Double);
    procedure SetRailBottom(const AValue: Double);
    procedure SetRailHeight(const AValue: Double);
    procedure SetSeatThick(const AValue: Double);
    procedure SetOldPlainSleeperLength(const AValue: Double);
    procedure SetRailInclination(const AValue: Double);
    procedure SetFootHeight(const AValue: Double);
    procedure SetChairOutLength(const AValue: Double);
    procedure SetChairInLength(const AValue: Double);
    procedure SetChairWidth(const AValue: Double);
    procedure SetChairCornerRadius(const AValue: Double);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty

    // gauge designation: 9 chars max actually used
    property name: String read FName write SetName;

    // mm per ft.
    property scale: Double read FScale write SetScale;

    // mm.
    property gauge: Double read FGauge write SetGauge;

    // mm flangeway.
    property flangeway: Double read FFlangeway write SetFlangeway;

    // mm flangeway end (flangeway+flare).
    property flangewayEnd: Double read FFlangewayEnd write SetFlangewayEnd;

    // mm length of flares (not h-d).
    property flareLength: Double read FFlareLength write SetFlareLength;

    // mm width of rail top (and bottom if bullhead).
    property railtopWidth: Double read FRailtopWidth write SetRailtopWidth;

    // mm track centres, turnout side.
    property turnoutSideTrackCentres: Double read FTurnoutSideTrackCentres write SetTurnoutSideTrackCentres;

    // mm track centres, main side.
    property mainSideTrackCentres: Double read FMainSideTrackCentres write SetMainSideTrackCentres;

    // mm track centres, return curve.
    property returnCurveTrackCentres: Double read FReturnCurveTrackCentres write SetReturnCurveTrackCentres;

    // mm minimum radius for check.
    property minimumRadius: Double read FMinimumRadius write SetMinimumRadius;

    // inches full-size width of turnout timbers.
    property turnoutTimberWidth: Double read FTurnoutTimberWidth write SetTurnoutTimberWidth;

    // inches full-size width of plain sleepers (not at rail joints 212a).
    property sleeperWidth: Double read FSleeperWidth write SetSleeperWidth;

    // inches full-size max timber-spacing for closure space.
    property maxTimberSpacing: Double read FMaxTimberSpacing write SetMaxTimberSpacing;

    // plain sleeper length mm.
    property sleeperLength: Double read FSleeperLength write SetSleeperLength;

    // True=main side ends in line, False=ends centralized.
    property mainsideEnds: Boolean read FMainsideEnds write SetMainsideEnds;

    // inches full-size width of plain sleepers at rail joints.
    property sleeperWidthAtRailJoint: Double read FSleeperWidthAtRailJoint write SetSleeperWidthAtRailJoint;

    // amount of timber-end randomising.
    property timberEndRandomising: Double read FTimberEndRandomising write SetTimberEndRandomising;

    // timber thickness (for DXF 3D).
    property timberThickness: Double read FTimberThickness write SetTimberThickness;

    // amount of timber_angle randomising.
    property timberAngleRandomising: Double read FTimberAngleRandomising write SetTimberAngleRandomising;

    // full-size inches - size 1 MS check rail working length (back from "A").
    property checkRailLengthMainSide1: Double read FCheckRailLengthMainSide1 write SetCheckRailLengthMainSide1;

    // full-size inches - size 2 MS check rail working length (back from "A").
    property checkRailLengthMainSide2: Double read FCheckRailLengthMainSide2 write SetCheckRailLengthMainSide2;

    // full-size inches - size 3 MS check rail working length (back from "A").
    property checkRailLengthMainSide3: Double read FCheckRailLengthMainSide3 write SetCheckRailLengthMainSide3;

    // full-size inches - size 1 MS check rail extension length (forward from "A").
    property checkRailExtensionMainSide1: Double read FCheckRailExtensionMainSide1 write SetCheckRailExtensionMainSide1;

    // full-size inches - size 2 MS check rail extension length (forward from "A").
    property checkRailExtensionMainSide2: Double read FCheckRailExtensionMainSide2 write SetCheckRailExtensionMainSide2;

    // full-size inches - size 1 MS wing rail reach length (forward from "A").
    property wingRailReachMainSide1: Double read FWingRailReachMainSide1 write SetWingRailReachMainSide1;

    // full-size inches - size 2 MS wing rail reach length (forward from "A").
    property wingRailReachMainSide2: Double read FWingRailReachMainSide2 write SetWingRailReachMainSide2;

    // mm width of railfoot (FB).
    property railBottom: Double read FRailBottom write SetRailBottom;

    // full-size inches rail height (for 3D in DXF).
    property railHeight: Double read FRailHeight write SetRailHeight;

    // full-size inches chair seating thickness (for 3D in DXF).
    property seatThick: Double read FSeatThick write SetSeatThick;

    // inches full-size (unlike tb_pi which is mm). used internally for gauge changes (no meaning in file).
    property oldPlainSleeperLength: Double read FOldPlainSleeperLength write SetOldPlainSleeperLength;

    // radians
    property railInclination: Double read FRailInclination write SetRailInclination;

    // inches full-size edge thickness
    property footHeight: Double read FFootHeight write SetFootHeight;

    // inches full-size from rail gauge-face
    property chairOutLength: Double read FChairOutLength write SetChairOutLength;

    // inches full-size
    property chairInLength: Double read FChairInLength write SetChairInLength;

    // inches full-size
    property chairWidth: Double read FChairWidth write SetChairWidth;

    // inches full-size
    property chairCornerRadius: Double read FChairCornerRadius write SetChairCornerRadius;
    //# endGenProperty
  end;

  TProtoInfoOwningList = class(TOTOwningList<TProtoInfo>);
  TProtoInfoReferenceList = class(TOTReferenceList<TProtoInfo>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TProtoInfo }

constructor TProtoInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TProtoInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TProtoInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TProtoInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'name' then
    FName := StrToString(AValue)
  else
  if AName = 'scale' then
    FScale := StrToDouble(AValue)
  else
  if AName = 'gauge' then
    FGauge := StrToDouble(AValue)
  else
  if AName = 'flangeway' then
    FFlangeway := StrToDouble(AValue)
  else
  if AName = 'flangewayEnd' then
    FFlangewayEnd := StrToDouble(AValue)
  else
  if AName = 'flareLength' then
    FFlareLength := StrToDouble(AValue)
  else
  if AName = 'railtopWidth' then
    FRailtopWidth := StrToDouble(AValue)
  else
  if AName = 'turnoutSideTrackCentres' then
    FTurnoutSideTrackCentres := StrToDouble(AValue)
  else
  if AName = 'mainSideTrackCentres' then
    FMainSideTrackCentres := StrToDouble(AValue)
  else
  if AName = 'returnCurveTrackCentres' then
    FReturnCurveTrackCentres := StrToDouble(AValue)
  else
  if AName = 'minimumRadius' then
    FMinimumRadius := StrToDouble(AValue)
  else
  if AName = 'turnoutTimberWidth' then
    FTurnoutTimberWidth := StrToDouble(AValue)
  else
  if AName = 'sleeperWidth' then
    FSleeperWidth := StrToDouble(AValue)
  else
  if AName = 'maxTimberSpacing' then
    FMaxTimberSpacing := StrToDouble(AValue)
  else
  if AName = 'sleeperLength' then
    FSleeperLength := StrToDouble(AValue)
  else
  if AName = 'mainsideEnds' then
    FMainsideEnds := StrToBoolean(AValue)
  else
  if AName = 'sleeperWidthAtRailJoint' then
    FSleeperWidthAtRailJoint := StrToDouble(AValue)
  else
  if AName = 'timberEndRandomising' then
    FTimberEndRandomising := StrToDouble(AValue)
  else
  if AName = 'timberThickness' then
    FTimberThickness := StrToDouble(AValue)
  else
  if AName = 'timberAngleRandomising' then
    FTimberAngleRandomising := StrToDouble(AValue)
  else
  if AName = 'checkRailLengthMainSide1' then
    FCheckRailLengthMainSide1 := StrToDouble(AValue)
  else
  if AName = 'checkRailLengthMainSide2' then
    FCheckRailLengthMainSide2 := StrToDouble(AValue)
  else
  if AName = 'checkRailLengthMainSide3' then
    FCheckRailLengthMainSide3 := StrToDouble(AValue)
  else
  if AName = 'checkRailExtensionMainSide1' then
    FCheckRailExtensionMainSide1 := StrToDouble(AValue)
  else
  if AName = 'checkRailExtensionMainSide2' then
    FCheckRailExtensionMainSide2 := StrToDouble(AValue)
  else
  if AName = 'wingRailReachMainSide1' then
    FWingRailReachMainSide1 := StrToDouble(AValue)
  else
  if AName = 'wingRailReachMainSide2' then
    FWingRailReachMainSide2 := StrToDouble(AValue)
  else
  if AName = 'railBottom' then
    FRailBottom := StrToDouble(AValue)
  else
  if AName = 'railHeight' then
    FRailHeight := StrToDouble(AValue)
  else
  if AName = 'seatThick' then
    FSeatThick := StrToDouble(AValue)
  else
  if AName = 'oldPlainSleeperLength' then
    FOldPlainSleeperLength := StrToDouble(AValue)
  else
  if AName = 'railInclination' then
    FRailInclination := StrToDouble(AValue)
  else
  if AName = 'footHeight' then
    FFootHeight := StrToDouble(AValue)
  else
  if AName = 'chairOutLength' then
    FChairOutLength := StrToDouble(AValue)
  else
  if AName = 'chairInLength' then
    FChairInLength := StrToDouble(AValue)
  else
  if AName = 'chairWidth' then
    FChairWidth := StrToDouble(AValue)
  else
  if AName = 'chairCornerRadius' then
    FChairCornerRadius := StrToDouble(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TProtoInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  FName := AStream.ReadAnsiString;
  AStream.ReadBuffer(FScale, sizeof(Double));
  AStream.ReadBuffer(FGauge, sizeof(Double));
  AStream.ReadBuffer(FFlangeway, sizeof(Double));
  AStream.ReadBuffer(FFlangewayEnd, sizeof(Double));
  AStream.ReadBuffer(FFlareLength, sizeof(Double));
  AStream.ReadBuffer(FRailtopWidth, sizeof(Double));
  AStream.ReadBuffer(FTurnoutSideTrackCentres, sizeof(Double));
  AStream.ReadBuffer(FMainSideTrackCentres, sizeof(Double));
  AStream.ReadBuffer(FReturnCurveTrackCentres, sizeof(Double));
  AStream.ReadBuffer(FMinimumRadius, sizeof(Double));
  AStream.ReadBuffer(FTurnoutTimberWidth, sizeof(Double));
  AStream.ReadBuffer(FSleeperWidth, sizeof(Double));
  AStream.ReadBuffer(FMaxTimberSpacing, sizeof(Double));
  AStream.ReadBuffer(FSleeperLength, sizeof(Double));
  AStream.ReadBuffer(FMainsideEnds, sizeof(Boolean));
  AStream.ReadBuffer(FSleeperWidthAtRailJoint, sizeof(Double));
  AStream.ReadBuffer(FTimberEndRandomising, sizeof(Double));
  AStream.ReadBuffer(FTimberThickness, sizeof(Double));
  AStream.ReadBuffer(FTimberAngleRandomising, sizeof(Double));
  AStream.ReadBuffer(FCheckRailLengthMainSide1, sizeof(Double));
  AStream.ReadBuffer(FCheckRailLengthMainSide2, sizeof(Double));
  AStream.ReadBuffer(FCheckRailLengthMainSide3, sizeof(Double));
  AStream.ReadBuffer(FCheckRailExtensionMainSide1, sizeof(Double));
  AStream.ReadBuffer(FCheckRailExtensionMainSide2, sizeof(Double));
  AStream.ReadBuffer(FWingRailReachMainSide1, sizeof(Double));
  AStream.ReadBuffer(FWingRailReachMainSide2, sizeof(Double));
  AStream.ReadBuffer(FRailBottom, sizeof(Double));
  AStream.ReadBuffer(FRailHeight, sizeof(Double));
  AStream.ReadBuffer(FSeatThick, sizeof(Double));
  AStream.ReadBuffer(FOldPlainSleeperLength, sizeof(Double));
  AStream.ReadBuffer(FRailInclination, sizeof(Double));
  AStream.ReadBuffer(FFootHeight, sizeof(Double));
  AStream.ReadBuffer(FChairOutLength, sizeof(Double));
  AStream.ReadBuffer(FChairInLength, sizeof(Double));
  AStream.ReadBuffer(FChairWidth, sizeof(Double));
  AStream.ReadBuffer(FChairCornerRadius, sizeof(Double));
  //# endGenRestoreVars
  end;

procedure TProtoInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteAnsiString(FName);
  AStream.WriteBuffer(FScale, sizeof(Double));
  AStream.WriteBuffer(FGauge, sizeof(Double));
  AStream.WriteBuffer(FFlangeway, sizeof(Double));
  AStream.WriteBuffer(FFlangewayEnd, sizeof(Double));
  AStream.WriteBuffer(FFlareLength, sizeof(Double));
  AStream.WriteBuffer(FRailtopWidth, sizeof(Double));
  AStream.WriteBuffer(FTurnoutSideTrackCentres, sizeof(Double));
  AStream.WriteBuffer(FMainSideTrackCentres, sizeof(Double));
  AStream.WriteBuffer(FReturnCurveTrackCentres, sizeof(Double));
  AStream.WriteBuffer(FMinimumRadius, sizeof(Double));
  AStream.WriteBuffer(FTurnoutTimberWidth, sizeof(Double));
  AStream.WriteBuffer(FSleeperWidth, sizeof(Double));
  AStream.WriteBuffer(FMaxTimberSpacing, sizeof(Double));
  AStream.WriteBuffer(FSleeperLength, sizeof(Double));
  AStream.WriteBuffer(FMainsideEnds, sizeof(Boolean));
  AStream.WriteBuffer(FSleeperWidthAtRailJoint, sizeof(Double));
  AStream.WriteBuffer(FTimberEndRandomising, sizeof(Double));
  AStream.WriteBuffer(FTimberThickness, sizeof(Double));
  AStream.WriteBuffer(FTimberAngleRandomising, sizeof(Double));
  AStream.WriteBuffer(FCheckRailLengthMainSide1, sizeof(Double));
  AStream.WriteBuffer(FCheckRailLengthMainSide2, sizeof(Double));
  AStream.WriteBuffer(FCheckRailLengthMainSide3, sizeof(Double));
  AStream.WriteBuffer(FCheckRailExtensionMainSide1, sizeof(Double));
  AStream.WriteBuffer(FCheckRailExtensionMainSide2, sizeof(Double));
  AStream.WriteBuffer(FWingRailReachMainSide1, sizeof(Double));
  AStream.WriteBuffer(FWingRailReachMainSide2, sizeof(Double));
  AStream.WriteBuffer(FRailBottom, sizeof(Double));
  AStream.WriteBuffer(FRailHeight, sizeof(Double));
  AStream.WriteBuffer(FSeatThick, sizeof(Double));
  AStream.WriteBuffer(FOldPlainSleeperLength, sizeof(Double));
  AStream.WriteBuffer(FRailInclination, sizeof(Double));
  AStream.WriteBuffer(FFootHeight, sizeof(Double));
  AStream.WriteBuffer(FChairOutLength, sizeof(Double));
  AStream.WriteBuffer(FChairInLength, sizeof(Double));
  AStream.WriteBuffer(FChairWidth, sizeof(Double));
  AStream.WriteBuffer(FChairCornerRadius, sizeof(Double));
  //# endGenSaveVars
  end;
  
procedure TProtoInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlString(AEmitter, 'name', FName);
  SaveYamlDouble(AEmitter, 'scale', FScale);
  SaveYamlDouble(AEmitter, 'gauge', FGauge);
  SaveYamlDouble(AEmitter, 'flangeway', FFlangeway);
  SaveYamlDouble(AEmitter, 'flangewayEnd', FFlangewayEnd);
  SaveYamlDouble(AEmitter, 'flareLength', FFlareLength);
  SaveYamlDouble(AEmitter, 'railtopWidth', FRailtopWidth);
  SaveYamlDouble(AEmitter, 'turnoutSideTrackCentres', FTurnoutSideTrackCentres);
  SaveYamlDouble(AEmitter, 'mainSideTrackCentres', FMainSideTrackCentres);
  SaveYamlDouble(AEmitter, 'returnCurveTrackCentres', FReturnCurveTrackCentres);
  SaveYamlDouble(AEmitter, 'minimumRadius', FMinimumRadius);
  SaveYamlDouble(AEmitter, 'turnoutTimberWidth', FTurnoutTimberWidth);
  SaveYamlDouble(AEmitter, 'sleeperWidth', FSleeperWidth);
  SaveYamlDouble(AEmitter, 'maxTimberSpacing', FMaxTimberSpacing);
  SaveYamlDouble(AEmitter, 'sleeperLength', FSleeperLength);
  SaveYamlBoolean(AEmitter, 'mainsideEnds', FMainsideEnds);
  SaveYamlDouble(AEmitter, 'sleeperWidthAtRailJoint', FSleeperWidthAtRailJoint);
  SaveYamlDouble(AEmitter, 'timberEndRandomising', FTimberEndRandomising);
  SaveYamlDouble(AEmitter, 'timberThickness', FTimberThickness);
  SaveYamlDouble(AEmitter, 'timberAngleRandomising', FTimberAngleRandomising);
  SaveYamlDouble(AEmitter, 'checkRailLengthMainSide1', FCheckRailLengthMainSide1);
  SaveYamlDouble(AEmitter, 'checkRailLengthMainSide2', FCheckRailLengthMainSide2);
  SaveYamlDouble(AEmitter, 'checkRailLengthMainSide3', FCheckRailLengthMainSide3);
  SaveYamlDouble(AEmitter, 'checkRailExtensionMainSide1', FCheckRailExtensionMainSide1);
  SaveYamlDouble(AEmitter, 'checkRailExtensionMainSide2', FCheckRailExtensionMainSide2);
  SaveYamlDouble(AEmitter, 'wingRailReachMainSide1', FWingRailReachMainSide1);
  SaveYamlDouble(AEmitter, 'wingRailReachMainSide2', FWingRailReachMainSide2);
  SaveYamlDouble(AEmitter, 'railBottom', FRailBottom);
  SaveYamlDouble(AEmitter, 'railHeight', FRailHeight);
  SaveYamlDouble(AEmitter, 'seatThick', FSeatThick);
  SaveYamlDouble(AEmitter, 'oldPlainSleeperLength', FOldPlainSleeperLength);
  SaveYamlDouble(AEmitter, 'railInclination', FRailInclination);
  SaveYamlDouble(AEmitter, 'footHeight', FFootHeight);
  SaveYamlDouble(AEmitter, 'chairOutLength', FChairOutLength);
  SaveYamlDouble(AEmitter, 'chairInLength', FChairInLength);
  SaveYamlDouble(AEmitter, 'chairWidth', FChairWidth);
  SaveYamlDouble(AEmitter, 'chairCornerRadius', FChairCornerRadius);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetName(const AValue: String);
begin
  if AValue <> FName then begin
    SetModified;
    FName := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetScale(const AValue: Double);
begin
  if AValue <> FScale then begin
    SetModified;
    FScale := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetGauge(const AValue: Double);
begin
  if AValue <> FGauge then begin
    SetModified;
    FGauge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetFlangeway(const AValue: Double);
begin
  if AValue <> FFlangeway then begin
    SetModified;
    FFlangeway := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetFlangewayEnd(const AValue: Double);
begin
  if AValue <> FFlangewayEnd then begin
    SetModified;
    FFlangewayEnd := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetFlareLength(const AValue: Double);
begin
  if AValue <> FFlareLength then begin
    SetModified;
    FFlareLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetRailtopWidth(const AValue: Double);
begin
  if AValue <> FRailtopWidth then begin
    SetModified;
    FRailtopWidth := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetTurnoutSideTrackCentres(const AValue: Double);
begin
  if AValue <> FTurnoutSideTrackCentres then begin
    SetModified;
    FTurnoutSideTrackCentres := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetMainSideTrackCentres(const AValue: Double);
begin
  if AValue <> FMainSideTrackCentres then begin
    SetModified;
    FMainSideTrackCentres := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetReturnCurveTrackCentres(const AValue: Double);
begin
  if AValue <> FReturnCurveTrackCentres then begin
    SetModified;
    FReturnCurveTrackCentres := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetMinimumRadius(const AValue: Double);
begin
  if AValue <> FMinimumRadius then begin
    SetModified;
    FMinimumRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetTurnoutTimberWidth(const AValue: Double);
begin
  if AValue <> FTurnoutTimberWidth then begin
    SetModified;
    FTurnoutTimberWidth := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetSleeperWidth(const AValue: Double);
begin
  if AValue <> FSleeperWidth then begin
    SetModified;
    FSleeperWidth := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetMaxTimberSpacing(const AValue: Double);
begin
  if AValue <> FMaxTimberSpacing then begin
    SetModified;
    FMaxTimberSpacing := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetSleeperLength(const AValue: Double);
begin
  if AValue <> FSleeperLength then begin
    SetModified;
    FSleeperLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetMainsideEnds(const AValue: Boolean);
begin
  if AValue <> FMainsideEnds then begin
    SetModified;
    FMainsideEnds := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetSleeperWidthAtRailJoint(const AValue: Double);
begin
  if AValue <> FSleeperWidthAtRailJoint then begin
    SetModified;
    FSleeperWidthAtRailJoint := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetTimberEndRandomising(const AValue: Double);
begin
  if AValue <> FTimberEndRandomising then begin
    SetModified;
    FTimberEndRandomising := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetTimberThickness(const AValue: Double);
begin
  if AValue <> FTimberThickness then begin
    SetModified;
    FTimberThickness := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetTimberAngleRandomising(const AValue: Double);
begin
  if AValue <> FTimberAngleRandomising then begin
    SetModified;
    FTimberAngleRandomising := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailLengthMainSide1(const AValue: Double);
begin
  if AValue <> FCheckRailLengthMainSide1 then begin
    SetModified;
    FCheckRailLengthMainSide1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailLengthMainSide2(const AValue: Double);
begin
  if AValue <> FCheckRailLengthMainSide2 then begin
    SetModified;
    FCheckRailLengthMainSide2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailLengthMainSide3(const AValue: Double);
begin
  if AValue <> FCheckRailLengthMainSide3 then begin
    SetModified;
    FCheckRailLengthMainSide3 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailExtensionMainSide1(const AValue: Double);
begin
  if AValue <> FCheckRailExtensionMainSide1 then begin
    SetModified;
    FCheckRailExtensionMainSide1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailExtensionMainSide2(const AValue: Double);
begin
  if AValue <> FCheckRailExtensionMainSide2 then begin
    SetModified;
    FCheckRailExtensionMainSide2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetWingRailReachMainSide1(const AValue: Double);
begin
  if AValue <> FWingRailReachMainSide1 then begin
    SetModified;
    FWingRailReachMainSide1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetWingRailReachMainSide2(const AValue: Double);
begin
  if AValue <> FWingRailReachMainSide2 then begin
    SetModified;
    FWingRailReachMainSide2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetRailBottom(const AValue: Double);
begin
  if AValue <> FRailBottom then begin
    SetModified;
    FRailBottom := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetRailHeight(const AValue: Double);
begin
  if AValue <> FRailHeight then begin
    SetModified;
    FRailHeight := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetSeatThick(const AValue: Double);
begin
  if AValue <> FSeatThick then begin
    SetModified;
    FSeatThick := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetOldPlainSleeperLength(const AValue: Double);
begin
  if AValue <> FOldPlainSleeperLength then begin
    SetModified;
    FOldPlainSleeperLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetRailInclination(const AValue: Double);
begin
  if AValue <> FRailInclination then begin
    SetModified;
    FRailInclination := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetFootHeight(const AValue: Double);
begin
  if AValue <> FFootHeight then begin
    SetModified;
    FFootHeight := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairOutLength(const AValue: Double);
begin
  if AValue <> FChairOutLength then begin
    SetModified;
    FChairOutLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairInLength(const AValue: Double);
begin
  if AValue <> FChairInLength then begin
    SetModified;
    FChairInLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairWidth(const AValue: Double);
begin
  if AValue <> FChairWidth then begin
    SetModified;
    FChairWidth := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairCornerRadius(const AValue: Double);
begin
  if AValue <> FChairCornerRadius then begin
    SetModified;
    FChairCornerRadius := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TProtoInfo.RegisterClass;
  TProtoInfoOwningList.RegisterClass;
  TProtoInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TProtoInfo');
end.
