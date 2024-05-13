unit SwitchInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;

{# enum TSwitchPattern
---
enum: TSwitchPattern
values:
- spStraightOrCurved
- spSemiCurved
- spDoubleCurved
...
}


{# class TSwitchInfo
---
class: TSwitchInfo
attributes:
  - name: switchPattern
    type: TSwitchPattern
  - name: planingLengthInches
    type: Double
  - name: planingAngle
    type: Double
  - name: switchRadiusInches
    type: Double
  - name: switchRailLengthInches
    type: Double
    comment: (C) length of switch rail (inches)
  - name: stockRailLengthInches
    type: Double
    comment: (S) length of stock rail (inches)
  - name: heelLeadInches
    type: Double
    comment: (L) lead to heel (incl. planing) (inches)
  - name: heelOffsetInches
    type: Double
    comment: (H) heel-offset (inches)
  - name: switchFrontInches
    type: Double
    comment: stock-rail-end to toe (inches)
  - name: planingRadiusInches
    type: Double
    comment: planing radius for couble-curved switch
  - name: timberCentres
    type: Double
    array: dynamic
    operations: [add, delete, clear]
    comment: timber centres (in inches).
  - name: groupCode
    type: Integer
    comment: which group of switches
  - name: sizeCode
    type: Integer
    comment: size within group (1=shortest)
  - name: joggleDepthInches
    type: Double
    comment: depth of joggle
  - name: joggleLengthInches
    type: Double
    comment: length of joggle in front of toe (+ve)
  - name: groupCount
    type: Integer
  - name: joggledStockRail
    type: Boolean
  - name: validData
    type: Boolean
  - name: frontTimbered
    type: Boolean
    comment: switch front sleepers are timber width.
  - name: numBridgeChairsMainRail
    type: Integer
  - name: numBridgeChairsTurnoutRail
    type: Integer
  - name: fbTipOffsetInches
    type: Double
    comment: fbtip dimension (FB foot from gauge-face at tip).
  - name: sleeperJ1Inches
    type: Double
    comment: first switch-front sleeper spacing back from TOE (NEGATIVE inches).
  - name: sleeperJ2Inches
    type: Double
    comment: seond switch-front sleeper spacing back from the first (NEGATIVE inches).
  - name: sleeperJ3Inches
    type: Double
    comment: third switch-front sleeper spacing back from the second (NEGATIVE inches).
  - name: sleeperJ4Inches
    type: Double
    comment: fourth switch-front sleeper spacing back from the third (NEGATIVE inches).
  - name: sleeperJ5Inches
    type: Double
    comment: fifth switch-front sleeper spacing back from the fourth (NEGATIVE inches).
  - name: numSlideChairs
    type: Integer
  - name: numBlockSlideChairs
    type: Integer
  - name: numBlockHeelChairs
    type: Integer
...
}

