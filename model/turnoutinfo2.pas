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
  HdkCheckRailInfo,
  VeeCheckRailInfo;

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
- name: diamondAutoCode
  type: Integer
  comment: 0=auto, 1=fixed diamond, 2=switch diamond.
- name: bonusTimberCount
  type: Integer
- name: equalizingFixed
  type: Boolean
- name: noTimbering
  type: Boolean
- name: angledOn
  type: Boolean
- name: chairing
  type: Boolean
- name: startDrawX
  type: Double
- name: timberLengthInc
  type: Double
  comment: timbinc timber length step size.
- name: omitSwitchFrontJoints
  type: Boolean
- name: omitSwitchRailJoints
  type: Boolean
- name: omitStockRailJoints
  type: Boolean
- name: omitWingRailJoints
  type: Boolean
- name: omitVeeRailJoints
  type: Boolean
- name: omitKCrossingStockRailJoints
  type: Boolean
- name: diamondSwitchTimbering
  type: Boolean
- name: gaunt
  type: Boolean
- name: diamondProtoTimbering
  type: Boolean
- name: semiDiamond
  type: Boolean
- name: diamondFixed
  type: Boolean
- name: hdkCheckRailInfo
  type: THdkCheckRailInfo
  owns: create
  access: [get]
- name: veeCheckRailInfo
  type: TVeeCheckRailInfo
  owns: create
  access: [get]
- name: turnoutRoadEndX
  type: Double
  comment: length of turnout road from CTRL-1
- name: templateType
  type: String
- name: smallestRadius
  type: Double
  comment: needed for box data -- not loaded to the control
- name: dpx
  type: Double
  comment: needed for ID number creation -- not loaded to the control
- name: ipx
  type: Double
  comment: needed for ID number creation -- not loaded to the control
- name: fpx
  type: Double
  comment: needed for ID number creation -- not loaded to the control
- name: gauntOffsetInches
  type: Double
- name: dxfConnector0
  type: Boolean
  comment: CTRL-0
- name: dxfConnectorT
  type: Boolean
  comment: TEXITP
- name: dxfConnector9
  type: Boolean
  comment: CTRL-9
...
}

