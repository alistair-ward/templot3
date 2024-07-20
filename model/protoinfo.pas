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
- name: turnoutTimberWidthInches
  type: Double
  comment: inches full-size width of turnout timbers.
- name: sleeperWidthInches
  type: Double
  comment: inches full-size width of plain sleepers (not at rail joints 212a).
- name: maxTimberSpacingInches
  type: Double
  comment: inches full-size max timber-spacing for closure space.
- name: sleeperLength
  type: Double
  comment: plain sleeper length mm.
- name: mainsideEnds
  type: Boolean
  comment: True=main side ends in line, False=ends centralized.
- name: sleeperWidthAtRailJointInches
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
- name: checkRailLengthMainSide1Inches
  type: Double
  comment: full-size inches - size 1 MS check rail working length (back from "A").
- name: checkRailLengthMainSide2Inches
  type: Double
  comment: full-size inches - size 2 MS check rail working length (back from "A").
- name: checkRailLengthMainSide3Inches
  type: Double
  comment: full-size inches - size 3 MS check rail working length (back from "A").
- name: checkRailExtensionMainSide1Inches
  type: Double
  comment: full-size inches - size 1 MS check rail extension length (forward from "A").
- name: checkRailExtensionMainSide2Inches
  type: Double
  comment: full-size inches - size 2 MS check rail extension length (forward from "A").
- name: wingRailReachMainSide1Inches
  type: Double
  comment: full-size inches - size 1 MS wing rail reach length (forward from "A").
- name: wingRailReachMainSide2Inches
  type: Double
  comment: full-size inches - size 2 MS wing rail reach length (forward from "A").
- name:  railBottom
  type: Double
  comment: mm width of railfoot (FB).
- name: railHeightInches
  type: Double
  comment: full-size inches rail height (for 3D in DXF).
- name: seatThickInches
  type: Double
  comment: full-size inches chair seating thickness (for 3D in DXF).
- name: oldPlainSleeperLengthInches
  type: Double
  comment: inches full-size (unlike tb_pi which is mm). used internally for gauge changes (no meaning in file).
- name: railInclination
  type: Double
  comment: radians
- name: footHeightInches
  type: Double
  comment: inches full-size edge thickness
- name: chairOutLengthInches
  type: Double
  comment: inches full-size from rail gauge-face
- name: chairInLengthInches
  type: Double
  comment: inches full-size
- name: chairWidthInches
  type: Double
  comment: inches full-size
