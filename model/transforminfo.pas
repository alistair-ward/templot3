unit TransformInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  point_ex,
  NotchInfo;

{
Ttransform_info = record             //  datums, shifts and rotations ...
  //  (yes I know the plural of datum is data !)

(/)  datum_y: double;  // y_datum, y datum point (green dot).

(x)  x_go_limit: double;  // (nyi) print cropping limits (paper inches)...
(x)  x_stop_limit: double;

(x)  transforms_apply: boolean; // !!! no longer used.  // False = ignore transform data.

(x)  alignment_byte_1: byte;   // D5 0.81 12-06-05

(/)  x1_shift: double;  //  mm    shift info...
(/)  y1_shift: double;  //  mm
(/)  k_shift: double;  //  radians.
(/)  x2_shift: double;  //  mm
(/)  y2_shift: double;  //  mm

(/)  peg_pos: Tpex;      //  mm  peg position.

(x)  alignment_byte_2: byte;   // D5 0.81 12-06-05
(x)  alignment_byte_3: byte;   // D5 0.81 12-06-05

(/)  peg_point_code: integer;   //  peg_code.
(/)  peg_point_rail: integer;   //  peg_rail.

(/)  mirror_on_x: boolean;   //  True= invert on x.
(/)  mirror_on_y: boolean;   //  True= invert on y. (swap hand).

  (x)  alignment_byte_4: byte;   // D5 0.81 12-06-05
  (x)  alignment_byte_5: byte;   // D5 0.81 12-06-05

  (x)  spare_int1: integer;
  (x)  spare_int2: integer;

  (x)  spare_flag1: boolean;
  (x)  spare_flag2: boolean;
  (x)  spare_flag3: boolean;
  (x)  spare_flag4: boolean;

(/)  notch_info: Tnotch;

  //spare_float1:double;    // 11-4-00 version 0.53
  //spare_float2:double;
  //spare_float3:double;

  (x)  spare_str: string[10];

  (x)  alignment_byte_6: byte;   // D5 0.81 12-06-05
  (x)  alignment_byte_7: byte;   // D5 0.81 12-06-05
  (x)  alignment_byte_8: byte;   // D5 0.81 12-06-05

end;//record
}

{# class TTransformInfo
---
class: TTransformInfo
attributes:
- name: datumY
  type: Double
  comment: y_datum, y datum point (green dot).
- name: x1Shift
  type: Double
  comment:  mm    shift info...
- name: y1Shift
  type: Double
  comment: mm
- name: kShift
  type: Double
  comment: radians.
- name: x2Shift
  type: Double
  comment: mm
- name: y2Shift
  type: Double
  comment: mm
- name: pegPos
  type: Tpex
  comment: mm  peg position.
- name: pegPointCode
  type: Integer
  comment: peg code - TODO change to enum
- name: pegPointRail
  type: Integer
  comment: peg rail - TODO change to enum
- name: mirrorOnX
  type: Boolean
- name: mirrorOnY
  type: Boolean
- name: notchInfo
  type: TNotchInfo
  owns: create
  access: [get]
...
}

type

  TTransformInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FDatumY: Double;
    FX1Shift: Double;
    FY1Shift: Double;
    FKShift: Double;
    FX2Shift: Double;
    FY2Shift: Double;
    FPegPos: Tpex;
    FPegPointCode: Integer;
    FPegPointRail: Integer;
    FMirrorOnX: Boolean;
    FMirrorOnY: Boolean;
    FNotchInfo: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetNotchInfo: TNotchInfo;
    procedure SetDatumY(const AValue: Double);
    procedure SetX1Shift(const AValue: Double);
    procedure SetY1Shift(const AValue: Double);
    procedure SetKShift(const AValue: Double);
    procedure SetX2Shift(const AValue: Double);
    procedure SetY2Shift(const AValue: Double);
    procedure SetPegPos(const AValue: Tpex);
    procedure SetPegPointCode(const AValue: Integer);
    procedure SetPegPointRail(const AValue: Integer);
    procedure SetMirrorOnX(const AValue: Boolean);
    procedure SetMirrorOnY(const AValue: Boolean);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty

    // y_datum, y datum point (green dot).
    property datumY: Double read FDatumY write SetDatumY;

    // mm    shift info...
    property x1Shift: Double read FX1Shift write SetX1Shift;

    // mm
    property y1Shift: Double read FY1Shift write SetY1Shift;

    // radians.
    property kShift: Double read FKShift write SetKShift;

    // mm
    property x2Shift: Double read FX2Shift write SetX2Shift;

    // mm
    property y2Shift: Double read FY2Shift write SetY2Shift;

    // mm  peg position.
    property pegPos: Tpex read FPegPos write SetPegPos;

    // peg code - TODO change to enum
    property pegPointCode: Integer read FPegPointCode write SetPegPointCode;

    // peg rail - TODO change to enum
    property pegPointRail: Integer read FPegPointRail write SetPegPointRail;
    property mirrorOnX: Boolean read FMirrorOnX write SetMirrorOnX;
    property mirrorOnY: Boolean read FMirrorOnY write SetMirrorOnY;
    property notchInfo: TNotchInfo read GetNotchInfo;
    //# endGenProperty
  end;

  TTransformInfoOwningList = class(TOTOwningList<TTransformInfo>);
  TTransformInfoReferenceList = class(TOTReferenceList<TTransformInfo>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TTransformInfo }

constructor TTransformInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FNotchInfo := TNotchInfo.Create(nil).oid
  else
    FNotchInfo := 0;
  //# endGenCreate
end;

