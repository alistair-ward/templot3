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
  template_records;


{# class TTemplate
---
class: TTemplate
attributes:
  - name: name
    type: String
  - name: memo
    type: String
  - name: curve
    type: TCurve
    owns: create
...
}

type

  TTemplate = class(TOTPersistent)
  private
    //# genMemberVars
    FName: String;
    FMemo: String;
    FCurve: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetCurve: TCurve;
    procedure SetName(const AValue: String);
    procedure SetMemo(const AValue: String);
    procedure SetCurve(const AValue: TCurve);
    //# endGenGetSetDeclarations

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

    template_info: Ttemplate_info;    // the template data.

    bgnd_keep: Tbgnd_keep;    // drawn data for a background template.

    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property name: String read FName write SetName;
    property memo: String read FMemo write SetMemo;
    property curve: TCurve read GetCurve write SetCurve;
    //# endGenProperty
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
  //# endGenCreate
end;

destructor TTemplate.Destroy;
begin
  //# genDestroy
  SetOwned(FCurve, nil);
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
  if AName = 'memo' then
    FMemo := StrToString(AValue)
  else
  if AName = 'curve' then
    RestoreYamlObjectOwn(FCurve, StrToInteger(AValue), ALoader)
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
  FMemo := AStream.ReadAnsiString;
  AStream.ReadBuffer(FCurve, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TTemplate.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteAnsiString(FName);
  AStream.WriteAnsiString(FMemo);
  AStream.WriteBuffer(FCurve, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TTemplate.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlString(AEmitter, 'name', FName);
  SaveYamlString(AEmitter, 'memo', FMemo);
  SaveYamlObject(AEmitter, 'curve', FCurve);
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
procedure TTemplate.SetCurve(const AValue: TCurve);
begin
  SetOwned(FCurve, AValue);
end;

//# endGenGetSetMethods

initialization
  TTemplate.RegisterClass;
  TTemplateOwningList.RegisterClass;
  TTemplateReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTemplate');
end.
