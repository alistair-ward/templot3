unit VeeCheckRailInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{
Tvee_check_rail_info = record         // V-crossing check and wing rail lengths. 0.79.a

  v_check_ms_working1: double;
  // full-size inches - size 1 MS check rail working length (back from "A").
  v_check_ms_working2: double;
  // full-size inches - size 2 MS check rail working length (back from "A").
  v_check_ms_working3: double;
  // full-size inches - size 3 MS check rail working length (back from "A").

  v_check_ts_working1: double;
  // full-size inches - size 1 TS check rail working length (back from "A").
  v_check_ts_working2: double;
  // full-size inches - size 2 TS check rail working length (back from "A").
  v_check_ts_working3: double;
  // full-size inches - size 3 TS check rail working length (back from "A").

  v_check_ms_ext1: double;
  // full-size inches - size 1 MS check rail extension length (forward from "A").
  v_check_ms_ext2: double;
  // full-size inches - size 2 MS check rail extension length (forward from "A").

  v_check_ts_ext1: double;
  // full-size inches - size 1 TS check rail extension length (forward from "A").
  v_check_ts_ext2: double;
  // full-size inches - size 2 TS check rail extension length (forward from "A").

  v_wing_ms_reach1: double;
  // full-size inches - size 1 MS wing rail reach length (forward from "A").
  v_wing_ms_reach2: double;
  // full-size inches - size 2 MS wing rail reach length (forward from "A").

  v_wing_ts_reach1: double;
  // full-size inches - size 1 TS wing rail reach length (forward from "A").
  v_wing_ts_reach2: double;
  // full-size inches - size 2 TS wing rail reach length (forward from "A").
end;


}

{# class TVeeCheckRailInfo
---
class: TVeeCheckRailInfo
attributes:
- name: vCheckMSWorking1
  type: Double
  comment: full-size inches - size 1 MS check rail working length (back from "A").
- name: vCheckMSWorking2
  type: Double
  comment: full-size inches - size 2 MS check rail working length (back from "A").
- name: vCheckMSWorking3
  type: Double
  comment: full-size inches - size 3 MS check rail working length (back from "A").
- name: vCheckTSWorking1
  type: Double
  comment: full-size inches - size 1 TS check rail working length (back from "A").
- name: vCheckTSWorking2
  type: Double
  comment: full-size inches - size 2 TS check rail working length (back from "A").
- name: vCheckTSWorking3
  type: Double
  comment: full-size inches - size 3 TS check rail working length (back from "A").
- name: vCheckMSExt1
  type: Double
  comment: full-size inches - size 1 MS check rail extension length (forward from "A").
- name: vCheckMSExt2
  type: Double
  comment: full-size inches - size 2 MS check rail extension length (forward from "A").
- name: vCheckTSExt1
  type: Double
  comment: full-size inches - size 1 TS check rail extension length (forward from "A").
- name: vCheckTSExt2
  type: Double
  comment: full-size inches - size 2 TS check rail extension length (forward from "A").
- name: vWingMSReach1
  type: Double
  comment: full-size inches - size 1 MS wing rail reach length (forward from "A").
- name: vWingMSReach2
  type: Double
  comment: full-size inches - size 2 MS wing rail reach length (forward from "A").
- name: vWingTSReach1
  type: Double
  comment: full-size inches - size 1 TS wing rail reach length (forward from "A").
- name: vWingTSReach2
  type: Double
  comment: full-size inches - size 2 TS wing rail reach length (forward from "A").
...
}