- name: chairCornerRadiusInches
  type: Double
  comment: inches full-size
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

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
    FTurnoutTimberWidthInches: Double;
    FSleeperWidthInches: Double;
    FMaxTimberSpacingInches: Double;
    FSleeperLength: Double;
    FMainsideEnds: Boolean;
    FSleeperWidthAtRailJointInches: Double;
    FTimberEndRandomising: Double;
    FTimberThickness: Double;
    FTimberAngleRandomising: Double;
    FCheckRailLengthMainSide1Inches: Double;
    FCheckRailLengthMainSide2Inches: Double;
    FCheckRailLengthMainSide3Inches: Double;
    FCheckRailExtensionMainSide1Inches: Double;
    FCheckRailExtensionMainSide2Inches: Double;
    FWingRailReachMainSide1Inches: Double;
    FWingRailReachMainSide2Inches: Double;
    FRailBottom: Double;
    FRailHeightInches: Double;
    FSeatThickInches: Double;
    FOldPlainSleeperLengthInches: Double;
    FRailInclination: Double;
    FFootHeightInches: Double;
    FChairOutLengthInches: Double;
    FChairInLengthInches: Double;
    FChairWidthInches: Double;
    FChairCornerRadiusInches: Double;
    //# endGenMemberVars

    // Templot2 global: inscale
    FInchScale: Double;
    // Templot2 global: gmi
    FInsideFaceMarkLength: Double;
    // Templot2 global: gmo
    FOutsideFaceMarkLength: Double;

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
    procedure SetTurnoutTimberWidthInches(const AValue: Double);
    procedure SetSleeperWidthInches(const AValue: Double);
    procedure SetMaxTimberSpacingInches(const AValue: Double);
    procedure SetSleeperLength(const AValue: Double);
    procedure SetMainsideEnds(const AValue: Boolean);
    procedure SetSleeperWidthAtRailJointInches(const AValue: Double);
    procedure SetTimberEndRandomising(const AValue: Double);
    procedure SetTimberThickness(const AValue: Double);
    procedure SetTimberAngleRandomising(const AValue: Double);
    procedure SetCheckRailLengthMainSide1Inches(const AValue: Double);
    procedure SetCheckRailLengthMainSide2Inches(const AValue: Double);
    procedure SetCheckRailLengthMainSide3Inches(const AValue: Double);
    procedure SetCheckRailExtensionMainSide1Inches(const AValue: Double);
    procedure SetCheckRailExtensionMainSide2Inches(const AValue: Double);
    procedure SetWingRailReachMainSide1Inches(const AValue: Double);
    procedure SetWingRailReachMainSide2Inches(const AValue: Double);
    procedure SetRailBottom(const AValue: Double);
    procedure SetRailHeightInches(const AValue: Double);
    procedure SetSeatThickInches(const AValue: Double);
    procedure SetOldPlainSleeperLengthInches(const AValue: Double);
    procedure SetRailInclination(const AValue: Double);
    procedure SetFootHeightInches(const AValue: Double);
    procedure SetChairOutLengthInches(const AValue: Double);
    procedure SetChairInLengthInches(const AValue: Double);
    procedure SetChairWidthInches(const AValue: Double);
    procedure SetChairCornerRadiusInches(const AValue: Double);
    //# endGenGetSetDeclarations

    function GetInchScale: Double;
    function GetInsideFaceMarkLength: Double;
    function GetOutsideFaceMarkLength: Double;

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
    property turnoutTimberWidthInches: Double read FTurnoutTimberWidthInches write SetTurnoutTimberWidthInches;

    // inches full-size width of plain sleepers (not at rail joints 212a).
    property sleeperWidthInches: Double read FSleeperWidthInches write SetSleeperWidthInches;

    // inches full-size max timber-spacing for closure space.
    property maxTimberSpacingInches: Double read FMaxTimberSpacingInches write SetMaxTimberSpacingInches;

    // plain sleeper length mm.
    property sleeperLength: Double read FSleeperLength write SetSleeperLength;

    // True=main side ends in line, False=ends centralized.
    property mainsideEnds: Boolean read FMainsideEnds write SetMainsideEnds;

    // inches full-size width of plain sleepers at rail joints.
    property sleeperWidthAtRailJointInches: Double read FSleeperWidthAtRailJointInches write SetSleeperWidthAtRailJointInches;

    // amount of timber-end randomising.
    property timberEndRandomising: Double read FTimberEndRandomising write SetTimberEndRandomising;

    // timber thickness (for DXF 3D).
    property timberThickness: Double read FTimberThickness write SetTimberThickness;

    // amount of timber_angle randomising.
    property timberAngleRandomising: Double read FTimberAngleRandomising write SetTimberAngleRandomising;

    // full-size inches - size 1 MS check rail working length (back from "A").
    property checkRailLengthMainSide1Inches: Double read FCheckRailLengthMainSide1Inches write SetCheckRailLengthMainSide1Inches;

    // full-size inches - size 2 MS check rail working length (back from "A").
    property checkRailLengthMainSide2Inches: Double read FCheckRailLengthMainSide2Inches write SetCheckRailLengthMainSide2Inches;

    // full-size inches - size 3 MS check rail working length (back from "A").
    property checkRailLengthMainSide3Inches: Double read FCheckRailLengthMainSide3Inches write SetCheckRailLengthMainSide3Inches;

    // full-size inches - size 1 MS check rail extension length (forward from "A").
    property checkRailExtensionMainSide1Inches: Double read FCheckRailExtensionMainSide1Inches write SetCheckRailExtensionMainSide1Inches;

    // full-size inches - size 2 MS check rail extension length (forward from "A").
    property checkRailExtensionMainSide2Inches: Double read FCheckRailExtensionMainSide2Inches write SetCheckRailExtensionMainSide2Inches;

    // full-size inches - size 1 MS wing rail reach length (forward from "A").
    property wingRailReachMainSide1Inches: Double read FWingRailReachMainSide1Inches write SetWingRailReachMainSide1Inches;

    // full-size inches - size 2 MS wing rail reach length (forward from "A").
    property wingRailReachMainSide2Inches: Double read FWingRailReachMainSide2Inches write SetWingRailReachMainSide2Inches;

    // mm width of railfoot (FB).
    property railBottom: Double read FRailBottom write SetRailBottom;

    // full-size inches rail height (for 3D in DXF).
    property railHeightInches: Double read FRailHeightInches write SetRailHeightInches;

    // full-size inches chair seating thickness (for 3D in DXF).
    property seatThickInches: Double read FSeatThickInches write SetSeatThickInches;

    // inches full-size (unlike tb_pi which is mm). used internally for gauge changes (no meaning in file).
    property oldPlainSleeperLengthInches: Double read FOldPlainSleeperLengthInches write SetOldPlainSleeperLengthInches;

    // radians
    property railInclination: Double read FRailInclination write SetRailInclination;

    // inches full-size edge thickness
    property footHeightInches: Double read FFootHeightInches write SetFootHeightInches;

    // inches full-size from rail gauge-face
    property chairOutLengthInches: Double read FChairOutLengthInches write SetChairOutLengthInches;

    // inches full-size
    property chairInLengthInches: Double read FChairInLengthInches write SetChairInLengthInches;

    // inches full-size
    property chairWidthInches: Double read FChairWidthInches write SetChairWidthInches;

    // inches full-size
    property chairCornerRadiusInches: Double read FChairCornerRadiusInches write SetChairCornerRadiusInches;
    //# endGenProperty

    property inchScale: Double read GetInchScale;
    property insideFaceMarkLength: Double read GetInsideFaceMarkLength;
    property outsideFaceMarkLength: Double read GetOutsideFaceMarkLength;
  end;

  TProtoInfoOwningList = class(TOTOwningList<TProtoInfo>);
  TProtoInfoReferenceList = class(TOTReferenceList<TProtoInfo>);

  //# genEnumSerialDeclarations
  //# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

  //# genEnumSerialMethods
  //# endGenEnumSerialMethods

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
  inherited;
  // Add your calculation code here, and cache the results...

  FInchScale := FScale / 12;
  FInsideFaceMarkLength := 5 * FInchScale;
  FOutsideFaceMarkLength := 5 * FInchScale;
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
  if AName = 'turnoutTimberWidthInches' then
    FTurnoutTimberWidthInches := StrToDouble(AValue)
  else
  if AName = 'sleeperWidthInches' then
    FSleeperWidthInches := StrToDouble(AValue)
  else
  if AName = 'maxTimberSpacingInches' then
    FMaxTimberSpacingInches := StrToDouble(AValue)
  else
  if AName = 'sleeperLength' then
    FSleeperLength := StrToDouble(AValue)
  else
  if AName = 'mainsideEnds' then
    FMainsideEnds := StrToBoolean(AValue)
  else
  if AName = 'sleeperWidthAtRailJointInches' then
    FSleeperWidthAtRailJointInches := StrToDouble(AValue)
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
  if AName = 'checkRailLengthMainSide1Inches' then
    FCheckRailLengthMainSide1Inches := StrToDouble(AValue)
  else
  if AName = 'checkRailLengthMainSide2Inches' then
    FCheckRailLengthMainSide2Inches := StrToDouble(AValue)
  else
  if AName = 'checkRailLengthMainSide3Inches' then
    FCheckRailLengthMainSide3Inches := StrToDouble(AValue)
  else
  if AName = 'checkRailExtensionMainSide1Inches' then
    FCheckRailExtensionMainSide1Inches := StrToDouble(AValue)
  else
  if AName = 'checkRailExtensionMainSide2Inches' then
    FCheckRailExtensionMainSide2Inches := StrToDouble(AValue)
  else
  if AName = 'wingRailReachMainSide1Inches' then
    FWingRailReachMainSide1Inches := StrToDouble(AValue)
  else
  if AName = 'wingRailReachMainSide2Inches' then
    FWingRailReachMainSide2Inches := StrToDouble(AValue)
  else
  if AName = 'railBottom' then
    FRailBottom := StrToDouble(AValue)
  else
  if AName = 'railHeightInches' then
    FRailHeightInches := StrToDouble(AValue)
  else
  if AName = 'seatThickInches' then
    FSeatThickInches := StrToDouble(AValue)
  else
  if AName = 'oldPlainSleeperLengthInches' then
    FOldPlainSleeperLengthInches := StrToDouble(AValue)
  else
  if AName = 'railInclination' then
    FRailInclination := StrToDouble(AValue)
  else
  if AName = 'footHeightInches' then
    FFootHeightInches := StrToDouble(AValue)
  else
  if AName = 'chairOutLengthInches' then
    FChairOutLengthInches := StrToDouble(AValue)
  else
  if AName = 'chairInLengthInches' then
    FChairInLengthInches := StrToDouble(AValue)
  else
  if AName = 'chairWidthInches' then
    FChairWidthInches := StrToDouble(AValue)
  else
  if AName = 'chairCornerRadiusInches' then
    FChairCornerRadiusInches := StrToDouble(AValue)
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
  AStream.ReadBuffer(FTurnoutTimberWidthInches, sizeof(Double));
  AStream.ReadBuffer(FSleeperWidthInches, sizeof(Double));
  AStream.ReadBuffer(FMaxTimberSpacingInches, sizeof(Double));
  AStream.ReadBuffer(FSleeperLength, sizeof(Double));
  AStream.ReadBuffer(FMainsideEnds, sizeof(Boolean));
  AStream.ReadBuffer(FSleeperWidthAtRailJointInches, sizeof(Double));
  AStream.ReadBuffer(FTimberEndRandomising, sizeof(Double));
  AStream.ReadBuffer(FTimberThickness, sizeof(Double));
  AStream.ReadBuffer(FTimberAngleRandomising, sizeof(Double));
  AStream.ReadBuffer(FCheckRailLengthMainSide1Inches, sizeof(Double));
  AStream.ReadBuffer(FCheckRailLengthMainSide2Inches, sizeof(Double));
  AStream.ReadBuffer(FCheckRailLengthMainSide3Inches, sizeof(Double));
  AStream.ReadBuffer(FCheckRailExtensionMainSide1Inches, sizeof(Double));
  AStream.ReadBuffer(FCheckRailExtensionMainSide2Inches, sizeof(Double));
  AStream.ReadBuffer(FWingRailReachMainSide1Inches, sizeof(Double));
  AStream.ReadBuffer(FWingRailReachMainSide2Inches, sizeof(Double));
  AStream.ReadBuffer(FRailBottom, sizeof(Double));
  AStream.ReadBuffer(FRailHeightInches, sizeof(Double));
  AStream.ReadBuffer(FSeatThickInches, sizeof(Double));
  AStream.ReadBuffer(FOldPlainSleeperLengthInches, sizeof(Double));
  AStream.ReadBuffer(FRailInclination, sizeof(Double));
  AStream.ReadBuffer(FFootHeightInches, sizeof(Double));
  AStream.ReadBuffer(FChairOutLengthInches, sizeof(Double));
  AStream.ReadBuffer(FChairInLengthInches, sizeof(Double));
  AStream.ReadBuffer(FChairWidthInches, sizeof(Double));
  AStream.ReadBuffer(FChairCornerRadiusInches, sizeof(Double));
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
  AStream.WriteBuffer(FTurnoutTimberWidthInches, sizeof(Double));
  AStream.WriteBuffer(FSleeperWidthInches, sizeof(Double));
  AStream.WriteBuffer(FMaxTimberSpacingInches, sizeof(Double));
  AStream.WriteBuffer(FSleeperLength, sizeof(Double));
  AStream.WriteBuffer(FMainsideEnds, sizeof(Boolean));
  AStream.WriteBuffer(FSleeperWidthAtRailJointInches, sizeof(Double));
  AStream.WriteBuffer(FTimberEndRandomising, sizeof(Double));
  AStream.WriteBuffer(FTimberThickness, sizeof(Double));
  AStream.WriteBuffer(FTimberAngleRandomising, sizeof(Double));
  AStream.WriteBuffer(FCheckRailLengthMainSide1Inches, sizeof(Double));
  AStream.WriteBuffer(FCheckRailLengthMainSide2Inches, sizeof(Double));
  AStream.WriteBuffer(FCheckRailLengthMainSide3Inches, sizeof(Double));
  AStream.WriteBuffer(FCheckRailExtensionMainSide1Inches, sizeof(Double));
  AStream.WriteBuffer(FCheckRailExtensionMainSide2Inches, sizeof(Double));
  AStream.WriteBuffer(FWingRailReachMainSide1Inches, sizeof(Double));
  AStream.WriteBuffer(FWingRailReachMainSide2Inches, sizeof(Double));
  AStream.WriteBuffer(FRailBottom, sizeof(Double));
  AStream.WriteBuffer(FRailHeightInches, sizeof(Double));
  AStream.WriteBuffer(FSeatThickInches, sizeof(Double));
  AStream.WriteBuffer(FOldPlainSleeperLengthInches, sizeof(Double));
  AStream.WriteBuffer(FRailInclination, sizeof(Double));
  AStream.WriteBuffer(FFootHeightInches, sizeof(Double));
  AStream.WriteBuffer(FChairOutLengthInches, sizeof(Double));
  AStream.WriteBuffer(FChairInLengthInches, sizeof(Double));
  AStream.WriteBuffer(FChairWidthInches, sizeof(Double));
  AStream.WriteBuffer(FChairCornerRadiusInches, sizeof(Double));
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
  SaveYamlDouble(AEmitter, 'turnoutTimberWidthInches', FTurnoutTimberWidthInches);
  SaveYamlDouble(AEmitter, 'sleeperWidthInches', FSleeperWidthInches);
  SaveYamlDouble(AEmitter, 'maxTimberSpacingInches', FMaxTimberSpacingInches);
  SaveYamlDouble(AEmitter, 'sleeperLength', FSleeperLength);
  SaveYamlBoolean(AEmitter, 'mainsideEnds', FMainsideEnds);
  SaveYamlDouble(AEmitter, 'sleeperWidthAtRailJointInches', FSleeperWidthAtRailJointInches);
  SaveYamlDouble(AEmitter, 'timberEndRandomising', FTimberEndRandomising);
  SaveYamlDouble(AEmitter, 'timberThickness', FTimberThickness);
  SaveYamlDouble(AEmitter, 'timberAngleRandomising', FTimberAngleRandomising);
  SaveYamlDouble(AEmitter, 'checkRailLengthMainSide1Inches', FCheckRailLengthMainSide1Inches);
  SaveYamlDouble(AEmitter, 'checkRailLengthMainSide2Inches', FCheckRailLengthMainSide2Inches);
  SaveYamlDouble(AEmitter, 'checkRailLengthMainSide3Inches', FCheckRailLengthMainSide3Inches);
  SaveYamlDouble(AEmitter, 'checkRailExtensionMainSide1Inches', FCheckRailExtensionMainSide1Inches);
  SaveYamlDouble(AEmitter, 'checkRailExtensionMainSide2Inches', FCheckRailExtensionMainSide2Inches);
  SaveYamlDouble(AEmitter, 'wingRailReachMainSide1Inches', FWingRailReachMainSide1Inches);
  SaveYamlDouble(AEmitter, 'wingRailReachMainSide2Inches', FWingRailReachMainSide2Inches);
  SaveYamlDouble(AEmitter, 'railBottom', FRailBottom);
  SaveYamlDouble(AEmitter, 'railHeightInches', FRailHeightInches);
  SaveYamlDouble(AEmitter, 'seatThickInches', FSeatThickInches);
  SaveYamlDouble(AEmitter, 'oldPlainSleeperLengthInches', FOldPlainSleeperLengthInches);
  SaveYamlDouble(AEmitter, 'railInclination', FRailInclination);
  SaveYamlDouble(AEmitter, 'footHeightInches', FFootHeightInches);
  SaveYamlDouble(AEmitter, 'chairOutLengthInches', FChairOutLengthInches);
  SaveYamlDouble(AEmitter, 'chairInLengthInches', FChairInLengthInches);
  SaveYamlDouble(AEmitter, 'chairWidthInches', FChairWidthInches);
  SaveYamlDouble(AEmitter, 'chairCornerRadiusInches', FChairCornerRadiusInches);
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
procedure TProtoInfo.SetTurnoutTimberWidthInches(const AValue: Double);
begin
  if AValue <> FTurnoutTimberWidthInches then begin
    SetModified;
    FTurnoutTimberWidthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetSleeperWidthInches(const AValue: Double);
