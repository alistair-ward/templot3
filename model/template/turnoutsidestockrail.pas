unit TurnoutsideStockRail;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Feature,
  ProtoInfo,
  PlainTrackInfo,
  TurnoutCurve;


{# class TTurnoutsideStockRail
---
class: TTurnoutsideStockRail
attributes:
- name: turnoutCurve
  type: TTurnoutCurve
  owns: ref
- name: protoInfo
  type: TProtoInfo
  owns: ref
- name: plainTrackInfo
  type: TPlainTrackInfo
  owns: ref
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  { TTurnoutsideStockRail }

  TTurnoutsideStockRail = class(TFeature)
  private
    //# genMemberVars
    FTurnoutCurve: TOID;
    FProtoInfo: TOID;
    FPlainTrackInfo: TOID;
    //# endGenMemberVars

    procedure CalculateLines;
    procedure CalculateMarks;

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    function GetTurnoutCurve: TTurnoutCurve;
    function GetProtoInfo: TProtoInfo;
    function GetPlainTrackInfo: TPlainTrackInfo;
    procedure SetTurnoutCurve(const AValue: TTurnoutCurve);
    procedure SetProtoInfo(const AValue: TProtoInfo);
    procedure SetPlainTrackInfo(const AValue: TPlainTrackInfo);
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
    property turnoutCurve: TTurnoutCurve Read GetTurnoutCurve Write SetTurnoutCurve;
    property protoInfo: TProtoInfo Read GetProtoInfo Write SetProtoInfo;
    property plainTrackInfo: TPlainTrackInfo Read GetPlainTrackInfo Write SetPlainTrackInfo;
    //# endGenProperty
  end;

  TTurnoutsideStockRailOwningList = class(TOTOwningList<TTurnoutsideStockRail>);
  TTurnoutsideStockRailReferenceList = class(TOTReferenceList<TTurnoutsideStockRail>);

  //# genEnumSerialDeclarations
  //# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit,
  TurnoutInfo1,
  Line,
  rail_data_unit,
  mark_unit,
  point_ex;

var
  log: ILogger;

  //# genEnumSerialMethods
  //# endGenEnumSerialMethods

  { TTurnoutsideStockRail }

constructor TTurnoutsideStockRail.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FTurnoutCurve := 0;
  FProtoInfo := 0;
  FPlainTrackInfo := 0;
  //# endGenCreate
end;

destructor TTurnoutsideStockRail.Destroy;
begin
  //# genDestroy
  SetReference(FTurnoutCurve, nil);
  SetReference(FProtoInfo, nil);
  SetReference(FPlainTrackInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutsideStockRail.CalculateLines;
var
  handMultiplier: Integer;
begin
  handMultiplier := TurnoutHandMultiplier(turnoutInfo.hand);

  FLines.Add(TLine.Create(rdCurvedStockGaugeFace));
  DoStraightLine(FLines[0], 0, turnoutInfo.turnoutLength, handMultiplier *
    -protoInfo.gauge / 2, turnoutCurve);

  FLines.Add(TLine.Create(rdCurvedStockOuterFace));
  DoStraightLine(FLines[1], 0, turnoutInfo.turnoutLength, handMultiplier *
    -(protoInfo.gauge / 2 + protoInfo.railtopWidth), turnoutCurve);
end;

procedure TTurnoutsideStockRail.CalculateMarks;
var
  handMultiplier: Integer;
  railLength: Double;
  x: Double;
  p1: Tpex;
  p2: Tpex;
  d: Tpex;
  r: Double;
  insideOffset: Double;
  outsideOffset: Double;
begin
  if plainTrackInfo.railJointsCode = rjNone then
    Exit;

  // Plain track
  // treat the whole length as approach track...
  //
  // Approach Track
  // Marks are applied from the turnout point *backwards* to the start
  // of the template
  //
  // Exit Track
  // Marks are applied from the end of the turnout *fowards* to the end
  // of the template
  //

  handMultiplier := TurnoutHandMultiplier(turnoutInfo.hand);
  insideOffset := -handMultiplier * (protoInfo.gauge / 2 - protoInfo.insideFaceMarkLength);
  outsideOffset := -handMultiplier * (protoInfo.gauge/2 + protoInfo.railtopWidth + protoInfo.outsideFaceMarkLength);

  DoRailJoints( turnoutInfo.originToToe, 0, plainTrackInfo.railLengthInches * protoInfo.inchScale, aeApproach, insideOffset, outsideOffset, turnoutCurve);
end;

procedure TTurnoutsideStockRail.Calculate;
begin
  // Add your calculation code here, and cache the results...
  inherited;

  FLines.Clear;
  SetLength(FMarks, 0);

  CalculateLines;
  CalculateMarks;
end;

procedure TTurnoutsideStockRail.RestoreYamlAttribute(AName, AValue: String;
  AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'turnoutCurve' then
    RestoreYamlObjectRef(FTurnoutCurve, StrToInteger(AValue), ALoader)
  else
  if AName = 'protoInfo' then
    RestoreYamlObjectRef(FProtoInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'plainTrackInfo' then
    RestoreYamlObjectRef(FPlainTrackInfo, StrToInteger(AValue), ALoader)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTurnoutsideStockRail.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FTurnoutCurve, sizeof(TOID));
  AStream.ReadBuffer(FProtoInfo, sizeof(TOID));
  AStream.ReadBuffer(FPlainTrackInfo, sizeof(TOID));
  //# endGenRestoreVars
end;

procedure TTurnoutsideStockRail.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FTurnoutCurve, sizeof(TOID));
  AStream.WriteBuffer(FProtoInfo, sizeof(TOID));
  AStream.WriteBuffer(FPlainTrackInfo, sizeof(TOID));
  //# endGenSaveVars
end;

procedure TTurnoutsideStockRail.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlObjectReference(AEmitter, 'turnoutCurve', FTurnoutCurve);
  SaveYamlObjectReference(AEmitter, 'protoInfo', FProtoInfo);
  SaveYamlObjectReference(AEmitter, 'plainTrackInfo', FPlainTrackInfo);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TTurnoutsideStockRail.GetTurnoutCurve: TTurnoutCurve;
begin
  Result := TTurnoutCurve(FromOID(FTurnoutCurve));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutsideStockRail.SetTurnoutCurve(const AValue: TTurnoutCurve);
begin
  SetReference(FTurnoutCurve, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TTurnoutsideStockRail.GetProtoInfo: TProtoInfo;
begin
  Result := TProtoInfo(FromOID(FProtoInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutsideStockRail.SetProtoInfo(const AValue: TProtoInfo);
begin
  SetReference(FProtoInfo, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TTurnoutsideStockRail.GetPlainTrackInfo: TPlainTrackInfo;
begin
  Result := TPlainTrackInfo(FromOID(FPlainTrackInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutsideStockRail.SetPlainTrackInfo(const AValue: TPlainTrackInfo);
begin
  SetReference(FPlainTrackInfo, AValue);
end;

//# endGenGetSetMethods

initialization
  TTurnoutsideStockRail.RegisterClass;
  TTurnoutsideStockRailOwningList.RegisterClass;
  TTurnoutsideStockRailReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutsideStockRail');
end.
