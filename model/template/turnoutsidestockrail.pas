unit TurnoutsideStockRail;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Feature,
  ProtoInfo;


{# class TTurnoutsideStockRail
---
class: TTurnoutsideStockRail
attributes:
- name: protoInfo
  type: TProtoInfo
  owns: ref
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TTurnoutsideStockRail = class(TFeature)
  private
    //# genMemberVars
    FProtoInfo: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetProtoInfo: TProtoInfo;
    procedure SetProtoInfo(const AValue: TProtoInfo);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property protoInfo: TProtoInfo read GetProtoInfo write SetProtoInfo;
    //# endGenProperty
  end;

  TTurnoutsideStockRailOwningList = class(TOTOwningList<TTurnoutsideStockRail>);
  TTurnoutsideStockRailReferenceList = class(TOTReferenceList<TTurnoutsideStockRail>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TTurnoutsideStockRail }

constructor TTurnoutsideStockRail.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  FProtoInfo := 0;
  //# endGenCreate
end;

destructor TTurnoutsideStockRail.Destroy;
begin
  //# genDestroy
  SetReference(FProtoInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutsideStockRail.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TTurnoutsideStockRail.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'protoInfo' then
    RestoreYamlObjectRef(FProtoInfo, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTurnoutsideStockRail.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FProtoInfo, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TTurnoutsideStockRail.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FProtoInfo, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TTurnoutsideStockRail.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObjectReference(AEmitter, 'protoInfo', FProtoInfo);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TTurnoutsideStockRail.GetProtoInfo: TProtoInfo;
begin
  Result := TProtoInfo(FromOID(FProtoInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutsideStockRail.SetProtoInfo(const AValue: TProtoInfo);
begin
  SetReference(FProtoInfo, AValue);
end;

//# endGenGetSetMethods

initialization
  TTurnoutsideStockRail.RegisterClass;
  TTurnoutsideStockRailOwningList.RegisterClass;
  TTurnoutsideStockRailReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutsideStockRail');
end.
