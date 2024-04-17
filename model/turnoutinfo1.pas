unit TurnoutInfo1;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{
Tturnout_info1 = record          // data for the turnout size...

  plain_track_flag: boolean;      //  True=plain track only.

  rolled_in_sleepered_flag: boolean;
  // 223a  alignment_byte_1:byte;   // D5 0.81 12-06-05

  front_timbers_flag: boolean;
  //  218a    alignment_byte_2:byte;   // D5 0.81 12-06-05

  approach_rails_only_flag: boolean;
  //  218a    alignment_byte_3:byte;   // D5 0.81 12-06-05

  hand: integer;      //  hand of turnout.
  timbering_flag: boolean;      //  True = equalized timbering.

  switch_timbers_flag: boolean;
  //  218a    alignment_byte_4:byte;   // D5 0.81 12-06-05
  closure_timbers_flag: boolean;
  //  218a    alignment_byte_5:byte;   // D5 0.81 12-06-05
  xing_timbers_flag: boolean;
  //  218a    alignment_byte_6:byte;   // D5 0.81 12-06-05

  exit_timbering: integer;      //  exit timbering style.
  turnout_road_code: integer;      //  length of turnout exit road.

  turnout_length: double;     //  turnoutx.
  origin_to_toe: double;     //  xorg.
  step_size: double;
  //  incx. (use saved step-size on reloading - not default).

  turnout_road_is_adjustable: boolean;
  // 211a    alignment_byte_7:byte;   // D5 0.81 12-06-05

  turnout_road_is_minimum: boolean;
  // 217a    alignment_byte_8:byte;   // D5 0.81 12-06-05

end;//tturnout_info1 record
}

{# class TTurnoutInfo1
---
class: TTurnoutInfo1
attributes:
- name: plainTrack
  type: Boolean
- name: rolledInSleepered
  type: Boolean
- name: frontTimbers
  type: Boolean
- name: approachRailsOnly
  type: Boolean
- name: hand
  type: TTurnoutHand
- name: timbering
  type: Boolean
- name: switchTimbers
  type: Boolean
- name: closureTimbers
  type: Boolean
- name: xingTimbers
  type: Boolean
- name: exitTimbering
  type: Integer
- name: turnoutRoadCode
  type: Integer
- name: turnoutLength
  type: Double
- name: originToToe
  type: Double
- name: stepSize
  type: Double
- name: turnoutRoadIsAdjustable
  type: Boolean
- name: turnoutRoadIsMinimum
  type: Boolean
...
}

