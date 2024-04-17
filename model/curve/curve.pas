unit Curve;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  point_ex,
  curve_calculator,
  curve_parameters_interface;


{# class TCurve
---
class: TCurve
attributes:
  - name: fixedRadius
    type: Double
  - name: transitionStartRadius
    type: Double
  - name: transitionEndRadius
    type: Double
  - name: distanceToTransition
    type: Double
  - name: transitionLength
    type: Double
  - name: isSpiral
    type: Boolean
  - name: isSlewing
    type: Boolean
  - name: distanceToStartOfSlew
    type: Double
  - name: slewLength
    type: Double
  - name: slewAmount
    type: Double
  - name: slewMode
    type: ESlewMode
  - name: slewFactor
    type: Double
...
}

const
  maximum_segment_length = 1e100;

  // the maximum value for a radius (approx 62 miles rad)
  // this dimension is in millimetres, and is independent of any scale settings
  // in openTemplot
  //
  // note: this is untyped, so the following typed consts will compile...
  maximum_radius_value = 1e08;

  // typed constant - maximum value for a radius.
  max_rad_limit: double = maximum_radius_value;

  // radius equivalent to "straight", maximum_radius_value - 5000 to allow for offsets without exceeding 1E8 max_rad_limit.
  max_rad: double = maximum_radius_value - 5000;

  // used for testing maximum radius.
  max_rad_test: double = maximum_radius_value - 10000;




type

  TCurve = class(TOTPersistent, ICurveParameters)
  private
    //# genMemberVars
    FFixedRadius: Double;
    FTransitionStartRadius: Double;
    FTransitionEndRadius: Double;
    FDistanceToTransition: Double;
    FTransitionLength: Double;
    FIsSpiral: Boolean;
    FIsSlewing: Boolean;
    FDistanceToStartOfSlew: Double;
    FSlewLength: Double;
    FSlewAmount: Double;
    FSlewMode: ESlewMode;
    FSlewFactor: Double;
    //# endGenMemberVars

    FCurveCalculator: TCurveCalculator;
    FDistanceToEndOfTransition: Double;

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    // ICurveParameters
    function GetIsSpiral: boolean;
    function GetFixedRadius: double;
    function GetTransitionStartRadius: double;
    function GetTransitionEndRadius: double;
    function GetDistanceToTransition: double;
    function GetTransitionLength: double;
    function GetIsSlewing: boolean;
    function GetDistanceToStartOfSlew: double;
    function GetSlewLength: double;
    function GetSlewAmount: double;
    function GetSlewMode: ESlewMode;
    function GetSlewFactor: double;


    //# genGetSetDeclarations
    procedure SetFixedRadius(const AValue: Double);
    procedure SetTransitionStartRadius(const AValue: Double);
    procedure SetTransitionEndRadius(const AValue: Double);
    procedure SetDistanceToTransition(const AValue: Double);
    procedure SetTransitionLength(const AValue: Double);
    procedure SetIsSpiral(const AValue: Boolean);
    procedure SetIsSlewing(const AValue: Boolean);
    procedure SetDistanceToStartOfSlew(const AValue: Double);
    procedure SetSlewLength(const AValue: Double);
    procedure SetSlewAmount(const AValue: Double);
    procedure SetSlewMode(const AValue: ESlewMode);
    procedure SetSlewFactor(const AValue: Double);
    //# endGenGetSetDeclarations

    function StrToESlewMode(AValue: String): ESlewMode;
    procedure SaveYamlESlewMode(AEmitter: TYamlEmitter; const AName: String; AValue: ESlewMode);

    function GetDistanceToEndOfTransition: Double;

  protected
    property curveCalculator: TCurveCalculator read FCurveCalculator;

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    procedure CalculateCurveAt(distance, offset: double; out pt, direction: Tpex; out radius: double);

    procedure CopyFrom(ASource: TCurve);


    //# genProperty
    property fixedRadius: Double read FFixedRadius write SetFixedRadius;
    property transitionStartRadius: Double read FTransitionStartRadius write SetTransitionStartRadius;
    property transitionEndRadius: Double read FTransitionEndRadius write SetTransitionEndRadius;
    property distanceToTransition: Double read FDistanceToTransition write SetDistanceToTransition;
    property transitionLength: Double read FTransitionLength write SetTransitionLength;
    property isSpiral: Boolean read FIsSpiral write SetIsSpiral;
    property isSlewing: Boolean read FIsSlewing write SetIsSlewing;
    property distanceToStartOfSlew: Double read FDistanceToStartOfSlew write SetDistanceToStartOfSlew;
    property slewLength: Double read FSlewLength write SetSlewLength;
    property slewAmount: Double read FSlewAmount write SetSlewAmount;
    property slewMode: ESlewMode read FSlewMode write SetSlewMode;
    property slewFactor: Double read FSlewFactor write SetSlewFactor;
    //# endGenProperty

    property distanceToEndOfTransition: Double read GetDistanceToEndOfTransition;
  end;

  TCurveOwningList = class(TOTOwningList<TCurve>);
  TCurveReferenceList = class(TOTReferenceList<TCurve>);