type

  TTurnoutInfo2 = class(TOTPersistent)
  private
    //# genMemberVars
    FSwitchInfo: TOID;
    FCrossingInfo: TOID;
    FDiamondAutoCode: Integer;
    FBonusTimberCount: Integer;
    FEqualizingFixed: Boolean;
    FNoTimbering: Boolean;
    FAngledOn: Boolean;
    FChairing: Boolean;
    FStartDrawX: Double;
    FTimberLengthInc: Double;
    FOmitSwitchFrontJoints: Boolean;
    FOmitSwitchRailJoints: Boolean;
    FOmitStockRailJoints: Boolean;
    FOmitWingRailJoints: Boolean;
    FOmitVeeRailJoints: Boolean;
    FOmitKCrossingStockRailJoints: Boolean;
    FDiamondSwitchTimbering: Boolean;
    FGaunt: Boolean;
    FDiamondProtoTimbering: Boolean;
    FSemiDiamond: Boolean;
    FDiamondFixed: Boolean;
    FHdkCheckRailInfo: TOID;
    FVeeCheckRailInfo: TOID;
    FTurnoutRoadEndX: Double;
    FTemplateType: String;
    FSmallestRadius: Double;
    FDpx: Double;
    FIpx: Double;
    FFpx: Double;
    FGauntOffsetInches: Double;
    FDxfConnector0: Boolean;
    FDxfConnectorT: Boolean;
    FDxfConnector9: Boolean;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    function GetSwitchInfo: TSwitchInfo;
    function GetCrossingInfo: TCrossingInfo;
    function GetHdkCheckRailInfo: THdkCheckRailInfo;
    function GetVeeCheckRailInfo: TVeeCheckRailInfo;
    procedure SetDiamondAutoCode(const AValue: Integer);
    procedure SetBonusTimberCount(const AValue: Integer);
    procedure SetEqualizingFixed(const AValue: Boolean);
    procedure SetNoTimbering(const AValue: Boolean);
    procedure SetAngledOn(const AValue: Boolean);
    procedure SetChairing(const AValue: Boolean);
    procedure SetStartDrawX(const AValue: Double);
    procedure SetTimberLengthInc(const AValue: Double);
    procedure SetOmitSwitchFrontJoints(const AValue: Boolean);
    procedure SetOmitSwitchRailJoints(const AValue: Boolean);
    procedure SetOmitStockRailJoints(const AValue: Boolean);
    procedure SetOmitWingRailJoints(const AValue: Boolean);
    procedure SetOmitVeeRailJoints(const AValue: Boolean);
    procedure SetOmitKCrossingStockRailJoints(const AValue: Boolean);
    procedure SetDiamondSwitchTimbering(const AValue: Boolean);
    procedure SetGaunt(const AValue: Boolean);
    procedure SetDiamondProtoTimbering(const AValue: Boolean);
    procedure SetSemiDiamond(const AValue: Boolean);
    procedure SetDiamondFixed(const AValue: Boolean);
    procedure SetTurnoutRoadEndX(const AValue: Double);
    procedure SetTemplateType(const AValue: String);
    procedure SetSmallestRadius(const AValue: Double);
    procedure SetDpx(const AValue: Double);
    procedure SetIpx(const AValue: Double);
    procedure SetFpx(const AValue: Double);
    procedure SetGauntOffsetInches(const AValue: Double);
    procedure SetDxfConnector0(const AValue: Boolean);
    procedure SetDxfConnectorT(const AValue: Boolean);
    procedure SetDxfConnector9(const AValue: Boolean);
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

    // 0=auto, 1=fixed diamond, 2=switch diamond.
    property diamondAutoCode: Integer read FDiamondAutoCode write SetDiamondAutoCode;
    property bonusTimberCount: Integer read FBonusTimberCount write SetBonusTimberCount;
    property equalizingFixed: Boolean read FEqualizingFixed write SetEqualizingFixed;
    property noTimbering: Boolean read FNoTimbering write SetNoTimbering;
    property angledOn: Boolean read FAngledOn write SetAngledOn;
    property chairing: Boolean read FChairing write SetChairing;
    property startDrawX: Double read FStartDrawX write SetStartDrawX;

    // timbinc timber length step size.
    property timberLengthInc: Double read FTimberLengthInc write SetTimberLengthInc;
    property omitSwitchFrontJoints: Boolean read FOmitSwitchFrontJoints write SetOmitSwitchFrontJoints;
    property omitSwitchRailJoints: Boolean read FOmitSwitchRailJoints write SetOmitSwitchRailJoints;
    property omitStockRailJoints: Boolean read FOmitStockRailJoints write SetOmitStockRailJoints;
    property omitWingRailJoints: Boolean read FOmitWingRailJoints write SetOmitWingRailJoints;
    property omitVeeRailJoints: Boolean read FOmitVeeRailJoints write SetOmitVeeRailJoints;
    property omitKCrossingStockRailJoints: Boolean read FOmitKCrossingStockRailJoints write SetOmitKCrossingStockRailJoints;
    property diamondSwitchTimbering: Boolean read FDiamondSwitchTimbering write SetDiamondSwitchTimbering;
    property gaunt: Boolean read FGaunt write SetGaunt;
    property diamondProtoTimbering: Boolean read FDiamondProtoTimbering write SetDiamondProtoTimbering;
    property semiDiamond: Boolean read FSemiDiamond write SetSemiDiamond;
    property diamondFixed: Boolean read FDiamondFixed write SetDiamondFixed;
    property hdkCheckRailInfo: THdkCheckRailInfo read GetHdkCheckRailInfo;
    property veeCheckRailInfo: TVeeCheckRailInfo read GetVeeCheckRailInfo;

    // length of turnout road from CTRL-1
    property turnoutRoadEndX: Double read FTurnoutRoadEndX write SetTurnoutRoadEndX;
    property templateType: String read FTemplateType write SetTemplateType;

    // needed for box data -- not loaded to the control
    property smallestRadius: Double read FSmallestRadius write SetSmallestRadius;

    // needed for ID number creation -- not loaded to the control
    property dpx: Double read FDpx write SetDpx;

    // needed for ID number creation -- not loaded to the control
    property ipx: Double read FIpx write SetIpx;

    // needed for ID number creation -- not loaded to the control
    property fpx: Double read FFpx write SetFpx;
    property gauntOffsetInches: Double read FGauntOffsetInches write SetGauntOffsetInches;

    // CTRL-0
    property dxfConnector0: Boolean read FDxfConnector0 write SetDxfConnector0;

    // TEXITP
    property dxfConnectorT: Boolean read FDxfConnectorT write SetDxfConnectorT;

    // CTRL-9
    property dxfConnector9: Boolean read FDxfConnector9 write SetDxfConnector9;
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
  if AOID = 0 then
    FHdkCheckRailInfo := THdkCheckRailInfo.Create(nil).oid
  else
    FHdkCheckRailInfo := 0;
  if AOID = 0 then
    FVeeCheckRailInfo := TVeeCheckRailInfo.Create(nil).oid
  else
    FVeeCheckRailInfo := 0;
  //# endGenCreate
