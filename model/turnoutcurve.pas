unit TurnoutCurve;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{# class TTurnoutCurve
---
class: TTurnoutCurve
attributes:
...
}

type

  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TTurnoutCurve = class(TOTPersistent)
  private
    //# genMemberVars
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
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
  //# endGenCreate
end;

destructor TTurnoutCurve.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutCurve.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TTurnoutCurve.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTurnoutCurve.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  //# endGenRestoreVars
  end;

procedure TTurnoutCurve.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  //# endGenSaveVars
  end;
  
procedure TTurnoutCurve.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
//# endGenGetSetMethods

initialization
  TTurnoutCurve.RegisterClass;
  TTurnoutCurveOwningList.RegisterClass;
  TTurnoutCurveReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutCurve');
end.