implementation

uses
  OTUndoRedoManager,
  TLoggerUnit,
  typinfo,
  Math,
  curve_segment_calculator,
  slew_calculator;

var
  log : ILogger;


{ TCurve }

constructor TCurve.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent, AOID);
  //# genCreate
  //# endGenCreate
end;

destructor TCurve.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TCurve.Calculate;
begin
  // Add your calculation code here, and cache the results...
  FreeAndNil(FCurveCalculator);
  FCurveCalculator := TCurveSegmentCalculator.Create(self);

  if FIsSlewing then begin
    FCurveCalculator := TSlewCalculator.Create(self, FCurveCalculator);
  end;

  if FIsSpiral then
     FDistanceToEndOfTransition := FDistanceToTransition + FTransitionLength
  else
     FDistanceToEndOfTransition := NaN;
end;

procedure TCurve.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'fixedRadius' then
    FFixedRadius := StrToDouble(AValue)
  else
  if AName = 'transitionStartRadius' then
    FTransitionStartRadius := StrToDouble(AValue)
  else
  if AName = 'transitionEndRadius' then
    FTransitionEndRadius := StrToDouble(AValue)
  else
  if AName = 'distanceToTransition' then
    FDistanceToTransition := StrToDouble(AValue)
  else
  if AName = 'transitionLength' then
    FTransitionLength := StrToDouble(AValue)
  else
  if AName = 'isSpiral' then
    FIsSpiral := StrToBoolean(AValue)
  else
  if AName = 'isSlewing' then
    FIsSlewing := StrToBoolean(AValue)
  else
  if AName = 'distanceToStartOfSlew' then
    FDistanceToStartOfSlew := StrToDouble(AValue)
  else
  if AName = 'slewLength' then
    FSlewLength := StrToDouble(AValue)
  else
  if AName = 'slewAmount' then
    FSlewAmount := StrToDouble(AValue)
  else
  if AName = 'slewMode' then
    FSlewMode := StrToESlewMode(AValue)
  else
  if AName = 'slewFactor' then
    FSlewFactor := StrToDouble(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TCurve.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FFixedRadius, sizeof(Double));
  AStream.ReadBuffer(FTransitionStartRadius, sizeof(Double));
  AStream.ReadBuffer(FTransitionEndRadius, sizeof(Double));
  AStream.ReadBuffer(FDistanceToTransition, sizeof(Double));
  AStream.ReadBuffer(FTransitionLength, sizeof(Double));
  AStream.ReadBuffer(FIsSpiral, sizeof(Boolean));
  AStream.ReadBuffer(FIsSlewing, sizeof(Boolean));
  AStream.ReadBuffer(FDistanceToStartOfSlew, sizeof(Double));
  AStream.ReadBuffer(FSlewLength, sizeof(Double));
  AStream.ReadBuffer(FSlewAmount, sizeof(Double));
  AStream.ReadBuffer(FSlewMode, sizeof(ESlewMode));
  AStream.ReadBuffer(FSlewFactor, sizeof(Double));
  //# endGenRestoreVars
  end;

