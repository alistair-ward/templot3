unit Timbers;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Generics.Collections,
  Timber,
  ShovedTimber,
  Curve,
  curve_interface,
  TurnoutInfo1,
  ProtoInfo,
  PlainTrackInfo,
  Feature;


{# class TTimbers
---
class: TTimbers
attributes:
- name: shovedTimbers
  type: TShovedTimberOwningList
  owns: create
  access: [get]
- name: curve
  type: TCurve
  owns: ref
- name: turnoutInfo
  type: TTurnoutInfo1
  owns: ref
- name: protoInfo
  type: TProtoInfo
  owns: ref
- name: plainTrackInfo
  type: TPlainTrackInfo
  owns: ref
...
}

type

  //# genEnumDeclarations
  //# endGenEnumDeclarations


  {
    TTimbers represents all the sleepers in the template, most
    of which will be generated automatically.

    shovedTimbers are those sleepers that have been manually
    edited. These will remain persistent in the template even
    if the length of the template is reduced such that the
    shoved timber is no longer visible.
  }
  TTimbers = class(TOTPersistent)
  private
    //# genMemberVars
    FShovedTimbers: TOID;
    FCurve: TOID;
    FTurnoutInfo: TOID;
    FProtoInfo: TOID;
    FPlainTrackInfo: TOID;
    //# endGenMemberVars

    FTimbers: TObjectList<TTimber>;

    function GetTimberCount: Integer;
    function GetTimber(idx: Integer): TTimber;

    procedure DoPlainSleepers(AStartX, AEndX: Double; AApproachOrExit: TApproachOrExit);

    procedure SetupDefaultTimbers;
    procedure ApplyShovedTimbers;
    procedure CalculateTimbers;

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    function GetShovedTimbers: TShovedTimberOwningList;
    function GetCurve: TCurve;
    function GetTurnoutInfo: TTurnoutInfo1;
    function GetProtoInfo: TProtoInfo;
    function GetPlainTrackInfo: TPlainTrackInfo;
    procedure SetCurve(const AValue: TCurve);
    procedure SetTurnoutInfo(const AValue: TTurnoutInfo1);
    procedure SetProtoInfo(const AValue: TProtoInfo);
    procedure SetPlainTrackInfo(const AValue: TPlainTrackInfo);
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
    property shovedTimbers: TShovedTimberOwningList Read GetShovedTimbers;
    property curve: TCurve Read GetCurve Write SetCurve;
    property turnoutInfo: TTurnoutInfo1 Read GetTurnoutInfo Write SetTurnoutInfo;
    property protoInfo: TProtoInfo Read GetProtoInfo Write SetProtoInfo;
    property plainTrackInfo: TPlainTrackInfo Read GetPlainTrackInfo Write SetPlainTrackInfo;
    //# endGenProperty

    property timberCount: Integer Read GetTimberCount;
    property timber[idx: Integer]: TTimber Read GetTimber;
  end;

  TTimbersOwningList = class(TOTOwningList<TTimbers>);
  TTimbersReferenceList = class(TOTReferenceList<TTimbers>);

  //# genEnumSerialDeclarations
  //# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log: ILogger;

  //# genEnumSerialMethods
  //# endGenEnumSerialMethods

  { TTimbers }

constructor TTimbers.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FShovedTimbers := TShovedTimberOwningList.Create(nil).oid
  else
    FShovedTimbers := 0;
  FCurve := 0;
  FTurnoutInfo := 0;
  FProtoInfo := 0;
  FPlainTrackInfo := 0;
  //# endGenCreate

  FTimbers := TObjectList<TTimber>.Create;
end;

destructor TTimbers.Destroy;
begin
  //# genDestroy
  SetOwned(FShovedTimbers, nil);
  SetReference(FCurve, nil);
  SetReference(FTurnoutInfo, nil);
  SetReference(FProtoInfo, nil);
  SetReference(FPlainTrackInfo, nil);
  //# endGenDestroy

  FTimbers.Free;

  inherited;
end;


procedure TTimbers.DoPlainSleepers(AStartX, AEndX: Double; AApproachOrExit: TApproachOrExit);
var
  pti: TPlainTrackInfo;
  i: Integer;
  isJointSleeper: Boolean;
  x: Double;
  direction: Double;
  inchScale: Double;
  sleeperCount: Integer;
  sleeperPrefix: Char;
  sleeperLabel: String;
  sleeperWidth: Double;
  sleeperLength: Double;
  mainsideOffset: Double;
  railLength: Double;
  railStartX: Double;
const
  centrelineExtraLengthInches = 12;
