unit AlignmentInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;

{
Talignment_info = record              //  curving and transition info...

(x)  curving_flag: boolean;
  // !!! no longer used 0.77.a !!! True=curved, False=straight.
  // but needed for check on loading older files.
  // - all templates now curved (straight=max_rad).

(x - in TCurve)  trans_flag: boolean;    // True=transition, False=fixed radius curving.

(x - in TCurve)   fixed_rad: double;   // fixed radius mm.
(x - in TCurve)   trans_rad1: double;   // first transition radius mm.
(x - in TCurve)   trans_rad2: double;   // second transition radius mm.
(x - in TCurve)   trans_length: double;   // length of transition mm.
(x - in TCurve)  trans_start: double;   // start of transition mm.
(x)  rad_offset: double;   // curving line offset mm. no longer used

(x)  alignment_byte_1: byte;   // D5 0.81 12-06-05
(x)  alignment_byte_2: byte;   // D5 0.81 12-06-05

(x - in TCurve)   tanh_kmax: double;             // factor for mode 2 slews.
  // !!! double used because only 8 bytes available in existing file format (2 integers).

(x - in TCurve)   slewing_flag: boolean;    // slewing flag.
  cl_only_flag: boolean;
  // draw track centre-line only for bgnd

(x - in TCurve)   slew_type: byte;
  // !!! byte used because only 1 byte available in existing file format 1-11-99.

  dummy_template_flag: boolean;  // 212a

(x - in TCurve)   slew_start: double;// slewing zone start mm.
(x - in TCurve)   slew_length: double; // slewing zone length mm.
(x - in TCurve)   slew_amount: double;  // amount of slew mm.


  cl_options_code_int: integer;            // 206a
  cl_options_custom_offset_ext: double;  // 206a

  // 216a ...

  reminder_flag: boolean;
  reminder_colour: integer;

  reminder_str: string[200];


(x - in TCurve)   spare_float1: double;
(x - in TCurve)   spare_float2: double;
(x - in TCurve)   spare_float3: double;

(x - in TCurve)   spare_int: integer;

end;//record
}

{# class TAlignmentInfo
---
class: TAlignmentInfo
attributes:
- name: drawCentrelineOnly
  type: Boolean
  comment: draw track centre-line only for bgnd
- name: dummyTemplateFlag
  type: Boolean
  comment: dummy templates not part of track plan
- name: reminderFlag
  type: Boolean
- name: reminderColour
  type: Integer
- name: reminderStr
  type: String
...
}

type

  TAlignmentInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FDrawCentrelineOnly: Boolean;
    FDummyTemplateFlag: Boolean;
    FReminderFlag: Boolean;
    FReminderColour: Integer;
    FReminderStr: String;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetDrawCentrelineOnly(const AValue: Boolean);
    procedure SetDummyTemplateFlag(const AValue: Boolean);
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

    // draw track centre-line only for bgnd
    property drawCentrelineOnly: Boolean read FDrawCentrelineOnly write SetDrawCentrelineOnly;

    // dummy templates not part of track plan
    property dummyTemplateFlag: Boolean read FDummyTemplateFlag write SetDummyTemplateFlag;
    property reminderFlag: Boolean read FReminderFlag write SetReminderFlag;
    property reminderColour: Integer read FReminderColour write SetReminderColour;
    property reminderStr: String read FReminderStr write SetReminderStr;
    //# endGenProperty
  end;

  TAlignmentInfoOwningList = class(TOTOwningList<TAlignmentInfo>);
  TAlignmentInfoReferenceList = class(TOTReferenceList<TAlignmentInfo>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TAlignmentInfo }

constructor TAlignmentInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TAlignmentInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TAlignmentInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TAlignmentInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'drawCentrelineOnly' then
    FDrawCentrelineOnly := StrToBoolean(AValue)
  else
  if AName = 'dummyTemplateFlag' then
    FDummyTemplateFlag := StrToBoolean(AValue)
  else
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

procedure TAlignmentInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FDrawCentrelineOnly, sizeof(Boolean));
  AStream.ReadBuffer(FDummyTemplateFlag, sizeof(Boolean));
  AStream.ReadBuffer(FReminderFlag, sizeof(Boolean));
  AStream.ReadBuffer(FReminderColour, sizeof(Integer));
  FReminderStr := AStream.ReadAnsiString;
  //# endGenRestoreVars
  end;

procedure TAlignmentInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FDrawCentrelineOnly, sizeof(Boolean));
  AStream.WriteBuffer(FDummyTemplateFlag, sizeof(Boolean));
  AStream.WriteBuffer(FReminderFlag, sizeof(Boolean));
  AStream.WriteBuffer(FReminderColour, sizeof(Integer));
  AStream.WriteAnsiString(FReminderStr);
  //# endGenSaveVars
  end;
  
procedure TAlignmentInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlBoolean(AEmitter, 'drawCentrelineOnly', FDrawCentrelineOnly);
  SaveYamlBoolean(AEmitter, 'dummyTemplateFlag', FDummyTemplateFlag);
  SaveYamlBoolean(AEmitter, 'reminderFlag', FReminderFlag);
  SaveYamlInteger(AEmitter, 'reminderColour', FReminderColour);
  SaveYamlString(AEmitter, 'reminderStr', FReminderStr);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TAlignmentInfo.SetDrawCentrelineOnly(const AValue: Boolean);
begin
  if AValue <> FDrawCentrelineOnly then begin
    SetModified;
    FDrawCentrelineOnly := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TAlignmentInfo.SetDummyTemplateFlag(const AValue: Boolean);
begin
  if AValue <> FDummyTemplateFlag then begin
    SetModified;
    FDummyTemplateFlag := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TAlignmentInfo.SetReminderFlag(const AValue: Boolean);
begin
  if AValue <> FReminderFlag then begin
    SetModified;
    FReminderFlag := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TAlignmentInfo.SetReminderColour(const AValue: Integer);
begin
  if AValue <> FReminderColour then begin
    SetModified;
    FReminderColour := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TAlignmentInfo.SetReminderStr(const AValue: String);
begin
  if AValue <> FReminderStr then begin
    SetModified;
    FReminderStr := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TAlignmentInfo.RegisterClass;
  TAlignmentInfoOwningList.RegisterClass;
  TAlignmentInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TAlignmentInfo');
end.
