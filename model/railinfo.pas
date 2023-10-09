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


{# class TRailInfo
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
- name: kDiagonalSideCheckRail
  type: Boolean
- name: kMainSideCheckRail
  type: Boolean
- name: switchDrive
  type: Boolean
- name: trackCentreLines
  type: Boolean
- name: turnoutRoadStockRail
  type: Boolean
- name: turnoutRoadCheckRail
  type: Boolean
- name: turnoutRoadCrossingRail
  type: Boolean
- name: crossingVee
  type: Boolean
- name: mainRoadCrossingRail
  type: Boolean
- name: mainRoadCheckRail
  type: Boolean
- name: mainRoadStockRail
  type: Boolean
...
}

type
  TFlaredEnd = (feBent, feMachined);

  TKnuckleCode = (kcNormal, kcSharp, kcCustom);

  TRailInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FFlaredEnds: TFlaredEnd;
    FKnuckleCode: TKnuckleCode;
    FKnuckleRadius: Double;
    FIsolatedCrossing: Boolean;
    FKDiagonalSideCheckRail: Boolean;
    FKMainSideCheckRail: Boolean;
    FSwitchDrive: Boolean;
    FTrackCentreLines: Boolean;
    FTurnoutRoadStockRail: Boolean;
    FTurnoutRoadCheckRail: Boolean;
    FTurnoutRoadCrossingRail: Boolean;
    FCrossingVee: Boolean;
    FMainRoadCrossingRail: Boolean;
    FMainRoadCheckRail: Boolean;
    FMainRoadStockRail: Boolean;
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
    procedure SetKDiagonalSideCheckRail(const AValue: Boolean);
    procedure SetKMainSideCheckRail(const AValue: Boolean);
    procedure SetSwitchDrive(const AValue: Boolean);
    procedure SetTrackCentreLines(const AValue: Boolean);
    procedure SetTurnoutRoadStockRail(const AValue: Boolean);
    procedure SetTurnoutRoadCheckRail(const AValue: Boolean);
    procedure SetTurnoutRoadCrossingRail(const AValue: Boolean);
    procedure SetCrossingVee(const AValue: Boolean);
    procedure SetMainRoadCrossingRail(const AValue: Boolean);
    procedure SetMainRoadCheckRail(const AValue: Boolean);
    procedure SetMainRoadStockRail(const AValue: Boolean);
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
    property kDiagonalSideCheckRail: Boolean read FKDiagonalSideCheckRail write SetKDiagonalSideCheckRail;
    property kMainSideCheckRail: Boolean read FKMainSideCheckRail write SetKMainSideCheckRail;
    property switchDrive: Boolean read FSwitchDrive write SetSwitchDrive;
    property trackCentreLines: Boolean read FTrackCentreLines write SetTrackCentreLines;
    property turnoutRoadStockRail: Boolean read FTurnoutRoadStockRail write SetTurnoutRoadStockRail;
    property turnoutRoadCheckRail: Boolean read FTurnoutRoadCheckRail write SetTurnoutRoadCheckRail;
    property turnoutRoadCrossingRail: Boolean read FTurnoutRoadCrossingRail write SetTurnoutRoadCrossingRail;
    property crossingVee: Boolean read FCrossingVee write SetCrossingVee;
    property mainRoadCrossingRail: Boolean read FMainRoadCrossingRail write SetMainRoadCrossingRail;
    property mainRoadCheckRail: Boolean read FMainRoadCheckRail write SetMainRoadCheckRail;
    property mainRoadStockRail: Boolean read FMainRoadStockRail write SetMainRoadStockRail;
    //# endGenProperty
  end;

  TRailInfoOwningList = class(TOTOwningList<TRailInfo>);
  TRailInfoReferenceList = class(TOTReferenceList<TRailInfo>);


implementation

uses
  TLoggerUnit,
  OtYaml,
  TypInfo;

var
  log : ILogger;

function StrToTFlaredEnd(const AValue: String): TFlaredEnd;
begin
  Result := TFlaredEnd(GetEnumValue(Typeinfo(TFlaredEnd), AValue));
end;

procedure SaveYamlTFlaredEnd(AEmitter: TYamlEmitter; const AName: String; AValue: TFlaredEnd);
begin
  AEmitter.ScalarEvent('', '', AName, True, False, yssPlainScalar);
  AEmitter.ScalarEvent('', '', GetEnumName(Typeinfo(TFlaredEnd), Ord(AValue)), True, False, yssPlainScalar);
end;

function StrToTKnuckleCode(const AValue: String): TKnuckleCode;
begin
  Result := TKnuckleCode(GetEnumValue(Typeinfo(TKnuckleCode), AValue));
end;

procedure SaveYamlTKnuckleCode(AEmitter: TYamlEmitter; const AName: String; AValue: TKnuckleCode);
begin
  AEmitter.ScalarEvent('', '', AName, True, False, yssPlainScalar);
  AEmitter.ScalarEvent('', '', GetEnumName(Typeinfo(TKnuckleCode), Ord(AValue)), True, False, yssPlainScalar);
