unit TurnoutCentreline;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Feature,
  Curve,
  TurnoutCurve;


{# class TTurnoutCentreline
---
class: TTurnoutCentreline
attributes:
- name: turnoutCurve
  type: TTurnoutCurve
  owns: ref
...
}

type

  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TTurnoutCentreline = class(TFeature)
  private
    //# genMemberVars
    FTurnoutCurve: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetTurnoutCurve: TTurnoutCurve;
    procedure SetTurnoutCurve(const AValue: TTurnoutCurve);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property turnoutCurve: TTurnoutCurve read GetTurnoutCurve write SetTurnoutCurve;
    //# endGenProperty
  end;

  TTurnoutCentrelineOwningList = class(TOTOwningList<TTurnoutCentreline>);
  TTurnoutCentrelineReferenceList = class(TOTReferenceList<TTurnoutCentreline>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit,
  Line,
  rail_data_unit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TTurnoutCentreline }

constructor TTurnoutCentreline.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FTurnoutCurve := 0;
  //# endGenCreate
end;

destructor TTurnoutCentreline.Destroy;
begin
  //# genDestroy
  SetReference(FTurnoutCurve, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutCentreline.Calculate;
begin
  // Add your calculation code here, and cache the results...
  inherited;

  SetLength(FMarks, 0);

  FLines.Clear;
  FLines.Add(TLine.Create(rdTurnoutRoadCentreLine));

  DoStraightLine(FLines[0], 0, turnoutInfo.turnoutLength, 0, turnoutCurve);
end;

procedure TTurnoutCentreline.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'turnoutCurve' then
    RestoreYamlObjectRef(FTurnoutCurve, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTurnoutCentreline.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FTurnoutCurve, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TTurnoutCentreline.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FTurnoutCurve, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TTurnoutCentreline.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObjectReference(AEmitter, 'turnoutCurve', FTurnoutCurve);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TTurnoutCentreline.GetTurnoutCurve: TTurnoutCurve;
begin
  Result := TTurnoutCurve(FromOID(FTurnoutCurve));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutCentreline.SetTurnoutCurve(const AValue: TTurnoutCurve);
begin
  SetReference(FTurnoutCurve, AValue);
end;

//# endGenGetSetMethods

initialization
  TTurnoutCentreline.RegisterClass;
  TTurnoutCentrelineOwningList.RegisterClass;
  TTurnoutCentrelineReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutCentreline');
end.
