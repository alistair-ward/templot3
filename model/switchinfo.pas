unit SwitchInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{# class TSwitchInfo
---
class: TSwitchInfo
attributes:
  - name: switchPattern
    type: Integer
  - name: planingLength
    type: Double
  - name: planingAngle
    type: Double
  - name: switchRadius
    type: Double
  - name: switchRailLength
    type: Double
    comment: (C) length of switch rail (inches)
  - name: stockRailLength
    type: Double
    comment: (S) length of stock rail (inches)
  - name: heelLead
    type: Double
    comment: (L) lead to heel (incl. planing) (inches)
  - name: heelOffset
    type: Double
    comment: (H) heel-offset (inches)
  - name: switchFront
    type: Double
    comment: stock-rail-end to toe (inches)
  - name: planingRadius
    type: Double
    comment: planing radius for couble-curved switch
  - name: sleeperJ1
    type: Double
    comment: first switch-front sleeper spacing back from TOE (NEGATIVE inches).
  - name: sleeperJ2
    type: Double
    comment: seond switch-front sleeper spacing back from the first (NEGATIVE inches).
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
  - name: joggleDepth
    type: Double
    comment: depth of joggle
  - name: joggleLength
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
  - name: fbTipOffset
    type: Double
    comment: fbtip dimension (FB foot from gauge-face at tip).
  - name: sleeperJ3
    type: Double
    comment: third switch-front sleeper spacing back from the second (NEGATIVE inches).
  - name: sleeperJ4
    type: Double
    comment: fourth switch-front sleeper spacing back from the third (NEGATIVE inches).
  - name: sleeperJ5
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

  TSwitchInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FSwitchPattern: Integer;
    FPlaningLength: Double;
    FPlaningAngle: Double;
    FSwitchRadius: Double;
    FSwitchRailLength: Double;
    FStockRailLength: Double;
    FHeelLead: Double;
    FHeelOffset: Double;
    FSwitchFront: Double;
    FPlaningRadius: Double;
    FSleeperJ1: Double;
    FSleeperJ2: Double;
    FTimberCentres: array of Double;
    FGroupCode: Integer;
    FSizeCode: Integer;
    FJoggleDepth: Double;
    FJoggleLength: Double;
    FGroupCount: Integer;
    FJoggledStockRail: Boolean;
    FValidData: Boolean;
    FFrontTimbered: Boolean;
    FNumBridgeChairsMainRail: Integer;
    FNumBridgeChairsTurnoutRail: Integer;
    FFbTipOffset: Double;
    FSleeperJ3: Double;
    FSleeperJ4: Double;
    FSleeperJ5: Double;
    FNumSlideChairs: Integer;
    FNumBlockSlideChairs: Integer;
    FNumBlockHeelChairs: Integer;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetTimberCentres(AIndex: Integer): Double;
    function GetTimberCentresCount: Integer;
    procedure SetSwitchPattern(const AValue: Integer);
    procedure SetPlaningLength(const AValue: Double);
    procedure SetPlaningAngle(const AValue: Double);
    procedure SetSwitchRadius(const AValue: Double);
    procedure SetSwitchRailLength(const AValue: Double);
    procedure SetStockRailLength(const AValue: Double);
    procedure SetHeelLead(const AValue: Double);
    procedure SetHeelOffset(const AValue: Double);
    procedure SetSwitchFront(const AValue: Double);
    procedure SetPlaningRadius(const AValue: Double);
    procedure SetSleeperJ1(const AValue: Double);
    procedure SetSleeperJ2(const AValue: Double);
    procedure SetTimberCentres(AIndex: Integer; const AValue: Double);
    procedure SetGroupCode(const AValue: Integer);
    procedure SetSizeCode(const AValue: Integer);
    procedure SetJoggleDepth(const AValue: Double);
    procedure SetJoggleLength(const AValue: Double);
    procedure SetGroupCount(const AValue: Integer);
    procedure SetJoggledStockRail(const AValue: Boolean);
    procedure SetValidData(const AValue: Boolean);
    procedure SetFrontTimbered(const AValue: Boolean);
    procedure SetNumBridgeChairsMainRail(const AValue: Integer);
    procedure SetNumBridgeChairsTurnoutRail(const AValue: Integer);
    procedure SetFbTipOffset(const AValue: Double);
    procedure SetSleeperJ3(const AValue: Double);
    procedure SetSleeperJ4(const AValue: Double);
    procedure SetSleeperJ5(const AValue: Double);
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

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property switchPattern: Integer read FSwitchPattern write SetSwitchPattern;
    property planingLength: Double read FPlaningLength write SetPlaningLength;
    property planingAngle: Double read FPlaningAngle write SetPlaningAngle;
    property switchRadius: Double read FSwitchRadius write SetSwitchRadius;

    // (C) length of switch rail (inches)
    property switchRailLength: Double read FSwitchRailLength write SetSwitchRailLength;

    // (S) length of stock rail (inches)
    property stockRailLength: Double read FStockRailLength write SetStockRailLength;

    // (L) lead to heel (incl. planing) (inches)
    property heelLead: Double read FHeelLead write SetHeelLead;

    // (H) heel-offset (inches)
    property heelOffset: Double read FHeelOffset write SetHeelOffset;

    // stock-rail-end to toe (inches)
    property switchFront: Double read FSwitchFront write SetSwitchFront;

    // planing radius for couble-curved switch
    property planingRadius: Double read FPlaningRadius write SetPlaningRadius;

    // first switch-front sleeper spacing back from TOE (NEGATIVE inches).
    property sleeperJ1: Double read FSleeperJ1 write SetSleeperJ1;

    // seond switch-front sleeper spacing back from the first (NEGATIVE inches).
    property sleeperJ2: Double read FSleeperJ2 write SetSleeperJ2;

    // timber centres (in inches).
    property timberCentres[AIndex: Integer]: Double read GetTimberCentres write SetTimberCentres;
    property timberCentresCount: Integer read GetTimberCentresCount;

    // which group of switches
    property groupCode: Integer read FGroupCode write SetGroupCode;

    // size within group (1=shortest)
    property sizeCode: Integer read FSizeCode write SetSizeCode;

    // depth of joggle
    property joggleDepth: Double read FJoggleDepth write SetJoggleDepth;

    // length of joggle in front of toe (+ve)
    property joggleLength: Double read FJoggleLength write SetJoggleLength;
    property groupCount: Integer read FGroupCount write SetGroupCount;
    property joggledStockRail: Boolean read FJoggledStockRail write SetJoggledStockRail;
    property validData: Boolean read FValidData write SetValidData;

    // switch front sleepers are timber width.
    property frontTimbered: Boolean read FFrontTimbered write SetFrontTimbered;
    property numBridgeChairsMainRail: Integer read FNumBridgeChairsMainRail write SetNumBridgeChairsMainRail;
    property numBridgeChairsTurnoutRail: Integer read FNumBridgeChairsTurnoutRail write SetNumBridgeChairsTurnoutRail;

    // fbtip dimension (FB foot from gauge-face at tip).
    property fbTipOffset: Double read FFbTipOffset write SetFbTipOffset;

    // third switch-front sleeper spacing back from the second (NEGATIVE inches).
    property sleeperJ3: Double read FSleeperJ3 write SetSleeperJ3;

    // fourth switch-front sleeper spacing back from the third (NEGATIVE inches).
    property sleeperJ4: Double read FSleeperJ4 write SetSleeperJ4;

    // fifth switch-front sleeper spacing back from the fourth (NEGATIVE inches).
    property sleeperJ5: Double read FSleeperJ5 write SetSleeperJ5;
    property numSlideChairs: Integer read FNumSlideChairs write SetNumSlideChairs;
    property numBlockSlideChairs: Integer read FNumBlockSlideChairs write SetNumBlockSlideChairs;
    property numBlockHeelChairs: Integer read FNumBlockHeelChairs write SetNumBlockHeelChairs;
    //# endGenProperty
  end;

  TSwitchInfoOwningList = class(TOTOwningList<TSwitchInfo>);
  TSwitchInfoReferenceList = class(TOTReferenceList<TSwitchInfo>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


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

procedure TSwitchInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'switchPattern' then
    FSwitchPattern := StrToInteger(AValue)
  else
  if AName = 'planingLength' then
    FPlaningLength := StrToDouble(AValue)
  else
  if AName = 'planingAngle' then
    FPlaningAngle := StrToDouble(AValue)
  else
  if AName = 'switchRadius' then
    FSwitchRadius := StrToDouble(AValue)
  else
  if AName = 'switchRailLength' then
    FSwitchRailLength := StrToDouble(AValue)
  else
  if AName = 'stockRailLength' then
    FStockRailLength := StrToDouble(AValue)
  else
  if AName = 'heelLead' then
    FHeelLead := StrToDouble(AValue)
  else
  if AName = 'heelOffset' then
    FHeelOffset := StrToDouble(AValue)
  else
  if AName = 'switchFront' then
    FSwitchFront := StrToDouble(AValue)
  else
  if AName = 'planingRadius' then
    FPlaningRadius := StrToDouble(AValue)
  else
  if AName = 'sleeperJ1' then
    FSleeperJ1 := StrToDouble(AValue)
  else
  if AName = 'sleeperJ2' then
    FSleeperJ2 := StrToDouble(AValue)
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
  if AName = 'joggleDepth' then
    FJoggleDepth := StrToDouble(AValue)
  else
  if AName = 'joggleLength' then
    FJoggleLength := StrToDouble(AValue)
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
  if AName = 'fbTipOffset' then
    FFbTipOffset := StrToDouble(AValue)
  else
  if AName = 'sleeperJ3' then
    FSleeperJ3 := StrToDouble(AValue)
  else
  if AName = 'sleeperJ4' then
    FSleeperJ4 := StrToDouble(AValue)
  else
  if AName = 'sleeperJ5' then
    FSleeperJ5 := StrToDouble(AValue)
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

procedure TSwitchInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FSwitchPattern, sizeof(Integer));
  AStream.ReadBuffer(FPlaningLength, sizeof(Double));
  AStream.ReadBuffer(FPlaningAngle, sizeof(Double));
  AStream.ReadBuffer(FSwitchRadius, sizeof(Double));
  AStream.ReadBuffer(FSwitchRailLength, sizeof(Double));
  AStream.ReadBuffer(FStockRailLength, sizeof(Double));
  AStream.ReadBuffer(FHeelLead, sizeof(Double));
  AStream.ReadBuffer(FHeelOffset, sizeof(Double));
  AStream.ReadBuffer(FSwitchFront, sizeof(Double));
  AStream.ReadBuffer(FPlaningRadius, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ1, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ2, sizeof(Double));
  SetLength(FTimberCentres, AStream.ReadDWord);
  AStream.ReadBuffer(FTimberCentres[Low(FTimberCentres)], (Ord(High(FTimberCentres))-Ord(Low(FTimberCentres)) + 1)*sizeof(Double));
  AStream.ReadBuffer(FGroupCode, sizeof(Integer));
  AStream.ReadBuffer(FSizeCode, sizeof(Integer));
  AStream.ReadBuffer(FJoggleDepth, sizeof(Double));
  AStream.ReadBuffer(FJoggleLength, sizeof(Double));
  AStream.ReadBuffer(FGroupCount, sizeof(Integer));
  AStream.ReadBuffer(FJoggledStockRail, sizeof(Boolean));
  AStream.ReadBuffer(FValidData, sizeof(Boolean));
  AStream.ReadBuffer(FFrontTimbered, sizeof(Boolean));
  AStream.ReadBuffer(FNumBridgeChairsMainRail, sizeof(Integer));
  AStream.ReadBuffer(FNumBridgeChairsTurnoutRail, sizeof(Integer));
  AStream.ReadBuffer(FFbTipOffset, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ3, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ4, sizeof(Double));
  AStream.ReadBuffer(FSleeperJ5, sizeof(Double));
  AStream.ReadBuffer(FNumSlideChairs, sizeof(Integer));
  AStream.ReadBuffer(FNumBlockSlideChairs, sizeof(Integer));
  AStream.ReadBuffer(FNumBlockHeelChairs, sizeof(Integer));
  //# endGenRestoreVars
  end;

procedure TSwitchInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FSwitchPattern, sizeof(Integer));
  AStream.WriteBuffer(FPlaningLength, sizeof(Double));
  AStream.WriteBuffer(FPlaningAngle, sizeof(Double));
  AStream.WriteBuffer(FSwitchRadius, sizeof(Double));
  AStream.WriteBuffer(FSwitchRailLength, sizeof(Double));
  AStream.WriteBuffer(FStockRailLength, sizeof(Double));
  AStream.WriteBuffer(FHeelLead, sizeof(Double));
  AStream.WriteBuffer(FHeelOffset, sizeof(Double));
  AStream.WriteBuffer(FSwitchFront, sizeof(Double));
  AStream.WriteBuffer(FPlaningRadius, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ1, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ2, sizeof(Double));
  AStream.WriteDWord(Length(FTimberCentres));
  AStream.WriteBuffer(FTimberCentres[Low(FTimberCentres)], (Ord(High(FTimberCentres))-Ord(Low(FTimberCentres)) + 1)*sizeof(Double));
  AStream.WriteBuffer(FGroupCode, sizeof(Integer));
  AStream.WriteBuffer(FSizeCode, sizeof(Integer));
  AStream.WriteBuffer(FJoggleDepth, sizeof(Double));
  AStream.WriteBuffer(FJoggleLength, sizeof(Double));
  AStream.WriteBuffer(FGroupCount, sizeof(Integer));
  AStream.WriteBuffer(FJoggledStockRail, sizeof(Boolean));
  AStream.WriteBuffer(FValidData, sizeof(Boolean));
  AStream.WriteBuffer(FFrontTimbered, sizeof(Boolean));
  AStream.WriteBuffer(FNumBridgeChairsMainRail, sizeof(Integer));
  AStream.WriteBuffer(FNumBridgeChairsTurnoutRail, sizeof(Integer));
  AStream.WriteBuffer(FFbTipOffset, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ3, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ4, sizeof(Double));
  AStream.WriteBuffer(FSleeperJ5, sizeof(Double));
  AStream.WriteBuffer(FNumSlideChairs, sizeof(Integer));
  AStream.WriteBuffer(FNumBlockSlideChairs, sizeof(Integer));
  AStream.WriteBuffer(FNumBlockHeelChairs, sizeof(Integer));
  //# endGenSaveVars
  end;
  