type

  TVeeCheckRailInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FVCheckMSWorking1: Double;
    FVCheckMSWorking2: Double;
    FVCheckMSWorking3: Double;
    FVCheckTSWorking1: Double;
    FVCheckTSWorking2: Double;
    FVCheckTSWorking3: Double;
    FVCheckMSExt1: Double;
    FVCheckMSExt2: Double;
    FVCheckTSExt1: Double;
    FVCheckTSExt2: Double;
    FVWingMSReach1: Double;
    FVWingMSReach2: Double;
    FVWingTSReach1: Double;
    FVWingTSReach2: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetVCheckMSWorking1(const AValue: Double);
    procedure SetVCheckMSWorking2(const AValue: Double);
    procedure SetVCheckMSWorking3(const AValue: Double);
    procedure SetVCheckTSWorking1(const AValue: Double);
    procedure SetVCheckTSWorking2(const AValue: Double);
    procedure SetVCheckTSWorking3(const AValue: Double);
    procedure SetVCheckMSExt1(const AValue: Double);
    procedure SetVCheckMSExt2(const AValue: Double);
    procedure SetVCheckTSExt1(const AValue: Double);
    procedure SetVCheckTSExt2(const AValue: Double);
    procedure SetVWingMSReach1(const AValue: Double);
    procedure SetVWingMSReach2(const AValue: Double);
    procedure SetVWingTSReach1(const AValue: Double);
    procedure SetVWingTSReach2(const AValue: Double);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty

    // full-size inches - size 1 MS check rail working length (back from "A").
    property vCheckMSWorking1: Double read FVCheckMSWorking1 write SetVCheckMSWorking1;

    // full-size inches - size 2 MS check rail working length (back from "A").
    property vCheckMSWorking2: Double read FVCheckMSWorking2 write SetVCheckMSWorking2;

    // full-size inches - size 3 MS check rail working length (back from "A").
    property vCheckMSWorking3: Double read FVCheckMSWorking3 write SetVCheckMSWorking3;

    // full-size inches - size 1 TS check rail working length (back from "A").
    property vCheckTSWorking1: Double read FVCheckTSWorking1 write SetVCheckTSWorking1;

    // full-size inches - size 2 TS check rail working length (back from "A").
    property vCheckTSWorking2: Double read FVCheckTSWorking2 write SetVCheckTSWorking2;

    // full-size inches - size 3 TS check rail working length (back from "A").
    property vCheckTSWorking3: Double read FVCheckTSWorking3 write SetVCheckTSWorking3;

    // full-size inches - size 1 MS check rail extension length (forward from "A").
    property vCheckMSExt1: Double read FVCheckMSExt1 write SetVCheckMSExt1;

    // full-size inches - size 2 MS check rail extension length (forward from "A").
    property vCheckMSExt2: Double read FVCheckMSExt2 write SetVCheckMSExt2;

    // full-size inches - size 1 TS check rail extension length (forward from "A").
    property vCheckTSExt1: Double read FVCheckTSExt1 write SetVCheckTSExt1;

    // full-size inches - size 2 TS check rail extension length (forward from "A").
    property vCheckTSExt2: Double read FVCheckTSExt2 write SetVCheckTSExt2;

    // full-size inches - size 1 MS wing rail reach length (forward from "A").
    property vWingMSReach1: Double read FVWingMSReach1 write SetVWingMSReach1;

    // full-size inches - size 2 MS wing rail reach length (forward from "A").
    property vWingMSReach2: Double read FVWingMSReach2 write SetVWingMSReach2;

    // full-size inches - size 1 TS wing rail reach length (forward from "A").
    property vWingTSReach1: Double read FVWingTSReach1 write SetVWingTSReach1;

    // full-size inches - size 2 TS wing rail reach length (forward from "A").
    property vWingTSReach2: Double read FVWingTSReach2 write SetVWingTSReach2;
    //# endGenProperty
  end;

  TVeeCheckRailInfoOwningList = class(TOTOwningList<TVeeCheckRailInfo>);
  TVeeCheckRailInfoReferenceList = class(TOTReferenceList<TVeeCheckRailInfo>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TVeeCheckRailInfo }

