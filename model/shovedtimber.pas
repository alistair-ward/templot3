unit ShovedTimber;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{# class TShovedTimber
---
class: TShovedTimber
attributes:
  - name: timberString
    type: String
  - name: shoveCode
    type: TShoveCode
  - name: xtbModifier
    type: Double
    extraSetCode: FShoveCode := svcShove;
  - name: angleModifier
    type: Double
    extraSetCode: FShoveCode := svcShove;
  - name: offsetModifier
    type: Double
    extraSetCode: FShoveCode := svcShove;
  - name: lengthModifier
    type: Double
    extraSetCode: FShoveCode := svcShove;
  - name: widthModifier
    type: Double
    extraSetCode: FShoveCode := svcShove;
  - name: crabModifier
    type: Double
    extraSetCode: FShoveCode := svcShove;
...
}

type
  TShoveCode = (svcOmit = -1, svcEmpty = 0, svcShove = 1);

  TShovedTimber = class(TOTPersistent)
  private
    //# genMemberVars
    FTimberString: String;
    FShoveCode: TShoveCode;
    FXtbModifier: Double;
    FAngleModifier: Double;
    FOffsetModifier: Double;
    FLengthModifier: Double;
    FWidthModifier: Double;
    FCrabModifier: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    procedure SetTimberString(const AValue: String);
    procedure SetShoveCode(const AValue: TShoveCode);
    procedure SetXtbModifier(const AValue: Double);
    procedure SetAngleModifier(const AValue: Double);
    procedure SetOffsetModifier(const AValue: Double);
    procedure SetLengthModifier(const AValue: Double);
    procedure SetWidthModifier(const AValue: Double);
    procedure SetCrabModifier(const AValue: Double);
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
    property timberString: String Read FTimberString Write SetTimberString;
    property shoveCode: TShoveCode Read FShoveCode Write SetShoveCode;
    property xtbModifier: Double Read FXtbModifier Write SetXtbModifier;
    property angleModifier: Double Read FAngleModifier Write SetAngleModifier;
    property offsetModifier: Double Read FOffsetModifier Write SetOffsetModifier;
    property lengthModifier: Double Read FLengthModifier Write SetLengthModifier;
    property widthModifier: Double Read FWidthModifier Write SetWidthModifier;
    property crabModifier: Double Read FCrabModifier Write SetCrabModifier;
    //# endGenProperty

    function StrToTShoveCode(AValue: String): TShoveCode;
    procedure SaveYamlTShoveCode(AEmitter: TYamlEmitter; const AName: String; AValue: TShoveCode);

    procedure MakeShoved;
    procedure MakeOmit;

    procedure AdjustXtb(adjustment: double);
    procedure AdjustWidth(adjustment: double);
    procedure AdjustOffset(adjustment: double);
    procedure AdjustLength(adjustment: double);
    procedure AdjustAngle(adjustment: double);
    procedure AdjustCrab(adjustment: double);
    procedure Rescale(scaleRatio: double);
    function CanRestore: boolean;

    class function CreateFrom(AParent: TOTPersistent; AFrom: TShovedTimber): TShovedTimber;
  end;

  TShovedTimberOwningList = class(TOTOwningList<TShovedTimber>)
  public
    procedure CopyFrom(AFrom: TShovedTimberOwningList);
  end;

  TShovedTimberReferenceList = class(TOTReferenceList<TShovedTimber>);


implementation

uses
  TLoggerUnit,
  typinfo;

var
  log: ILogger;


{ TShovedTimber }