type

  TTurnoutHand = (thLeft, thY, thRight);

  TTurnoutInfo1 = class(TOTPersistent)
  private
    //# genMemberVars
    FPlainTrack: Boolean;
    FRolledInSleepered: Boolean;
    FFrontTimbers: Boolean;
    FApproachRailsOnly: Boolean;
    FHand: TTurnoutHand;
    FTimbering: Boolean;
    FSwitchTimbers: Boolean;
    FClosureTimbers: Boolean;
    FXingTimbers: Boolean;
    FExitTimbering: Integer;
    FTurnoutRoadCode: Integer;
    FTurnoutLength: Double;
    FOriginToToe: Double;
    FStepSize: Double;
    FTurnoutRoadIsAdjustable: Boolean;
    FTurnoutRoadIsMinimum: Boolean;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    procedure SetPlainTrack(const AValue: Boolean);
    procedure SetRolledInSleepered(const AValue: Boolean);
    procedure SetFrontTimbers(const AValue: Boolean);
    procedure SetApproachRailsOnly(const AValue: Boolean);
    procedure SetHand(const AValue: TTurnoutHand);
    procedure SetTimbering(const AValue: Boolean);
    procedure SetSwitchTimbers(const AValue: Boolean);
    procedure SetClosureTimbers(const AValue: Boolean);
    procedure SetXingTimbers(const AValue: Boolean);
    procedure SetExitTimbering(const AValue: Integer);
    procedure SetTurnoutRoadCode(const AValue: Integer);
    procedure SetTurnoutLength(const AValue: Double);
    procedure SetOriginToToe(const AValue: Double);
    procedure SetStepSize(const AValue: Double);
    procedure SetTurnoutRoadIsAdjustable(const AValue: Boolean);
    procedure SetTurnoutRoadIsMinimum(const AValue: Boolean);
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
    property plainTrack: Boolean read FPlainTrack write SetPlainTrack;
    property rolledInSleepered: Boolean read FRolledInSleepered write SetRolledInSleepered;
    property frontTimbers: Boolean read FFrontTimbers write SetFrontTimbers;
    property approachRailsOnly: Boolean read FApproachRailsOnly write SetApproachRailsOnly;
    property hand: TTurnoutHand read FHand write SetHand;
    property timbering: Boolean read FTimbering write SetTimbering;
    property switchTimbers: Boolean read FSwitchTimbers write SetSwitchTimbers;
    property closureTimbers: Boolean read FClosureTimbers write SetClosureTimbers;
    property xingTimbers: Boolean read FXingTimbers write SetXingTimbers;
    property exitTimbering: Integer read FExitTimbering write SetExitTimbering;
    property turnoutRoadCode: Integer read FTurnoutRoadCode write SetTurnoutRoadCode;
    property turnoutLength: Double read FTurnoutLength write SetTurnoutLength;
    property originToToe: Double read FOriginToToe write SetOriginToToe;
    property stepSize: Double read FStepSize write SetStepSize;
    property turnoutRoadIsAdjustable: Boolean read FTurnoutRoadIsAdjustable write SetTurnoutRoadIsAdjustable;
    property turnoutRoadIsMinimum: Boolean read FTurnoutRoadIsMinimum write SetTurnoutRoadIsMinimum;
    //# endGenProperty
  end;

  TTurnoutInfo1OwningList = class(TOTOwningList<TTurnoutInfo1>);
  TTurnoutInfo1ReferenceList = class(TOTReferenceList<TTurnoutInfo1>);


function StrToTTurnoutHand(AValue: String): TTurnoutHand;
procedure SaveYamlTTurnoutHand(AEmitter: TYamlEmitter; const AName: String;
  AValue: TTurnoutHand);

function TurnoutHandMultiplier(AHand: TTurnoutHand): Integer;
function SwapTurnoutHand(AHand: TTurnoutHand): TTurnoutHand;

implementation

uses
  TLoggerUnit,
  Typinfo;

var
  log: ILogger;

function StrToTTurnoutHand(AValue: String): TTurnoutHand;
begin
  Result := TTurnoutHand(GetEnumValue(TypeInfo(TTurnoutHand), AValue));
end;

procedure SaveYamlTTurnoutHand(AEmitter: TYamlEmitter; const AName: String;
  AValue: TTurnoutHand);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TTurnoutHand), Ord(AValue)));
end;

function TurnoutHandMultiplier(AHand: TTurnoutHand): Integer;
begin
  case AHand of
    thLeft:
      Result := 1;
    thY:
      Result := 0;
    thRight:
      Result := -1;
    else
      raise Exception.Create('Unknown TTurnoutHand');
  end;
end;

function SwapTurnoutHand(AHand: TTurnoutHand): TTurnoutHand;
begin
  if AHand = thLeft then
    Result := thRight
  else
  if AHand = thRight then
    Result := thLeft
  else
    Result := thY;
end;

{ TTurnoutInfo1 }