type
  //# genEnumDeclarations
  TSwitchPattern = (
    spStraightOrCurved,
    spSemiCurved,
    spDoubleCurved
    );

  //# endGenEnumDeclarations

  TSwitchInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FSwitchPattern: TSwitchPattern;
    FPlaningLengthInches: Double;
    FPlaningAngle: Double;
    FSwitchRadiusInches: Double;
    FSwitchRailLengthInches: Double;
    FStockRailLengthInches: Double;
    FHeelLeadInches: Double;
    FHeelOffsetInches: Double;
    FSwitchFrontInches: Double;
    FPlaningRadiusInches: Double;
    FTimberCentres: array of Double;
    FGroupCode: Integer;
    FSizeCode: Integer;
    FJoggleDepthInches: Double;
    FJoggleLengthInches: Double;
    FGroupCount: Integer;
    FJoggledStockRail: Boolean;
    FValidData: Boolean;
    FFrontTimbered: Boolean;
    FNumBridgeChairsMainRail: Integer;
    FNumBridgeChairsTurnoutRail: Integer;
    FFbTipOffsetInches: Double;
    FSleeperJ1Inches: Double;
    FSleeperJ2Inches: Double;
    FSleeperJ3Inches: Double;
    FSleeperJ4Inches: Double;
    FSleeperJ5Inches: Double;
    FNumSlideChairs: Integer;
    FNumBlockSlideChairs: Integer;
    FNumBlockHeelChairs: Integer;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    function GetTimberCentres(AIndex: Integer): Double;
    function GetTimberCentresCount: Integer;
    procedure SetSwitchPattern(const AValue: TSwitchPattern);
    procedure SetPlaningLengthInches(const AValue: Double);
    procedure SetPlaningAngle(const AValue: Double);
    procedure SetSwitchRadiusInches(const AValue: Double);
    procedure SetSwitchRailLengthInches(const AValue: Double);
    procedure SetStockRailLengthInches(const AValue: Double);
    procedure SetHeelLeadInches(const AValue: Double);
    procedure SetHeelOffsetInches(const AValue: Double);
    procedure SetSwitchFrontInches(const AValue: Double);
    procedure SetPlaningRadiusInches(const AValue: Double);
    procedure SetTimberCentres(AIndex: Integer; const AValue: Double);
    procedure SetGroupCode(const AValue: Integer);
    procedure SetSizeCode(const AValue: Integer);
    procedure SetJoggleDepthInches(const AValue: Double);
    procedure SetJoggleLengthInches(const AValue: Double);
    procedure SetGroupCount(const AValue: Integer);
    procedure SetJoggledStockRail(const AValue: Boolean);
    procedure SetValidData(const AValue: Boolean);
    procedure SetFrontTimbered(const AValue: Boolean);
    procedure SetNumBridgeChairsMainRail(const AValue: Integer);
    procedure SetNumBridgeChairsTurnoutRail(const AValue: Integer);
    procedure SetFbTipOffsetInches(const AValue: Double);
    procedure SetSleeperJ1Inches(const AValue: Double);
    procedure SetSleeperJ2Inches(const AValue: Double);
    procedure SetSleeperJ3Inches(const AValue: Double);
    procedure SetSleeperJ4Inches(const AValue: Double);
    procedure SetSleeperJ5Inches(const AValue: Double);
    procedure SetNumSlideChairs(const AValue: Integer);
    procedure SetNumBlockSlideChairs(const AValue: Integer);
    procedure SetNumBlockHeelChairs(const AValue: Integer);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    function AddTimberCentres(AValue: Double): Integer;
    procedure DeleteTimberCentres(AIndex: Integer);
    procedure ClearTimberCentres;
    //# endGenPublicDeclarations

    procedure RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
      ALoader: TOTPersistentLoader); override;
    procedure SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property switchPattern: TSwitchPattern read FSwitchPattern write SetSwitchPattern;
    property planingLengthInches: Double read FPlaningLengthInches write SetPlaningLengthInches;
    property planingAngle: Double read FPlaningAngle write SetPlaningAngle;
    property switchRadiusInches: Double read FSwitchRadiusInches write SetSwitchRadiusInches;

    // (C) length of switch rail (inches)
    property switchRailLengthInches: Double read FSwitchRailLengthInches write SetSwitchRailLengthInches;

    // (S) length of stock rail (inches)
    property stockRailLengthInches: Double read FStockRailLengthInches write SetStockRailLengthInches;

    // (L) lead to heel (incl. planing) (inches)
    property heelLeadInches: Double read FHeelLeadInches write SetHeelLeadInches;

    // (H) heel-offset (inches)
    property heelOffsetInches: Double read FHeelOffsetInches write SetHeelOffsetInches;

    // stock-rail-end to toe (inches)
    property switchFrontInches: Double read FSwitchFrontInches write SetSwitchFrontInches;

    // planing radius for couble-curved switch
    property planingRadiusInches: Double read FPlaningRadiusInches write SetPlaningRadiusInches;

    // timber centres (in inches).
    property timberCentres[AIndex: Integer]: Double read GetTimberCentres write SetTimberCentres;
    property timberCentresCount: Integer read GetTimberCentresCount;

    // which group of switches
    property groupCode: Integer read FGroupCode write SetGroupCode;

    // size within group (1=shortest)
    property sizeCode: Integer read FSizeCode write SetSizeCode;

    // depth of joggle
    property joggleDepthInches: Double read FJoggleDepthInches write SetJoggleDepthInches;

    // length of joggle in front of toe (+ve)
    property joggleLengthInches: Double read FJoggleLengthInches write SetJoggleLengthInches;
    property groupCount: Integer read FGroupCount write SetGroupCount;
    property joggledStockRail: Boolean read FJoggledStockRail write SetJoggledStockRail;
    property validData: Boolean read FValidData write SetValidData;

    // switch front sleepers are timber width.
    property frontTimbered: Boolean read FFrontTimbered write SetFrontTimbered;
    property numBridgeChairsMainRail: Integer read FNumBridgeChairsMainRail write SetNumBridgeChairsMainRail;
    property numBridgeChairsTurnoutRail: Integer read FNumBridgeChairsTurnoutRail write SetNumBridgeChairsTurnoutRail;

    // fbtip dimension (FB foot from gauge-face at tip).
    property fbTipOffsetInches: Double read FFbTipOffsetInches write SetFbTipOffsetInches;

    // first switch-front sleeper spacing back from TOE (NEGATIVE inches).
    property sleeperJ1Inches: Double read FSleeperJ1Inches write SetSleeperJ1Inches;

    // seond switch-front sleeper spacing back from the first (NEGATIVE inches).
    property sleeperJ2Inches: Double read FSleeperJ2Inches write SetSleeperJ2Inches;

    // third switch-front sleeper spacing back from the second (NEGATIVE inches).
    property sleeperJ3Inches: Double read FSleeperJ3Inches write SetSleeperJ3Inches;

    // fourth switch-front sleeper spacing back from the third (NEGATIVE inches).
    property sleeperJ4Inches: Double read FSleeperJ4Inches write SetSleeperJ4Inches;

    // fifth switch-front sleeper spacing back from the fourth (NEGATIVE inches).
    property sleeperJ5Inches: Double read FSleeperJ5Inches write SetSleeperJ5Inches;
    property numSlideChairs: Integer read FNumSlideChairs write SetNumSlideChairs;
    property numBlockSlideChairs: Integer read FNumBlockSlideChairs write SetNumBlockSlideChairs;
    property numBlockHeelChairs: Integer read FNumBlockHeelChairs write SetNumBlockHeelChairs;
    //# endGenProperty

  end;

  TSwitchInfoOwningList = class(TOTOwningList<TSwitchInfo>);
  TSwitchInfoReferenceList = class(TOTReferenceList<TSwitchInfo>);

