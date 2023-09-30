unit TurnoutInfo2;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  SwitchInfo,
  CrossingInfo,
  PlainTrackInfo;

{
Tturnout_info2 = record
(/)  switch_info: Tswitch_info;      //  all the switch dimensions.
(/)  crossing_info: Tcrossing_info;    //  all the crossing dimensions.
(/)  plain_track_info: Tplain_track_info;
  //  need the plain track info for approach and exit tracks.

  diamond_auto_code: integer;
  // 0.77.a 0=auto, 1=fixed diamond, 2=switch diamond.

  bonus_timber_count: integer;     // 0.76.a number of bonus timbers.

  equalizing_fixed_flag: boolean;
  no_timbering_flag: boolean;

  angled_on_flag: boolean;

  chairing_flag: boolean;          // 214a    //spare_flag2:boolean;

  start_draw_x: double;  // startx.

  timber_length_inc: double;     // timbinc timber length step size.

  //------
  omit_switch_front_joints: boolean;  // 0.79.a spare_float1:double;...
  omit_switch_rail_joints: boolean;
  omit_stock_rail_joints: boolean;
  omit_wing_rail_joints: boolean;
  omit_vee_rail_joints: boolean;
  omit_k_crossing_stock_rail_joints: boolean;

  spare_flag14: boolean;
  spare_flag13: boolean;
  spare_flag12: boolean;

  diamond_switch_timbering_flag: boolean;  // 213a spare_flag11:boolean;

  //------


  gaunt_flag: boolean;    // True = gaunt template 0.81.a   //spare_flag10:boolean;

  diamond_proto_timbering_flag: boolean;    // 0.77.b

  semi_diamond_flag: boolean;      // True = half-diamond template.
  diamond_fixed_flag: boolean;     // True = fixed-diamond.


  hdk_check_rail_info: Thdk_check_rail_info;

  vee_check_rail_info: Tvee_check_rail_info;

  turnout_road_endx_infile: double;
  // 209a length of turnout road from CTRL-1   //spare_float:double;

  // 208c added to aid debugging of box files in text editor (never read):

  template_type_str: string[6];
  // 208c was spare_str[16]        208a was spare_str:string[56]

  smallest_radius_stored: double;
  // 208a needed for box data -- not loaded to the control

  dpx_stored: double;
  // 208a needed for ID number creation -- not loaded to the control
  ipx_stored: double;
  // 208a needed for ID number creation -- not loaded to the control
  fpx_stored: double;
  // 208a needed for ID number creation -- not loaded to the control


  gaunt_offset_inches: double;  // 0.81

  // 219a  include connectors for XTrackCAD in export DXF file  -- not loaded to the control  ...

  dxf_connector_0: boolean;
  // CTRL-0   // alignment_byte_1:byte;   // D5 0.81 12-06-05
  dxf_connector_t: boolean;
  // TEXITP   // alignment_byte_2:byte;   // D5 0.81 12-06-05
  dxf_connector_9: boolean;
  // CTRL-9   // alignment_byte_3:byte;   // D5 0.81 12-06-05

end;//Tturnout_info2 record
}

{# class TTurnoutInfo2
---
class: TTurnoutInfo2
attributes:
- name: switchInfo
  type: TSwitchInfo
  owns: create
  access: [get]
- name: crossingInfo
  type: TCrossingInfo
  owns: create
  access: [get]
- name: plainTrackInfo
  type: TPlainTrackInfo
  comment: need the plain track info for approach and exit tracks.
...
}

type

  TTurnoutInfo2 = class(TOTPersistent)
  private
    //# genMemberVars
    FSwitchInfo: TOID;
    FCrossingInfo: TOID;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetSwitchInfo: TSwitchInfo;
    function GetCrossingInfo: TCrossingInfo;
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty
    property switchInfo: TSwitchInfo read GetSwitchInfo;
    property crossingInfo: TCrossingInfo read GetCrossingInfo;
    //# endGenProperty
  end;

  TTurnoutInfo2OwningList = class(TOTOwningList<TTurnoutInfo2>);
  TTurnoutInfo2ReferenceList = class(TOTReferenceList<TTurnoutInfo2>);


implementation

uses
  TLoggerUnit;

var
  log : ILogger;


{ TTurnoutInfo2 }

constructor TTurnoutInfo2.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  if AOID = 0 then
    FSwitchInfo := TSwitchInfo.Create(nil).oid
  else
    FSwitchInfo := 0;
  if AOID = 0 then
    FCrossingInfo := TCrossingInfo.Create(nil).oid
  else
    FCrossingInfo := 0;
  //# endGenCreate
end;

destructor TTurnoutInfo2.Destroy;
begin
  //# genDestroy
  SetOwned(FSwitchInfo, nil);
  SetOwned(FCrossingInfo, nil);
  //# endGenDestroy
  inherited;
end;

procedure TTurnoutInfo2.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TTurnoutInfo2.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'switchInfo' then
    RestoreYamlObjectOwn(FSwitchInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'crossingInfo' then
    RestoreYamlObjectOwn(FCrossingInfo, StrToInteger(AValue), ALoader)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TTurnoutInfo2.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FSwitchInfo, sizeof(TOID));
  AStream.ReadBuffer(FCrossingInfo, sizeof(TOID));
  //# endGenRestoreVars
  end;

procedure TTurnoutInfo2.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FSwitchInfo, sizeof(TOID));
  AStream.WriteBuffer(FCrossingInfo, sizeof(TOID));
  //# endGenSaveVars
  end;
  
procedure TTurnoutInfo2.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlObject(AEmitter, 'switchInfo', FSwitchInfo);
  SaveYamlObject(AEmitter, 'crossingInfo', FCrossingInfo);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
function TTurnoutInfo2.GetSwitchInfo: TSwitchInfo;
begin
  Result := TSwitchInfo(FromOID(FSwitchInfo));
end;

// GENERATED METHOD - DO NOT EDIT
function TTurnoutInfo2.GetCrossingInfo: TCrossingInfo;
begin
  Result := TCrossingInfo(FromOID(FCrossingInfo));
end;

//# endGenGetSetMethods

initialization
  TTurnoutInfo2.RegisterClass;
  TTurnoutInfo2OwningList.RegisterClass;
  TTurnoutInfo2ReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutInfo2');
end.