constructor TTurnoutInfo1.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TTurnoutInfo1.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutInfo1.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TTurnoutInfo1.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'plainTrack' then
    FPlainTrack := StrToBoolean(AValue)
  else
  if AName = 'rolledInSleepered' then
    FRolledInSleepered := StrToBoolean(AValue)
  else
  if AName = 'frontTimbers' then
    FFrontTimbers := StrToBoolean(AValue)
  else
  if AName = 'approachRailsOnly' then
    FApproachRailsOnly := StrToBoolean(AValue)
  else
  if AName = 'hand' then
    FHand := StrToTTurnoutHand(AValue)
  else
  if AName = 'timbering' then
    FTimbering := StrToBoolean(AValue)
  else
  if AName = 'switchTimbers' then
    FSwitchTimbers := StrToBoolean(AValue)
  else
  if AName = 'closureTimbers' then
    FClosureTimbers := StrToBoolean(AValue)
  else
  if AName = 'xingTimbers' then
    FXingTimbers := StrToBoolean(AValue)
  else
  if AName = 'exitTimbering' then
    FExitTimbering := StrToInteger(AValue)
  else
  if AName = 'turnoutRoadCode' then
    FTurnoutRoadCode := StrToInteger(AValue)
  else
  if AName = 'turnoutLength' then
    FTurnoutLength := StrToDouble(AValue)
  else
  if AName = 'originToToe' then
    FOriginToToe := StrToDouble(AValue)
  else
  if AName = 'stepSize' then
    FStepSize := StrToDouble(AValue)
  else
  if AName = 'turnoutRoadIsAdjustable' then
    FTurnoutRoadIsAdjustable := StrToBoolean(AValue)
  else
  if AName = 'turnoutRoadIsMinimum' then
    FTurnoutRoadIsMinimum := StrToBoolean(AValue)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTurnoutInfo1.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FPlainTrack, sizeof(Boolean));
  AStream.ReadBuffer(FRolledInSleepered, sizeof(Boolean));
  AStream.ReadBuffer(FFrontTimbers, sizeof(Boolean));
  AStream.ReadBuffer(FApproachRailsOnly, sizeof(Boolean));
  AStream.ReadBuffer(FHand, sizeof(TTurnoutHand));
  AStream.ReadBuffer(FTimbering, sizeof(Boolean));
  AStream.ReadBuffer(FSwitchTimbers, sizeof(Boolean));
  AStream.ReadBuffer(FClosureTimbers, sizeof(Boolean));
  AStream.ReadBuffer(FXingTimbers, sizeof(Boolean));
  AStream.ReadBuffer(FExitTimbering, sizeof(Integer));
  AStream.ReadBuffer(FTurnoutRoadCode, sizeof(Integer));
  AStream.ReadBuffer(FTurnoutLength, sizeof(Double));
  AStream.ReadBuffer(FOriginToToe, sizeof(Double));
  AStream.ReadBuffer(FStepSize, sizeof(Double));
  AStream.ReadBuffer(FTurnoutRoadIsAdjustable, sizeof(Boolean));
  AStream.ReadBuffer(FTurnoutRoadIsMinimum, sizeof(Boolean));
  //# endGenRestoreVars
end;

procedure TTurnoutInfo1.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FPlainTrack, sizeof(Boolean));
  AStream.WriteBuffer(FRolledInSleepered, sizeof(Boolean));
  AStream.WriteBuffer(FFrontTimbers, sizeof(Boolean));
  AStream.WriteBuffer(FApproachRailsOnly, sizeof(Boolean));
  AStream.WriteBuffer(FHand, sizeof(TTurnoutHand));
  AStream.WriteBuffer(FTimbering, sizeof(Boolean));
  AStream.WriteBuffer(FSwitchTimbers, sizeof(Boolean));
  AStream.WriteBuffer(FClosureTimbers, sizeof(Boolean));
  AStream.WriteBuffer(FXingTimbers, sizeof(Boolean));
  AStream.WriteBuffer(FExitTimbering, sizeof(Integer));
  AStream.WriteBuffer(FTurnoutRoadCode, sizeof(Integer));
  AStream.WriteBuffer(FTurnoutLength, sizeof(Double));
  AStream.WriteBuffer(FOriginToToe, sizeof(Double));
  AStream.WriteBuffer(FStepSize, sizeof(Double));
  AStream.WriteBuffer(FTurnoutRoadIsAdjustable, sizeof(Boolean));
  AStream.WriteBuffer(FTurnoutRoadIsMinimum, sizeof(Boolean));
  //# endGenSaveVars
end;

