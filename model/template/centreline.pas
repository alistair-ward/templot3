unit Centreline;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Feature,
  TurnoutInfo1,
  ProtoInfo;


{# enum TCentrelineOption
---
enum: TCentrelineOption
values:
- cloMainSideSleeperEnds
- cloMainSideTrack
- cloMainSideDouble
- cloNormal
- cloTurnoutSideDouble
- cloTurnoutSideTrack
- cloTurnoutSideSleeperEnds
- cloCustom
...
}

{# class TCentreline
---
class: TCentreline
attributes:
  - name: option
    type: TCentrelineOption
  - name: customOffset
    type: Double
  - name: protoInfo
    type: TProtoInfo
    owns: ref
...
}

type

  //# genEnumDeclarations
  TCentrelineOption = (
    cloMainSideSleeperEnds,
    cloMainSideTrack,
    cloMainSideDouble,
    cloNormal,
    cloTurnoutSideDouble,
    cloTurnoutSideTrack,
    cloTurnoutSideSleeperEnds,
    cloCustom
    );

  //# endGenEnumDeclarations

  TCentreline = class(TFeature)
  private
    //# genMemberVars
    FOption: TCentrelineOption;
    FCustomOffset: Double;
    FProtoInfo: TOID;
    //# endGenMemberVars

    FCentrelineOffset: Double;

    function CalculateCentrelineOffset: Double;

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    function GetProtoInfo: TProtoInfo;
    procedure SetOption(const AValue: TCentrelineOption);
    procedure SetCustomOffset(const AValue: Double);
    procedure SetProtoInfo(const AValue: TProtoInfo);
    //# endGenGetSetDeclarations

    function GetCentrelineOffset: Double;

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
      ALoader: TOTPersistentLoader); override;
    procedure SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property option: TCentrelineOption read FOption write SetOption;
    property customOffset: Double read FCustomOffset write SetCustomOffset;
    property protoInfo: TProtoInfo read GetProtoInfo write SetProtoInfo;
    //# endGenProperty

    property centrelineOffset: Double Read GetCentrelineOffset;
  end;

  TCentrelineOwningList = class(TOTOwningList<TCentreline>);
  TCentrelineReferenceList = class(TOTReferenceList<TCentreline>);

//# genEnumSerialDeclarations
  function StrToTCentrelineOption(AValue: String): TCentrelineOption;
  procedure SaveYamlTCentrelineOption(AEmitter: TYamlEmitter; const AName: String;
    AValue: TCentrelineOption);

//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit,
  Typinfo,
  rail_data_unit,
  line;

var
  log: ILogger;

  //# genEnumSerialMethods
// GENERATED METHOD - DO NOT EDIT
function StrToTCentrelineOption(AValue: String): TCentrelineOption;
begin
  Result := TCentrelineOption(GetEnumValue(TypeInfo(TCentrelineOption), AValue));
end;

// GENERATED METHOD - DO NOT EDIT
procedure SaveYamlTCentrelineOption(AEmitter: TYamlEmitter; const AName: String;
  AValue: TCentrelineOption);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TCentrelineOption), Ord(AValue)));
end;

  //# endGenEnumSerialMethods

{ TCentreline }

constructor TCentreline.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FProtoInfo := 0;
  //# endGenCreate
end;

destructor TCentreline.Destroy;
begin
  //# genDestroy
  SetReference(FProtoInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TCentreline.Calculate;
begin
  // Add your calculation code here, and cache the results...
  inherited;

  SetLength(FMarks, 0);

  FLines.Clear;
  FLines.Add(TLine.Create(rdMainRoadCentreLine));

  FCentrelineOffset := CalculateCentrelineOffset;

  DoStraightLine(FLines[0], 0, turnoutInfo.turnoutLength, FCentrelineOffset);
end;

procedure TCentreline.RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
  ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'option' then
    FOption := StrToTCentrelineOption(AValue)
  else
  if AName = 'customOffset' then
    FCustomOffset := StrToDouble(AValue)
  else
  if AName = 'protoInfo' then
    RestoreYamlObjectRef(FProtoInfo, StrToInteger(AValue), ALoader)
  else
    //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TCentreline.RestoreAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FOption, sizeof(TCentrelineOption));
  AStream.ReadBuffer(FCustomOffset, sizeof(Double));
  AStream.ReadBuffer(FProtoInfo, sizeof(TOID));
  //# endGenRestoreVars
end;

procedure TCentreline.SaveAttributes(AStream: TStream);
var
  i: Integer;
begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FOption, sizeof(TCentrelineOption));
  AStream.WriteBuffer(FCustomOffset, sizeof(Double));
  AStream.WriteBuffer(FProtoInfo, sizeof(TOID));
  //# endGenSaveVars
end;

procedure TCentreline.SaveYamlAttributes(AEmitter: TYamlEmitter);
var
  i: Integer;
begin
  inherited;

  //# genSaveYamlVars
  SaveYamlTCentrelineOption(AEmitter, 'option', FOption);
  SaveYamlDouble(AEmitter, 'customOffset', FCustomOffset);
  SaveYamlObjectReference(AEmitter, 'protoInfo', FProtoInfo);
  //# endGenSaveYamlVars
end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TCentreline.SetOption(const AValue: TCentrelineOption);
begin
  if AValue <> FOption then begin
    SetModified;
    FOption := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCentreline.SetCustomOffset(const AValue: Double);
begin
  if AValue <> FCustomOffset then begin
    SetModified;
    FCustomOffset := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TCentreline.GetProtoInfo: TProtoInfo;
begin
  Result := TProtoInfo(FromOID(FProtoInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCentreline.SetProtoInfo(const AValue: TProtoInfo);
begin
  SetReference(FProtoInfo, AValue);
end;

//# endGenGetSetMethods

function TCentreline.GetCentrelineOffset: Double;
begin
  CheckCalculated;
  Result := FCentrelineOffset;
end;

function TCentreline.CalculateCentrelineOffset: Double;
begin
  case FOption of
    cloMainSideSleeperEnds:
      Result := protoInfo.sleeperLength/2;
    cloMainSideTrack:
      Result := protoInfo.mainSideTrackCentres;
    cloMainSideDouble:
      Result := protoInfo.mainSideTrackCentres/2;
    cloNormal:
      Result := 0;
    cloTurnoutSideDouble:
      Result := -protoInfo.turnoutSideTrackCentres/2;
    cloTurnoutSideTrack:
      Result := -protoInfo.turnoutSideTrackCentres;
    cloTurnoutSideSleeperEnds:
      Result := -protoInfo.sleeperLength/2;
    cloCustom:
      // custom offset if +ve to the turnout side
      Result := -FCustomOffset;
  end;

  if turnoutInfo.hand = thRight then begin
    Result := -Result;
  end;
end;

initialization
  TCentreline.RegisterClass;
  TCentrelineOwningList.RegisterClass;
  TCentrelineReferenceList.RegisterClass;

  //log := Logger.GetInstance('TCentreline');
end.
