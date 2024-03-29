unit Feature;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Curve;


{# class TFeature
---
class: TFeature
attributes:
- name: curve
  type: TCurve
  owns: ref
...
}

type

  TFeature = class(TOTPersistent)
  private
    //# genMemberVars
    FCurve: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetCurve: TCurve;
    procedure SetCurve(const AValue: TCurve);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property curve: TCurve read GetCurve write SetCurve;
    //# endGenProperty
  end;

  TFeatureOwningList = class(TOTOwningList<TFeature>);
  TFeatureReferenceList = class(TOTReferenceList<TFeature>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TFeature }

constructor TFeature.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FCurve := 0;
  //# endGenCreate
end;

destructor TFeature.Destroy;
begin
  //# genDestroy
  SetReference(FCurve, nil);
  //# endGenDestroy
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
  //# endGenRestoreVars
  end;

procedure TFeature.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FCurve, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TFeature.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObjectReference(AEmitter, 'curve', FCurve);
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

//# endGenGetSetMethods

initialization
  TFeature.RegisterClass;
  TFeatureOwningList.RegisterClass;
  TFeatureReferenceList.RegisterClass;

  //log := Logger.GetInstance('TFeature');
end.
