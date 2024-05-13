unit CheckEndDiff;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;

{# enum TDiffType
---
enum: TDiffType
values:
- dtNoDiff
- dtBentFlare
- dtMachinedFlare
- dtNoFlare
...
}


{# class TCheckEndDiff
---
class: TCheckEndDiff
attributes:
- name: lenDiff
  type: Double
  comment: length differ inches f-s
- name: flareDiff
  type: Double
  comment: flare Length inches f-s
- name: gapDiff
  type: Double
  comment: end gap model mm
- name: typeDiff
  type: TDiffType
...
}

type
  //# genEnumDeclarations
  TDiffType = (
    dtNoDiff,
    dtBentFlare,
    dtMachinedFlare,
    dtNoFlare
    );

  //# endGenEnumDeclarations

  TCheckEndDiff = class(TOTPersistent)
  private
    //# genMemberVars
    FLenDiff: Double;
    FFlareDiff: Double;
    FGapDiff: Double;
    FTypeDiff: TDiffType;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    procedure SetLenDiff(const AValue: Double);
    procedure SetFlareDiff(const AValue: Double);
    procedure SetGapDiff(const AValue: Double);
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
    property flareDiff: Double read FFlareDiff write SetFlareDiff;

    // end gap model mm
    property gapDiff: Double read FGapDiff write SetGapDiff;
    property typeDiff: TDiffType read FTypeDiff write SetTypeDiff;
    //# endGenProperty
  end;

  TCheckEndDiffOwningList = class(TOTOwningList<TCheckEndDiff>);
  TCheckEndDiffReferenceList = class(TOTReferenceList<TCheckEndDiff>);

//# genEnumSerialDeclarations
  function StrToTDiffType(AValue: String): TDiffType;
  procedure SaveYamlTDiffType(AEmitter: TYamlEmitter; const AName: String;
    AValue: TDiffType);

//# endGenEnumSerialDeclarations


implementation

uses
  TLoggerUnit,
  TypInfo;

var
  log: ILogger;

//# genEnumSerialMethods
// GENERATED METHOD - DO NOT EDIT
function StrToTDiffType(AValue: String): TDiffType;
begin
  Result := TDiffType(GetEnumValue(TypeInfo(TDiffType), AValue));
end;

// GENERATED METHOD - DO NOT EDIT
procedure SaveYamlTDiffType(AEmitter: TYamlEmitter; const AName: String;
  AValue: TDiffType);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TDiffType), Ord(AValue)));
end;

//# endGenEnumSerialMethods

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
  if AName = 'flareDiff' then
    FFlareDiff := StrToDouble(AValue)
  else
  if AName = 'gapDiff' then
    FGapDiff := StrToDouble(AValue)
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
  AStream.ReadBuffer(FFlareDiff, sizeof(Double));
  AStream.ReadBuffer(FGapDiff, sizeof(Double));
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
  AStream.WriteBuffer(FFlareDiff, sizeof(Double));
  AStream.WriteBuffer(FGapDiff, sizeof(Double));
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
  SaveYamlDouble(AEmitter, 'flareDiff', FFlareDiff);
  SaveYamlDouble(AEmitter, 'gapDiff', FGapDiff);
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
procedure TCheckEndDiff.SetFlareDiff(const AValue: Double);
begin
  if AValue <> FFlareDiff then begin
    SetModified;
    FFlareDiff := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCheckEndDiff.SetGapDiff(const AValue: Double);
begin
  if AValue <> FGapDiff then begin
    SetModified;
    FGapDiff := AValue;
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
