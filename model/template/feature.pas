unit Feature;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  point_ex,
  mark_unit,
  rail_data_unit,
  line,
  curve_interface,
  Curve,
  TurnoutInfo1,
  TurnoutCurve;


{# class TFeature
---
class: TFeature
attributes:
- name: curve
  type: TCurve
  owns: ref
- name: turnoutInfo
  type: TTurnoutInfo1
  owns: ref
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TApproachOrExit = (aeApproach, aeExit);

  { TFeature }

  TFeature = class(TOTPersistent)
  private
    //# genMemberVars
    FCurve: TOID;
    FTurnoutInfo: TOID;
    //# endGenMemberVars

  protected
    FLines: TObjectList<TLine>;
    FMarks: TMarkExArray;

    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetCurve: TCurve;
    function GetTurnoutInfo: TTurnoutInfo1;
    procedure SetCurve(const AValue: TCurve);
    procedure SetTurnoutInfo(const AValue: TTurnoutInfo1);
    //# endGenGetSetDeclarations

    function GetNumberOfLines: Integer;
    function GetLine(idx: Integer): TLine;
    function GetNumberOfMarks: Integer;
    function GetMark(idx: Integer): TMarkEx;

    procedure AddMark(const p1, p2: Tpex; code: EMarkCode);

    procedure DoStraightLine(ALine: TLine; AStartX, AEndX, AYOffset: Double; ACurve: ICurve);
    procedure DoRailJoints(AStartX, AEndX, ARailLength: Double; AApproachOrExit: TApproachOrExit; AOffset1, AOffset2: Double; ACurve: ICurve);

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property curve: TCurve read GetCurve write SetCurve;
    property turnoutInfo: TTurnoutInfo1 read GetTurnoutInfo write SetTurnoutInfo;
    //# endGenProperty

    property numberOfLines: Integer read GetNumberOfLines;
    property lines[idx: Integer]: TLine read GetLine;
    property numberOfMarks: Integer read GetNumberOfMarks;
    property marks[idx: Integer]: TMarkEx read GetMark;
  end;

  TFeatureOwningList = class(TOTOwningList<TFeature>);
  TFeatureReferenceList = class(TOTReferenceList<TFeature>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TFeature }

constructor TFeature.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FCurve := 0;
  FTurnoutInfo := 0;
  //# endGenCreate

  FLines := TObjectList<TLine>.Create;
end;

destructor TFeature.Destroy;
begin
  //# genDestroy
  SetReference(FCurve, nil);
  SetReference(FTurnoutInfo, nil);
  //# endGenDestroy

  FLines.Free;
  inherited;
end;

procedure TFeature.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TFeature.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'curve' then
    RestoreYamlObjectRef(FCurve, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutInfo' then
    RestoreYamlObjectRef(FTurnoutInfo, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TFeature.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FCurve, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutInfo, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TFeature.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FCurve, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutInfo, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TFeature.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObjectReference(AEmitter, 'curve', FCurve);
  SaveYamlObjectReference(AEmitter, 'turnoutInfo', FTurnoutInfo);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TFeature.GetCurve: TCurve;
begin
  Result := TCurve(FromOID(FCurve));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TFeature.SetCurve(const AValue: TCurve);
begin
  SetReference(FCurve, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TFeature.GetTurnoutInfo: TTurnoutInfo1;
begin
  Result := TTurnoutInfo1(FromOID(FTurnoutInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TFeature.SetTurnoutInfo(const AValue: TTurnoutInfo1);
begin
  SetReference(FTurnoutInfo, AValue);
end;

//# endGenGetSetMethods

function TFeature.GetNumberOfLines: Integer;
begin
  CheckCalculated;
  Result := FLines.Count;
end;

function TFeature.GetLine(idx: Integer): TLine;
begin
  CheckCalculated;
  Result := FLines[idx];
end;

function TFeature.GetNumberOfMarks: Integer;
begin
  CheckCalculated;
  Result := Length(FMarks);
end;

function TFeature.GetMark(idx: Integer): TMarkEx;
begin
  CheckCalculated;
  Result := FMarks[idx];
end;

procedure TFeature.AddMark(const p1, p2: Tpex; code: EMarkCode);
begin
  SetLength(FMarks, Length(FMarks) + 1);
  FMarks[High(FMarks)].SetMark(code, p1, p2);
end;

procedure TFeature.DoStraightLine(ALine: TLine; AStartX, AEndX, AYOffset: Double; ACurve: ICurve);
var
  crvX: Double;
  incX: Double;
  pt: Tpex;
  dir: Tpex;
  radius: Double;
begin
  incX := turnoutInfo.stepSize;
  crvX := AStartX;

  repeat
    ACurve.CalculateCurveAt(crvX, AYOffset, pt, dir, radius);
    ALine.AddPoint(TPex.xy(crvX, AYOffset), pt);
    crvX := crvX + incX;
  until crvX > AEndX - (incX * 0.1);

  ACurve.CalculateCurveAt(AEndX, AYOffset, pt, dir, radius);
  ALine.AddPoint(TPex.xy(AEndX, AYOffset), pt);

end;

procedure TFeature.DoRailJoints(AStartX, AEndX, ARailLength: Double; AApproachOrExit: TApproachOrExit; AOffset1, AOffset2: Double; ACurve: ICurve);
var
  x: Double;
  p1: Tpex;
  p2: Tpex;
  d: Tpex;
  r: Double;
  direction: Double;
begin
  if AApproachOrExit = aeApproach then
    direction := -1
  else
    direction := 1;

  x := AStartX;

  while true do begin
    // loop condition check
    if AApproachOrExit = aeApproach then begin
      // working backwards
      if x < AEndX then
        break;
    end
    else begin
      // going forwards
      if x > AEndX then
        break;
    end;

    ACurve.CalculateCurveAt(x, AOffset1, p1, d, r);
    ACurve.CalculateCurveAt(x, AOffset2, p2, d, r);

    AddMark(p1, p2, eMC_6_RailJoint);
    x := x + direction * ARailLength;
  end;

end;

initialization
  TFeature.RegisterClass;
  TFeatureOwningList.RegisterClass;
  TFeatureReferenceList.RegisterClass;

  //log := Logger.GetInstance('TFeature');
end.