end;




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
  if AName = 'kDiagonalSideCheckRail' then
    FKDiagonalSideCheckRail := StrToBoolean(AValue)
  else
  if AName = 'kMainSideCheckRail' then
    FKMainSideCheckRail := StrToBoolean(AValue)
  else
  if AName = 'switchDrive' then
    FSwitchDrive := StrToBoolean(AValue)
  else
  if AName = 'trackCentreLines' then
    FTrackCentreLines := StrToBoolean(AValue)
  else
  if AName = 'turnoutRoadStockRail' then
    FTurnoutRoadStockRail := StrToBoolean(AValue)
  else
  if AName = 'turnoutRoadCheckRail' then
    FTurnoutRoadCheckRail := StrToBoolean(AValue)
  else
  if AName = 'turnoutRoadCrossingRail' then
    FTurnoutRoadCrossingRail := StrToBoolean(AValue)
  else
  if AName = 'crossingVee' then
    FCrossingVee := StrToBoolean(AValue)
  else
  if AName = 'mainRoadCrossingRail' then
    FMainRoadCrossingRail := StrToBoolean(AValue)
  else
  if AName = 'mainRoadCheckRail' then
    FMainRoadCheckRail := StrToBoolean(AValue)
  else
  if AName = 'mainRoadStockRail' then
    FMainRoadStockRail := StrToBoolean(AValue)
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
  AStream.ReadBuffer(FKDiagonalSideCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FKMainSideCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FSwitchDrive, sizeof(Boolean));
  AStream.ReadBuffer(FTrackCentreLines, sizeof(Boolean));
  AStream.ReadBuffer(FTurnoutRoadStockRail, sizeof(Boolean));
  AStream.ReadBuffer(FTurnoutRoadCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FTurnoutRoadCrossingRail, sizeof(Boolean));
  AStream.ReadBuffer(FCrossingVee, sizeof(Boolean));
  AStream.ReadBuffer(FMainRoadCrossingRail, sizeof(Boolean));
  AStream.ReadBuffer(FMainRoadCheckRail, sizeof(Boolean));
  AStream.ReadBuffer(FMainRoadStockRail, sizeof(Boolean));
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
  AStream.WriteBuffer(FKDiagonalSideCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FKMainSideCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FSwitchDrive, sizeof(Boolean));
  AStream.WriteBuffer(FTrackCentreLines, sizeof(Boolean));
  AStream.WriteBuffer(FTurnoutRoadStockRail, sizeof(Boolean));
  AStream.WriteBuffer(FTurnoutRoadCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FTurnoutRoadCrossingRail, sizeof(Boolean));
  AStream.WriteBuffer(FCrossingVee, sizeof(Boolean));
  AStream.WriteBuffer(FMainRoadCrossingRail, sizeof(Boolean));
  AStream.WriteBuffer(FMainRoadCheckRail, sizeof(Boolean));
  AStream.WriteBuffer(FMainRoadStockRail, sizeof(Boolean));
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
  SaveYamlBoolean(AEmitter, 'kDiagonalSideCheckRail', FKDiagonalSideCheckRail);
  SaveYamlBoolean(AEmitter, 'kMainSideCheckRail', FKMainSideCheckRail);
  SaveYamlBoolean(AEmitter, 'switchDrive', FSwitchDrive);
  SaveYamlBoolean(AEmitter, 'trackCentreLines', FTrackCentreLines);
  SaveYamlBoolean(AEmitter, 'turnoutRoadStockRail', FTurnoutRoadStockRail);
  SaveYamlBoolean(AEmitter, 'turnoutRoadCheckRail', FTurnoutRoadCheckRail);
  SaveYamlBoolean(AEmitter, 'turnoutRoadCrossingRail', FTurnoutRoadCrossingRail);
  SaveYamlBoolean(AEmitter, 'crossingVee', FCrossingVee);
  SaveYamlBoolean(AEmitter, 'mainRoadCrossingRail', FMainRoadCrossingRail);
  SaveYamlBoolean(AEmitter, 'mainRoadCheckRail', FMainRoadCheckRail);
  SaveYamlBoolean(AEmitter, 'mainRoadStockRail', FMainRoadStockRail);
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

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetKDiagonalSideCheckRail(const AValue: Boolean);
begin
  if AValue <> FKDiagonalSideCheckRail then begin
    SetModified;
    FKDiagonalSideCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetKMainSideCheckRail(const AValue: Boolean);
begin
  if AValue <> FKMainSideCheckRail then begin
    SetModified;
    FKMainSideCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetSwitchDrive(const AValue: Boolean);
begin
  if AValue <> FSwitchDrive then begin
    SetModified;
    FSwitchDrive := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetTrackCentreLines(const AValue: Boolean);
begin
  if AValue <> FTrackCentreLines then begin
    SetModified;
    FTrackCentreLines := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetTurnoutRoadStockRail(const AValue: Boolean);
begin
  if AValue <> FTurnoutRoadStockRail then begin
    SetModified;
    FTurnoutRoadStockRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetTurnoutRoadCheckRail(const AValue: Boolean);
begin
  if AValue <> FTurnoutRoadCheckRail then begin
    SetModified;
    FTurnoutRoadCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetTurnoutRoadCrossingRail(const AValue: Boolean);
begin
  if AValue <> FTurnoutRoadCrossingRail then begin
    SetModified;
    FTurnoutRoadCrossingRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetCrossingVee(const AValue: Boolean);
begin
  if AValue <> FCrossingVee then begin
    SetModified;
    FCrossingVee := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetMainRoadCrossingRail(const AValue: Boolean);
begin
  if AValue <> FMainRoadCrossingRail then begin
    SetModified;
    FMainRoadCrossingRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetMainRoadCheckRail(const AValue: Boolean);
begin
  if AValue <> FMainRoadCheckRail then begin
    SetModified;
    FMainRoadCheckRail := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TRailInfo.SetMainRoadStockRail(const AValue: Boolean);
begin
  if AValue <> FMainRoadStockRail then begin
    SetModified;
    FMainRoadStockRail := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TRailInfo.RegisterClass;
  TRailInfoOwningList.RegisterClass;
  TRailInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TRailInfo');
end.