constructor TShovedTimber.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TShovedTimber.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TShovedTimber.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TShovedTimber.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'timberString' then
    FTimberString := StrToString(AValue)
  else
  if AName = 'shoveCode' then
    FShoveCode := StrToTShoveCode(AValue)
  else
  if AName = 'xtbModifier' then
    FXtbModifier := StrToDouble(AValue)
  else
  if AName = 'angleModifier' then
    FAngleModifier := StrToDouble(AValue)
  else
  if AName = 'offsetModifier' then
    FOffsetModifier := StrToDouble(AValue)
  else
  if AName = 'lengthModifier' then
    FLengthModifier := StrToDouble(AValue)
  else
  if AName = 'widthModifier' then
    FWidthModifier := StrToDouble(AValue)
  else
  if AName = 'crabModifier' then
    FCrabModifier := StrToDouble(AValue)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TShovedTimber.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  FTimberString := AStream.ReadAnsiString;
  AStream.ReadBuffer(FShoveCode, sizeof(TShoveCode));
  AStream.ReadBuffer(FXtbModifier, sizeof(Double));
  AStream.ReadBuffer(FAngleModifier, sizeof(Double));
  AStream.ReadBuffer(FOffsetModifier, sizeof(Double));
  AStream.ReadBuffer(FLengthModifier, sizeof(Double));
  AStream.ReadBuffer(FWidthModifier, sizeof(Double));
  AStream.ReadBuffer(FCrabModifier, sizeof(Double));
  //# endGenRestoreVars
end;

procedure TShovedTimber.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteAnsiString(FTimberString);
  AStream.WriteBuffer(FShoveCode, sizeof(TShoveCode));
  AStream.WriteBuffer(FXtbModifier, sizeof(Double));
  AStream.WriteBuffer(FAngleModifier, sizeof(Double));
  AStream.WriteBuffer(FOffsetModifier, sizeof(Double));
  AStream.WriteBuffer(FLengthModifier, sizeof(Double));
  AStream.WriteBuffer(FWidthModifier, sizeof(Double));
  AStream.WriteBuffer(FCrabModifier, sizeof(Double));
  //# endGenSaveVars
end;

procedure TShovedTimber.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlString(AEmitter, 'timberString', FTimberString);
  SaveYamlTShoveCode(AEmitter, 'shoveCode', FShoveCode);
  SaveYamlDouble(AEmitter, 'xtbModifier', FXtbModifier);
  SaveYamlDouble(AEmitter, 'angleModifier', FAngleModifier);
  SaveYamlDouble(AEmitter, 'offsetModifier', FOffsetModifier);
  SaveYamlDouble(AEmitter, 'lengthModifier', FLengthModifier);
  SaveYamlDouble(AEmitter, 'widthModifier', FWidthModifier);
  SaveYamlDouble(AEmitter, 'crabModifier', FCrabModifier);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetTimberString(const AValue: String);
begin
  if AValue <> FTimberString then begin
    SetModified;
    FTimberString := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetShoveCode(const AValue: TShoveCode);
begin
  if AValue <> FShoveCode then begin
    SetModified;
    FShoveCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetXtbModifier(const AValue: Double);
begin
  if AValue <> FXtbModifier then begin
    SetModified;
    FXtbModifier := AValue;
    FShoveCode := svcShove;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetAngleModifier(const AValue: Double);
begin
  if AValue <> FAngleModifier then begin
    SetModified;
    FAngleModifier := AValue;
    FShoveCode := svcShove;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetOffsetModifier(const AValue: Double);
begin
  if AValue <> FOffsetModifier then begin
    SetModified;
    FOffsetModifier := AValue;
    FShoveCode := svcShove;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetLengthModifier(const AValue: Double);
begin
  if AValue <> FLengthModifier then begin
    SetModified;
    FLengthModifier := AValue;
    FShoveCode := svcShove;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetWidthModifier(const AValue: Double);
begin
  if AValue <> FWidthModifier then begin
    SetModified;
    FWidthModifier := AValue;
    FShoveCode := svcShove;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TShovedTimber.SetCrabModifier(const AValue: Double);
begin
  if AValue <> FCrabModifier then begin
    SetModified;
    FCrabModifier := AValue;
    FShoveCode := svcShove;
  end;
end;

//# endGenGetSetMethods

function TShovedTimber.StrToTShoveCode(AValue: String): TShoveCode;
begin
  Result := TShoveCode(GetEnumValue(TypeInfo(TShoveCode), AValue));
end;

procedure TShovedTimber.SaveYamlTShoveCode(AEmitter: TYamlEmitter; const AName: String;
  AValue: TShoveCode);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TShoveCode), Ord(AValue)));