//# genEnumSerialDeclarations
  function StrToTSwitchPattern(AValue: String): TSwitchPattern;
  procedure SaveYamlTSwitchPattern(AEmitter: TYamlEmitter; const AName: String;
    AValue: TSwitchPattern);

//# endGenEnumSerialDeclarations


implementation

uses
  TypInfo,
  TLoggerUnit;

var
  log: ILogger;

//# genEnumSerialMethods
// GENERATED METHOD - DO NOT EDIT
function StrToTSwitchPattern(AValue: String): TSwitchPattern;
begin
  Result := TSwitchPattern(GetEnumValue(TypeInfo(TSwitchPattern), AValue));
end;

// GENERATED METHOD - DO NOT EDIT
procedure SaveYamlTSwitchPattern(AEmitter: TYamlEmitter; const AName: String;
  AValue: TSwitchPattern);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TSwitchPattern), Ord(AValue)));
end;

//# endGenEnumSerialMethods

{ TSwitchInfo }

constructor TSwitchInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TSwitchInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TSwitchInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TSwitchInfo.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'switchPattern' then
    FSwitchPattern := StrToTSwitchPattern(AValue)
  else
  if AName = 'planingLengthInches' then
    FPlaningLengthInches := StrToDouble(AValue)
  else
  if AName = 'planingAngle' then
    FPlaningAngle := StrToDouble(AValue)
  else
  if AName = 'switchRadiusInches' then
    FSwitchRadiusInches := StrToDouble(AValue)
  else
  if AName = 'switchRailLengthInches' then
    FSwitchRailLengthInches := StrToDouble(AValue)
  else
  if AName = 'stockRailLengthInches' then
    FStockRailLengthInches := StrToDouble(AValue)
  else
  if AName = 'heelLeadInches' then
    FHeelLeadInches := StrToDouble(AValue)
  else
  if AName = 'heelOffsetInches' then
    FHeelOffsetInches := StrToDouble(AValue)
  else
  if AName = 'switchFrontInches' then
    FSwitchFrontInches := StrToDouble(AValue)
  else
  if AName = 'planingRadiusInches' then
    FPlaningRadiusInches := StrToDouble(AValue)
  else
  if AName = 'timberCentres-length' then
    SetLength(FTimberCentres, StrToInteger(AValue))
  else
  if AName = 'timberCentres' then
    FTimberCentres[Integer(Ord(Low(FTimberCentres))+AIndex)] := StrToDouble(AValue)
  else
  if AName = 'groupCode' then
    FGroupCode := StrToInteger(AValue)
  else
  if AName = 'sizeCode' then
    FSizeCode := StrToInteger(AValue)
  else
  if AName = 'joggleDepthInches' then
    FJoggleDepthInches := StrToDouble(AValue)
  else
  if AName = 'joggleLengthInches' then
    FJoggleLengthInches := StrToDouble(AValue)
  else
  if AName = 'groupCount' then
    FGroupCount := StrToInteger(AValue)
  else
  if AName = 'joggledStockRail' then
    FJoggledStockRail := StrToBoolean(AValue)
  else
  if AName = 'validData' then
    FValidData := StrToBoolean(AValue)
  else
  if AName = 'frontTimbered' then
    FFrontTimbered := StrToBoolean(AValue)
  else
  if AName = 'numBridgeChairsMainRail' then
    FNumBridgeChairsMainRail := StrToInteger(AValue)
  else
  if AName = 'numBridgeChairsTurnoutRail' then
    FNumBridgeChairsTurnoutRail := StrToInteger(AValue)
  else
  if AName = 'fbTipOffsetInches' then
    FFbTipOffsetInches := StrToDouble(AValue)
  else
  if AName = 'sleeperJ1Inches' then
    FSleeperJ1Inches := StrToDouble(AValue)
  else
  if AName = 'sleeperJ2Inches' then
    FSleeperJ2Inches := StrToDouble(AValue)
  else
  if AName = 'sleeperJ3Inches' then
    FSleeperJ3Inches := StrToDouble(AValue)
  else
  if AName = 'sleeperJ4Inches' then
    FSleeperJ4Inches := StrToDouble(AValue)
  else
  if AName = 'sleeperJ5Inches' then
    FSleeperJ5Inches := StrToDouble(AValue)
  else
  if AName = 'numSlideChairs' then
    FNumSlideChairs := StrToInteger(AValue)
  else
  if AName = 'numBlockSlideChairs' then
    FNumBlockSlideChairs := StrToInteger(AValue)
  else
  if AName = 'numBlockHeelChairs' then
    FNumBlockHeelChairs := StrToInteger(AValue)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TSwitchInfo.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FSwitchPattern, sizeof(TSwitchPattern));
  AStream.ReadBuffer(FPlaningLengthInches, sizeof(Double));
  AStream.ReadBuffer(FPlaningAngle, sizeof(Double));
  AStream.ReadBuffer(FSwitchRadiusInches, sizeof(Double));
  AStream.ReadBuffer(FSwitchRailLengthInches, sizeof(Double));
  AStream.ReadBuffer(FStockRailLengthInches, sizeof(Double));
  AStream.ReadBuffer(FHeelLeadInches, sizeof(Double));
  AStream.ReadBuffer(FHeelOffsetInches, sizeof(Double));
  AStream.ReadBuffer(FSwitchFrontInches, sizeof(Double));
  AStream.ReadBuffer(FPlaningRadiusInches, sizeof(Double));
  SetLength(FTimberCentres, AStream.ReadDWord);
  AStream.ReadBuffer(FTimberCentres[Low(FTimberCentres)], (Ord(High(FTimberCentres))-Ord(Low(FTimberCentres)) + 1)*sizeof(Double));
  AStream.ReadBuffer(FGroupCode, sizeof(Integer));
  AStream.ReadBuffer(FSizeCode, sizeof(Integer));
  AStream.ReadBuffer(FJoggleDepthInches, sizeof(Double));
  AStream.ReadBuffer(FJoggleLengthInches, sizeof(Double));
  AStream.ReadBuffer(FGroupCount, sizeof(Integer));
  AStream.ReadBuffer(FJoggledStockRail, sizeof(Boolean));
  AStream.ReadBuffer(FValidData, sizeof(Boolean));
  AStream.ReadBuffer(FFrontTimbered, sizeof(Boolean));
  AStream.ReadBuffer(FNumBridgeChairsMainRail, sizeof(Integer));
  AStream.ReadBuffer(FNumBridgeChairsTurnoutRail, sizeof(Integer));
  AStream.ReadBuffer(FFbTipOffsetInches, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ1Inches, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ2Inches, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ3Inches, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ4Inches, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ5Inches, sizeof(Double));
  AStream.ReadBuffer(FNumSlideChairs, sizeof(Integer));
  AStream.ReadBuffer(FNumBlockSlideChairs, sizeof(Integer));
  AStream.ReadBuffer(FNumBlockHeelChairs, sizeof(Integer));
  //# endGenRestoreVars