end;

destructor TTurnoutInfo2.Destroy;
begin
  //# genDestroy
  SetOwned(FSwitchInfo, nil);
  SetOwned(FCrossingInfo, nil);
  SetOwned(FHdkCheckRailInfo, nil);
  SetOwned(FVeeCheckRailInfo, nil);
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
  if AName = 'diamondAutoCode' then
    FDiamondAutoCode := StrToInteger(AValue)
  else
  if AName = 'bonusTimberCount' then
    FBonusTimberCount := StrToInteger(AValue)
  else
  if AName = 'equalizingFixed' then
    FEqualizingFixed := StrToBoolean(AValue)
  else
  if AName = 'noTimbering' then
    FNoTimbering := StrToBoolean(AValue)
  else
  if AName = 'angledOn' then
    FAngledOn := StrToBoolean(AValue)
  else
  if AName = 'chairing' then
    FChairing := StrToBoolean(AValue)
  else
  if AName = 'startDrawX' then
    FStartDrawX := StrToDouble(AValue)
  else
  if AName = 'timberLengthInc' then
    FTimberLengthInc := StrToDouble(AValue)
  else
  if AName = 'omitSwitchFrontJoints' then
    FOmitSwitchFrontJoints := StrToBoolean(AValue)
  else
  if AName = 'omitSwitchRailJoints' then
    FOmitSwitchRailJoints := StrToBoolean(AValue)
  else
  if AName = 'omitStockRailJoints' then
    FOmitStockRailJoints := StrToBoolean(AValue)
  else
  if AName = 'omitWingRailJoints' then
    FOmitWingRailJoints := StrToBoolean(AValue)
  else
  if AName = 'omitVeeRailJoints' then
    FOmitVeeRailJoints := StrToBoolean(AValue)
  else
  if AName = 'omitKCrossingStockRailJoints' then
    FOmitKCrossingStockRailJoints := StrToBoolean(AValue)
  else
  if AName = 'diamondSwitchTimbering' then
    FDiamondSwitchTimbering := StrToBoolean(AValue)
  else
  if AName = 'gaunt' then
    FGaunt := StrToBoolean(AValue)
  else
  if AName = 'diamondProtoTimbering' then
    FDiamondProtoTimbering := StrToBoolean(AValue)
  else
  if AName = 'semiDiamond' then
    FSemiDiamond := StrToBoolean(AValue)
  else
  if AName = 'diamondFixed' then
    FDiamondFixed := StrToBoolean(AValue)
  else
  if AName = 'hdkCheckRailInfo' then
    RestoreYamlObjectOwn(FHdkCheckRailInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'veeCheckRailInfo' then
    RestoreYamlObjectOwn(FVeeCheckRailInfo, StrToInteger(AValue), ALoader)
  else
  if AName = 'turnoutRoadEndX' then
    FTurnoutRoadEndX := StrToDouble(AValue)
  else
  if AName = 'templateType' then
    FTemplateType := StrToString(AValue)
  else
  if AName = 'smallestRadius' then
    FSmallestRadius := StrToDouble(AValue)
  else
  if AName = 'dpx' then
    FDpx := StrToDouble(AValue)
  else
  if AName = 'ipx' then
    FIpx := StrToDouble(AValue)
  else
  if AName = 'fpx' then
    FFpx := StrToDouble(AValue)
  else
  if AName = 'gauntOffsetInches' then
    FGauntOffsetInches := StrToDouble(AValue)
  else
  if AName = 'dxfConnector0' then
    FDxfConnector0 := StrToBoolean(AValue)
  else
  if AName = 'dxfConnectorT' then
    FDxfConnectorT := StrToBoolean(AValue)
  else
  if AName = 'dxfConnector9' then
    FDxfConnector9 := StrToBoolean(AValue)
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
  AStream.ReadBuffer(FDiamondAutoCode, sizeof(Integer));
  AStream.ReadBuffer(FBonusTimberCount, sizeof(Integer));
  AStream.ReadBuffer(FEqualizingFixed, sizeof(Boolean));
  AStream.ReadBuffer(FNoTimbering, sizeof(Boolean));
  AStream.ReadBuffer(FAngledOn, sizeof(Boolean));
  AStream.ReadBuffer(FChairing, sizeof(Boolean));
  AStream.ReadBuffer(FStartDrawX, sizeof(Double));
  AStream.ReadBuffer(FTimberLengthInc, sizeof(Double));
  AStream.ReadBuffer(FOmitSwitchFrontJoints, sizeof(Boolean));
  AStream.ReadBuffer(FOmitSwitchRailJoints, sizeof(Boolean));
  AStream.ReadBuffer(FOmitStockRailJoints, sizeof(Boolean));
  AStream.ReadBuffer(FOmitWingRailJoints, sizeof(Boolean));
  AStream.ReadBuffer(FOmitVeeRailJoints, sizeof(Boolean));
  AStream.ReadBuffer(FOmitKCrossingStockRailJoints, sizeof(Boolean));
  AStream.ReadBuffer(FDiamondSwitchTimbering, sizeof(Boolean));
  AStream.ReadBuffer(FGaunt, sizeof(Boolean));
  AStream.ReadBuffer(FDiamondProtoTimbering, sizeof(Boolean));
  AStream.ReadBuffer(FSemiDiamond, sizeof(Boolean));
  AStream.ReadBuffer(FDiamondFixed, sizeof(Boolean));
  AStream.ReadBuffer(FHdkCheckRailInfo, sizeof(TOID));
  AStream.ReadBuffer(FVeeCheckRailInfo, sizeof(TOID));
  AStream.ReadBuffer(FTurnoutRoadEndX, sizeof(Double));
  FTemplateType := AStream.ReadAnsiString;
  AStream.ReadBuffer(FSmallestRadius, sizeof(Double));
  AStream.ReadBuffer(FDpx, sizeof(Double));
  AStream.ReadBuffer(FIpx, sizeof(Double));
  AStream.ReadBuffer(FFpx, sizeof(Double));
  AStream.ReadBuffer(FGauntOffsetInches, sizeof(Double));
  AStream.ReadBuffer(FDxfConnector0, sizeof(Boolean));
  AStream.ReadBuffer(FDxfConnectorT, sizeof(Boolean));
  AStream.ReadBuffer(FDxfConnector9, sizeof(Boolean));
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
  AStream.WriteBuffer(FDiamondAutoCode, sizeof(Integer));
  AStream.WriteBuffer(FBonusTimberCount, sizeof(Integer));
  AStream.WriteBuffer(FEqualizingFixed, sizeof(Boolean));
  AStream.WriteBuffer(FNoTimbering, sizeof(Boolean));
  AStream.WriteBuffer(FAngledOn, sizeof(Boolean));
  AStream.WriteBuffer(FChairing, sizeof(Boolean));
  AStream.WriteBuffer(FStartDrawX, sizeof(Double));
  AStream.WriteBuffer(FTimberLengthInc, sizeof(Double));
  AStream.WriteBuffer(FOmitSwitchFrontJoints, sizeof(Boolean));
  AStream.WriteBuffer(FOmitSwitchRailJoints, sizeof(Boolean));
  AStream.WriteBuffer(FOmitStockRailJoints, sizeof(Boolean));
  AStream.WriteBuffer(FOmitWingRailJoints, sizeof(Boolean));
  AStream.WriteBuffer(FOmitVeeRailJoints, sizeof(Boolean));
  AStream.WriteBuffer(FOmitKCrossingStockRailJoints, sizeof(Boolean));
  AStream.WriteBuffer(FDiamondSwitchTimbering, sizeof(Boolean));
  AStream.WriteBuffer(FGaunt, sizeof(Boolean));
  AStream.WriteBuffer(FDiamondProtoTimbering, sizeof(Boolean));
  AStream.WriteBuffer(FSemiDiamond, sizeof(Boolean));
  AStream.WriteBuffer(FDiamondFixed, sizeof(Boolean));
  AStream.WriteBuffer(FHdkCheckRailInfo, sizeof(TOID));
  AStream.WriteBuffer(FVeeCheckRailInfo, sizeof(TOID));
  AStream.WriteBuffer(FTurnoutRoadEndX, sizeof(Double));
  AStream.WriteAnsiString(FTemplateType);
  AStream.WriteBuffer(FSmallestRadius, sizeof(Double));
  AStream.WriteBuffer(FDpx, sizeof(Double));
  AStream.WriteBuffer(FIpx, sizeof(Double));
  AStream.WriteBuffer(FFpx, sizeof(Double));
  AStream.WriteBuffer(FGauntOffsetInches, sizeof(Double));
  AStream.WriteBuffer(FDxfConnector0, sizeof(Boolean));
  AStream.WriteBuffer(FDxfConnectorT, sizeof(Boolean));
  AStream.WriteBuffer(FDxfConnector9, sizeof(Boolean));
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
  SaveYamlInteger(AEmitter, 'diamondAutoCode', FDiamondAutoCode);
  SaveYamlInteger(AEmitter, 'bonusTimberCount', FBonusTimberCount);
  SaveYamlBoolean(AEmitter, 'equalizingFixed', FEqualizingFixed);
  SaveYamlBoolean(AEmitter, 'noTimbering', FNoTimbering);
  SaveYamlBoolean(AEmitter, 'angledOn', FAngledOn);
  SaveYamlBoolean(AEmitter, 'chairing', FChairing);
  SaveYamlDouble(AEmitter, 'startDrawX', FStartDrawX);
  SaveYamlDouble(AEmitter, 'timberLengthInc', FTimberLengthInc);
  SaveYamlBoolean(AEmitter, 'omitSwitchFrontJoints', FOmitSwitchFrontJoints);
  SaveYamlBoolean(AEmitter, 'omitSwitchRailJoints', FOmitSwitchRailJoints);
  SaveYamlBoolean(AEmitter, 'omitStockRailJoints', FOmitStockRailJoints);
  SaveYamlBoolean(AEmitter, 'omitWingRailJoints', FOmitWingRailJoints);
  SaveYamlBoolean(AEmitter, 'omitVeeRailJoints', FOmitVeeRailJoints);
  SaveYamlBoolean(AEmitter, 'omitKCrossingStockRailJoints', FOmitKCrossingStockRailJoints);
  SaveYamlBoolean(AEmitter, 'diamondSwitchTimbering', FDiamondSwitchTimbering);
  SaveYamlBoolean(AEmitter, 'gaunt', FGaunt);
  SaveYamlBoolean(AEmitter, 'diamondProtoTimbering', FDiamondProtoTimbering);
  SaveYamlBoolean(AEmitter, 'semiDiamond', FSemiDiamond);
  SaveYamlBoolean(AEmitter, 'diamondFixed', FDiamondFixed);
  SaveYamlObject(AEmitter, 'hdkCheckRailInfo', FHdkCheckRailInfo);
  SaveYamlObject(AEmitter, 'veeCheckRailInfo', FVeeCheckRailInfo);
  SaveYamlDouble(AEmitter, 'turnoutRoadEndX', FTurnoutRoadEndX);
  SaveYamlString(AEmitter, 'templateType', FTemplateType);
  SaveYamlDouble(AEmitter, 'smallestRadius', FSmallestRadius);
  SaveYamlDouble(AEmitter, 'dpx', FDpx);
  SaveYamlDouble(AEmitter, 'ipx', FIpx);
  SaveYamlDouble(AEmitter, 'fpx', FFpx);
  SaveYamlDouble(AEmitter, 'gauntOffsetInches', FGauntOffsetInches);
  SaveYamlBoolean(AEmitter, 'dxfConnector0', FDxfConnector0);
  SaveYamlBoolean(AEmitter, 'dxfConnectorT', FDxfConnectorT);
  SaveYamlBoolean(AEmitter, 'dxfConnector9', FDxfConnector9);
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

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDiamondAutoCode(const AValue: Integer);
begin
  if AValue <> FDiamondAutoCode then begin
    SetModified;
    FDiamondAutoCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetBonusTimberCount(const AValue: Integer);
begin
  if AValue <> FBonusTimberCount then begin
    SetModified;
    FBonusTimberCount := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetEqualizingFixed(const AValue: Boolean);
begin
  if AValue <> FEqualizingFixed then begin
    SetModified;
    FEqualizingFixed := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetNoTimbering(const AValue: Boolean);
begin
  if AValue <> FNoTimbering then begin
    SetModified;
    FNoTimbering := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetAngledOn(const AValue: Boolean);
begin
  if AValue <> FAngledOn then begin
    SetModified;
    FAngledOn := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetChairing(const AValue: Boolean);
begin
  if AValue <> FChairing then begin
    SetModified;
    FChairing := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetStartDrawX(const AValue: Double);
begin
  if AValue <> FStartDrawX then begin
    SetModified;
    FStartDrawX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetTimberLengthInc(const AValue: Double);
begin
  if AValue <> FTimberLengthInc then begin
    SetModified;
    FTimberLengthInc := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetOmitSwitchFrontJoints(const AValue: Boolean);
begin
  if AValue <> FOmitSwitchFrontJoints then begin
    SetModified;
    FOmitSwitchFrontJoints := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetOmitSwitchRailJoints(const AValue: Boolean);
begin
  if AValue <> FOmitSwitchRailJoints then begin
    SetModified;
    FOmitSwitchRailJoints := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetOmitStockRailJoints(const AValue: Boolean);
begin
  if AValue <> FOmitStockRailJoints then begin
    SetModified;
    FOmitStockRailJoints := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetOmitWingRailJoints(const AValue: Boolean);
begin
  if AValue <> FOmitWingRailJoints then begin
    SetModified;
    FOmitWingRailJoints := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetOmitVeeRailJoints(const AValue: Boolean);
begin
  if AValue <> FOmitVeeRailJoints then begin
    SetModified;
    FOmitVeeRailJoints := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetOmitKCrossingStockRailJoints(const AValue: Boolean);
begin
  if AValue <> FOmitKCrossingStockRailJoints then begin
    SetModified;
    FOmitKCrossingStockRailJoints := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDiamondSwitchTimbering(const AValue: Boolean);
begin
  if AValue <> FDiamondSwitchTimbering then begin
    SetModified;
    FDiamondSwitchTimbering := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetGaunt(const AValue: Boolean);
begin
  if AValue <> FGaunt then begin
    SetModified;
    FGaunt := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDiamondProtoTimbering(const AValue: Boolean);
begin
  if AValue <> FDiamondProtoTimbering then begin
    SetModified;
    FDiamondProtoTimbering := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetSemiDiamond(const AValue: Boolean);
begin
  if AValue <> FSemiDiamond then begin
    SetModified;
    FSemiDiamond := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDiamondFixed(const AValue: Boolean);
begin
  if AValue <> FDiamondFixed then begin
    SetModified;
    FDiamondFixed := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
function TTurnoutInfo2.GetHdkCheckRailInfo: THdkCheckRailInfo;
begin
  Result := THdkCheckRailInfo(FromOID(FHdkCheckRailInfo));
end;

// GENERATED METHOD - DO NOT EDIT
function TTurnoutInfo2.GetVeeCheckRailInfo: TVeeCheckRailInfo;
begin
  Result := TVeeCheckRailInfo(FromOID(FVeeCheckRailInfo));
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetTurnoutRoadEndX(const AValue: Double);
begin
  if AValue <> FTurnoutRoadEndX then begin
    SetModified;
    FTurnoutRoadEndX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetTemplateType(const AValue: String);
begin
  if AValue <> FTemplateType then begin
    SetModified;
    FTemplateType := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetSmallestRadius(const AValue: Double);
begin
  if AValue <> FSmallestRadius then begin
    SetModified;
    FSmallestRadius := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDpx(const AValue: Double);
begin
  if AValue <> FDpx then begin
    SetModified;
    FDpx := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetIpx(const AValue: Double);
begin
  if AValue <> FIpx then begin
    SetModified;
    FIpx := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetFpx(const AValue: Double);
begin
  if AValue <> FFpx then begin
    SetModified;
    FFpx := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetGauntOffsetInches(const AValue: Double);
begin
  if AValue <> FGauntOffsetInches then begin
    SetModified;
    FGauntOffsetInches := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDxfConnector0(const AValue: Boolean);
begin
  if AValue <> FDxfConnector0 then begin
    SetModified;
    FDxfConnector0 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDxfConnectorT(const AValue: Boolean);
begin
  if AValue <> FDxfConnectorT then begin
    SetModified;
    FDxfConnectorT := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TTurnoutInfo2.SetDxfConnector9(const AValue: Boolean);
begin
  if AValue <> FDxfConnector9 then begin
    SetModified;
    FDxfConnector9 := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TTurnoutInfo2.RegisterClass;
  TTurnoutInfo2OwningList.RegisterClass;
  TTurnoutInfo2ReferenceList.RegisterClass;

  //log := Logger.GetInstance('TTurnoutInfo2');
end.
