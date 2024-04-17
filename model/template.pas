unit Template;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Curve,
  template_records,
  BoxDims,
  TurnoutInfo2,
  ShovedTimber,
  Feature,
  Centreline;


{# class TTemplate
---
class: TTemplate
attributes:
  - name: name
    type: String
  - name: topLabel
    type: String
  - name: memo
    type: String
  - name: curve
    type: TCurve
    owns: create
    access: [get]
  - name: boxDims
    type: TBoxDims
    owns: create
    access: [get]
  - name: turnoutInfo2
    type: TTurnoutInfo2
    owns: create
    access: [get]
  - name: shovedTimbers
    type: TShovedTimberOwningList
    owns: create
    access: [get]
  - name: centreline
    type: TCentreline
    owns: create
    access: [get]
...
}

type

  TTemplate = class(TOTPersistent)
  private
    //# genMemberVars
    FName: String;
    FTopLabel: String;
    FMemo: String;
    FCurve: TOID;
    FBoxDims: TOID;
    FTurnoutInfo2: TOID;
    FShovedTimbers: TOID;
    FCentreline: TOID;
    //# endGenMemberVars

    FFeatures: array of TFeature;

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetCurve: TCurve;
    function GetBoxDims: TBoxDims;
    function GetTurnoutInfo2: TTurnoutInfo2;
    function GetShovedTimbers: TShovedTimberOwningList;
    function GetCentreline: TCentreline;
    procedure SetName(const AValue: String);
    procedure SetTopLabel(const AValue: String);
    procedure SetMemo(const AValue: String);
    //# endGenGetSetDeclarations

    function GetFeature(idx: Integer): TFeature;
    function GetFeatureCount: Integer;

  public
    // True=has been copied to the background. (not included in file).
    bg_copied: boolean;
    // True=selected as one of a group.
    group_selected: boolean;
    // True=has been shifted/rotated/mirrored, needs a new timestamp on rebuilding.
    new_stamp_wanted: boolean;

    // snapping positions for F7 shift mouse action  0.79.a  27-05-06
    snap_peg_positions: Tsnap_peg_positions;
    boundary_info: Tboundary_info;              // 213b for extend to boundary

    // used for peg snapping checks. (also in the template_info for file).  0.79.a  27-05-06
    bgnd_half_diamond: boolean;
    bgnd_plain_track: boolean;         // ditto
    bgnd_retpar: boolean;              // ditto parallel crossing
    bgnd_peg_on_zero: boolean;         // ditto Ctrl-0 or not.

    // added 205e for obtain tradius to control...

    bgnd_xing_type: integer;
    bgnd_spiral: boolean;
    bgnd_turnout_radius: double;

    bgnd_gaunt: boolean;               // 218a

    // 218d   temp flag   template is within a rectangle (e.g. on screen)
    bgnd_is_in_rect: boolean;

    // 211b position of name label...

    bgnd_label_x: double;   // mm
    bgnd_label_y: double;   // mm

    bgnd_blanked: boolean;        // 215a
    bgnd_no_xing: boolean;        // 215a

    this_is_tandem_first: boolean;  // 218a

    bgnd_keep: Tbgnd_keep;    // drawn data for a background template.

    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property name: String read FName write SetName;
    property topLabel: String read FTopLabel write SetTopLabel;
    property memo: String read FMemo write SetMemo;
    property curve: TCurve read GetCurve;
    property boxDims: TBoxDims read GetBoxDims;
    property turnoutInfo2: TTurnoutInfo2 read GetTurnoutInfo2;
    property shovedTimbers: TShovedTimberOwningList read GetShovedTimbers;
    property centreline: TCentreline read GetCentreline;
    //# endGenProperty

    property featureCount: Integer read GetFeatureCount;
    property features[idx: Integer] : TFeature read GetFeature;
  end;

  TTemplateOwningList = class(TOTOwningList<TTemplate>);
  TTemplateReferenceList = class(TOTReferenceList<TTemplate>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TTemplate }

constructor TTemplate.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FCurve := TCurve.Create(nil).oid
  else
    FCurve := 0;
  if AOID = 0 then
    FBoxDims := TBoxDims.Create(nil).oid
  else
    FBoxDims := 0;
  if AOID = 0 then
    FTurnoutInfo2 := TTurnoutInfo2.Create(nil).oid
  else
    FTurnoutInfo2 := 0;
  if AOID = 0 then
    FShovedTimbers := TShovedTimberOwningList.Create(nil).oid
  else
    FShovedTimbers := 0;
  if AOID = 0 then
    FCentreline := TCentreline.Create(nil).oid
  else
    FCentreline := 0;
  //# endGenCreate

  if AOID = 0 then begin
    centreline.curve := curve;
  end;
