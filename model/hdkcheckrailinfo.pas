unit HdkCheckRailInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;

{
Thdk_check_rail_info = record         // K-crossing check and wing rail lengths. 0.79.a

  k_check_ms_1: double;
  // full-size inches - size 1 MS k-crossing check rail length.
  k_check_ms_2: double;
  // full-size inches - size 2 MS k-crossing check rail length.

  k_check_ds_1: double;
  // full-size inches - size 1 DS k-crossing check rail length.
  k_check_ds_2: double;
  // full-size inches - size 2 DS k-crossing check rail length.
end;
}

{# class THdkCheckRailInfo
---
class: THdkCheckRailInfo
attributes:
- name: kCheckMS1
  type: Double
  comment: full-size inches - size 1 MS k-crossing check rail length.
- name: kCheckMS2
  type: Double
  comment: full-size inches - size 2 MS k-crossing check rail length.
- name: kCheckDS1
  type: Double
  comment: full-size inches - size 1 DS k-crossing check rail length.
- name: kCheckDS2
  type: Double
  comment: full-size inches - size 2 DS k-crossing check rail length.
...
}

type

  THdkCheckRailInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FKCheckMS1: Double;
    FKCheckMS2: Double;
    FKCheckDS1: Double;
    FKCheckDS2: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetKCheckMS1(const AValue: Double);
    procedure SetKCheckMS2(const AValue: Double);
    procedure SetKCheckDS1(const AValue: Double);
    procedure SetKCheckDS2(const AValue: Double);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty

    // full-size inches - size 1 MS k-crossing check rail length.
    property kCheckMS1: Double read FKCheckMS1 write SetKCheckMS1;

    // full-size inches - size 2 MS k-crossing check rail length.
    property kCheckMS2: Double read FKCheckMS2 write SetKCheckMS2;

    // full-size inches - size 1 DS k-crossing check rail length.
    property kCheckDS1: Double read FKCheckDS1 write SetKCheckDS1;

    // full-size inches - size 2 DS k-crossing check rail length.
    property kCheckDS2: Double read FKCheckDS2 write SetKCheckDS2;
    //# endGenProperty
  end;

  THdkCheckRailInfoOwningList = class(TOTOwningList<THdkCheckRailInfo>);
  THdkCheckRailInfoReferenceList = class(TOTReferenceList<THdkCheckRailInfo>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ THdkCheckRailInfo }

constructor THdkCheckRailInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor THdkCheckRailInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure THdkCheckRailInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure THdkCheckRailInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'kCheckMS1' then
    FKCheckMS1 := StrToDouble(AValue)
  else
  if AName = 'kCheckMS2' then
    FKCheckMS2 := StrToDouble(AValue)
  else
  if AName = 'kCheckDS1' then
    FKCheckDS1 := StrToDouble(AValue)
  else
  if AName = 'kCheckDS2' then
    FKCheckDS2 := StrToDouble(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure THdkCheckRailInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FKCheckMS1, sizeof(Double));
  AStream.ReadBuffer(FKCheckMS2, sizeof(Double));
  AStream.ReadBuffer(FKCheckDS1, sizeof(Double));
  AStream.ReadBuffer(FKCheckDS2, sizeof(Double));
  //# endGenRestoreVars
  end;

procedure THdkCheckRailInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FKCheckMS1, sizeof(Double));
  AStream.WriteBuffer(FKCheckMS2, sizeof(Double));
  AStream.WriteBuffer(FKCheckDS1, sizeof(Double));
  AStream.WriteBuffer(FKCheckDS2, sizeof(Double));
  //# endGenSaveVars
  end;
  
procedure THdkCheckRailInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlDouble(AEmitter, 'kCheckMS1', FKCheckMS1);
  SaveYamlDouble(AEmitter, 'kCheckMS2', FKCheckMS2);
  SaveYamlDouble(AEmitter, 'kCheckDS1', FKCheckDS1);
  SaveYamlDouble(AEmitter, 'kCheckDS2', FKCheckDS2);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure THdkCheckRailInfo.SetKCheckMS1(const AValue: Double);
begin
  if AValue <> FKCheckMS1 then begin
    SetModified;
    FKCheckMS1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure THdkCheckRailInfo.SetKCheckMS2(const AValue: Double);
begin
  if AValue <> FKCheckMS2 then begin
    SetModified;
    FKCheckMS2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure THdkCheckRailInfo.SetKCheckDS1(const AValue: Double);
begin
  if AValue <> FKCheckDS1 then begin
    SetModified;
    FKCheckDS1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure THdkCheckRailInfo.SetKCheckDS2(const AValue: Double);
begin
  if AValue <> FKCheckDS2 then begin
    SetModified;
    FKCheckDS2 := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  THdkCheckRailInfo.RegisterClass;
  THdkCheckRailInfoOwningList.RegisterClass;
  THdkCheckRailInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('THdkCheckRailInfo');
end.