begin
  pti := plainTrackInfo;
  inchScale := protoInfo.inchScale;

  if AApproachOrExit = aeApproach then begin
    direction := -1;
    sleeperPrefix := 'A';
  end
  else begin
    direction := 1;
    sleeperPrefix := 'X';
  end;

  railLength := pti.railLengthInches * inchScale;
  sleeperCount := 1;
  i := 0;
  railStartX := AStartX;
  x := AStartX + pti.sleeperCentresInches[i] * inchScale * direction;
  while True do begin
    // loop condition check
    if AApproachOrExit = aeApproach then begin
      // working backwards
      if x < AEndX then
        break;
    end
    else begin
      // going forwards
      if x > AEndX then
        break;
    end;

    isJointSleeper := (i = 0) or (i = pti.sleeperCentresInchesCount - 1);

    sleeperLabel := sleeperPrefix + IntToStr(sleeperCount);

    if isJointSleeper then
       sleeperWidth := protoInfo.sleeperWidthAtRailJointInches * inchScale
    else
        sleeperWidth := protoInfo.sleeperWidthInches * inchScale;

    sleeperLength := protoInfo.sleeperLength;
    mainsideOffset := -sleeperLength / 2;

    FTimbers.Add(TTimber.Create(sleeperLabel, x, sleeperWidth, sleeperLength, mainsideOffset, centrelineExtraLengthInches * inchScale));

    sleeperCount := sleeperCount + 1;
    i := i + 1;
    if i = pti.sleeperCentresInchesCount then begin
      railStartX := railStartX + railLength * direction;
      i := 0;
      x := railStartX;
    end;
    x := x + pti.sleeperCentresInches[i] * inchScale * direction;
  end;

end;

procedure TTimbers.SetupDefaultTimbers;
var
  handMultiplier: Double;
begin
  // Plain track
  // treat the whole length as approach track...
  //
  // Approach Track
  // Marks are applied from the turnout point *backwards* to the start
  // of the template
  //
  // Exit Track
  // Marks are applied from the end of the turnout *fowards* to the end
  // of the template
  //

  DoPlainSleepers(turnoutInfo.originToToe, 0, aeApproach);
end;

procedure TTimbers.ApplyShovedTimbers;
begin

end;

procedure TTimbers.CalculateTimbers;
var
  i: Integer;
begin
  for i := 0 to FTimbers.Count - 1 do begin
    FTimbers[i].Calculate(curve, TurnoutHandMultiplier(turnoutInfo.hand));
  end;
end;

procedure TTimbers.Calculate;
begin
  inherited;

  // Add your calculation code here, and cache the results...
  FTimbers.Clear;

  SetupDefaultTimbers;
  ApplyShovedTimbers;
  CalculateTimbers;
end;

procedure TTimbers.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'shovedTimbers' then
    RestoreYamlObjectOwn(FShovedTimbers, StrToInteger(AValue), ALoader)
  else
  if AName = 'curve' then
    RestoreYamlObjectRef(FCurve, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutInfo' then
    RestoreYamlObjectRef(FTurnoutInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'protoInfo' then
    RestoreYamlObjectRef(FProtoInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'plainTrackInfo' then
    RestoreYamlObjectRef(FPlainTrackInfo, StrToInteger(AValue), ALoader)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTimbers.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FShovedTimbers, sizeof(TOID));
  AStream.ReadBuffer(FCurve, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutInfo, sizeof(TOID));
  AStream.ReadBuffer(FProtoInfo, sizeof(TOID));
  AStream.ReadBuffer(FPlainTrackInfo, sizeof(TOID));
  //# endGenRestoreVars
end;

procedure TTimbers.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FShovedTimbers, sizeof(TOID));
  AStream.WriteBuffer(FCurve, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutInfo, sizeof(TOID));
  AStream.WriteBuffer(FProtoInfo, sizeof(TOID));
  AStream.WriteBuffer(FPlainTrackInfo, sizeof(TOID));
  //# endGenSaveVars
end;

procedure TTimbers.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlObject(AEmitter, 'shovedTimbers', FShovedTimbers);
  SaveYamlObjectReference(AEmitter, 'curve', FCurve);
  SaveYamlObjectReference(AEmitter, 'turnoutInfo', FTurnoutInfo);
  SaveYamlObjectReference(AEmitter, 'protoInfo', FProtoInfo);
  SaveYamlObjectReference(AEmitter, 'plainTrackInfo', FPlainTrackInfo);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TTimbers.GetShovedTimbers: TShovedTimberOwningList;
begin
  Result := TShovedTimberOwningList(FromOID(FShovedTimbers));
end;

// GENERATED METHOD - DO NOT EDIT
function TTimbers.GetCurve: TCurve;
begin
  Result := TCurve(FromOID(FCurve));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTimbers.SetCurve(const AValue: TCurve);
begin
  SetReference(FCurve, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TTimbers.GetTurnoutInfo: TTurnoutInfo1;
begin
  Result := TTurnoutInfo1(FromOID(FTurnoutInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTimbers.SetTurnoutInfo(const AValue: TTurnoutInfo1);
begin
  SetReference(FTurnoutInfo, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TTimbers.GetProtoInfo: TProtoInfo;
begin
  Result := TProtoInfo(FromOID(FProtoInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTimbers.SetProtoInfo(const AValue: TProtoInfo);
begin
  SetReference(FProtoInfo, AValue);
end;

// GENERATED METHOD - DO NOT EDIT
function TTimbers.GetPlainTrackInfo: TPlainTrackInfo;
begin
  Result := TPlainTrackInfo(FromOID(FPlainTrackInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTimbers.SetPlainTrackInfo(const AValue: TPlainTrackInfo);
begin
  SetReference(FPlainTrackInfo, AValue);
end;

//# endGenGetSetMethods

function TTimbers.GetTimberCount: Integer;
begin
  CheckCalculated;
  Result := FTimbers.Count;
end;

function TTimbers.GetTimber(idx: Integer): TTimber;
begin
  CheckCalculated;
  Result := FTimbers[idx];
end;

initialization
  TTimbers.RegisterClass;
  TTimbersOwningList.RegisterClass;
  TTimbersReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTimbers');
end.
