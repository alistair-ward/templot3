unit CheckEndDiff;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{# class TCheckEndDiff
---
class: TCheckEndDiff
attributes:
- name: lenDiff
  type: Double
  comment: length differ inches f-s
- name: flareLength
  type: Double
  comment: flare Length inches f-s
- name: getDiff
  type: Double
  comment: end gap model mm
- name: typeDiff
  type: TDiffType
...
}

type

  TDiffType = (dtNoDiff, dtBentFlare, dtMachinedFlare, dtNoFlare);

  TCheckEndDiff = class(TOTPersistent)
  private
    //# genMemberVars
    FLenDiff: Double;
    FFlareLength: Double;
    FGetDiff: Double;
    FTypeDiff: TDiffType;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    procedure SetLenDiff(const AValue: Double);
    procedure SetFlareLength(const AValue: Double);
    procedure SetGetDiff(const AValue: Double);
    procedure SetTypeDiff(const AValue: TDiffType);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
      ALoader: TOTPersistentLoader); override;
    procedure SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty

    // length differ inches f-s
    property lenDiff: Double read FLenDiff write SetLenDiff;

    // flare Length inches f-s
    property flareLength: Double read FFlareLength write SetFlareLength;

    // end gap model mm
    property getDiff: Double read FGetDiff write SetGetDiff;
    property typeDiff: TDiffType read FTypeDiff write SetTypeDiff;
    //# endGenProperty
  end;

  TCheckEndDiffOwningList = class(TOTOwningList<TCheckEndDiff>);
  TCheckEndDiffReferenceList = class(TOTReferenceList<TCheckEndDiff>);

function StrToTDiffType(AValue: String): TDiffType;
procedure SaveYamlTDiffType(AEmitter: TYamlEmitter; const AName: String;
  AValue: TDiffType);


implementation

uses
  TLoggerUnit,
  TypInfo;

var
  log: ILogger;


function StrToTDiffType(AValue: String): TDiffType;
begin
  Result := TDiffType(GetEnumValue(TypeInfo(TDiffType), AValue));
end;

procedure SaveYamlTDiffType(AEmitter: TYamlEmitter; const AName: String;
  AValue: TDiffType);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TDiffType), Ord(AValue)));
end;

{ TCheckEndDiff }

constructor TCheckEndDiff.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TCheckEndDiff.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TCheckEndDiff.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TCheckEndDiff.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'lenDiff' then
    FLenDiff := StrToDouble(AValue)
  else
  if AName = 'flareLength' then
    FFlareLength := StrToDouble(AValue)
  else
  if AName = 'getDiff' then
    FGetDiff := StrToDouble(AValue)
  else
  if AName = 'typeDiff' then
    FTypeDiff := StrToTDiffType(AValue)
  else
  //# endGenRestoreYamlVars
  inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TCheckEndDiff.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FLenDiff, sizeof(Double));
  AStream.ReadBuffer(FFlareLength, sizeof(Double));
  AStream.ReadBuffer(FGetDiff, sizeof(Double));
  AStream.ReadBuffer(FTypeDiff, sizeof(TDiffType));
  //# endGenRestoreVars
end;

procedure TCheckEndDiff.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FLenDiff, sizeof(Double));
  AStream.WriteBuffer(FFlareLength, sizeof(Double));
  AStream.WriteBuffer(FGetDiff, sizeof(Double));
  AStream.WriteBuffer(FTypeDiff, sizeof(TDiffType));
  //# endGenSaveVars
end;

procedure TCheckEndDiff.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlDouble(AEmitter, 'lenDiff', FLenDiff);
  SaveYamlDouble(AEmitter, 'flareLength', FFlareLength);
  SaveYamlDouble(AEmitter, 'getDiff', FGetDiff);
  SaveYamlTDiffType(AEmitter, 'typeDiff', FTypeDiff);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TCheckEndDiff.SetLenDiff(const AValue: Double);
begin
  if AValue <> FLenDiff then begin
    SetModified;
    FLenDiff := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCheckEndDiff.SetFlareLength(const AValue: Double);
begin
  if AValue <> FFlareLength then begin
    SetModified;
    FFlareLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCheckEndDiff.SetGetDiff(const AValue: Double);
begin
  if AValue <> FGetDiff then begin
    SetModified;
    FGetDiff := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCheckEndDiff.SetTypeDiff(const AValue: TDiffType);
begin
  if AValue <> FTypeDiff then begin
    SetModified;
    FTypeDiff := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TCheckEndDiff.RegisterClass;
  TCheckEndDiffOwningList.RegisterClass;
  TCheckEndDiffReferenceList.RegisterClass;

  //log := Logger.GetInstance('TCheckEndDiff');
end.
