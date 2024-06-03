unit RailInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;

(*
Trail_info = record     // rail switch settings.  23-5-01.

  // !!! 17-1-00 - exhaustive testing done to get file match with previous version.
  // !!! with both same file size and correct reading of bgnd_flag.
  // !!! Due to Delphi2 aligning boundaries. Don't change anything!!! ...

  flared_ends_ri: integer;  // 0=straight bent, 1=straight machined

  knuckle_code_ri: integer;
  // 214a spare_int2:integer;     0=normal, -1=sharp, 1=use custom knuckle_radius_ri
  knuckle_radius_ri: double;
  // 214a spare_float1:double;  custom setting - inches full-size

  isolated_crossing_sw: boolean;            //  217a   spare_bool3:boolean;

  // rail switches ..

  k_diagonal_side_check_rail_sw: boolean;    // added 0.93.a
  k_main_side_check_rail_sw: boolean;        // added 0.93.a

  switch_drive_sw: boolean;   // 0.82.a  13-10-06

  // rail switches...

  track_centre_lines_sw: boolean;
  turnout_road_stock_rail_sw: boolean;
  turnout_road_check_rail_sw: boolean;
  turnout_road_crossing_rail_sw: boolean;
  crossing_vee_sw: boolean;
  main_road_crossing_rail_sw: boolean;
  main_road_check_rail_sw: boolean;
  main_road_stock_rail_sw: boolean;

end;
*)

{#
---
enum: TFlaredEnd
values:
- feBent
- feMachined
...
---
enum: TKnuckleCode
values:
- kcNormal
- kcSharp
- kcCustom
...
---
class: TRailInfo
attributes:
- name: flaredEnds
  type: TFlaredEnd
- name: knuckleCode
  type: TKnuckleCode
- name: knuckleRadius
  type: Double
  comment: custom setting - inches full-size
- name: isolatedCrossing
  type: Boolean
...
}

type
  //# genEnumDeclarations
  TFlaredEnd = (
    feBent,
    feMachined
    );

  TKnuckleCode = (
    kcNormal,
    kcSharp,
    kcCustom
    );

  //# endGenEnumDeclarations

  TRailInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FFlaredEnds: TFlaredEnd;
    FKnuckleCode: TKnuckleCode;
    FKnuckleRadius: Double;
    FIsolatedCrossing: Boolean;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetFlaredEnds(const AValue: TFlaredEnd);
    procedure SetKnuckleCode(const AValue: TKnuckleCode);
    procedure SetKnuckleRadius(const AValue: Double);
    procedure SetIsolatedCrossing(const AValue: Boolean);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property flaredEnds: TFlaredEnd read FFlaredEnds write SetFlaredEnds;
    property knuckleCode: TKnuckleCode read FKnuckleCode write SetKnuckleCode;

    // custom setting - inches full-size
    property knuckleRadius: Double read FKnuckleRadius write SetKnuckleRadius;
    property isolatedCrossing: Boolean read FIsolatedCrossing write SetIsolatedCrossing;
    //# endGenProperty
  end;

  TRailInfoOwningList = class(TOTOwningList<TRailInfo>);
  TRailInfoReferenceList = class(TOTReferenceList<TRailInfo>);

//# genEnumSerialDeclarations
  function StrToTFlaredEnd(AValue: String): TFlaredEnd;
  procedure SaveYamlTFlaredEnd(AEmitter: TYamlEmitter; const AName: String;
    AValue: TFlaredEnd);

  function StrToTKnuckleCode(AValue: String): TKnuckleCode;
  procedure SaveYamlTKnuckleCode(AEmitter: TYamlEmitter; const AName: String;
    AValue: TKnuckleCode);

//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit,
  OtYaml,
  TypInfo;

var
  log : ILogger;

//# genEnumSerialMethods
// GENERATED METHOD - DO NOT EDIT
function StrToTFlaredEnd(AValue: String): TFlaredEnd;
begin
  Result := TFlaredEnd(GetEnumValue(TypeInfo(TFlaredEnd), AValue));
end;

// GENERATED METHOD - DO NOT EDIT
procedure SaveYamlTFlaredEnd(AEmitter: TYamlEmitter; const AName: String;
  AValue: TFlaredEnd);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TFlaredEnd), Ord(AValue)));
end;

// GENERATED METHOD - DO NOT EDIT
function StrToTKnuckleCode(AValue: String): TKnuckleCode;
begin
  Result := TKnuckleCode(GetEnumValue(TypeInfo(TKnuckleCode), AValue));
end;

// GENERATED METHOD - DO NOT EDIT
procedure SaveYamlTKnuckleCode(AEmitter: TYamlEmitter; const AName: String;
  AValue: TKnuckleCode);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TKnuckleCode), Ord(AValue)));
end;

//# endGenEnumSerialMethods


{ TRailInfo }

constructor TRailInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TRailInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TRailInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TRailInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'flaredEnds' then
    FFlaredEnds := StrToTFlaredEnd(AValue)
  else
  if AName = 'knuckleCode' then
    FKnuckleCode := StrToTKnuckleCode(AValue)
  else
  if AName = 'knuckleRadius' then
    FKnuckleRadius := StrToDouble(AValue)
  else
  if AName = 'isolatedCrossing' then
    FIsolatedCrossing := StrToBoolean(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TRailInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FFlaredEnds, sizeof(TFlaredEnd));
  AStream.ReadBuffer(FKnuckleCode, sizeof(TKnuckleCode));
  AStream.ReadBuffer(FKnuckleRadius, sizeof(Double));
  AStream.ReadBuffer(FIsolatedCrossing, sizeof(Boolean));
  //# endGenRestoreVars
  end;

procedure TRailInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FFlaredEnds, sizeof(TFlaredEnd));
  AStream.WriteBuffer(FKnuckleCode, sizeof(TKnuckleCode));
  AStream.WriteBuffer(FKnuckleRadius, sizeof(Double));
  AStream.WriteBuffer(FIsolatedCrossing, sizeof(Boolean));
  //# endGenSaveVars
  end;
  
procedure TRailInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlTFlaredEnd(AEmitter, 'flaredEnds', FFlaredEnds);
  SaveYamlTKnuckleCode(AEmitter, 'knuckleCode', FKnuckleCode);
  SaveYamlDouble(AEmitter, 'knuckleRadius', FKnuckleRadius);
  SaveYamlBoolean(AEmitter, 'isolatedCrossing', FIsolatedCrossing);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetFlaredEnds(const AValue: TFlaredEnd);
begin
  if AValue <> FFlaredEnds then begin
    SetModified;
    FFlaredEnds := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetKnuckleCode(const AValue: TKnuckleCode);
begin
  if AValue <> FKnuckleCode then begin
    SetModified;
    FKnuckleCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetKnuckleRadius(const AValue: Double);
begin
  if AValue <> FKnuckleRadius then begin
    SetModified;
    FKnuckleRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetIsolatedCrossing(const AValue: Boolean);
begin
  if AValue <> FIsolatedCrossing then begin
    SetModified;
    FIsolatedCrossing := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TRailInfo.RegisterClass;
  TRailInfoOwningList.RegisterClass;
  TRailInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TRailInfo');
end.
