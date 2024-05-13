unit NotchInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{# class TNotchInfo
---
class: TNotchInfo
attributes:
- name: x
  type: Double
- name: y
  type: Double
- name: k
  type: Double
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  // old Tnotch record, moved here temporarily...
  Tnotch = record      //  a notch position.
    notch_x: double;
    notch_y: double;
    notch_k: double;
  end;


  TNotchInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FX: Double;
    FY: Double;
    FK: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    procedure SetX(const AValue: Double);
    procedure SetY(const AValue: Double);
    procedure SetK(const AValue: Double);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
      ALoader: TOTPersistentLoader); override;
    procedure SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    procedure SetNotch(const ANotch: Tnotch);
    function ToNotch: Tnotch;

    //# genProperty
    property x: Double Read FX Write SetX;
    property y: Double Read FY Write SetY;
    property k: Double Read FK Write SetK;
    //# endGenProperty
  end;

  TNotchInfoOwningList = class(TOTOwningList<TNotchInfo>);
  TNotchInfoReferenceList = class(TOTReferenceList<TNotchInfo>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log: ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TNotchInfo }

constructor TNotchInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TNotchInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TNotchInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TNotchInfo.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'x' then
    FX := StrToDouble(AValue)
  else
  if AName = 'y' then
    FY := StrToDouble(AValue)
  else
  if AName = 'k' then
    FK := StrToDouble(AValue)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TNotchInfo.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FX, sizeof(Double));
  AStream.ReadBuffer(FY, sizeof(Double));
  AStream.ReadBuffer(FK, sizeof(Double));
  //# endGenRestoreVars
end;

procedure TNotchInfo.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FX, sizeof(Double));
  AStream.WriteBuffer(FY, sizeof(Double));
  AStream.WriteBuffer(FK, sizeof(Double));
  //# endGenSaveVars
end;

procedure TNotchInfo.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlDouble(AEmitter, 'x', FX);
  SaveYamlDouble(AEmitter, 'y', FY);
  SaveYamlDouble(AEmitter, 'k', FK);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TNotchInfo.SetX(const AValue: Double);
begin
  if AValue <> FX then begin
    SetModified;
    FX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TNotchInfo.SetY(const AValue: Double);
begin
  if AValue <> FY then begin
    SetModified;
    FY := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TNotchInfo.SetK(const AValue: Double);
begin
  if AValue <> FK then begin
    SetModified;
    FK := AValue;
  end;
end;

//# endGenGetSetMethods

procedure TNotchInfo.SetNotch(const ANotch: Tnotch);
begin
  x := ANotch.notch_x;
  y := ANotch.notch_y;
  k := ANotch.notch_k;
end;

function TNotchInfo.ToNotch: Tnotch;
begin
  Result.notch_x := x;
  Result.notch_y := y;
  Result.notch_k := k;
end;

initialization
  TNotchInfo.RegisterClass;
  TNotchInfoOwningList.RegisterClass;
  TNotchInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TNotchInfo');
end.