procedure TSwitchInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlInteger(AEmitter, 'switchPattern', FSwitchPattern);
  SaveYamlDouble(AEmitter, 'planingLength', FPlaningLength);
  SaveYamlDouble(AEmitter, 'planingAngle', FPlaningAngle);
  SaveYamlDouble(AEmitter, 'switchRadius', FSwitchRadius);
  SaveYamlDouble(AEmitter, 'switchRailLength', FSwitchRailLength);
  SaveYamlDouble(AEmitter, 'stockRailLength', FStockRailLength);
  SaveYamlDouble(AEmitter, 'heelLead', FHeelLead);
  SaveYamlDouble(AEmitter, 'heelOffset', FHeelOffset);
  SaveYamlDouble(AEmitter, 'switchFront', FSwitchFront);
  SaveYamlDouble(AEmitter, 'planingRadius', FPlaningRadius);
  SaveYamlDouble(AEmitter, 'sleeperJ1', FSleeperJ1);
  SaveYamlDouble(AEmitter, 'sleeperJ2', FSleeperJ2);
  SaveYamlInteger(AEmitter, 'timberCentres-length', Length(FTimberCentres));
  SaveYamlSequence(AEmitter, 'timberCentres');
  for i := Ord(Low(FTimberCentres)) to Ord(High(FTimberCentres)) do
    SaveYamlSequenceDouble(AEmitter, FTimberCentres[Integer(i)]);
  SaveYamlEndSequence(AEmitter);
  SaveYamlInteger(AEmitter, 'groupCode', FGroupCode);
  SaveYamlInteger(AEmitter, 'sizeCode', FSizeCode);
  SaveYamlDouble(AEmitter, 'joggleDepth', FJoggleDepth);
  SaveYamlDouble(AEmitter, 'joggleLength', FJoggleLength);
  SaveYamlInteger(AEmitter, 'groupCount', FGroupCount);
  SaveYamlBoolean(AEmitter, 'joggledStockRail', FJoggledStockRail);
  SaveYamlBoolean(AEmitter, 'validData', FValidData);
  SaveYamlBoolean(AEmitter, 'frontTimbered', FFrontTimbered);
  SaveYamlInteger(AEmitter, 'numBridgeChairsMainRail', FNumBridgeChairsMainRail);
  SaveYamlInteger(AEmitter, 'numBridgeChairsTurnoutRail', FNumBridgeChairsTurnoutRail);
  SaveYamlDouble(AEmitter, 'fbTipOffset', FFbTipOffset);
  SaveYamlDouble(AEmitter, 'sleeperJ3', FSleeperJ3);
  SaveYamlDouble(AEmitter, 'sleeperJ4', FSleeperJ4);
  SaveYamlDouble(AEmitter, 'sleeperJ5', FSleeperJ5);
  SaveYamlInteger(AEmitter, 'numSlideChairs', FNumSlideChairs);
  SaveYamlInteger(AEmitter, 'numBlockSlideChairs', FNumBlockSlideChairs);
  SaveYamlInteger(AEmitter, 'numBlockHeelChairs', FNumBlockHeelChairs);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSwitchPattern(const AValue: Integer);