destructor TTransformInfo.Destroy;
begin
  //# genDestroy
  SetOwned(FNotchInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTransformInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TTransformInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'datumY' then
    FDatumY := StrToDouble(AValue)
  else
  if AName = 'x1Shift' then
    FX1Shift := StrToDouble(AValue)
  else
  if AName = 'y1Shift' then
    FY1Shift := StrToDouble(AValue)
  else
  if AName = 'kShift' then
    FKShift := StrToDouble(AValue)
  else
  if AName = 'x2Shift' then
    FX2Shift := StrToDouble(AValue)
  else
  if AName = 'y2Shift' then
    FY2Shift := StrToDouble(AValue)
  else
  if AName = 'pegPos' then
    FPegPos := StrToTpex(AValue)
  else
  if AName = 'pegPointCode' then
    FPegPointCode := StrToInteger(AValue)
  else
  if AName = 'pegPointRail' then
    FPegPointRail := StrToInteger(AValue)
  else
  if AName = 'mirrorOnX' then
    FMirrorOnX := StrToBoolean(AValue)
  else
  if AName = 'mirrorOnY' then
    FMirrorOnY := StrToBoolean(AValue)
  else
  if AName = 'notchInfo' then
    RestoreYamlObjectOwn(FNotchInfo, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTransformInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FDatumY, sizeof(Double));
  AStream.ReadBuffer(FX1Shift, sizeof(Double));
  AStream.ReadBuffer(FY1Shift, sizeof(Double));
  AStream.ReadBuffer(FKShift, sizeof(Double));
  AStream.ReadBuffer(FX2Shift, sizeof(Double));
  AStream.ReadBuffer(FY2Shift, sizeof(Double));
  AStream.ReadBuffer(FPegPos, sizeof(Tpex));
  AStream.ReadBuffer(FPegPointCode, sizeof(Integer));
  AStream.ReadBuffer(FPegPointRail, sizeof(Integer));
  AStream.ReadBuffer(FMirrorOnX, sizeof(Boolean));
  AStream.ReadBuffer(FMirrorOnY, sizeof(Boolean));
  AStream.ReadBuffer(FNotchInfo, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TTransformInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FDatumY, sizeof(Double));
  AStream.WriteBuffer(FX1Shift, sizeof(Double));
  AStream.WriteBuffer(FY1Shift, sizeof(Double));
  AStream.WriteBuffer(FKShift, sizeof(Double));
  AStream.WriteBuffer(FX2Shift, sizeof(Double));
  AStream.WriteBuffer(FY2Shift, sizeof(Double));
  AStream.WriteBuffer(FPegPos, sizeof(Tpex));
  AStream.WriteBuffer(FPegPointCode, sizeof(Integer));
  AStream.WriteBuffer(FPegPointRail, sizeof(Integer));
  AStream.WriteBuffer(FMirrorOnX, sizeof(Boolean));
  AStream.WriteBuffer(FMirrorOnY, sizeof(Boolean));
  AStream.WriteBuffer(FNotchInfo, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TTransformInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlDouble(AEmitter, 'datumY', FDatumY);
  SaveYamlDouble(AEmitter, 'x1Shift', FX1Shift);
  SaveYamlDouble(AEmitter, 'y1Shift', FY1Shift);
  SaveYamlDouble(AEmitter, 'kShift', FKShift);
  SaveYamlDouble(AEmitter, 'x2Shift', FX2Shift);
  SaveYamlDouble(AEmitter, 'y2Shift', FY2Shift);
  SaveYamlTpex(AEmitter, 'pegPos', FPegPos);
  SaveYamlInteger(AEmitter, 'pegPointCode', FPegPointCode);
  SaveYamlInteger(AEmitter, 'pegPointRail', FPegPointRail);
  SaveYamlBoolean(AEmitter, 'mirrorOnX', FMirrorOnX);
  SaveYamlBoolean(AEmitter, 'mirrorOnY', FMirrorOnY);
  SaveYamlObject(AEmitter, 'notchInfo', FNotchInfo);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetDatumY(const AValue: Double);
begin
  if AValue <> FDatumY then begin
    SetModified;
    FDatumY := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetX1Shift(const AValue: Double);
begin
  if AValue <> FX1Shift then begin
    SetModified;
    FX1Shift := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetY1Shift(const AValue: Double);
begin
  if AValue <> FY1Shift then begin
    SetModified;
    FY1Shift := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetKShift(const AValue: Double);
begin
  if AValue <> FKShift then begin
    SetModified;
    FKShift := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetX2Shift(const AValue: Double);
begin
  if AValue <> FX2Shift then begin
    SetModified;
    FX2Shift := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetY2Shift(const AValue: Double);
begin
  if AValue <> FY2Shift then begin
    SetModified;
    FY2Shift := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetPegPos(const AValue: Tpex);
begin
  if AValue <> FPegPos then begin
    SetModified;
    FPegPos := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetPegPointCode(const AValue: Integer);
begin
  if AValue <> FPegPointCode then begin
    SetModified;
    FPegPointCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetPegPointRail(const AValue: Integer);
begin
  if AValue <> FPegPointRail then begin
    SetModified;
    FPegPointRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetMirrorOnX(const AValue: Boolean);
begin
  if AValue <> FMirrorOnX then begin
    SetModified;
    FMirrorOnX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTransformInfo.SetMirrorOnY(const AValue: Boolean);
begin
  if AValue <> FMirrorOnY then begin
    SetModified;
    FMirrorOnY := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TTransformInfo.GetNotchInfo: TNotchInfo;
begin
  Result := TNotchInfo(FromOID(FNotchInfo));
end;

//# endGenGetSetMethods

initialization
  TTransformInfo.RegisterClass;
  TTransformInfoOwningList.RegisterClass;
  TTransformInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTransformInfo');
end.