end;

destructor TTemplate.Destroy;
begin
  //# genDestroy
  SetOwned(FCurve, nil);
  SetOwned(FBoxDims, nil);
  SetOwned(FTurnoutInfo2, nil);
  SetOwned(FShovedTimbers, nil);
  SetOwned(FCentreline, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTemplate.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TTemplate.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'name' then
    FName := StrToString(AValue)
  else
  if AName = 'topLabel' then
    FTopLabel := StrToString(AValue)
  else
  if AName = 'memo' then
    FMemo := StrToString(AValue)
  else
  if AName = 'curve' then
    RestoreYamlObjectOwn(FCurve, StrToInteger(AValue), ALoader)
  else
  if AName = 'boxDims' then
    RestoreYamlObjectOwn(FBoxDims, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutInfo2' then
    RestoreYamlObjectOwn(FTurnoutInfo2, StrToInteger(AValue), ALoader)
  else
  if AName = 'shovedTimbers' then
    RestoreYamlObjectOwn(FShovedTimbers, StrToInteger(AValue), ALoader)
  else
  if AName = 'centreline' then
    RestoreYamlObjectOwn(FCentreline, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTemplate.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  FName := AStream.ReadAnsiString;
  FTopLabel := AStream.ReadAnsiString;
  FMemo := AStream.ReadAnsiString;
  AStream.ReadBuffer(FCurve, sizeof(TOID));
  AStream.ReadBuffer(FBoxDims, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutInfo2, sizeof(TOID));
  AStream.ReadBuffer(FShovedTimbers, sizeof(TOID));
  AStream.ReadBuffer(FCentreline, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TTemplate.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteAnsiString(FName);
  AStream.WriteAnsiString(FTopLabel);
  AStream.WriteAnsiString(FMemo);
  AStream.WriteBuffer(FCurve, sizeof(TOID));
  AStream.WriteBuffer(FBoxDims, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutInfo2, sizeof(TOID));
  AStream.WriteBuffer(FShovedTimbers, sizeof(TOID));
  AStream.WriteBuffer(FCentreline, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TTemplate.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlString(AEmitter, 'name', FName);
  SaveYamlString(AEmitter, 'topLabel', FTopLabel);
  SaveYamlString(AEmitter, 'memo', FMemo);
  SaveYamlObject(AEmitter, 'curve', FCurve);
  SaveYamlObject(AEmitter, 'boxDims', FBoxDims);
  SaveYamlObject(AEmitter, 'turnoutInfo2', FTurnoutInfo2);
  SaveYamlObject(AEmitter, 'shovedTimbers', FShovedTimbers);
  SaveYamlObject(AEmitter, 'centreline', FCentreline);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetName(const AValue: String);
begin
  if AValue <> FName then begin
    SetModified;
    FName := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetTopLabel(const AValue: String);
begin
  if AValue <> FTopLabel then begin
    SetModified;
    FTopLabel := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTemplate.SetMemo(const AValue: String);
begin
  if AValue <> FMemo then begin
    SetModified;
    FMemo := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetCurve: TCurve;
begin
  Result := TCurve(FromOID(FCurve));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetBoxDims: TBoxDims;
begin
  Result := TBoxDims(FromOID(FBoxDims));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetTurnoutInfo2: TTurnoutInfo2;
begin
  Result := TTurnoutInfo2(FromOID(FTurnoutInfo2));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetShovedTimbers: TShovedTimberOwningList;
begin
  Result := TShovedTimberOwningList(FromOID(FShovedTimbers));
end;

// GENERATED METHOD - DO NOT EDIT
function TTemplate.GetCentreline: TCentreline;
begin
  Result := TCentreline(FromOID(FCentreline));
end;

//# endGenGetSetMethods

function TTemplate.GetFeature(idx: Integer): TFeature;
begin
  CheckCalculated;
  Result := FFeatures[idx];
end;

function TTemplate.GetFeatureCount: Integer;
begin
  CheckCalculated;
  Result := Length(FFeatures);
end;

initialization
  TTemplate.RegisterClass;
  TTemplateOwningList.RegisterClass;
  TTemplateReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTemplate');
end.