begin
  if AValue <> FSwitchPattern then begin
    SetModified;
    FSwitchPattern := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetPlaningLength(const AValue: Double);
begin
  if AValue <> FPlaningLength then begin
    SetModified;
    FPlaningLength := AValue;
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
procedure TSwitchInfo.SetSwitchRadius(const AValue: Double);
begin
  if AValue <> FSwitchRadius then begin
    SetModified;
    FSwitchRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSwitchRailLength(const AValue: Double);
begin
  if AValue <> FSwitchRailLength then begin
    SetModified;
    FSwitchRailLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetStockRailLength(const AValue: Double);
begin
  if AValue <> FStockRailLength then begin
    SetModified;
    FStockRailLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetHeelLead(const AValue: Double);
begin
  if AValue <> FHeelLead then begin
    SetModified;
    FHeelLead := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetHeelOffset(const AValue: Double);
begin
  if AValue <> FHeelOffset then begin
    SetModified;
    FHeelOffset := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSwitchFront(const AValue: Double);
begin
  if AValue <> FSwitchFront then begin
    SetModified;
    FSwitchFront := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetPlaningRadius(const AValue: Double);
begin
  if AValue <> FPlaningRadius then begin
    SetModified;
    FPlaningRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ1(const AValue: Double);
begin
  if AValue <> FSleeperJ1 then begin
    SetModified;
    FSleeperJ1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ2(const AValue: Double);
begin
  if AValue <> FSleeperJ2 then begin
    SetModified;
    FSleeperJ2 := AValue;
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
procedure TSwitchInfo.SetJoggleDepth(const AValue: Double);
begin
  if AValue <> FJoggleDepth then begin
    SetModified;
    FJoggleDepth := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetJoggleLength(const AValue: Double);
begin
  if AValue <> FJoggleLength then begin
    SetModified;
    FJoggleLength := AValue;
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
procedure TSwitchInfo.SetFbTipOffset(const AValue: Double);
begin
  if AValue <> FFbTipOffset then begin
    SetModified;
    FFbTipOffset := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ3(const AValue: Double);
begin
  if AValue <> FSleeperJ3 then begin
    SetModified;
    FSleeperJ3 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ4(const AValue: Double);
begin
  if AValue <> FSleeperJ4 then begin
    SetModified;
    FSleeperJ4 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TSwitchInfo.SetSleeperJ5(const AValue: Double);
begin
  if AValue <> FSleeperJ5 then begin
    SetModified;
    FSleeperJ5 := AValue;
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
