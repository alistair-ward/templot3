unit PlainTrackInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


const
  //  maximum of 52 sleepers per length.
  psleep_c = 51;

{
Tplain_track_info = record

(/)  pt_custom: boolean;        // custom plain track flag.

  alignment_byte_1: byte;   // D5 0.81 12-06-05
  alignment_byte_2: byte;   // D5 0.81 12-06-05
  alignment_byte_3: byte;   // D5 0.81 12-06-05

(/)  list_index: integer;
(/)  rail_length: double;         // rail length in inches.

  alignment_byte_4: byte;   // D5 0.81 12-06-05
  alignment_byte_5: byte;   // D5 0.81 12-06-05

(/)  sleepers_per_length: integer;                     // number of sleepers per length.
(/)  sleeper_centres: array[0..psleep_c] of double;  // spacings in inches for custom.

(/)  rail_joints_code: integer;   // 0=normal, 1=staggered, -1=none (cwr).

(/)  user_peg_rail: integer;   // was pt_spare_int2:integer; 13-3-01.

  pt_spare_flag1: boolean;
  pt_spare_flag2: boolean;
  pt_spare_flag3: boolean;

  user_peg_data_valid: boolean;    // was pt_spare_flag4:boolean;  13-3-01

  user_pegx: double;          // was pt_spare_float1:double;  13-3-01
  user_pegy: double;          // was pt_spare_float2:double;  13-3-01
  user_pegk: double;          // was pt_spare_float3:double;  13-3-01

  pt_spacing_name_str: string[200];     // was spare_str:string[250];   17-1-01.

  alignment_byte_6: byte;   // D5 0.81 12-06-05

  pt_tb_rolling_percent: double;      // 0.76.a  17-5-02.

  gaunt_sleeper_mod_inches: double;       // 0.93.a ex 0.81 pt_spare_ext4:double;

  pt_spare_ext3: double;
  pt_spare_ext2: double;
  pt_spare_ext1: double;

  alignment_byte_7: byte;   // D5 0.81 12-06-05
  alignment_byte_8: byte;   // D5 0.81 12-06-05

end;//record

}

{# enum TRailJointCode
---
enum: TRailJointCode
values:
- rjNone
- rjNormal
- rjStaggered
...
}

{# class TPlainTrackInfo
---
class: TPlainTrackInfo
attributes:
- name: customPlainTrack
  type: Boolean
- name: listIndex
  type: Integer
- name: railLength
  type: Double
  comment: rail length in inches.
- name: sleepersPerLength
  type: Integer
  comment: number of sleepers per length.
- name: sleeperCentres
  type: Double
  array: 0..psleep_c
  comment: spacings in inches for custom
- name: railJointsCode
  type: TRailJointCode
- name: userPegRail
  type: Integer
- name: userPegDataValid
  type: Boolean
- name: userPegX
  type: Double
- name: userPegY
  type: Double
- name: userPegK
  type: Double
- name: plainTrackSpacingName
  type: String
- name: plainTrackTimberRollingPercent
  type: Double
- name: gauntSleeperModInches
  type: Double
...
}

type
  //# genEnumDeclarations
  TRailJointCode = (
    rjNone,
    rjNormal,
    rjStaggered
    );

  //# endGenEnumDeclarations

  TPlainTrackInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FCustomPlainTrack: Boolean;
    FListIndex: Integer;
    FRailLength: Double;
    FSleepersPerLength: Integer;
    FSleeperCentres: array[0..psleep_c] of Double;
    FRailJointsCode: TRailJointCode;
    FUserPegRail: Integer;
    FUserPegDataValid: Boolean;
    FUserPegX: Double;
    FUserPegY: Double;
    FUserPegK: Double;
    FPlainTrackSpacingName: String;
    FPlainTrackTimberRollingPercent: Double;
    FGauntSleeperModInches: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetSleeperCentres(AIndex: Integer): Double;
    procedure SetCustomPlainTrack(const AValue: Boolean);
    procedure SetListIndex(const AValue: Integer);
    procedure SetRailLength(const AValue: Double);
    procedure SetSleepersPerLength(const AValue: Integer);
    procedure SetSleeperCentres(AIndex: Integer; const AValue: Double);
    procedure SetRailJointsCode(const AValue: TRailJointCode);
    procedure SetUserPegRail(const AValue: Integer);
    procedure SetUserPegDataValid(const AValue: Boolean);
    procedure SetUserPegX(const AValue: Double);
    procedure SetUserPegY(const AValue: Double);
    procedure SetUserPegK(const AValue: Double);
    procedure SetPlainTrackSpacingName(const AValue: String);
    procedure SetPlainTrackTimberRollingPercent(const AValue: Double);
    procedure SetGauntSleeperModInches(const AValue: Double);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property customPlainTrack: Boolean read FCustomPlainTrack write SetCustomPlainTrack;
    property listIndex: Integer read FListIndex write SetListIndex;

    // rail length in inches.
    property railLength: Double read FRailLength write SetRailLength;

    // number of sleepers per length.
    property sleepersPerLength: Integer read FSleepersPerLength write SetSleepersPerLength;

    // spacings in inches for custom
    property sleeperCentres[AIndex: Integer]: Double read GetSleeperCentres write SetSleeperCentres;
    property railJointsCode: TRailJointCode read FRailJointsCode write SetRailJointsCode;
    property userPegRail: Integer read FUserPegRail write SetUserPegRail;
    property userPegDataValid: Boolean read FUserPegDataValid write SetUserPegDataValid;
    property userPegX: Double read FUserPegX write SetUserPegX;
    property userPegY: Double read FUserPegY write SetUserPegY;
    property userPegK: Double read FUserPegK write SetUserPegK;
    property plainTrackSpacingName: String read FPlainTrackSpacingName write SetPlainTrackSpacingName;
    property plainTrackTimberRollingPercent: Double read FPlainTrackTimberRollingPercent write SetPlainTrackTimberRollingPercent;
    property gauntSleeperModInches: Double read FGauntSleeperModInches write SetGauntSleeperModInches;
    //# endGenProperty
  end;

  TPlainTrackInfoOwningList = class(TOTOwningList<TPlainTrackInfo>);
  TPlainTrackInfoReferenceList = class(TOTReferenceList<TPlainTrackInfo>);

  //# genEnumSerialDeclarations
  function StrToTRailJointCode(AValue: String): TRailJointCode;
  procedure SaveYamlTRailJointCode(AEmitter: TYamlEmitter; const AName: String;
    AValue: TRailJointCode);

  //# endGenEnumSerialDeclarations