procedure TCurve.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FFixedRadius, sizeof(Double));
  AStream.WriteBuffer(FTransitionStartRadius, sizeof(Double));
  AStream.WriteBuffer(FTransitionEndRadius, sizeof(Double));
  AStream.WriteBuffer(FDistanceToTransition, sizeof(Double));
  AStream.WriteBuffer(FTransitionLength, sizeof(Double));
  AStream.WriteBuffer(FIsSpiral, sizeof(Boolean));
  AStream.WriteBuffer(FIsSlewing, sizeof(Boolean));
  AStream.WriteBuffer(FDistanceToStartOfSlew, sizeof(Double));
  AStream.WriteBuffer(FSlewLength, sizeof(Double));
  AStream.WriteBuffer(FSlewAmount, sizeof(Double));
  AStream.WriteBuffer(FSlewMode, sizeof(ESlewMode));
  AStream.WriteBuffer(FSlewFactor, sizeof(Double));
  //# endGenSaveVars
  end;
  
procedure TCurve.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlDouble(AEmitter, 'fixedRadius', FFixedRadius);
  SaveYamlDouble(AEmitter, 'transitionStartRadius', FTransitionStartRadius);
  SaveYamlDouble(AEmitter, 'transitionEndRadius', FTransitionEndRadius);
  SaveYamlDouble(AEmitter, 'distanceToTransition', FDistanceToTransition);
  SaveYamlDouble(AEmitter, 'transitionLength', FTransitionLength);
  SaveYamlBoolean(AEmitter, 'isSpiral', FIsSpiral);
  SaveYamlBoolean(AEmitter, 'isSlewing', FIsSlewing);
  SaveYamlDouble(AEmitter, 'distanceToStartOfSlew', FDistanceToStartOfSlew);
  SaveYamlDouble(AEmitter, 'slewLength', FSlewLength);
  SaveYamlDouble(AEmitter, 'slewAmount', FSlewAmount);
  SaveYamlESlewMode(AEmitter, 'slewMode', FSlewMode);
  SaveYamlDouble(AEmitter, 'slewFactor', FSlewFactor);
  //# endGenSaveYamlVars
  end;

function TCurve.GetIsSpiral: boolean;
begin
  Result := FIsSpiral;
end;

function TCurve.GetFixedRadius: double;
begin
  Result := FFixedRadius;
end;

function TCurve.GetTransitionStartRadius: double;
begin
  Result := FTransitionStartRadius;
end;

function TCurve.GetTransitionEndRadius: double;
begin
  Result := FTransitionEndRadius;
end;

function TCurve.GetDistanceToTransition: double;
begin
  Result := FDistanceToTransition;
end;

function TCurve.GetTransitionLength: double;
begin
  Result := FTransitionLength;
end;

function TCurve.GetIsSlewing: boolean;
begin
  Result := FIsSlewing;
end;

function TCurve.GetDistanceToStartOfSlew: double;
begin
  Result := FDistanceToStartOfSlew;
end;

function TCurve.GetSlewLength: double;
begin
  Result := FSlewLength;
end;

function TCurve.GetSlewAmount: double;
begin
  Result := FSlewAmount;
end;

function TCurve.GetSlewMode: ESlewMode;
begin
  Result := FSlewMode;
end;

function TCurve.GetSlewFactor: double;
begin
  Result := FSlewFactor;
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetFixedRadius(const AValue: Double);
begin
  if AValue <> FFixedRadius then begin
    SetModified;
    FFixedRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetTransitionStartRadius(const AValue: Double);