begin
  if AValue <> FSleeperWidthInches then begin
    SetModified;
    FSleeperWidthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetMaxTimberSpacingInches(const AValue: Double);
begin
  if AValue <> FMaxTimberSpacingInches then begin
    SetModified;
    FMaxTimberSpacingInches := AValue;
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
procedure TProtoInfo.SetSleeperWidthAtRailJointInches(const AValue: Double);
begin
  if AValue <> FSleeperWidthAtRailJointInches then begin
    SetModified;
    FSleeperWidthAtRailJointInches := AValue;
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
procedure TProtoInfo.SetCheckRailLengthMainSide1Inches(const AValue: Double);
begin
  if AValue <> FCheckRailLengthMainSide1Inches then begin
    SetModified;
    FCheckRailLengthMainSide1Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailLengthMainSide2Inches(const AValue: Double);
begin
  if AValue <> FCheckRailLengthMainSide2Inches then begin
    SetModified;
    FCheckRailLengthMainSide2Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailLengthMainSide3Inches(const AValue: Double);
begin
  if AValue <> FCheckRailLengthMainSide3Inches then begin
    SetModified;
    FCheckRailLengthMainSide3Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailExtensionMainSide1Inches(const AValue: Double);
begin
  if AValue <> FCheckRailExtensionMainSide1Inches then begin
    SetModified;
    FCheckRailExtensionMainSide1Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetCheckRailExtensionMainSide2Inches(const AValue: Double);