end;

procedure TSwitchInfo.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FSwitchPattern, sizeof(TSwitchPattern));
  AStream.WriteBuffer(FPlaningLengthInches, sizeof(Double));
  AStream.WriteBuffer(FPlaningAngle, sizeof(Double));
  AStream.WriteBuffer(FSwitchRadiusInches, sizeof(Double));
  AStream.WriteBuffer(FSwitchRailLengthInches, sizeof(Double));
  AStream.WriteBuffer(FStockRailLengthInches, sizeof(Double));
  AStream.WriteBuffer(FHeelLeadInches, sizeof(Double));
  AStream.WriteBuffer(FHeelOffsetInches, sizeof(Double));
  AStream.WriteBuffer(FSwitchFrontInches, sizeof(Double));
  AStream.WriteBuffer(FPlaningRadiusInches, sizeof(Double));
  AStream.WriteDWord(Length(FTimberCentres));
  AStream.WriteBuffer(FTimberCentres[Low(FTimberCentres)], (Ord(High(FTimberCentres))-Ord(Low(FTimberCentres)) + 1)*sizeof(Double));
  AStream.WriteBuffer(FGroupCode, sizeof(Integer));
  AStream.WriteBuffer(FSizeCode, sizeof(Integer));
  AStream.WriteBuffer(FJoggleDepthInches, sizeof(Double));
  AStream.WriteBuffer(FJoggleLengthInches, sizeof(Double));
  AStream.WriteBuffer(FGroupCount, sizeof(Integer));
  AStream.WriteBuffer(FJoggledStockRail, sizeof(Boolean));
  AStream.WriteBuffer(FValidData, sizeof(Boolean));
  AStream.WriteBuffer(FFrontTimbered, sizeof(Boolean));
  AStream.WriteBuffer(FNumBridgeChairsMainRail, sizeof(Integer));
  AStream.WriteBuffer(FNumBridgeChairsTurnoutRail, sizeof(Integer));
  AStream.WriteBuffer(FFbTipOffsetInches, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ1Inches, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ2Inches, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ3Inches, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ4Inches, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ5Inches, sizeof(Double));
  AStream.WriteBuffer(FNumSlideChairs, sizeof(Integer));
  AStream.WriteBuffer(FNumBlockSlideChairs, sizeof(Integer));
  AStream.WriteBuffer(FNumBlockHeelChairs, sizeof(Integer));
  //# endGenSaveVars