procedure TTurnoutInfo1.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlBoolean(AEmitter, 'plainTrack', FPlainTrack);
  SaveYamlBoolean(AEmitter, 'rolledInSleepered', FRolledInSleepered);
  SaveYamlBoolean(AEmitter, 'frontTimbers', FFrontTimbers);
  SaveYamlBoolean(AEmitter, 'approachRailsOnly', FApproachRailsOnly);
  SaveYamlTTurnoutHand(AEmitter, 'hand', FHand);
  SaveYamlBoolean(AEmitter, 'timbering', FTimbering);
  SaveYamlBoolean(AEmitter, 'switchTimbers', FSwitchTimbers);
  SaveYamlBoolean(AEmitter, 'closureTimbers', FClosureTimbers);
  SaveYamlBoolean(AEmitter, 'xingTimbers', FXingTimbers);
  SaveYamlInteger(AEmitter, 'exitTimbering', FExitTimbering);
  SaveYamlInteger(AEmitter, 'turnoutRoadCode', FTurnoutRoadCode);
  SaveYamlDouble(AEmitter, 'turnoutLength', FTurnoutLength);
  SaveYamlDouble(AEmitter, 'originToToe', FOriginToToe);
  SaveYamlDouble(AEmitter, 'stepSize', FStepSize);
  SaveYamlBoolean(AEmitter, 'turnoutRoadIsAdjustable', FTurnoutRoadIsAdjustable);
  SaveYamlBoolean(AEmitter, 'turnoutRoadIsMinimum', FTurnoutRoadIsMinimum);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetPlainTrack(const AValue: Boolean);
begin
  if AValue <> FPlainTrack then begin
    SetModified;
    FPlainTrack := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetRolledInSleepered(const AValue: Boolean);
begin
  if AValue <> FRolledInSleepered then begin
    SetModified;
    FRolledInSleepered := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetFrontTimbers(const AValue: Boolean);
begin
  if AValue <> FFrontTimbers then begin
    SetModified;
    FFrontTimbers := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetApproachRailsOnly(const AValue: Boolean);
begin
  if AValue <> FApproachRailsOnly then begin
    SetModified;
    FApproachRailsOnly := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetHand(const AValue: TTurnoutHand);
begin
  if AValue <> FHand then begin
    SetModified;
    FHand := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetTimbering(const AValue: Boolean);
begin
  if AValue <> FTimbering then begin
    SetModified;
    FTimbering := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetSwitchTimbers(const AValue: Boolean);
begin
  if AValue <> FSwitchTimbers then begin
    SetModified;
    FSwitchTimbers := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetClosureTimbers(const AValue: Boolean);
begin
  if AValue <> FClosureTimbers then begin
    SetModified;
    FClosureTimbers := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetXingTimbers(const AValue: Boolean);
begin
  if AValue <> FXingTimbers then begin
    SetModified;
    FXingTimbers := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetExitTimbering(const AValue: Integer);
begin
  if AValue <> FExitTimbering then begin
    SetModified;
    FExitTimbering := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetTurnoutRoadCode(const AValue: Integer);
begin
  if AValue <> FTurnoutRoadCode then begin
    SetModified;
    FTurnoutRoadCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetTurnoutLength(const AValue: Double);
begin
  if AValue <> FTurnoutLength then begin
    SetModified;
    FTurnoutLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetOriginToToe(const AValue: Double);
begin
  if AValue <> FOriginToToe then begin
    SetModified;
    FOriginToToe := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetStepSize(const AValue: Double);
begin
  if AValue <> FStepSize then begin
    SetModified;
    FStepSize := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetTurnoutRoadIsAdjustable(const AValue: Boolean);
begin
  if AValue <> FTurnoutRoadIsAdjustable then begin
    SetModified;
    FTurnoutRoadIsAdjustable := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo1.SetTurnoutRoadIsMinimum(const AValue: Boolean);
begin
  if AValue <> FTurnoutRoadIsMinimum then begin
    SetModified;
    FTurnoutRoadIsMinimum := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TTurnoutInfo1.RegisterClass;
  TTurnoutInfo1OwningList.RegisterClass;
  TTurnoutInfo1ReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutInfo1');
end.