begin
  if AValue <> FCheckRailExtensionMainSide2Inches then begin
    SetModified;
    FCheckRailExtensionMainSide2Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetWingRailReachMainSide1Inches(const AValue: Double);
begin
  if AValue <> FWingRailReachMainSide1Inches then begin
    SetModified;
    FWingRailReachMainSide1Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetWingRailReachMainSide2Inches(const AValue: Double);
begin
  if AValue <> FWingRailReachMainSide2Inches then begin
    SetModified;
    FWingRailReachMainSide2Inches := AValue;
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
procedure TProtoInfo.SetRailHeightInches(const AValue: Double);
begin
  if AValue <> FRailHeightInches then begin
    SetModified;
    FRailHeightInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetSeatThickInches(const AValue: Double);
begin
  if AValue <> FSeatThickInches then begin
    SetModified;
    FSeatThickInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetOldPlainSleeperLengthInches(const AValue: Double);
begin
  if AValue <> FOldPlainSleeperLengthInches then begin
    SetModified;
    FOldPlainSleeperLengthInches := AValue;
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
procedure TProtoInfo.SetFootHeightInches(const AValue: Double);
begin
  if AValue <> FFootHeightInches then begin
    SetModified;
    FFootHeightInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairOutLengthInches(const AValue: Double);
begin
  if AValue <> FChairOutLengthInches then begin
    SetModified;
    FChairOutLengthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairInLengthInches(const AValue: Double);
begin
  if AValue <> FChairInLengthInches then begin
    SetModified;
    FChairInLengthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairWidthInches(const AValue: Double);
begin
  if AValue <> FChairWidthInches then begin
    SetModified;
    FChairWidthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProtoInfo.SetChairCornerRadiusInches(const AValue: Double);
begin
  if AValue <> FChairCornerRadiusInches then begin
    SetModified;
    FChairCornerRadiusInches := AValue;
  end;
end;

//# endGenGetSetMethods

function TProtoInfo.GetInchScale: Double;
begin
  CheckCalculated;
  result := FInchScale;
end;

function TProtoInfo.GetInsideFaceMarkLength: Double;
begin
  CheckCalculated;
  result := FInsideFaceMarkLength;
end;

function TProtoInfo.GetOutsideFaceMarkLength: Double;
begin
  CheckCalculated;
  result := FOutsideFaceMarkLength;
end;

initialization
  TProtoInfo.RegisterClass;
  TProtoInfoOwningList.RegisterClass;
  TProtoInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TProtoInfo');
end.