end;

procedure TSwitchInfo.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlTSwitchPattern(AEmitter, 'switchPattern', FSwitchPattern);
  SaveYamlDouble(AEmitter, 'planingLengthInches', FPlaningLengthInches);
  SaveYamlDouble(AEmitter, 'planingAngle', FPlaningAngle);
  SaveYamlDouble(AEmitter, 'switchRadiusInches', FSwitchRadiusInches);
  SaveYamlDouble(AEmitter, 'switchRailLengthInches', FSwitchRailLengthInches);
  SaveYamlDouble(AEmitter, 'stockRailLengthInches', FStockRailLengthInches);
  SaveYamlDouble(AEmitter, 'heelLeadInches', FHeelLeadInches);
  SaveYamlDouble(AEmitter, 'heelOffsetInches', FHeelOffsetInches);
  SaveYamlDouble(AEmitter, 'switchFrontInches', FSwitchFrontInches);
  SaveYamlDouble(AEmitter, 'planingRadiusInches', FPlaningRadiusInches);
  SaveYamlInteger(AEmitter, 'timberCentres-length', Length(FTimberCentres));
  SaveYamlSequence(AEmitter, 'timberCentres');
  for i := Ord(Low(FTimberCentres)) to Ord(High(FTimberCentres)) do
    SaveYamlSequenceDouble(AEmitter, FTimberCentres[Integer(i)]);
  SaveYamlEndSequence(AEmitter);
  SaveYamlInteger(AEmitter, 'groupCode', FGroupCode);
  SaveYamlInteger(AEmitter, 'sizeCode', FSizeCode);
  SaveYamlDouble(AEmitter, 'joggleDepthInches', FJoggleDepthInches);
  SaveYamlDouble(AEmitter, 'joggleLengthInches', FJoggleLengthInches);
  SaveYamlInteger(AEmitter, 'groupCount', FGroupCount);
  SaveYamlBoolean(AEmitter, 'joggledStockRail', FJoggledStockRail);
  SaveYamlBoolean(AEmitter, 'validData', FValidData);
  SaveYamlBoolean(AEmitter, 'frontTimbered', FFrontTimbered);
  SaveYamlInteger(AEmitter, 'numBridgeChairsMainRail', FNumBridgeChairsMainRail);
  SaveYamlInteger(AEmitter, 'numBridgeChairsTurnoutRail', FNumBridgeChairsTurnoutRail);
  SaveYamlDouble(AEmitter, 'fbTipOffsetInches', FFbTipOffsetInches);
  SaveYamlDouble(AEmitter, 'sleeperJ1Inches', FSleeperJ1Inches);
  SaveYamlDouble(AEmitter, 'sleeperJ2Inches', FSleeperJ2Inches);
  SaveYamlDouble(AEmitter, 'sleeperJ3Inches', FSleeperJ3Inches);
  SaveYamlDouble(AEmitter, 'sleeperJ4Inches', FSleeperJ4Inches);
  SaveYamlDouble(AEmitter, 'sleeperJ5Inches', FSleeperJ5Inches);
  SaveYamlInteger(AEmitter, 'numSlideChairs', FNumSlideChairs);
  SaveYamlInteger(AEmitter, 'numBlockSlideChairs', FNumBlockSlideChairs);
  SaveYamlInteger(AEmitter, 'numBlockHeelChairs', FNumBlockHeelChairs);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSwitchPattern(const AValue: TSwitchPattern);