implementation

uses
  TypInfo,
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
// GENERATED METHOD - DO NOT EDIT
function StrToTRailJointCode(AValue: String): TRailJointCode;
begin
  Result := TRailJointCode(GetEnumValue(TypeInfo(TRailJointCode), AValue));
end;

// GENERATED METHOD - DO NOT EDIT
procedure SaveYamlTRailJointCode(AEmitter: TYamlEmitter; const AName: String;
  AValue: TRailJointCode);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TRailJointCode), Ord(AValue)));
end;

//# endGenEnumSerialMethods


{ TPlainTrackInfo }

constructor TPlainTrackInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TPlainTrackInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TPlainTrackInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TPlainTrackInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'customPlainTrack' then
    FCustomPlainTrack := StrToBoolean(AValue)
  else
  if AName = 'listIndex' then
    FListIndex := StrToInteger(AValue)
  else
  if AName = 'railLength' then
    FRailLength := StrToDouble(AValue)
  else
  if AName = 'sleepersPerLength' then
    FSleepersPerLength := StrToInteger(AValue)
  else
  if AName = 'sleeperCentres' then
    FSleeperCentres[Integer(Ord(Low(FSleeperCentres))+AIndex)] := StrToDouble(AValue)
  else
  if AName = 'railJointsCode' then
    FRailJointsCode := StrToTRailJointCode(AValue)
  else
  if AName = 'userPegRail' then
    FUserPegRail := StrToInteger(AValue)
  else
  if AName = 'userPegDataValid' then
    FUserPegDataValid := StrToBoolean(AValue)
  else
  if AName = 'userPegX' then
    FUserPegX := StrToDouble(AValue)
  else
  if AName = 'userPegY' then
    FUserPegY := StrToDouble(AValue)
  else
  if AName = 'userPegK' then
    FUserPegK := StrToDouble(AValue)
  else
  if AName = 'plainTrackSpacingName' then
    FPlainTrackSpacingName := StrToString(AValue)
  else
  if AName = 'plainTrackTimberRollingPercent' then
    FPlainTrackTimberRollingPercent := StrToDouble(AValue)
  else
  if AName = 'gauntSleeperModInches' then
    FGauntSleeperModInches := StrToDouble(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TPlainTrackInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FCustomPlainTrack, sizeof(Boolean));
  AStream.ReadBuffer(FListIndex, sizeof(Integer));
  AStream.ReadBuffer(FRailLength, sizeof(Double));
  AStream.ReadBuffer(FSleepersPerLength, sizeof(Integer));
  AStream.ReadBuffer(FSleeperCentres[Low(FSleeperCentres)], (Ord(High(FSleeperCentres))-Ord(Low(FSleeperCentres)) + 1)*sizeof(Double));
  AStream.ReadBuffer(FRailJointsCode, sizeof(TRailJointCode));
  AStream.ReadBuffer(FUserPegRail, sizeof(Integer));
  AStream.ReadBuffer(FUserPegDataValid, sizeof(Boolean));
  AStream.ReadBuffer(FUserPegX, sizeof(Double));
  AStream.ReadBuffer(FUserPegY, sizeof(Double));
  AStream.ReadBuffer(FUserPegK, sizeof(Double));
  FPlainTrackSpacingName := AStream.ReadAnsiString;
  AStream.ReadBuffer(FPlainTrackTimberRollingPercent, sizeof(Double));
  AStream.ReadBuffer(FGauntSleeperModInches, sizeof(Double));
  //# endGenRestoreVars
  end;

