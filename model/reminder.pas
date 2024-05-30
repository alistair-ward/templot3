unit Reminder;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{# class TReminder
---
class: TReminder
attributes:
- name: reminderFlag
  type: Boolean
- name: reminderColour
  type: Integer
- name: reminderStr
  type: String
...
}

type

  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TReminder = class(TOTPersistent)
  private
    //# genMemberVars
    FReminderFlag: Boolean;
    FReminderColour: Integer;
    FReminderStr: String;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetReminderFlag(const AValue: Boolean);
    procedure SetReminderColour(const AValue: Integer);
    procedure SetReminderStr(const AValue: String);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property reminderFlag: Boolean read FReminderFlag write SetReminderFlag;
    property reminderColour: Integer read FReminderColour write SetReminderColour;
    property reminderStr: String read FReminderStr write SetReminderStr;
    //# endGenProperty
  end;

  TReminderOwningList = class(TOTOwningList<TReminder>);
  TReminderReferenceList = class(TOTReferenceList<TReminder>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TReminder }

constructor TReminder.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TReminder.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TReminder.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TReminder.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'reminderFlag' then
    FReminderFlag := StrToBoolean(AValue)
  else
  if AName = 'reminderColour' then
    FReminderColour := StrToInteger(AValue)
  else
  if AName = 'reminderStr' then
    FReminderStr := StrToString(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TReminder.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FReminderFlag, sizeof(Boolean));
  AStream.ReadBuffer(FReminderColour, sizeof(Integer));
  FReminderStr := AStream.ReadAnsiString;
  //# endGenRestoreVars
  end;

procedure TReminder.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FReminderFlag, sizeof(Boolean));
  AStream.WriteBuffer(FReminderColour, sizeof(Integer));
  AStream.WriteAnsiString(FReminderStr);
  //# endGenSaveVars
  end;
  
procedure TReminder.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlBoolean(AEmitter, 'reminderFlag', FReminderFlag);
  SaveYamlInteger(AEmitter, 'reminderColour', FReminderColour);
  SaveYamlString(AEmitter, 'reminderStr', FReminderStr);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TReminder.SetReminderFlag(const AValue: Boolean);
begin
  if AValue <> FReminderFlag then begin
    SetModified;
    FReminderFlag := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TReminder.SetReminderColour(const AValue: Integer);
begin
  if AValue <> FReminderColour then begin
    SetModified;
    FReminderColour := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TReminder.SetReminderStr(const AValue: String);
begin
  if AValue <> FReminderStr then begin
    SetModified;
    FReminderStr := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TReminder.RegisterClass;
  TReminderOwningList.RegisterClass;
  TReminderReferenceList.RegisterClass;

  //log := Logger.GetInstance('TReminder');
end.