begin
  if AValue <> FSwitchPattern then begin
    SetModified;
    FSwitchPattern := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetPlaningLengthInches(const AValue: Double);
begin
  if AValue <> FPlaningLengthInches then begin
    SetModified;
    FPlaningLengthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetPlaningAngle(const AValue: Double);
begin
  if AValue <> FPlaningAngle then begin
    SetModified;
    FPlaningAngle := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSwitchRadiusInches(const AValue: Double);
begin
  if AValue <> FSwitchRadiusInches then begin
    SetModified;
    FSwitchRadiusInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSwitchRailLengthInches(const AValue: Double);
begin
  if AValue <> FSwitchRailLengthInches then begin
    SetModified;
    FSwitchRailLengthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetStockRailLengthInches(const AValue: Double);
begin
  if AValue <> FStockRailLengthInches then begin
    SetModified;
    FStockRailLengthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetHeelLeadInches(const AValue: Double);
begin
  if AValue <> FHeelLeadInches then begin
    SetModified;
    FHeelLeadInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetHeelOffsetInches(const AValue: Double);
begin
  if AValue <> FHeelOffsetInches then begin
    SetModified;
    FHeelOffsetInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSwitchFrontInches(const AValue: Double);
begin
  if AValue <> FSwitchFrontInches then begin
    SetModified;
    FSwitchFrontInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetPlaningRadiusInches(const AValue: Double);