constructor TVeeCheckRailInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TVeeCheckRailInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TVeeCheckRailInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TVeeCheckRailInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'vCheckMSWorking1' then
    FVCheckMSWorking1 := StrToDouble(AValue)
  else
  if AName = 'vCheckMSWorking2' then
    FVCheckMSWorking2 := StrToDouble(AValue)
  else
  if AName = 'vCheckMSWorking3' then
    FVCheckMSWorking3 := StrToDouble(AValue)
  else
  if AName = 'vCheckTSWorking1' then
    FVCheckTSWorking1 := StrToDouble(AValue)
  else
  if AName = 'vCheckTSWorking2' then
    FVCheckTSWorking2 := StrToDouble(AValue)
  else
  if AName = 'vCheckTSWorking3' then
    FVCheckTSWorking3 := StrToDouble(AValue)
  else
  if AName = 'vCheckMSExt1' then
    FVCheckMSExt1 := StrToDouble(AValue)
  else
  if AName = 'vCheckMSExt2' then
    FVCheckMSExt2 := StrToDouble(AValue)
  else
  if AName = 'vCheckTSExt1' then
    FVCheckTSExt1 := StrToDouble(AValue)
  else
  if AName = 'vCheckTSExt2' then
    FVCheckTSExt2 := StrToDouble(AValue)
  else
  if AName = 'vWingMSReach1' then
    FVWingMSReach1 := StrToDouble(AValue)
  else
  if AName = 'vWingMSReach2' then
    FVWingMSReach2 := StrToDouble(AValue)
  else
  if AName = 'vWingTSReach1' then
    FVWingTSReach1 := StrToDouble(AValue)
  else
  if AName = 'vWingTSReach2' then
    FVWingTSReach2 := StrToDouble(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TVeeCheckRailInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FVCheckMSWorking1, sizeof(Double));
  AStream.ReadBuffer(FVCheckMSWorking2, sizeof(Double));
  AStream.ReadBuffer(FVCheckMSWorking3, sizeof(Double));
  AStream.ReadBuffer(FVCheckTSWorking1, sizeof(Double));
  AStream.ReadBuffer(FVCheckTSWorking2, sizeof(Double));
  AStream.ReadBuffer(FVCheckTSWorking3, sizeof(Double));
  AStream.ReadBuffer(FVCheckMSExt1, sizeof(Double));
  AStream.ReadBuffer(FVCheckMSExt2, sizeof(Double));
  AStream.ReadBuffer(FVCheckTSExt1, sizeof(Double));
  AStream.ReadBuffer(FVCheckTSExt2, sizeof(Double));
  AStream.ReadBuffer(FVWingMSReach1, sizeof(Double));
  AStream.ReadBuffer(FVWingMSReach2, sizeof(Double));
  AStream.ReadBuffer(FVWingTSReach1, sizeof(Double));
  AStream.ReadBuffer(FVWingTSReach2, sizeof(Double));
  //# endGenRestoreVars
  end;

procedure TVeeCheckRailInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FVCheckMSWorking1, sizeof(Double));
  AStream.WriteBuffer(FVCheckMSWorking2, sizeof(Double));
  AStream.WriteBuffer(FVCheckMSWorking3, sizeof(Double));
  AStream.WriteBuffer(FVCheckTSWorking1, sizeof(Double));
  AStream.WriteBuffer(FVCheckTSWorking2, sizeof(Double));
  AStream.WriteBuffer(FVCheckTSWorking3, sizeof(Double));
  AStream.WriteBuffer(FVCheckMSExt1, sizeof(Double));
  AStream.WriteBuffer(FVCheckMSExt2, sizeof(Double));
  AStream.WriteBuffer(FVCheckTSExt1, sizeof(Double));
  AStream.WriteBuffer(FVCheckTSExt2, sizeof(Double));
  AStream.WriteBuffer(FVWingMSReach1, sizeof(Double));
  AStream.WriteBuffer(FVWingMSReach2, sizeof(Double));
  AStream.WriteBuffer(FVWingTSReach1, sizeof(Double));
  AStream.WriteBuffer(FVWingTSReach2, sizeof(Double));
  //# endGenSaveVars
  end;
  