end;


procedure TShovedTimber.MakeShoved;
begin
  if FShoveCode = svcEmpty then begin
    SetModified;
    FShoveCode := svcShove;
  end;
end;

procedure TShovedTimber.MakeOmit;
begin
  SetModified;
  FShoveCode := svcOmit;
  FXtbModifier := 0;        // xtb modifier.
  FAngleModifier := 0;        // angle modifier.
  FOffsetModifier := 0;        // offset modifier (near end).
  FLengthModifier := 0;        // length modifier (far end).
  FWidthModifier := 0;        // width modifier (per side).
  FCrabModifier := 0;        // crab modifier.
end;


procedure TShovedTimber.AdjustXtb(adjustment: double);
begin
  SetModified;
  FShoveCode := svcShove;
  FXtbModifier := FXtbModifier + adjustment;
end;

procedure TShovedTimber.AdjustWidth(adjustment: double);
begin
  SetModified;
  FShoveCode := svcShove;
  FWidthModifier := FWidthModifier + adjustment;
end;

procedure TShovedTimber.AdjustOffset(adjustment: double);
begin
  SetModified;
  FShoveCode := svcShove;
  FOffsetModifier := FOffsetModifier + adjustment;
end;

procedure TShovedTimber.AdjustLength(adjustment: double);
begin
  SetModified;
  FShoveCode := svcShove;
  FLengthModifier := FLengthModifier + adjustment;
end;

procedure TShovedTimber.AdjustAngle(adjustment: double);
begin
  SetModified;
  FShoveCode := svcShove;
  FAngleModifier := FAngleModifier + adjustment;
end;

procedure TShovedTimber.AdjustCrab(adjustment: double);
begin
  SetModified;
  FShoveCode := svcShove;
  FCrabModifier := FCrabModifier + adjustment;
end;

procedure TShovedTimber.Rescale(scaleRatio: double);
begin
  SetModified;
  FXtbModifier := FXtbModifier * scaleRatio;
  // angle modifier (no change).
  FOffsetModifier := FOffsetModifier * scaleRatio;
  FLengthModifier := FLengthModifier * scaleRatio;
  FWidthModifier := FWidthModifier * scaleRatio;
  FCrabModifier := FCrabModifier * scaleRatio;
end;

function TShovedTimber.CanRestore: boolean;
begin
  Result := (FShoveCode = svcOmit) or
    (((FXtbModifier <> 0)       // xtb modifier.
    or (FAngleModifier <> 0)       // angle modifier.
    or (FOffsetModifier <> 0)       // offset modifier (near end).
    or (FLengthModifier <> 0)       // length modifier (far end).
    or (FWidthModifier <> 0)       // width modifier (per side).
    or (FCrabModifier <> 0)       // crab modifier.  0.78.c  01-02-03.

    ) and (FShoveCode = svcShove));
end;

class function TShovedTimber.CreateFrom(AParent: TOTPersistent; AFrom: TShovedTimber): TShovedTimber;

begin
  Result := TShovedTimber.Create(AParent);
  Result.timberString := AFrom.timberString;
  Result.shoveCode := AFrom.shoveCode;
  Result.xtbModifier := AFrom.xtbModifier;
  Result.angleModifier := AFrom.angleModifier;
  Result.offsetModifier := AFrom.offsetModifier;
  Result.lengthModifier := AFrom.lengthModifier;
  Result.widthModifier := AFrom.widthModifier;
  Result.crabModifier := AFrom.crabModifier;
end;

procedure TShovedTimberOwningList.CopyFrom(AFrom: TShovedTimberOwningList);
var
  f: TShovedTimber;
  t: TShovedTimber;
begin
  Clear;

  if not Assigned(AFrom) then
    EXIT;  // return empty list.

  for f in AFrom do begin
    t := TShovedTimber.CreateFrom(nil, f);
    Add(t);
  end;//next
end;



initialization
  TShovedTimber.RegisterClass;
  TShovedTimberOwningList.RegisterClass;
  TShovedTimberReferenceList.RegisterClass;

  //log := Logger.GetInstance('TShovedTimber');
end.
