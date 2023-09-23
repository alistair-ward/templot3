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
- name: gridUnits
  type: TGridUnitCode
- name: gridSpaceX
  type: Double
- name: gridSpaceY
  type: Double
- name: boxSaveDone
  type: Boolean
...
}

type
  TGridUnitCode = (gucFeet, gucInches, gucProtoFeet, gucCentimetres, gucMillimetres);

  TProject = class(TOTPersistent)
  private
    //# genMemberVars
    FTitle: String;
    FTemplates: TOID;
    FAutoRestoreOnStartup: Boolean;
    FAskRestoreOnStartup: Boolean;
    FTemplotVersion: Integer;
    FGridUnits: TGridUnitCode;
    FGridSpaceX: Double;
    FGridSpaceY: Double;
    FBoxSaveDone: Boolean;
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
    procedure SetGridUnits(const AValue: TGridUnitCode);
    procedure SetGridSpaceX(const AValue: Double);
    procedure SetGridSpaceY(const AValue: Double);
    procedure SetBoxSaveDone(const AValue: Boolean);
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
    property gridUnits: TGridUnitCode read FGridUnits write SetGridUnits;
    property gridSpaceX: Double read FGridSpaceX write SetGridSpaceX;
    property gridSpaceY: Double read FGridSpaceY write SetGridSpaceY;
    property boxSaveDone: Boolean read FBoxSaveDone write SetBoxSaveDone;
    //# endGenProperty

    function StrToTGridUnitCode(AValue: String): TGridUnitCode;
    procedure SaveYamlTGridUnitCode(AEmitter: TYamlEmitter; const AName: String; AValue: TGridUnitCode);

  end;

  TProjectOwningList = class(TOTOwningList<TProject>);
  TProjectReferenceList = class(TOTReferenceList<TProject>);


implementation

uses
  TLoggerUnit,
  Typinfo;

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
  if AName = 'gridUnits' then
    FGridUnits := StrToTGridUnitCode(AValue)
  else
  if AName = 'gridSpaceX' then
    FGridSpaceX := StrToDouble(AValue)
  else
  if AName = 'gridSpaceY' then
    FGridSpaceY := StrToDouble(AValue)
  else
  if AName = 'boxSaveDone' then
    FBoxSaveDone := StrToBoolean(AValue)
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
  AStream.ReadBuffer(FGridUnits, sizeof(TGridUnitCode));
  AStream.ReadBuffer(FGridSpaceX, sizeof(Double));
  AStream.ReadBuffer(FGridSpaceY, sizeof(Double));
  AStream.ReadBuffer(FBoxSaveDone, sizeof(Boolean));
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
  AStream.WriteBuffer(FGridUnits, sizeof(TGridUnitCode));
  AStream.WriteBuffer(FGridSpaceX, sizeof(Double));
  AStream.WriteBuffer(FGridSpaceY, sizeof(Double));
  AStream.WriteBuffer(FBoxSaveDone, sizeof(Boolean));
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
  SaveYamlTGridUnitCode(AEmitter, 'gridUnits', FGridUnits);
  SaveYamlDouble(AEmitter, 'gridSpaceX', FGridSpaceX);
  SaveYamlDouble(AEmitter, 'gridSpaceY', FGridSpaceY);
  SaveYamlBoolean(AEmitter, 'boxSaveDone', FBoxSaveDone);
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

// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetGridUnits(const AValue: TGridUnitCode);
begin
  if AValue <> FGridUnits then begin
    SetModified;
    FGridUnits := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetGridSpaceX(const AValue: Double);
begin
  if AValue <> FGridSpaceX then begin
    SetModified;
    FGridSpaceX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetGridSpaceY(const AValue: Double);
begin
  if AValue <> FGridSpaceY then begin
    SetModified;
    FGridSpaceY := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TProject.SetBoxSaveDone(const AValue: Boolean);
begin
  if AValue <> FBoxSaveDone then begin
    SetModified;
    FBoxSaveDone := AValue;
  end;
end;

//# endGenGetSetMethods

function TProject.StrToTGridUnitCode(AValue: String): TGridUnitCode;
begin
  Result := TGridUnitCode(GetEnumValue(TypeInfo(TGridUnitCode), AValue));
end;

procedure TProject.SaveYamlTGridUnitCode(AEmitter: TYamlEmitter; const AName: String; AValue: TGridUnitCode);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TGridUnitCode), ord(AValue)));
end;



initialization
  TProject.RegisterClass;
  TProjectOwningList.RegisterClass;
  TProjectReferenceList.RegisterClass;

  //log := Logger.GetInstance('TProject');
end.
