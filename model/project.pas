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
- name: title
  type: String
- name: templates
  type: TTemplateOwningList
  owns: create
  access: [get]
- name: autoRestoreOnStartup
  type: Boolean
- name: askRestoreOnStartup
  type: Boolean
- name: templotVersion
  type: Integer
...
}

type

  TProject = class(TOTPersistent)
  private
    //# genMemberVars
    FTitle: String;
    FTemplates: TOID;
    FAutoRestoreOnStartup: Boolean;
    FAskRestoreOnStartup: Boolean;
    FTemplotVersion: Integer;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetTemplates: TTemplateOwningList;
    procedure SetTitle(const AValue: String);
    procedure SetAutoRestoreOnStartup(const AValue: Boolean);
    procedure SetAskRestoreOnStartup(const AValue: Boolean);
    procedure SetTemplotVersion(const AValue: Integer);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property title: String read FTitle write SetTitle;
    property templates: TTemplateOwningList read GetTemplates;
    property autoRestoreOnStartup: Boolean read FAutoRestoreOnStartup write SetAutoRestoreOnStartup;
    property askRestoreOnStartup: Boolean read FAskRestoreOnStartup write SetAskRestoreOnStartup;
    property templotVersion: Integer read FTemplotVersion write SetTemplotVersion;
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
  if AName = 'title' then
    FTitle := StrToString(AValue)
  else
  if AName = 'templates' then
    RestoreYamlObjectOwn(FTemplates, StrToInteger(AValue), ALoader)
  else
  if AName = 'autoRestoreOnStartup' then
    FAutoRestoreOnStartup := StrToBoolean(AValue)
  else
  if AName = 'askRestoreOnStartup' then
    FAskRestoreOnStartup := StrToBoolean(AValue)
  else
  if AName = 'templotVersion' then
    FTemplotVersion := StrToInteger(AValue)
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
  FTitle := AStream.ReadAnsiString;
  AStream.ReadBuffer(FTemplates, sizeof(TOID));
  AStream.ReadBuffer(FAutoRestoreOnStartup, sizeof(Boolean));
  AStream.ReadBuffer(FAskRestoreOnStartup, sizeof(Boolean));
  AStream.ReadBuffer(FTemplotVersion, sizeof(Integer));
  //# endGenRestoreVars
  end;

procedure TProject.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteAnsiString(FTitle);
  AStream.WriteBuffer(FTemplates, sizeof(TOID));
  AStream.WriteBuffer(FAutoRestoreOnStartup, sizeof(Boolean));
  AStream.WriteBuffer(FAskRestoreOnStartup, sizeof(Boolean));
  AStream.WriteBuffer(FTemplotVersion, sizeof(Integer));
  //# endGenSaveVars
  end;
  
procedure TProject.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlString(AEmitter, 'title', FTitle);
  SaveYamlObject(AEmitter, 'templates', FTemplates);
  SaveYamlBoolean(AEmitter, 'autoRestoreOnStartup', FAutoRestoreOnStartup);
  SaveYamlBoolean(AEmitter, 'askRestoreOnStartup', FAskRestoreOnStartup);
  SaveYamlInteger(AEmitter, 'templotVersion', FTemplotVersion);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetTitle(const AValue: String);
begin
  if AValue <> FTitle then begin
    SetModified;
    FTitle := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TProject.GetTemplates: TTemplateOwningList;
begin
  Result := TTemplateOwningList(FromOID(FTemplates));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetAutoRestoreOnStartup(const AValue: Boolean);
begin
  if AValue <> FAutoRestoreOnStartup then begin
    SetModified;
    FAutoRestoreOnStartup := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetAskRestoreOnStartup(const AValue: Boolean);
begin
  if AValue <> FAskRestoreOnStartup then begin
    SetModified;
    FAskRestoreOnStartup := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetTemplotVersion(const AValue: Integer);
begin
  if AValue <> FTemplotVersion then begin
    SetModified;
    FTemplotVersion := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TProject.RegisterClass;
  TProjectOwningList.RegisterClass;
  TProjectReferenceList.RegisterClass;

  //log := Logger.GetInstance('TProject');
end.