procedure TVeeCheckRailInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlDouble(AEmitter, 'vCheckMSWorking1', FVCheckMSWorking1);
  SaveYamlDouble(AEmitter, 'vCheckMSWorking2', FVCheckMSWorking2);
  SaveYamlDouble(AEmitter, 'vCheckMSWorking3', FVCheckMSWorking3);
  SaveYamlDouble(AEmitter, 'vCheckTSWorking1', FVCheckTSWorking1);
  SaveYamlDouble(AEmitter, 'vCheckTSWorking2', FVCheckTSWorking2);
  SaveYamlDouble(AEmitter, 'vCheckTSWorking3', FVCheckTSWorking3);
  SaveYamlDouble(AEmitter, 'vCheckMSExt1', FVCheckMSExt1);
  SaveYamlDouble(AEmitter, 'vCheckMSExt2', FVCheckMSExt2);
  SaveYamlDouble(AEmitter, 'vCheckTSExt1', FVCheckTSExt1);
  SaveYamlDouble(AEmitter, 'vCheckTSExt2', FVCheckTSExt2);
  SaveYamlDouble(AEmitter, 'vWingMSReach1', FVWingMSReach1);
  SaveYamlDouble(AEmitter, 'vWingMSReach2', FVWingMSReach2);
  SaveYamlDouble(AEmitter, 'vWingTSReach1', FVWingTSReach1);
  SaveYamlDouble(AEmitter, 'vWingTSReach2', FVWingTSReach2);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckMSWorking1(const AValue: Double);
begin
  if AValue <> FVCheckMSWorking1 then begin
    SetModified;
    FVCheckMSWorking1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckMSWorking2(const AValue: Double);
begin
  if AValue <> FVCheckMSWorking2 then begin
    SetModified;
    FVCheckMSWorking2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckMSWorking3(const AValue: Double);
begin
  if AValue <> FVCheckMSWorking3 then begin
    SetModified;
    FVCheckMSWorking3 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckTSWorking1(const AValue: Double);
begin
  if AValue <> FVCheckTSWorking1 then begin
    SetModified;
    FVCheckTSWorking1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckTSWorking2(const AValue: Double);
begin
  if AValue <> FVCheckTSWorking2 then begin
    SetModified;
    FVCheckTSWorking2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckTSWorking3(const AValue: Double);
begin
  if AValue <> FVCheckTSWorking3 then begin
    SetModified;
    FVCheckTSWorking3 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckMSExt1(const AValue: Double);
begin
  if AValue <> FVCheckMSExt1 then begin
    SetModified;
    FVCheckMSExt1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckMSExt2(const AValue: Double);
begin
  if AValue <> FVCheckMSExt2 then begin
    SetModified;
    FVCheckMSExt2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckTSExt1(const AValue: Double);
begin
  if AValue <> FVCheckTSExt1 then begin
    SetModified;
    FVCheckTSExt1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVCheckTSExt2(const AValue: Double);
begin
  if AValue <> FVCheckTSExt2 then begin
    SetModified;
    FVCheckTSExt2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVWingMSReach1(const AValue: Double);
begin
  if AValue <> FVWingMSReach1 then begin
    SetModified;
    FVWingMSReach1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVWingMSReach2(const AValue: Double);
begin
  if AValue <> FVWingMSReach2 then begin
    SetModified;
    FVWingMSReach2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVWingTSReach1(const AValue: Double);
begin
  if AValue <> FVWingTSReach1 then begin
    SetModified;
    FVWingTSReach1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TVeeCheckRailInfo.SetVWingTSReach2(const AValue: Double);
begin
  if AValue <> FVWingTSReach2 then begin
    SetModified;
    FVWingTSReach2 := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TVeeCheckRailInfo.RegisterClass;
  TVeeCheckRailInfoOwningList.RegisterClass;
  TVeeCheckRailInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TVeeCheckRailInfo');
end.
