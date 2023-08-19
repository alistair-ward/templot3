unit Project;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  template;


{# class TProject
---
class: TProject
attributes:
- name: templates
  type: TTemplateOwningList
  owns: create
  access: [get]
...
}

type

  TProject = class(TOTPersistent)
  private
    //# genMemberVars
    FTemplates: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetTemplates: TTemplateOwningList;
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property templates: TTemplateOwningList read GetTemplates;
    //# endGenProperty
  end;

  TProjectOwningList = class(TOTOwningList<TProject>);
  TProjectReferenceList = class(TOTReferenceList<TProject>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TProject }

constructor TProject.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FTemplates := TTemplateOwningList.Create(nil).oid
  else
    FTemplates := 0;
  //# endGenCreate
end;

destructor TProject.Destroy;
begin
  //# genDestroy
  SetOwned(FTemplates, nil);
  //# endGenDestroy
  inherited;
end;

procedure TProject.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TProject.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'templates' then
    RestoreYamlObjectOwn(FTemplates, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TProject.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FTemplates, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TProject.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FTemplates, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TProject.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObject(AEmitter, 'templates', FTemplates);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TProject.GetTemplates: TTemplateOwningList;
begin
  Result := TTemplateOwningList(FromOID(FTemplates));
end;

//# endGenGetSetMethods

initialization
  TProject.RegisterClass;
  TProjectOwningList.RegisterClass;
  TProjectReferenceList.RegisterClass;

  //log := Logger.GetInstance('TProject');
end.