begin
  if AValue <> FPlaningRadiusInches then begin
    SetModified;
    FPlaningRadiusInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TSwitchInfo.GetTimberCentres(AIndex: Integer): Double;
begin
  Result := FTimberCentres[AIndex];
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetTimberCentres(AIndex: Integer; const AValue: Double);
begin
  if AValue <> FTimberCentres[AIndex] then begin
    SetModified;
    FTimberCentres[AIndex] := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TSwitchInfo.GetTimberCentresCount: Integer;
begin
  Result := Length(FTimberCentres);
end;

// GENERATED METHOD - DO NOT EDIT
function TSwitchInfo.AddTimberCentres(AValue: Double): Integer;
begin
  SetModified;
  SetLength(FTimberCentres, Length(FTimberCentres) + 1);
  FTimberCentres[High(FTimberCentres)] := AValue;
  Result := High(FTimberCentres);
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.DeleteTimberCentres(AIndex: Integer);
begin
  SetModified;
  Delete(FTimberCentres, AIndex, 1);
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.ClearTimberCentres;
begin
  SetModified;
  SetLength(FTimberCentres, 0);
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetGroupCode(const AValue: Integer);
begin
  if AValue <> FGroupCode then begin
    SetModified;
    FGroupCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSizeCode(const AValue: Integer);
begin
  if AValue <> FSizeCode then begin
    SetModified;
    FSizeCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetJoggleDepthInches(const AValue: Double);
begin
  if AValue <> FJoggleDepthInches then begin
    SetModified;
    FJoggleDepthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetJoggleLengthInches(const AValue: Double);
begin
  if AValue <> FJoggleLengthInches then begin
    SetModified;
    FJoggleLengthInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetGroupCount(const AValue: Integer);
begin
  if AValue <> FGroupCount then begin
    SetModified;
    FGroupCount := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetJoggledStockRail(const AValue: Boolean);
begin
  if AValue <> FJoggledStockRail then begin
    SetModified;
    FJoggledStockRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetValidData(const AValue: Boolean);
begin
  if AValue <> FValidData then begin
    SetModified;
    FValidData := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetFrontTimbered(const AValue: Boolean);
begin
  if AValue <> FFrontTimbered then begin
    SetModified;
    FFrontTimbered := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetNumBridgeChairsMainRail(const AValue: Integer);
begin
  if AValue <> FNumBridgeChairsMainRail then begin
    SetModified;
    FNumBridgeChairsMainRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetNumBridgeChairsTurnoutRail(const AValue: Integer);
begin
  if AValue <> FNumBridgeChairsTurnoutRail then begin
    SetModified;
    FNumBridgeChairsTurnoutRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetFbTipOffsetInches(const AValue: Double);
begin
  if AValue <> FFbTipOffsetInches then begin
    SetModified;
    FFbTipOffsetInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ1Inches(const AValue: Double);
begin
  if AValue <> FSleeperJ1Inches then begin
    SetModified;
    FSleeperJ1Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ2Inches(const AValue: Double);
begin
  if AValue <> FSleeperJ2Inches then begin
    SetModified;
    FSleeperJ2Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ3Inches(const AValue: Double);
begin
  if AValue <> FSleeperJ3Inches then begin
    SetModified;
    FSleeperJ3Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ4Inches(const AValue: Double);
begin
  if AValue <> FSleeperJ4Inches then begin
    SetModified;
    FSleeperJ4Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ5Inches(const AValue: Double);
begin
  if AValue <> FSleeperJ5Inches then begin
    SetModified;
    FSleeperJ5Inches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetNumSlideChairs(const AValue: Integer);
begin
  if AValue <> FNumSlideChairs then begin
    SetModified;
    FNumSlideChairs := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetNumBlockSlideChairs(const AValue: Integer);
begin
  if AValue <> FNumBlockSlideChairs then begin
    SetModified;
    FNumBlockSlideChairs := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetNumBlockHeelChairs(const AValue: Integer);
begin
  if AValue <> FNumBlockHeelChairs then begin
    SetModified;
    FNumBlockHeelChairs := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TSwitchInfo.RegisterClass;
  TSwitchInfoOwningList.RegisterClass;
  TSwitchInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TSwitchInfo');
end.
