unit TurnoutCurve;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  point_ex,
  curve_interface,
  Curve,
  TurnoutInfo1;


{# class TTurnoutCurve
---
class: TTurnoutCurve
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

  TTurnoutCurve = class(TOTPersistent, ICurve)
  private
    //# genMemberVars
    FCurve: TOID;
    FTurnoutInfo: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetCurve: TCurve;
    function GetTurnoutInfo: TTurnoutInfo1;
    procedure SetCurve(const AValue: TCurve);
    procedure SetTurnoutInfo(const AValue: TTurnoutInfo1);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    procedure CalculateCurveAt(distance, offset: Double; out pt, direction: Tpex; out radius: Double);
    function CalculateCurveDistanceFromOffset(distance, offset, distanceFromOffset:
      Double): Double;

    //# genProperty
    property curve: TCurve read GetCurve write SetCurve;
    property turnoutInfo: TTurnoutInfo1 read GetTurnoutInfo write SetTurnoutInfo;
    //# endGenProperty

  end;

  TTurnoutCurveOwningList = class(TOTOwningList<TTurnoutCurve>);
  TTurnoutCurveReferenceList = class(TOTReferenceList<TTurnoutCurve>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TTurnoutCurve }

constructor TTurnoutCurve.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FCurve := 0;
  FTurnoutInfo := 0;
  //# endGenCreate
end;

destructor TTurnoutCurve.Destroy;
begin
  //# genDestroy
  SetReference(FCurve, nil);
  SetReference(FTurnoutInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutCurve.Calculate;
begin
  inherited;

  // initial assumption is plain track only, so we're just going to pass any calls straight through
  // to the underlying curve

end;

procedure TTurnoutCurve.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
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

procedure TTurnoutCurve.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FCurve, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutInfo, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TTurnoutCurve.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FCurve, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutInfo, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TTurnoutCurve.SaveYamlAttributes(AEmitter : TYamlEmitter);
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
function TTurnoutCurve.GetCurve: TCurve;
begin
  Result := TCurve(FromOID(FCurve));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutCurve.SetCurve(const AValue: TCurve);
begin
  SetReference(FCurve, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TTurnoutCurve.GetTurnoutInfo: TTurnoutInfo1;
begin
  Result := TTurnoutInfo1(FromOID(FTurnoutInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutCurve.SetTurnoutInfo(const AValue: TTurnoutInfo1);
begin
  SetReference(FTurnoutInfo, AValue);
end;

//# endGenGetSetMethods

procedure TTurnoutCurve.CalculateCurveAt(distance, offset: Double; out pt, direction: Tpex; out radius: Double);
begin
  CheckCalculated;
  // initial assumption of plain track
  curve.CalculateCurveAt(distance, offset, pt, direction, radius);
end;

function TTurnoutCurve.CalculateCurveDistanceFromOffset(distance, offset, distanceFromOffset:
  Double): Double;
begin
  CheckCalculated;
  // initial assumption of plain track
  Result := curve.CalculateCurveDistanceFromOffset(distance, offset, distanceFromOffset);
end;

initialization
  TTurnoutCurve.RegisterClass;
  TTurnoutCurveOwningList.RegisterClass;
  TTurnoutCurveReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutCurve');
end.
