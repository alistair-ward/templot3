unit TurnoutInfo2;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{# class TTurnoutInfo2
---
class: TTurnoutInfo2
attributes:
...
}

type

  TTurnoutInfo2 = class(TOTPersistent)
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

  TTurnoutInfo2OwningList = class(TOTOwningList<TTurnoutInfo2>);
  TTurnoutInfo2ReferenceList = class(TOTReferenceList<TTurnoutInfo2>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TTurnoutInfo2 }

constructor TTurnoutInfo2.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TTurnoutInfo2.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutInfo2.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TTurnoutInfo2.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTurnoutInfo2.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  //# endGenRestoreVars
  end;

procedure TTurnoutInfo2.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  //# endGenSaveVars
  end;
  
procedure TTurnoutInfo2.SaveYamlAttributes(AEmitter : TYamlEmitter);
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
  TTurnoutInfo2.RegisterClass;
  TTurnoutInfo2OwningList.RegisterClass;
  TTurnoutInfo2ReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutInfo2');
end.