begin
  if AValue <> FTransitionStartRadius then begin
    SetModified;
    FTransitionStartRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetTransitionEndRadius(const AValue: Double);
begin
  if AValue <> FTransitionEndRadius then begin
    SetModified;
    FTransitionEndRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetDistanceToTransition(const AValue: Double);
begin
  if AValue <> FDistanceToTransition then begin
    SetModified;
    FDistanceToTransition := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetTransitionLength(const AValue: Double);
begin
  if AValue <> FTransitionLength then begin
    SetModified;
    FTransitionLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetIsSpiral(const AValue: Boolean);
begin
  if AValue <> FIsSpiral then begin
    SetModified;
    FIsSpiral := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetIsSlewing(const AValue: Boolean);
begin
  if AValue <> FIsSlewing then begin
    SetModified;
    FIsSlewing := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetDistanceToStartOfSlew(const AValue: Double);
begin
  if AValue <> FDistanceToStartOfSlew then begin
    SetModified;
    FDistanceToStartOfSlew := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetSlewLength(const AValue: Double);
begin
  if AValue <> FSlewLength then begin
    SetModified;
    FSlewLength := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetSlewAmount(const AValue: Double);
begin
  if AValue <> FSlewAmount then begin
    SetModified;
    FSlewAmount := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetSlewMode(const AValue: ESlewMode);
begin
  if AValue <> FSlewMode then begin
    SetModified;
    FSlewMode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCurve.SetSlewFactor(const AValue: Double);
begin
  if AValue <> FSlewFactor then begin
    SetModified;
    FSlewFactor := AValue;
  end;
end;

//# endGenGetSetMethods

function TCurve.StrToESlewMode(AValue: String): ESlewMode;
begin
  Result := ESlewMode(GetEnumValue(TypeInfo(ESlewMode), AValue));
end;

procedure TCurve.SaveYamlESlewMode(AEmitter: TYamlEmitter; const AName: String; AValue: ESlewMode);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(ESlewMode), ord(AValue)));
end;

procedure TCurve.CalculateCurveAt(distance, offset: double; out pt, direction: Tpex; out radius: double);
var
  normal: Tpex;
begin
  CheckCalculated;

  if Assigned(FCurveCalculator) then begin
    FCurveCalculator.CalculateCurveAt(distance, pt, direction, radius);
    // rotate 90 degrees clockwise
    normal.set_xy(direction.y, -direction.x);
    pt := pt + normal * offset;
  end
  else begin
    pt.set_xy(NaN, NaN);
    direction.set_xy(NaN, NaN);
    radius := NaN;
  end;

end;

function TCurve.GetDistanceToEndOfTransition: Double;
begin
  CheckCalculated;

  Result := FDistanceToEndOfTransition;
end;

procedure TCurve.CopyFrom(ASource: TCurve);
var
  hasActiveMark: Boolean;
begin
  hasActiveMark := UndoRedoManager.hasActiveMark;
  if not hasActiveMark then begin
    UndoRedoManager.SetMark('');
  end;

  SetModified;

  fixedRadius := ASource.fixedRadius;
  transitionStartRadius := ASource.transitionStartRadius;
  transitionEndRadius := ASource.transitionEndRadius;
  distanceToTransition := ASource.distanceToTransition;
  transitionLength := ASource.transitionLength;
  isSpiral := ASource.isSpiral;
  isSlewing := ASource.isSlewing;
  distanceToStartOfSlew := ASource.distanceToStartOfSlew;
  slewLength := ASource.slewLength;
  slewAmount := ASource.slewAmount;
  slewMode := ASource.slewMode;
  slewFactor := ASource.slewFactor;

  if not hasActiveMark then begin
    UndoRedoManager.Commit;
  end;

end;

initialization
  TCurve.RegisterClass;
  TCurveOwningList.RegisterClass;
  TCurveReferenceList.RegisterClass;

  //log := Logger.GetInstance('TCurve');
end.
