unit Centreline;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  Feature;


{# class TCentreline
---
class: TCentreline
attributes:
  - name: option
    type: TCentrelineOption
  - name: customOffset
    type: Double
...
}

type

  TCentrelineOption = (cloMainSideSleeperEnds, cloMainSideTrack, cloMainSideDouble,
    cloNormal, cloTurnoutSideDouble, cloTurnoutSideTrack, cloTurnoutSideSleeperEnds, cloCustom);

  TCentreline = class(TFeature)
  private
    //# genMemberVars
    FOption: TCentrelineOption;
    FCustomOffset: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream: TStream); override;
    procedure SaveAttributes(AStream: TStream); override;

    //# genGetSetDeclarations
    procedure SetOption(const AValue: TCentrelineOption);
    procedure SetCustomOffset(const AValue: Double);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure RestoreYamlAttribute(AName, AValue: String; AIndex: Integer;
      ALoader: TOTPersistentLoader); override;
    procedure SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property option: TCentrelineOption Read FOption Write SetOption;
    property customOffset: Double Read FCustomOffset Write SetCustomOffset;
    //# endGenProperty
  end;

  TCentrelineOwningList = class(TOTOwningList<TCentreline>);
  TCentrelineReferenceList = class(TOTReferenceList<TCentreline>);

function StrToTCentrelineOption(AValue: String): TCentrelineOption;
procedure SaveYamlTCentrelineOption(AEmitter: TYamlEmitter; const AName: String;
  AValue: TCentrelineOption);


implementation

uses
  TLoggerUnit,
  Typinfo;

var
  log: ILogger;

function StrToTCentrelineOption(AValue: String): TCentrelineOption;
begin
  Result := TCentrelineOption(GetEnumValue(TypeInfo(TCentrelineOption), AValue));
end;

procedure SaveYamlTCentrelineOption(AEmitter: TYamlEmitter; const AName: String;
  AValue: TCentrelineOption);
begin
  SaveYamlString(AEmitter, AName, GetEnumName(TypeInfo(TCentrelineOption), Ord(AValue)));
end;

{ TCentreline }

constructor TCentreline.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TCentreline.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TCentreline.Calculate;
begin
  // Add your calculation code here, and cache the results...
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

//# endGenGetSetMethods

initialization
  TCentreline.RegisterClass;
  TCentrelineOwningList.RegisterClass;
  TCentrelineReferenceList.RegisterClass;

  //log := Logger.GetInstance('TCentreline');
end.