procedure TPlainTrackInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FCustomPlainTrack, sizeof(Boolean));
  AStream.WriteBuffer(FListIndex, sizeof(Integer));
  AStream.WriteBuffer(FRailLength, sizeof(Double));
  AStream.WriteBuffer(FSleepersPerLength, sizeof(Integer));
  AStream.WriteBuffer(FSleeperCentres[Low(FSleeperCentres)], (Ord(High(FSleeperCentres))-Ord(Low(FSleeperCentres)) + 1)*sizeof(Double));
  AStream.WriteBuffer(FRailJointsCode, sizeof(TRailJointCode));
  AStream.WriteBuffer(FUserPegRail, sizeof(Integer));
  AStream.WriteBuffer(FUserPegDataValid, sizeof(Boolean));
  AStream.WriteBuffer(FUserPegX, sizeof(Double));
  AStream.WriteBuffer(FUserPegY, sizeof(Double));
  AStream.WriteBuffer(FUserPegK, sizeof(Double));
  AStream.WriteAnsiString(FPlainTrackSpacingName);
  AStream.WriteBuffer(FPlainTrackTimberRollingPercent, sizeof(Double));
  AStream.WriteBuffer(FGauntSleeperModInches, sizeof(Double));
  //# endGenSaveVars
  end;
  
procedure TPlainTrackInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlBoolean(AEmitter, 'customPlainTrack', FCustomPlainTrack);
  SaveYamlInteger(AEmitter, 'listIndex', FListIndex);
  SaveYamlDouble(AEmitter, 'railLength', FRailLength);
  SaveYamlInteger(AEmitter, 'sleepersPerLength', FSleepersPerLength);
  SaveYamlSequence(AEmitter, 'sleeperCentres');
  for i := Ord(Low(FSleeperCentres)) to Ord(High(FSleeperCentres)) do
    SaveYamlSequenceDouble(AEmitter, FSleeperCentres[Integer(i)]);
  SaveYamlEndSequence(AEmitter);
  SaveYamlTRailJointCode(AEmitter, 'railJointsCode', FRailJointsCode);
  SaveYamlInteger(AEmitter, 'userPegRail', FUserPegRail);
  SaveYamlBoolean(AEmitter, 'userPegDataValid', FUserPegDataValid);
  SaveYamlDouble(AEmitter, 'userPegX', FUserPegX);
  SaveYamlDouble(AEmitter, 'userPegY', FUserPegY);
  SaveYamlDouble(AEmitter, 'userPegK', FUserPegK);
  SaveYamlString(AEmitter, 'plainTrackSpacingName', FPlainTrackSpacingName);
  SaveYamlDouble(AEmitter, 'plainTrackTimberRollingPercent', FPlainTrackTimberRollingPercent);
  SaveYamlDouble(AEmitter, 'gauntSleeperModInches', FGauntSleeperModInches);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetCustomPlainTrack(const AValue: Boolean);
begin
  if AValue <> FCustomPlainTrack then begin
    SetModified;
    FCustomPlainTrack := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetListIndex(const AValue: Integer);
begin
  if AValue <> FListIndex then begin
    SetModified;
    FListIndex := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetRailLength(const AValue: Double);
begin
  if AValue <> FRailLength then begin
    SetModified;
    FRailLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetSleepersPerLength(const AValue: Integer);
begin
  if AValue <> FSleepersPerLength then begin
    SetModified;
    FSleepersPerLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TPlainTrackInfo.GetSleeperCentres(AIndex: Integer): Double;
begin
  Result := FSleeperCentres[AIndex];
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetSleeperCentres(AIndex: Integer; const AValue: Double);
begin
  if AValue <> FSleeperCentres[AIndex] then begin
    SetModified;
    FSleeperCentres[AIndex] := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetRailJointsCode(const AValue: TRailJointCode);
begin
  if AValue <> FRailJointsCode then begin
    SetModified;
    FRailJointsCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetUserPegRail(const AValue: Integer);
begin
  if AValue <> FUserPegRail then begin
    SetModified;
    FUserPegRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetUserPegDataValid(const AValue: Boolean);
begin
  if AValue <> FUserPegDataValid then begin
    SetModified;
    FUserPegDataValid := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetUserPegX(const AValue: Double);
begin
  if AValue <> FUserPegX then begin
    SetModified;
    FUserPegX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetUserPegY(const AValue: Double);
begin
  if AValue <> FUserPegY then begin
    SetModified;
    FUserPegY := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetUserPegK(const AValue: Double);
begin
  if AValue <> FUserPegK then begin
    SetModified;
    FUserPegK := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetPlainTrackSpacingName(const AValue: String);
begin
  if AValue <> FPlainTrackSpacingName then begin
    SetModified;
    FPlainTrackSpacingName := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetPlainTrackTimberRollingPercent(const AValue: Double);
begin
  if AValue <> FPlainTrackTimberRollingPercent then begin
    SetModified;
    FPlainTrackTimberRollingPercent := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlainTrackInfo.SetGauntSleeperModInches(const AValue: Double);
begin
  if AValue <> FGauntSleeperModInches then begin
    SetModified;
    FGauntSleeperModInches := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TPlainTrackInfo.RegisterClass;
  TPlainTrackInfoOwningList.RegisterClass;
  TPlainTrackInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TPlainTrackInfo');
end.
