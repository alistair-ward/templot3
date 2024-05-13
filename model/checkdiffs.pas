unit CheckDiffs;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  CheckEndDiff;


{# class TCheckDiffs
---
class: TCheckDiffs
attributes:
- name: endDiffMW
  type: TCheckEndDiff
  owns: create
  access: [get]
- name: endDiffME
  type: TCheckEndDiff
  owns: create
  access: [get]
- name: endDiffMR
  type: TCheckEndDiff
  owns: create
  access: [get]
- name: endDiffTW
  type: TCheckEndDiff
  owns: create
  access: [get]
- name: endDiffTE
  type: TCheckEndDiff
  owns: create
  access: [get]
- name: endDiffTR
  type: TCheckEndDiff
  owns: create
  access: [get]
- name: endDiffMK
  type: TCheckEndDiff
  owns: create
  access: [get]
- name: endDiffDK
  type: TCheckEndDiff
  owns: create
  access: [get]
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TCheckDiffs = class(TOTPersistent)
  private
    //# genMemberVars
    FEndDiffMW: TOID;
    FEndDiffME: TOID;
    FEndDiffMR: TOID;
    FEndDiffTW: TOID;
    FEndDiffTE: TOID;
    FEndDiffTR: TOID;
    FEndDiffMK: TOID;
    FEndDiffDK: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetEndDiffMW: TCheckEndDiff;
    function GetEndDiffME: TCheckEndDiff;
    function GetEndDiffMR: TCheckEndDiff;
    function GetEndDiffTW: TCheckEndDiff;
    function GetEndDiffTE: TCheckEndDiff;
    function GetEndDiffTR: TCheckEndDiff;
    function GetEndDiffMK: TCheckEndDiff;
    function GetEndDiffDK: TCheckEndDiff;
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property endDiffMW: TCheckEndDiff read GetEndDiffMW;
    property endDiffME: TCheckEndDiff read GetEndDiffME;
    property endDiffMR: TCheckEndDiff read GetEndDiffMR;
    property endDiffTW: TCheckEndDiff read GetEndDiffTW;
    property endDiffTE: TCheckEndDiff read GetEndDiffTE;
    property endDiffTR: TCheckEndDiff read GetEndDiffTR;
    property endDiffMK: TCheckEndDiff read GetEndDiffMK;
    property endDiffDK: TCheckEndDiff read GetEndDiffDK;
    //# endGenProperty
  end;

  TCheckDiffsOwningList = class(TOTOwningList<TCheckDiffs>);
  TCheckDiffsReferenceList = class(TOTReferenceList<TCheckDiffs>);

  //# genEnumSerialDeclarations
  //# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

  //# genEnumSerialMethods
  //# endGenEnumSerialMethods

{ TCheckDiffs }

constructor TCheckDiffs.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FEndDiffMW := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffMW := 0;
  if AOID = 0 then
    FEndDiffME := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffME := 0;
  if AOID = 0 then
    FEndDiffMR := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffMR := 0;
  if AOID = 0 then
    FEndDiffTW := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffTW := 0;
  if AOID = 0 then
    FEndDiffTE := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffTE := 0;
  if AOID = 0 then
    FEndDiffTR := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffTR := 0;
  if AOID = 0 then
    FEndDiffMK := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffMK := 0;
  if AOID = 0 then
    FEndDiffDK := TCheckEndDiff.Create(nil).oid
  else
    FEndDiffDK := 0;
  //# endGenCreate
end;

destructor TCheckDiffs.Destroy;
begin
  //# genDestroy
  SetOwned(FEndDiffMW, nil);
  SetOwned(FEndDiffME, nil);
  SetOwned(FEndDiffMR, nil);
  SetOwned(FEndDiffTW, nil);
  SetOwned(FEndDiffTE, nil);
  SetOwned(FEndDiffTR, nil);
  SetOwned(FEndDiffMK, nil);
  SetOwned(FEndDiffDK, nil);
  //# endGenDestroy
  inherited;
end;

procedure TCheckDiffs.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TCheckDiffs.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'endDiffMW' then
    RestoreYamlObjectOwn(FEndDiffMW, StrToInteger(AValue), ALoader)
  else
  if AName = 'endDiffME' then
    RestoreYamlObjectOwn(FEndDiffME, StrToInteger(AValue), ALoader)
  else
  if AName = 'endDiffMR' then
    RestoreYamlObjectOwn(FEndDiffMR, StrToInteger(AValue), ALoader)
  else
  if AName = 'endDiffTW' then
    RestoreYamlObjectOwn(FEndDiffTW, StrToInteger(AValue), ALoader)
  else
  if AName = 'endDiffTE' then
    RestoreYamlObjectOwn(FEndDiffTE, StrToInteger(AValue), ALoader)
  else
  if AName = 'endDiffTR' then
    RestoreYamlObjectOwn(FEndDiffTR, StrToInteger(AValue), ALoader)
  else
  if AName = 'endDiffMK' then
    RestoreYamlObjectOwn(FEndDiffMK, StrToInteger(AValue), ALoader)
  else
  if AName = 'endDiffDK' then
    RestoreYamlObjectOwn(FEndDiffDK, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TCheckDiffs.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FEndDiffMW, sizeof(TOID));
  AStream.ReadBuffer(FEndDiffME, sizeof(TOID));
  AStream.ReadBuffer(FEndDiffMR, sizeof(TOID));
  AStream.ReadBuffer(FEndDiffTW, sizeof(TOID));
  AStream.ReadBuffer(FEndDiffTE, sizeof(TOID));
  AStream.ReadBuffer(FEndDiffTR, sizeof(TOID));
  AStream.ReadBuffer(FEndDiffMK, sizeof(TOID));
  AStream.ReadBuffer(FEndDiffDK, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TCheckDiffs.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FEndDiffMW, sizeof(TOID));
  AStream.WriteBuffer(FEndDiffME, sizeof(TOID));
  AStream.WriteBuffer(FEndDiffMR, sizeof(TOID));
  AStream.WriteBuffer(FEndDiffTW, sizeof(TOID));
  AStream.WriteBuffer(FEndDiffTE, sizeof(TOID));
  AStream.WriteBuffer(FEndDiffTR, sizeof(TOID));
  AStream.WriteBuffer(FEndDiffMK, sizeof(TOID));
  AStream.WriteBuffer(FEndDiffDK, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TCheckDiffs.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObject(AEmitter, 'endDiffMW', FEndDiffMW);
  SaveYamlObject(AEmitter, 'endDiffME', FEndDiffME);
  SaveYamlObject(AEmitter, 'endDiffMR', FEndDiffMR);
  SaveYamlObject(AEmitter, 'endDiffTW', FEndDiffTW);
  SaveYamlObject(AEmitter, 'endDiffTE', FEndDiffTE);
  SaveYamlObject(AEmitter, 'endDiffTR', FEndDiffTR);
  SaveYamlObject(AEmitter, 'endDiffMK', FEndDiffMK);
  SaveYamlObject(AEmitter, 'endDiffDK', FEndDiffDK);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffMW: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffMW));
end;

// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffME: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffME));
end;

// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffMR: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffMR));
end;

// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffTW: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffTW));
end;

// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffTE: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffTE));
end;

// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffTR: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffTR));
end;

// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffMK: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffMK));
end;

// GENERATED METHOD - DO NOT EDIT
function TCheckDiffs.GetEndDiffDK: TCheckEndDiff;
begin
  Result := TCheckEndDiff(FromOID(FEndDiffDK));
end;

//# endGenGetSetMethods

initialization
  TCheckDiffs.RegisterClass;
  TCheckDiffsOwningList.RegisterClass;
  TCheckDiffsReferenceList.RegisterClass;

  //log := Logger.GetInstance('TCheckDiffs');
end.
