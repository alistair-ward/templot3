unit MainsideStockRail;

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
  PlainTrackInfo;


{# class TMainsideStockRail
---
class: TMainsideStockRail
attributes:
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

  TMainsideStockRail = class(TFeature)
  private
    //# genMemberVars
    FProtoInfo: TOID;
    FPlainTrackInfo: TOID;
    //# endGenMemberVars

    procedure CalculateLines;
    procedure CalculateMarks;

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetProtoInfo: TProtoInfo;
    function GetPlainTrackInfo: TPlainTrackInfo;
    procedure SetProtoInfo(const AValue: TProtoInfo);
    procedure SetPlainTrackInfo(const AValue: TPlainTrackInfo);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property protoInfo: TProtoInfo read GetProtoInfo write SetProtoInfo;
    property plainTrackInfo: TPlainTrackInfo read GetPlainTrackInfo write SetPlainTrackInfo;
    //# endGenProperty
  end;

  TMainsideStockRailOwningList = class(TOTOwningList<TMainsideStockRail>);
  TMainsideStockRailReferenceList = class(TOTReferenceList<TMainsideStockRail>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit,
  point_ex,
  mark_unit,
  rail_data_unit,
  Line,
  TurnoutInfo1;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TMainsideStockRail }

constructor TMainsideStockRail.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FProtoInfo := 0;
  FPlainTrackInfo := 0;
  //# endGenCreate
end;

destructor TMainsideStockRail.Destroy;
begin
  //# genDestroy
  SetReference(FProtoInfo, nil);
  SetReference(FPlainTrackInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TMainsideStockRail.CalculateLines;
  var
    handMultiplier: Integer;
  begin
    handMultiplier := TurnoutHandMultiplier(turnoutInfo.hand);

    FLines.Add(TLine.Create(rdStraightStockGaugeFace));
    DoStraightLine(FLines[0], 0, turnoutInfo.turnoutLength, handMultiplier * protoInfo.gauge/2);

    FLines.Add(TLine.Create(rdStraightStockOuterFace));
    DoStraightLine(FLines[1], 0, turnoutInfo.turnoutLength, handMultiplier * (protoInfo.gauge/2 + protoInfo.railtopWidth));
end;

procedure TMainsideStockRail.CalculateMarks;
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
  insideOffset := handMultiplier * (protoInfo.gauge / 2 - protoInfo.insideFaceMarkLength);
  outsideOffset := handMultiplier * (protoInfo.gauge/2 + protoInfo.railtopWidth + protoInfo.outsideFaceMarkLength);

  // first cut... assume plain track...
  railLength := plainTrackInfo.railLengthInches * protoInfo.inchScale;
  x := turnoutInfo.originToToe;

  while x > 0 do begin
    curve.CalculateCurveAt(x, insideOffset, p1, d, r);
    curve.CalculateCurveAt(x, outsideOffset, p2, d, r);

    AddMark(p1, p2, eMC_6_RailJoint);
    x := x - railLength;
  end;
end;

procedure TMainsideStockRail.Calculate;
begin
  // Add your calculation code here, and cache the results...
  inherited;

  FLines.Clear;
  SetLength(FMarks, 0);

  CalculateLines;
  CalculateMarks;
end;

procedure TMainsideStockRail.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'protoInfo' then
    RestoreYamlObjectRef(FProtoInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'plainTrackInfo' then
    RestoreYamlObjectRef(FPlainTrackInfo, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TMainsideStockRail.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FProtoInfo, sizeof(TOID));
  AStream.ReadBuffer(FPlainTrackInfo, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TMainsideStockRail.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FProtoInfo, sizeof(TOID));
  AStream.WriteBuffer(FPlainTrackInfo, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TMainsideStockRail.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObjectReference(AEmitter, 'protoInfo', FProtoInfo);
  SaveYamlObjectReference(AEmitter, 'plainTrackInfo', FPlainTrackInfo);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TMainsideStockRail.GetProtoInfo: TProtoInfo;
begin
  Result := TProtoInfo(FromOID(FProtoInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TMainsideStockRail.SetProtoInfo(const AValue: TProtoInfo);
begin
  SetReference(FProtoInfo, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TMainsideStockRail.GetPlainTrackInfo: TPlainTrackInfo;
begin
  Result := TPlainTrackInfo(FromOID(FPlainTrackInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TMainsideStockRail.SetPlainTrackInfo(const AValue: TPlainTrackInfo);
begin
  SetReference(FPlainTrackInfo, AValue);
end;

//# endGenGetSetMethods

initialization
  TMainsideStockRail.RegisterClass;
  TMainsideStockRailOwningList.RegisterClass;
  TMainsideStockRailReferenceList.RegisterClass;

  //log := Logger.GetInstance('TMainsideStockRail');
end.
