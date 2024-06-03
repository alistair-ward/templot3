unit Template;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Curve,
  template_records,
  BoxDims,
  TurnoutInfo2,
  Reminder,
  PlainTrackInfo,
  ShovedTimber,
  TurnoutCurve,
  Feature,
  Centreline,
  TurnoutCentreline,
  MainsideStockRail,
  TurnoutsideStockRail;


{# class TTemplate
---
class: TTemplate
attributes:
- name: name
  type: String
- name: topLabel
  type: String
- name: memo
  type: String
- name: curve
  type: TCurve
  owns: create
  access: [get]
- name: reminder
  type: TReminder
  owns: create
  access: [get]
- name: boxDims
  type: TBoxDims
  owns: create
  access: [get]
- name: turnoutInfo2
  type: TTurnoutInfo2
  owns: create
  access: [get]
- name: plainTrackInfo
  type: TPlainTrackInfo
  owns: create
  access: [get]
  comment: need the plain track info for approach and exit tracks.
- name: turnoutCurve
  type: TTurnoutCurve
  owns: create
  access: [get]
- name: shovedTimbers
  type: TShovedTimberOwningList
  owns: create
  access: [get]
- name: centreline
  type: TCentreline
  owns: create
  access: [get]
- name: turnoutCentreline
  type: TTurnoutCentreline
  owns: create
  access: [get]
- name: mainsideStockRail
  type: TMainsideStockRail
  owns: create
  access: [get]
- name: turnoutsideStockRail
  type: TTurnoutsideStockRail
  owns: create
  access: [get]
- name: drawKDiagonalSideCheckRail
  type: Boolean
- name: drawKMainSideCheckRail
  type: Boolean
- name: drawSwitchDrive
  type: Boolean
- name: drawCentrelineOnly
  type: Boolean
  comment: draw track centre-line only for bgnd
- name: drawDummyTemplate
  type: Boolean
  comment: same as centre-lines only, but drawn as background shape. 211c
- name: drawTrackCentreLines
  type: Boolean
- name: drawTurnoutRoadStockRail
  type: Boolean
- name: drawTurnoutRoadCheckRail
  type: Boolean
- name: drawTurnoutRoadCrossingRail
  type: Boolean
- name: drawCrossingVee
  type: Boolean
- name: drawMainRoadCrossingRail
  type: Boolean
- name: drawMainRoadCheckRail
  type: Boolean
- name: drawMainRoadStockRail
  type: Boolean
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TTemplate = class(TOTPersistent)
  private
    //# genMemberVars
    FName: String;
    FTopLabel: String;
    FMemo: String;
    FCurve: TOID;
    FReminder: TOID;
    FBoxDims: TOID;
    FTurnoutInfo2: TOID;
    FPlainTrackInfo: TOID;
    FTurnoutCurve: TOID;
    FShovedTimbers: TOID;
    FCentreline: TOID;
    FTurnoutCentreline: TOID;
    FMainsideStockRail: TOID;
    FTurnoutsideStockRail: TOID;
    FDrawKDiagonalSideCheckRail: Boolean;
    FDrawKMainSideCheckRail: Boolean;
    FDrawSwitchDrive: Boolean;
    FDrawCentrelineOnly: Boolean;
    FDrawDummyTemplate: Boolean;
    FDrawTrackCentreLines: Boolean;
    FDrawTurnoutRoadStockRail: Boolean;
    FDrawTurnoutRoadCheckRail: Boolean;
    FDrawTurnoutRoadCrossingRail: Boolean;
    FDrawCrossingVee: Boolean;
    FDrawMainRoadCrossingRail: Boolean;
    FDrawMainRoadCheckRail: Boolean;
    FDrawMainRoadStockRail: Boolean;
    //# endGenMemberVars

    FFeatures: array of TOID;

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetCurve: TCurve;
    function GetReminder: TReminder;
    function GetBoxDims: TBoxDims;
    function GetTurnoutInfo2: TTurnoutInfo2;
    function GetPlainTrackInfo: TPlainTrackInfo;
    function GetTurnoutCurve: TTurnoutCurve;
    function GetShovedTimbers: TShovedTimberOwningList;
    function GetCentreline: TCentreline;
    function GetTurnoutCentreline: TTurnoutCentreline;
    function GetMainsideStockRail: TMainsideStockRail;
    function GetTurnoutsideStockRail: TTurnoutsideStockRail;
    procedure SetName(const AValue: String);
    procedure SetTopLabel(const AValue: String);
    procedure SetMemo(const AValue: String);
    procedure SetDrawKDiagonalSideCheckRail(const AValue: Boolean);
    procedure SetDrawKMainSideCheckRail(const AValue: Boolean);
    procedure SetDrawSwitchDrive(const AValue: Boolean);
    procedure SetDrawCentrelineOnly(const AValue: Boolean);
    procedure SetDrawDummyTemplate(const AValue: Boolean);
    procedure SetDrawTrackCentreLines(const AValue: Boolean);
    procedure SetDrawTurnoutRoadStockRail(const AValue: Boolean);
    procedure SetDrawTurnoutRoadCheckRail(const AValue: Boolean);
    procedure SetDrawTurnoutRoadCrossingRail(const AValue: Boolean);
    procedure SetDrawCrossingVee(const AValue: Boolean);
    procedure SetDrawMainRoadCrossingRail(const AValue: Boolean);
    procedure SetDrawMainRoadCheckRail(const AValue: Boolean);
    procedure SetDrawMainRoadStockRail(const AValue: Boolean);
    //# endGenGetSetDeclarations

    function GetFeature(idx: Integer): TFeature;
    function GetFeatureCount: Integer;

  public
    // True=has been copied to the background. (not included in file).
    bg_copied: boolean;
    // True=selected as one of a group.
    group_selected: boolean;
    // True=has been shifted/rotated/mirrored, needs a new timestamp on rebuilding.
    new_stamp_wanted: boolean;

    // snapping positions for F7 shift mouse action  0.79.a  27-05-06
    snap_peg_positions: Tsnap_peg_positions;
    boundary_info: Tboundary_info;              // 213b for extend to boundary

    // used for peg snapping checks. (also in the template_info for file).  0.79.a  27-05-06
    bgnd_half_diamond: boolean;
    bgnd_plain_track: boolean;         // ditto
    bgnd_retpar: boolean;              // ditto parallel crossing
    bgnd_peg_on_zero: boolean;         // ditto Ctrl-0 or not.

    // added 205e for obtain tradius to control...

    bgnd_xing_type: integer;
    bgnd_spiral: boolean;
    bgnd_turnout_radius: double;

    bgnd_gaunt: boolean;               // 218a

    // 218d   temp flag   template is within a rectangle (e.g. on screen)
    bgnd_is_in_rect: boolean;

    // 211b position of name label...

    bgnd_label_x: double;   // mm
    bgnd_label_y: double;   // mm

    bgnd_blanked: boolean;        // 215a
    bgnd_no_xing: boolean;        // 215a

    this_is_tandem_first: boolean;  // 218a

    bgnd_keep: Tbgnd_keep;    // drawn data for a background template.

    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property name: String read FName write SetName;
    property topLabel: String read FTopLabel write SetTopLabel;
    property memo: String read FMemo write SetMemo;
    property curve: TCurve read GetCurve;
    property reminder: TReminder read GetReminder;
    property boxDims: TBoxDims read GetBoxDims;
    property turnoutInfo2: TTurnoutInfo2 read GetTurnoutInfo2;

    // need the plain track info for approach and exit tracks.
    property plainTrackInfo: TPlainTrackInfo read GetPlainTrackInfo;
    property turnoutCurve: TTurnoutCurve read GetTurnoutCurve;
    property shovedTimbers: TShovedTimberOwningList read GetShovedTimbers;
    property centreline: TCentreline read GetCentreline;
    property turnoutCentreline: TTurnoutCentreline read GetTurnoutCentreline;
    property mainsideStockRail: TMainsideStockRail read GetMainsideStockRail;
    property turnoutsideStockRail: TTurnoutsideStockRail read GetTurnoutsideStockRail;
    property drawKDiagonalSideCheckRail: Boolean read FDrawKDiagonalSideCheckRail write SetDrawKDiagonalSideCheckRail;
    property drawKMainSideCheckRail: Boolean read FDrawKMainSideCheckRail write SetDrawKMainSideCheckRail;
    property drawSwitchDrive: Boolean read FDrawSwitchDrive write SetDrawSwitchDrive;

    // draw track centre-line only for bgnd
    property drawCentrelineOnly: Boolean read FDrawCentrelineOnly write SetDrawCentrelineOnly;

    // same as centre-lines only, but drawn as background shape. 211c
    property drawDummyTemplate: Boolean read FDrawDummyTemplate write SetDrawDummyTemplate;
    property drawTrackCentreLines: Boolean read FDrawTrackCentreLines write SetDrawTrackCentreLines;
    property drawTurnoutRoadStockRail: Boolean read FDrawTurnoutRoadStockRail write SetDrawTurnoutRoadStockRail;
    property drawTurnoutRoadCheckRail: Boolean read FDrawTurnoutRoadCheckRail write SetDrawTurnoutRoadCheckRail;
    property drawTurnoutRoadCrossingRail: Boolean read FDrawTurnoutRoadCrossingRail write SetDrawTurnoutRoadCrossingRail;
    property drawCrossingVee: Boolean read FDrawCrossingVee write SetDrawCrossingVee;
    property drawMainRoadCrossingRail: Boolean read FDrawMainRoadCrossingRail write SetDrawMainRoadCrossingRail;
    property drawMainRoadCheckRail: Boolean read FDrawMainRoadCheckRail write SetDrawMainRoadCheckRail;
    property drawMainRoadStockRail: Boolean read FDrawMainRoadStockRail write SetDrawMainRoadStockRail;
    //# endGenProperty

    property featureCount: Integer read GetFeatureCount;
    property features[idx: Integer] : TFeature read GetFeature;
  end;

  TTemplateOwningList = class(TOTOwningList<TTemplate>);
  TTemplateReferenceList = class(TOTReferenceList<TTemplate>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TTemplate }

constructor TTemplate.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FCurve := TCurve.Create(nil).oid
  else
    FCurve := 0;
  if AOID = 0 then
    FReminder := TReminder.Create(nil).oid
  else
    FReminder := 0;
  if AOID = 0 then
    FBoxDims := TBoxDims.Create(nil).oid
  else
    FBoxDims := 0;
  if AOID = 0 then
    FTurnoutInfo2 := TTurnoutInfo2.Create(nil).oid
  else
    FTurnoutInfo2 := 0;
  if AOID = 0 then
    FPlainTrackInfo := TPlainTrackInfo.Create(nil).oid
  else
    FPlainTrackInfo := 0;
  if AOID = 0 then
    FTurnoutCurve := TTurnoutCurve.Create(nil).oid
  else
    FTurnoutCurve := 0;
  if AOID = 0 then
    FShovedTimbers := TShovedTimberOwningList.Create(nil).oid
  else
    FShovedTimbers := 0;
  if AOID = 0 then
    FCentreline := TCentreline.Create(nil).oid
  else
    FCentreline := 0;
  if AOID = 0 then
    FTurnoutCentreline := TTurnoutCentreline.Create(nil).oid
  else
    FTurnoutCentreline := 0;
  if AOID = 0 then
    FMainsideStockRail := TMainsideStockRail.Create(nil).oid
  else
    FMainsideStockRail := 0;
  if AOID = 0 then
    FTurnoutsideStockRail := TTurnoutsideStockRail.Create(nil).oid
  else
    FTurnoutsideStockRail := 0;
  //# endGenCreate

  if AOID = 0 then begin
    turnoutCurve.curve := curve;
    centreline.curve := curve;
    turnoutCentreline.curve := curve;
    turnoutCentreline.turnoutCurve := turnoutCurve;
    mainsideStockRail.curve := curve;
    turnoutsideStockRail.curve := curve;
    turnoutsideStockRail.turnoutCurve := turnoutCurve;
  end;
end;

destructor TTemplate.Destroy;
begin
  //# genDestroy
  SetOwned(FCurve, nil);
  SetOwned(FReminder, nil);
  SetOwned(FBoxDims, nil);
  SetOwned(FTurnoutInfo2, nil);
  SetOwned(FPlainTrackInfo, nil);
  SetOwned(FTurnoutCurve, nil);
  SetOwned(FShovedTimbers, nil);
  SetOwned(FCentreline, nil);
  SetOwned(FTurnoutCentreline, nil);
  SetOwned(FMainsideStockRail, nil);
  SetOwned(FTurnoutsideStockRail, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTemplate.Calculate;
  procedure AddFeature(AFeature: TFeature);
  begin
    SetLength(FFeatures, Length(FFeatures) + 1);
    FFeatures[High(FFeatures)] := AFeature.oid;
  end;

begin
  // Add your calculation code here, and cache the results...
  inherited;

  SetLength(FFeatures, 0);

  if drawCentrelineOnly or drawTrackCentreLines then begin
    AddFeature(centreline);
    if not boxDims.turnoutInfo1.plainTrack then
      AddFeature(turnoutCentreline);
    if drawCentrelineOnly then
      Exit;
  end;

  if drawMainRoadStockRail then
    AddFeature(mainsideStockRail);

  if drawTurnoutRoadStockRail then
    AddFeature(turnoutsideStockRail);

  if (boxDims.turnoutInfo1.plainTrack) then
    Exit;
end;

procedure TTemplate.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'name' then
    FName := StrToString(AValue)
  else
  if AName = 'topLabel' then
    FTopLabel := StrToString(AValue)
  else
  if AName = 'memo' then
    FMemo := StrToString(AValue)
  else
  if AName = 'curve' then
    RestoreYamlObjectOwn(FCurve, StrToInteger(AValue), ALoader)
  else
  if AName = 'reminder' then
    RestoreYamlObjectOwn(FReminder, StrToInteger(AValue), ALoader)
  else
  if AName = 'boxDims' then
    RestoreYamlObjectOwn(FBoxDims, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutInfo2' then
    RestoreYamlObjectOwn(FTurnoutInfo2, StrToInteger(AValue), ALoader)
  else
  if AName = 'plainTrackInfo' then
    RestoreYamlObjectOwn(FPlainTrackInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutCurve' then
    RestoreYamlObjectOwn(FTurnoutCurve, StrToInteger(AValue), ALoader)
  else
  if AName = 'shovedTimbers' then
    RestoreYamlObjectOwn(FShovedTimbers, StrToInteger(AValue), ALoader)
  else
  if AName = 'centreline' then
    RestoreYamlObjectOwn(FCentreline, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutCentreline' then
    RestoreYamlObjectOwn(FTurnoutCentreline, StrToInteger(AValue), ALoader)
  else
  if AName = 'mainsideStockRail' then
    RestoreYamlObjectOwn(FMainsideStockRail, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutsideStockRail' then
    RestoreYamlObjectOwn(FTurnoutsideStockRail, StrToInteger(AValue), ALoader)
  else
  if AName = 'drawKDiagonalSideCheckRail' then
    FDrawKDiagonalSideCheckRail := StrToBoolean(AValue)
  else
  if AName = 'drawKMainSideCheckRail' then
    FDrawKMainSideCheckRail := StrToBoolean(AValue)
  else
  if AName = 'drawSwitchDrive' then
    FDrawSwitchDrive := StrToBoolean(AValue)
  else
  if AName = 'drawCentrelineOnly' then
    FDrawCentrelineOnly := StrToBoolean(AValue)
  else
  if AName = 'drawDummyTemplate' then
    FDrawDummyTemplate := StrToBoolean(AValue)
  else
  if AName = 'drawTrackCentreLines' then
    FDrawTrackCentreLines := StrToBoolean(AValue)
  else
  if AName = 'drawTurnoutRoadStockRail' then
    FDrawTurnoutRoadStockRail := StrToBoolean(AValue)
  else
  if AName = 'drawTurnoutRoadCheckRail' then
    FDrawTurnoutRoadCheckRail := StrToBoolean(AValue)
  else
  if AName = 'drawTurnoutRoadCrossingRail' then
    FDrawTurnoutRoadCrossingRail := StrToBoolean(AValue)
  else
  if AName = 'drawCrossingVee' then
    FDrawCrossingVee := StrToBoolean(AValue)
  else
  if AName = 'drawMainRoadCrossingRail' then
    FDrawMainRoadCrossingRail := StrToBoolean(AValue)
  else
  if AName = 'drawMainRoadCheckRail' then
    FDrawMainRoadCheckRail := StrToBoolean(AValue)
  else
  if AName = 'drawMainRoadStockRail' then
    FDrawMainRoadStockRail := StrToBoolean(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTemplate.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  FName := AStream.ReadAnsiString;
  FTopLabel := AStream.ReadAnsiString;
  FMemo := AStream.ReadAnsiString;
  AStream.ReadBuffer(FCurve, sizeof(TOID));
  AStream.ReadBuffer(FReminder, sizeof(TOID));
  AStream.ReadBuffer(FBoxDims, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutInfo2, sizeof(TOID));
  AStream.ReadBuffer(FPlainTrackInfo, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutCurve, sizeof(TOID));
  AStream.ReadBuffer(FShovedTimbers, sizeof(TOID));
  AStream.ReadBuffer(FCentreline, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutCentreline, sizeof(TOID));
  AStream.ReadBuffer(FMainsideStockRail, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutsideStockRail, sizeof(TOID));
  AStream.ReadBuffer(FDrawKDiagonalSideCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FDrawKMainSideCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FDrawSwitchDrive, sizeof(Boolean));
  AStream.ReadBuffer(FDrawCentrelineOnly, sizeof(Boolean));
  AStream.ReadBuffer(FDrawDummyTemplate, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTrackCentreLines, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTurnoutRoadStockRail, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTurnoutRoadCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTurnoutRoadCrossingRail, sizeof(Boolean));
  AStream.ReadBuffer(FDrawCrossingVee, sizeof(Boolean));
  AStream.ReadBuffer(FDrawMainRoadCrossingRail, sizeof(Boolean));
  AStream.ReadBuffer(FDrawMainRoadCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FDrawMainRoadStockRail, sizeof(Boolean));
  //# endGenRestoreVars
  end;

procedure TTemplate.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteAnsiString(FName);
  AStream.WriteAnsiString(FTopLabel);
  AStream.WriteAnsiString(FMemo);
  AStream.WriteBuffer(FCurve, sizeof(TOID));
  AStream.WriteBuffer(FReminder, sizeof(TOID));
  AStream.WriteBuffer(FBoxDims, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutInfo2, sizeof(TOID));
  AStream.WriteBuffer(FPlainTrackInfo, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutCurve, sizeof(TOID));
  AStream.WriteBuffer(FShovedTimbers, sizeof(TOID));
  AStream.WriteBuffer(FCentreline, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutCentreline, sizeof(TOID));
  AStream.WriteBuffer(FMainsideStockRail, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutsideStockRail, sizeof(TOID));
  AStream.WriteBuffer(FDrawKDiagonalSideCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FDrawKMainSideCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FDrawSwitchDrive, sizeof(Boolean));
  AStream.WriteBuffer(FDrawCentrelineOnly, sizeof(Boolean));
  AStream.WriteBuffer(FDrawDummyTemplate, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTrackCentreLines, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTurnoutRoadStockRail, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTurnoutRoadCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTurnoutRoadCrossingRail, sizeof(Boolean));
  AStream.WriteBuffer(FDrawCrossingVee, sizeof(Boolean));
  AStream.WriteBuffer(FDrawMainRoadCrossingRail, sizeof(Boolean));
  AStream.WriteBuffer(FDrawMainRoadCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FDrawMainRoadStockRail, sizeof(Boolean));
  //# endGenSaveVars
  end;
  
procedure TTemplate.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlString(AEmitter, 'name', FName);
  SaveYamlString(AEmitter, 'topLabel', FTopLabel);
  SaveYamlString(AEmitter, 'memo', FMemo);
  SaveYamlObject(AEmitter, 'curve', FCurve);
  SaveYamlObject(AEmitter, 'reminder', FReminder);
  SaveYamlObject(AEmitter, 'boxDims', FBoxDims);
  SaveYamlObject(AEmitter, 'turnoutInfo2', FTurnoutInfo2);
  SaveYamlObject(AEmitter, 'plainTrackInfo', FPlainTrackInfo);
  SaveYamlObject(AEmitter, 'turnoutCurve', FTurnoutCurve);
  SaveYamlObject(AEmitter, 'shovedTimbers', FShovedTimbers);
  SaveYamlObject(AEmitter, 'centreline', FCentreline);
  SaveYamlObject(AEmitter, 'turnoutCentreline', FTurnoutCentreline);
  SaveYamlObject(AEmitter, 'mainsideStockRail', FMainsideStockRail);
  SaveYamlObject(AEmitter, 'turnoutsideStockRail', FTurnoutsideStockRail);
  SaveYamlBoolean(AEmitter, 'drawKDiagonalSideCheckRail', FDrawKDiagonalSideCheckRail);
  SaveYamlBoolean(AEmitter, 'drawKMainSideCheckRail', FDrawKMainSideCheckRail);
  SaveYamlBoolean(AEmitter, 'drawSwitchDrive', FDrawSwitchDrive);
  SaveYamlBoolean(AEmitter, 'drawCentrelineOnly', FDrawCentrelineOnly);
  SaveYamlBoolean(AEmitter, 'drawDummyTemplate', FDrawDummyTemplate);
  SaveYamlBoolean(AEmitter, 'drawTrackCentreLines', FDrawTrackCentreLines);
  SaveYamlBoolean(AEmitter, 'drawTurnoutRoadStockRail', FDrawTurnoutRoadStockRail);
  SaveYamlBoolean(AEmitter, 'drawTurnoutRoadCheckRail', FDrawTurnoutRoadCheckRail);
  SaveYamlBoolean(AEmitter, 'drawTurnoutRoadCrossingRail', FDrawTurnoutRoadCrossingRail);
  SaveYamlBoolean(AEmitter, 'drawCrossingVee', FDrawCrossingVee);
  SaveYamlBoolean(AEmitter, 'drawMainRoadCrossingRail', FDrawMainRoadCrossingRail);
  SaveYamlBoolean(AEmitter, 'drawMainRoadCheckRail', FDrawMainRoadCheckRail);
  SaveYamlBoolean(AEmitter, 'drawMainRoadStockRail', FDrawMainRoadStockRail);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetName(const AValue: String);
begin
  if AValue <> FName then begin
    SetModified;
    FName := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetTopLabel(const AValue: String);
begin
  if AValue <> FTopLabel then begin
    SetModified;
    FTopLabel := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetMemo(const AValue: String);
begin
  if AValue <> FMemo then begin
    SetModified;
    FMemo := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetCurve: TCurve;
begin
  Result := TCurve(FromOID(FCurve));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetReminder: TReminder;
begin
  Result := TReminder(FromOID(FReminder));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetBoxDims: TBoxDims;
begin
  Result := TBoxDims(FromOID(FBoxDims));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetTurnoutInfo2: TTurnoutInfo2;
begin
  Result := TTurnoutInfo2(FromOID(FTurnoutInfo2));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetPlainTrackInfo: TPlainTrackInfo;
begin
  Result := TPlainTrackInfo(FromOID(FPlainTrackInfo));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetTurnoutCurve: TTurnoutCurve;
begin
  Result := TTurnoutCurve(FromOID(FTurnoutCurve));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetShovedTimbers: TShovedTimberOwningList;
begin
  Result := TShovedTimberOwningList(FromOID(FShovedTimbers));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetCentreline: TCentreline;
begin
  Result := TCentreline(FromOID(FCentreline));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetTurnoutCentreline: TTurnoutCentreline;
begin
  Result := TTurnoutCentreline(FromOID(FTurnoutCentreline));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetMainsideStockRail: TMainsideStockRail;
begin
  Result := TMainsideStockRail(FromOID(FMainsideStockRail));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetTurnoutsideStockRail: TTurnoutsideStockRail;
begin
  Result := TTurnoutsideStockRail(FromOID(FTurnoutsideStockRail));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawKDiagonalSideCheckRail(const AValue: Boolean);
begin
  if AValue <> FDrawKDiagonalSideCheckRail then begin
    SetModified;
    FDrawKDiagonalSideCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawKMainSideCheckRail(const AValue: Boolean);
begin
  if AValue <> FDrawKMainSideCheckRail then begin
    SetModified;
    FDrawKMainSideCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawSwitchDrive(const AValue: Boolean);
begin
  if AValue <> FDrawSwitchDrive then begin
    SetModified;
    FDrawSwitchDrive := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawCentrelineOnly(const AValue: Boolean);
begin
  if AValue <> FDrawCentrelineOnly then begin
    SetModified;
    FDrawCentrelineOnly := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawDummyTemplate(const AValue: Boolean);
begin
  if AValue <> FDrawDummyTemplate then begin
    SetModified;
    FDrawDummyTemplate := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawTrackCentreLines(const AValue: Boolean);
begin
  if AValue <> FDrawTrackCentreLines then begin
    SetModified;
    FDrawTrackCentreLines := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawTurnoutRoadStockRail(const AValue: Boolean);
begin
  if AValue <> FDrawTurnoutRoadStockRail then begin
    SetModified;
    FDrawTurnoutRoadStockRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawTurnoutRoadCheckRail(const AValue: Boolean);
begin
  if AValue <> FDrawTurnoutRoadCheckRail then begin
    SetModified;
    FDrawTurnoutRoadCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawTurnoutRoadCrossingRail(const AValue: Boolean);
begin
  if AValue <> FDrawTurnoutRoadCrossingRail then begin
    SetModified;
    FDrawTurnoutRoadCrossingRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawCrossingVee(const AValue: Boolean);
begin
  if AValue <> FDrawCrossingVee then begin
    SetModified;
    FDrawCrossingVee := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawMainRoadCrossingRail(const AValue: Boolean);
begin
  if AValue <> FDrawMainRoadCrossingRail then begin
    SetModified;
    FDrawMainRoadCrossingRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawMainRoadCheckRail(const AValue: Boolean);
begin
  if AValue <> FDrawMainRoadCheckRail then begin
    SetModified;
    FDrawMainRoadCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetDrawMainRoadStockRail(const AValue: Boolean);
begin
  if AValue <> FDrawMainRoadStockRail then begin
    SetModified;
    FDrawMainRoadStockRail := AValue;
  end;
end;

//# endGenGetSetMethods

function TTemplate.GetFeature(idx: Integer): TFeature;
begin
  CheckCalculated;
  Result := TFeature(FromOID(FFeatures[idx]));
end;

function TTemplate.GetFeatureCount: Integer;
begin
  CheckCalculated;
  Result := Length(FFeatures);
end;

initialization
  TTemplate.RegisterClass;
  TTemplateOwningList.RegisterClass;
  TTemplateReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTemplate');
end.
