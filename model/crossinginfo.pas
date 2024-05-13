unit CrossingInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter,
  TurnoutInfo1;

{
Tcrossing_info = record        // crossing stuff...

  pattern: integer;     // 0=straight, 1=curviform, 2=parallel, -1=generic.

  sl_mode: integer;     // 0=auto_fit, 1=use fixed_sl.
  retcent_mode: integer;
  // 0=return centres as adjacent track, 1=use custom centres.
  k3n_unit_angle: double;    // k3n angle in units.
  fixed_st: double;    // length of knuckle straight. mm.

  spare_int3: integer;

  hd_timbers_code: integer;     // extended half-diamond timbers for slip road.
  hd_vchecks_code: integer;
  // shortening code for half-diamond v-crossing check rails.

  k_check_length_1: double;    // length of size 1 k-crossing check rail (inches).
  k_check_length_2: double;    // length of size 2 k-crossing check rail (inches).
  k_check_mod_ms: double;    // main side modifer.
  k_check_mod_ds: double;    // diamond side modifer.
  k_check_flare: double;    // length of flare on k-crossing check rails.

  curviform_timbering_keep: boolean;
  // 215a                           alignment_byte_1:byte;   // D5 0.81 12-06-05

  alignment_byte_2: byte;   // D5 0.81 12-06-05

  main_road_code: integer;
  //  length of main-side exit road.      //  217a  spare_int2:integer;

  tandem_timber_code: integer;   //   218a      spare_int1:        integer;

  // 0.75.a  9-10-01...

  blunt_nose_width: double;    // full-size inches.
  blunt_nose_to_timb: double;    // full-size inches - to "A" timber centre.

  vee_joint_half_spacing: double;
  // full-size inches - rail overlap at vee point rail joint.
  wing_joint_spacing: double;
  // full-size inches - timber spacing at wing rail joint.

  wing_timber_spacing: double;
  // full-size inches - timber spacing for wing rail front part of crossing (up to "A").
  vee_timber_spacing: double;
  // full-size inches - timber spacing for vee point rail part of crossing (on from "A").

  // number of timbers spanned by vee rail incl. "A" timber.

  vee_joint_space_co1: byte;
  vee_joint_space_co2: byte;
  vee_joint_space_co3: byte;
  vee_joint_space_co4: byte;
  vee_joint_space_co5: byte;
  vee_joint_space_co6: byte;

  // number of timbers spanned by wing rail front excl. "A" timber...

  wing_joint_space_co1: byte;
  wing_joint_space_co2: byte;
  wing_joint_space_co3: byte;
  wing_joint_space_co4: byte;
  wing_joint_space_co5: byte;
  wing_joint_space_co6: byte;

  spare_flag1: boolean;
  spare_flag2: boolean;

  main_road_endx_infile: double;  // 217a

  hdkn_unit_angle: double;    // half-diamond hdkn angle in units.

(x)  check_flare_info_081: Tcheck_flare_info_081;   // not used 0.93.a

  k_custom_wing_long_keep: double;   // 0.95.a inches full-size k-crossing wing rails
  k_custom_point_long_keep: double;
  // 0.95.a inches full-size k-crossing point rails   NYI

  use_k_custom_wing_rails_keep: boolean;   // 0.95.a
  use_k_custom_point_rails_keep: boolean;  // 0.95.a  NYI

  spare_str: string[10];    // 0.95.a was 30

  alignment_byte_3: byte;   // D5 0.81 12-06-05

end;//record
}


{# class TCrossingInfo
---
class: TCrossingInfo
attributes:
- name: pattern
  type: Integer
  comment: 0=straight, 1=curviform, 2=parallel, -1=generic.
- name: slMode
  type: Integer
  comment: 0=auto_fit, 1=use fixed_sl.
- name: returnCentresMode
  type: Integer
  comment: 0=return centres as adjacent track, 1=use custom centres.
- name: k3nUnitAngle
  type: Double
  comment: k3n angle in units.
- name: fixedSt
  type: Double
  comment: length of knuckle straight. mm.
- name: hdTimbersCode
  type: Integer
  comment: extended half-diamond timbers for slip road.
- name: hdVchecksCode
  type: Integer
  comment: shortening code for half-diamond v-crossing check rails.
- name: kCheckLength1
  type: Double
  comment: length of size 1 k-crossing check rail (inches).
- name: kCheckLength2
  type: Double
  comment: length of size 2 k-crossing check rail (inches).
- name: kCheckModMS
  type: Double
  comment: main side modifer.
- name: kCheckModDS
  type: Double
  comment: diamond side modifer.
- name: kCheckFlare
  type: Double
  comment: length of flare on k-crossing check rails.
- name: curviformTimbering
  type: Boolean
- name: mainRoadCode
  type: TMainOrTurnoutRoadLengthOption
  comment: length of main-side exit road.
- name: tandemTimberCode
  type: Integer
- name: bluntNoseWidth
  type: Double
  comment: full-size inches.
- name: bluntNoseToTimber
  type: Double
  comment: full-size inches - to "A" timber centre.
- name: veeJointHalfSpacing
  type: Double
  comment: full-size inches - rail overlap at vee point rail joint.
- name: wingJointSpacing
  type: Double
  comment: full-size inches - timber spacing at wing rail joint.
- name: wingTimberSpacing
  type: Double
  comment: full-size inches - timber spacing for wing rail front part of crossing (up to "A").
- name: veeTimberSpacing
  type: Double
  comment: full-size inches - timber spacing for vee point rail part of crossing (on from "A").
- name: veeJointSpaceCo1
  type: Integer
  comment: number of timbers spanned by vee rail incl. "A" timber.
- name: veeJointSpaceCo2
  type: Integer
  comment: number of timbers spanned by vee rail incl. "A" timber.
- name: veeJointSpaceCo3
  type: Integer
  comment: number of timbers spanned by vee rail incl. "A" timber.
- name: veeJointSpaceCo4
  type: Integer
  comment: number of timbers spanned by vee rail incl. "A" timber.
- name: veeJointSpaceCo5
  type: Integer
  comment: number of timbers spanned by vee rail incl. "A" timber.
- name: veeJointSpaceCo6
  type: Integer
  comment: number of timbers spanned by vee rail incl. "A" timber.
- name: wingJointSpaceCo1
  type: Integer
  comment: number of timbers spanned by wing rail front excl. "A" timber
- name: wingJointSpaceCo2
  type: Integer
  comment: number of timbers spanned by wing rail front excl. "A" timber
- name: wingJointSpaceCo3
  type: Integer
  comment: number of timbers spanned by wing rail front excl. "A" timber
- name: wingJointSpaceCo4
  type: Integer
  comment: number of timbers spanned by wing rail front excl. "A" timber
- name: wingJointSpaceCo5
  type: Integer
  comment: number of timbers spanned by wing rail front excl. "A" timber
- name: wingJointSpaceCo6
  type: Integer
  comment: number of timbers spanned by wing rail front excl. "A" timber
- name: mainRoadEndX
  type: Double
- name: hdkn
  type: Double
  comment: half-diamond hdkn angle in units.
- name: kCustomWingLong
  type: Double
  comment: inches full-size k-crossing wing rails
- name: kCustomPointLong
  type: Double
  comment: inches full-size k-crossing point rails   NYI
- name: useKCustomWingRails
  type: Boolean
- name: useKCustomPointRails
  type: Boolean
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TCrossingInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FPattern: Integer;
    FSlMode: Integer;
    FReturnCentresMode: Integer;
    FK3nUnitAngle: Double;
    FFixedSt: Double;
    FHdTimbersCode: Integer;
    FHdVchecksCode: Integer;
    FKCheckLength1: Double;
    FKCheckLength2: Double;
    FKCheckModMS: Double;
    FKCheckModDS: Double;
    FKCheckFlare: Double;
    FCurviformTimbering: Boolean;
    FMainRoadCode: TMainOrTurnoutRoadLengthOption;
    FTandemTimberCode: Integer;
    FBluntNoseWidth: Double;
    FBluntNoseToTimber: Double;
    FVeeJointHalfSpacing: Double;
    FWingJointSpacing: Double;
    FWingTimberSpacing: Double;
    FVeeTimberSpacing: Double;
    FVeeJointSpaceCo1: Integer;
    FVeeJointSpaceCo2: Integer;
    FVeeJointSpaceCo3: Integer;
    FVeeJointSpaceCo4: Integer;
    FVeeJointSpaceCo5: Integer;
    FVeeJointSpaceCo6: Integer;
    FWingJointSpaceCo1: Integer;
    FWingJointSpaceCo2: Integer;
    FWingJointSpaceCo3: Integer;
    FWingJointSpaceCo4: Integer;
    FWingJointSpaceCo5: Integer;
    FWingJointSpaceCo6: Integer;
    FMainRoadEndX: Double;
    FHdkn: Double;
    FKCustomWingLong: Double;
    FKCustomPointLong: Double;
    FUseKCustomWingRails: Boolean;
    FUseKCustomPointRails: Boolean;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetPattern(const AValue: Integer);
    procedure SetSlMode(const AValue: Integer);
    procedure SetReturnCentresMode(const AValue: Integer);
    procedure SetK3nUnitAngle(const AValue: Double);
    procedure SetFixedSt(const AValue: Double);
    procedure SetHdTimbersCode(const AValue: Integer);
    procedure SetHdVchecksCode(const AValue: Integer);
    procedure SetKCheckLength1(const AValue: Double);
    procedure SetKCheckLength2(const AValue: Double);
    procedure SetKCheckModMS(const AValue: Double);
    procedure SetKCheckModDS(const AValue: Double);
    procedure SetKCheckFlare(const AValue: Double);
    procedure SetCurviformTimbering(const AValue: Boolean);
    procedure SetMainRoadCode(const AValue: TMainOrTurnoutRoadLengthOption);
    procedure SetTandemTimberCode(const AValue: Integer);
    procedure SetBluntNoseWidth(const AValue: Double);
    procedure SetBluntNoseToTimber(const AValue: Double);
    procedure SetVeeJointHalfSpacing(const AValue: Double);
    procedure SetWingJointSpacing(const AValue: Double);
    procedure SetWingTimberSpacing(const AValue: Double);
    procedure SetVeeTimberSpacing(const AValue: Double);
    procedure SetVeeJointSpaceCo1(const AValue: Integer);
    procedure SetVeeJointSpaceCo2(const AValue: Integer);
    procedure SetVeeJointSpaceCo3(const AValue: Integer);
    procedure SetVeeJointSpaceCo4(const AValue: Integer);
    procedure SetVeeJointSpaceCo5(const AValue: Integer);
    procedure SetVeeJointSpaceCo6(const AValue: Integer);
    procedure SetWingJointSpaceCo1(const AValue: Integer);
    procedure SetWingJointSpaceCo2(const AValue: Integer);
    procedure SetWingJointSpaceCo3(const AValue: Integer);
    procedure SetWingJointSpaceCo4(const AValue: Integer);
    procedure SetWingJointSpaceCo5(const AValue: Integer);
    procedure SetWingJointSpaceCo6(const AValue: Integer);
    procedure SetMainRoadEndX(const AValue: Double);
    procedure SetHdkn(const AValue: Double);
    procedure SetKCustomWingLong(const AValue: Double);
    procedure SetKCustomPointLong(const AValue: Double);
    procedure SetUseKCustomWingRails(const AValue: Boolean);
    procedure SetUseKCustomPointRails(const AValue: Boolean);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty

    // 0=straight, 1=curviform, 2=parallel, -1=generic.
    property pattern: Integer read FPattern write SetPattern;

    // 0=auto_fit, 1=use fixed_sl.
    property slMode: Integer read FSlMode write SetSlMode;

    // 0=return centres as adjacent track, 1=use custom centres.
    property returnCentresMode: Integer read FReturnCentresMode write SetReturnCentresMode;

    // k3n angle in units.
    property k3nUnitAngle: Double read FK3nUnitAngle write SetK3nUnitAngle;

    // length of knuckle straight. mm.
    property fixedSt: Double read FFixedSt write SetFixedSt;

    // extended half-diamond timbers for slip road.
    property hdTimbersCode: Integer read FHdTimbersCode write SetHdTimbersCode;

    // shortening code for half-diamond v-crossing check rails.
    property hdVchecksCode: Integer read FHdVchecksCode write SetHdVchecksCode;

    // length of size 1 k-crossing check rail (inches).
    property kCheckLength1: Double read FKCheckLength1 write SetKCheckLength1;

    // length of size 2 k-crossing check rail (inches).
    property kCheckLength2: Double read FKCheckLength2 write SetKCheckLength2;

    // main side modifer.
    property kCheckModMS: Double read FKCheckModMS write SetKCheckModMS;

    // diamond side modifer.
    property kCheckModDS: Double read FKCheckModDS write SetKCheckModDS;

    // length of flare on k-crossing check rails.
    property kCheckFlare: Double read FKCheckFlare write SetKCheckFlare;
    property curviformTimbering: Boolean read FCurviformTimbering write SetCurviformTimbering;

    // length of main-side exit road.
    property mainRoadCode: TMainOrTurnoutRoadLengthOption read FMainRoadCode write SetMainRoadCode;
    property tandemTimberCode: Integer read FTandemTimberCode write SetTandemTimberCode;

    // full-size inches.
    property bluntNoseWidth: Double read FBluntNoseWidth write SetBluntNoseWidth;

    // full-size inches - to "A" timber centre.
    property bluntNoseToTimber: Double read FBluntNoseToTimber write SetBluntNoseToTimber;

    // full-size inches - rail overlap at vee point rail joint.
    property veeJointHalfSpacing: Double read FVeeJointHalfSpacing write SetVeeJointHalfSpacing;

    // full-size inches - timber spacing at wing rail joint.
    property wingJointSpacing: Double read FWingJointSpacing write SetWingJointSpacing;

    // full-size inches - timber spacing for wing rail front part of crossing (up to "A").
    property wingTimberSpacing: Double read FWingTimberSpacing write SetWingTimberSpacing;

    // full-size inches - timber spacing for vee point rail part of crossing (on from "A").
    property veeTimberSpacing: Double read FVeeTimberSpacing write SetVeeTimberSpacing;

    // number of timbers spanned by vee rail incl. "A" timber.
    property veeJointSpaceCo1: Integer read FVeeJointSpaceCo1 write SetVeeJointSpaceCo1;

    // number of timbers spanned by vee rail incl. "A" timber.
    property veeJointSpaceCo2: Integer read FVeeJointSpaceCo2 write SetVeeJointSpaceCo2;

    // number of timbers spanned by vee rail incl. "A" timber.
    property veeJointSpaceCo3: Integer read FVeeJointSpaceCo3 write SetVeeJointSpaceCo3;

    // number of timbers spanned by vee rail incl. "A" timber.
    property veeJointSpaceCo4: Integer read FVeeJointSpaceCo4 write SetVeeJointSpaceCo4;

    // number of timbers spanned by vee rail incl. "A" timber.
    property veeJointSpaceCo5: Integer read FVeeJointSpaceCo5 write SetVeeJointSpaceCo5;

    // number of timbers spanned by vee rail incl. "A" timber.
    property veeJointSpaceCo6: Integer read FVeeJointSpaceCo6 write SetVeeJointSpaceCo6;

    // number of timbers spanned by wing rail front excl. "A" timber
    property wingJointSpaceCo1: Integer read FWingJointSpaceCo1 write SetWingJointSpaceCo1;

    // number of timbers spanned by wing rail front excl. "A" timber
    property wingJointSpaceCo2: Integer read FWingJointSpaceCo2 write SetWingJointSpaceCo2;

    // number of timbers spanned by wing rail front excl. "A" timber
    property wingJointSpaceCo3: Integer read FWingJointSpaceCo3 write SetWingJointSpaceCo3;

    // number of timbers spanned by wing rail front excl. "A" timber
    property wingJointSpaceCo4: Integer read FWingJointSpaceCo4 write SetWingJointSpaceCo4;

    // number of timbers spanned by wing rail front excl. "A" timber
    property wingJointSpaceCo5: Integer read FWingJointSpaceCo5 write SetWingJointSpaceCo5;

    // number of timbers spanned by wing rail front excl. "A" timber
    property wingJointSpaceCo6: Integer read FWingJointSpaceCo6 write SetWingJointSpaceCo6;
    property mainRoadEndX: Double read FMainRoadEndX write SetMainRoadEndX;

    // half-diamond hdkn angle in units.
    property hdkn: Double read FHdkn write SetHdkn;

    // inches full-size k-crossing wing rails
    property kCustomWingLong: Double read FKCustomWingLong write SetKCustomWingLong;

    // inches full-size k-crossing point rails   NYI
    property kCustomPointLong: Double read FKCustomPointLong write SetKCustomPointLong;
    property useKCustomWingRails: Boolean read FUseKCustomWingRails write SetUseKCustomWingRails;
    property useKCustomPointRails: Boolean read FUseKCustomPointRails write SetUseKCustomPointRails;
    //# endGenProperty
  end;

  TCrossingInfoOwningList = class(TOTOwningList<TCrossingInfo>);
  TCrossingInfoReferenceList = class(TOTReferenceList<TCrossingInfo>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TCrossingInfo }

constructor TCrossingInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TCrossingInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TCrossingInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TCrossingInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'pattern' then
    FPattern := StrToInteger(AValue)
  else
  if AName = 'slMode' then
    FSlMode := StrToInteger(AValue)
  else
  if AName = 'returnCentresMode' then
    FReturnCentresMode := StrToInteger(AValue)
  else
  if AName = 'k3nUnitAngle' then
    FK3nUnitAngle := StrToDouble(AValue)
  else
  if AName = 'fixedSt' then
    FFixedSt := StrToDouble(AValue)
  else
  if AName = 'hdTimbersCode' then
    FHdTimbersCode := StrToInteger(AValue)
  else
  if AName = 'hdVchecksCode' then
    FHdVchecksCode := StrToInteger(AValue)
  else
  if AName = 'kCheckLength1' then
    FKCheckLength1 := StrToDouble(AValue)
  else
  if AName = 'kCheckLength2' then
    FKCheckLength2 := StrToDouble(AValue)
  else
  if AName = 'kCheckModMS' then
    FKCheckModMS := StrToDouble(AValue)
  else
  if AName = 'kCheckModDS' then
    FKCheckModDS := StrToDouble(AValue)
  else
  if AName = 'kCheckFlare' then
    FKCheckFlare := StrToDouble(AValue)
  else
  if AName = 'curviformTimbering' then
    FCurviformTimbering := StrToBoolean(AValue)
  else
  if AName = 'mainRoadCode' then
    FMainRoadCode := StrToTMainOrTurnoutRoadLengthOption(AValue)
  else
  if AName = 'tandemTimberCode' then
    FTandemTimberCode := StrToInteger(AValue)
  else
  if AName = 'bluntNoseWidth' then
    FBluntNoseWidth := StrToDouble(AValue)
  else
  if AName = 'bluntNoseToTimber' then
    FBluntNoseToTimber := StrToDouble(AValue)
  else
  if AName = 'veeJointHalfSpacing' then
    FVeeJointHalfSpacing := StrToDouble(AValue)
  else
  if AName = 'wingJointSpacing' then
    FWingJointSpacing := StrToDouble(AValue)
  else
  if AName = 'wingTimberSpacing' then
    FWingTimberSpacing := StrToDouble(AValue)
  else
  if AName = 'veeTimberSpacing' then
    FVeeTimberSpacing := StrToDouble(AValue)
  else
  if AName = 'veeJointSpaceCo1' then
    FVeeJointSpaceCo1 := StrToInteger(AValue)
  else
  if AName = 'veeJointSpaceCo2' then
    FVeeJointSpaceCo2 := StrToInteger(AValue)
  else
  if AName = 'veeJointSpaceCo3' then
    FVeeJointSpaceCo3 := StrToInteger(AValue)
  else
  if AName = 'veeJointSpaceCo4' then
    FVeeJointSpaceCo4 := StrToInteger(AValue)
  else
  if AName = 'veeJointSpaceCo5' then
    FVeeJointSpaceCo5 := StrToInteger(AValue)
  else
  if AName = 'veeJointSpaceCo6' then
    FVeeJointSpaceCo6 := StrToInteger(AValue)
  else
  if AName = 'wingJointSpaceCo1' then
    FWingJointSpaceCo1 := StrToInteger(AValue)
  else
  if AName = 'wingJointSpaceCo2' then
    FWingJointSpaceCo2 := StrToInteger(AValue)
  else
  if AName = 'wingJointSpaceCo3' then
    FWingJointSpaceCo3 := StrToInteger(AValue)
  else
  if AName = 'wingJointSpaceCo4' then
    FWingJointSpaceCo4 := StrToInteger(AValue)
  else
  if AName = 'wingJointSpaceCo5' then
    FWingJointSpaceCo5 := StrToInteger(AValue)
  else
  if AName = 'wingJointSpaceCo6' then
    FWingJointSpaceCo6 := StrToInteger(AValue)
  else
  if AName = 'mainRoadEndX' then
    FMainRoadEndX := StrToDouble(AValue)
  else
  if AName = 'hdkn' then
    FHdkn := StrToDouble(AValue)
  else
  if AName = 'kCustomWingLong' then
    FKCustomWingLong := StrToDouble(AValue)
  else
  if AName = 'kCustomPointLong' then
    FKCustomPointLong := StrToDouble(AValue)
  else
  if AName = 'useKCustomWingRails' then
    FUseKCustomWingRails := StrToBoolean(AValue)
  else
  if AName = 'useKCustomPointRails' then
    FUseKCustomPointRails := StrToBoolean(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TCrossingInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FPattern, sizeof(Integer));
  AStream.ReadBuffer(FSlMode, sizeof(Integer));
  AStream.ReadBuffer(FReturnCentresMode, sizeof(Integer));
  AStream.ReadBuffer(FK3nUnitAngle, sizeof(Double));
  AStream.ReadBuffer(FFixedSt, sizeof(Double));
  AStream.ReadBuffer(FHdTimbersCode, sizeof(Integer));
  AStream.ReadBuffer(FHdVchecksCode, sizeof(Integer));
  AStream.ReadBuffer(FKCheckLength1, sizeof(Double));
  AStream.ReadBuffer(FKCheckLength2, sizeof(Double));
  AStream.ReadBuffer(FKCheckModMS, sizeof(Double));
  AStream.ReadBuffer(FKCheckModDS, sizeof(Double));
  AStream.ReadBuffer(FKCheckFlare, sizeof(Double));
  AStream.ReadBuffer(FCurviformTimbering, sizeof(Boolean));
  AStream.ReadBuffer(FMainRoadCode, sizeof(TMainOrTurnoutRoadLengthOption));
  AStream.ReadBuffer(FTandemTimberCode, sizeof(Integer));
  AStream.ReadBuffer(FBluntNoseWidth, sizeof(Double));
  AStream.ReadBuffer(FBluntNoseToTimber, sizeof(Double));
  AStream.ReadBuffer(FVeeJointHalfSpacing, sizeof(Double));
  AStream.ReadBuffer(FWingJointSpacing, sizeof(Double));
  AStream.ReadBuffer(FWingTimberSpacing, sizeof(Double));
  AStream.ReadBuffer(FVeeTimberSpacing, sizeof(Double));
  AStream.ReadBuffer(FVeeJointSpaceCo1, sizeof(Integer));
  AStream.ReadBuffer(FVeeJointSpaceCo2, sizeof(Integer));
  AStream.ReadBuffer(FVeeJointSpaceCo3, sizeof(Integer));
  AStream.ReadBuffer(FVeeJointSpaceCo4, sizeof(Integer));
  AStream.ReadBuffer(FVeeJointSpaceCo5, sizeof(Integer));
  AStream.ReadBuffer(FVeeJointSpaceCo6, sizeof(Integer));
  AStream.ReadBuffer(FWingJointSpaceCo1, sizeof(Integer));
  AStream.ReadBuffer(FWingJointSpaceCo2, sizeof(Integer));
  AStream.ReadBuffer(FWingJointSpaceCo3, sizeof(Integer));
  AStream.ReadBuffer(FWingJointSpaceCo4, sizeof(Integer));
  AStream.ReadBuffer(FWingJointSpaceCo5, sizeof(Integer));
  AStream.ReadBuffer(FWingJointSpaceCo6, sizeof(Integer));
  AStream.ReadBuffer(FMainRoadEndX, sizeof(Double));
  AStream.ReadBuffer(FHdkn, sizeof(Double));
  AStream.ReadBuffer(FKCustomWingLong, sizeof(Double));
  AStream.ReadBuffer(FKCustomPointLong, sizeof(Double));
  AStream.ReadBuffer(FUseKCustomWingRails, sizeof(Boolean));
  AStream.ReadBuffer(FUseKCustomPointRails, sizeof(Boolean));
  //# endGenRestoreVars
  end;

procedure TCrossingInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FPattern, sizeof(Integer));
  AStream.WriteBuffer(FSlMode, sizeof(Integer));
  AStream.WriteBuffer(FReturnCentresMode, sizeof(Integer));
  AStream.WriteBuffer(FK3nUnitAngle, sizeof(Double));
  AStream.WriteBuffer(FFixedSt, sizeof(Double));
  AStream.WriteBuffer(FHdTimbersCode, sizeof(Integer));
  AStream.WriteBuffer(FHdVchecksCode, sizeof(Integer));
  AStream.WriteBuffer(FKCheckLength1, sizeof(Double));
  AStream.WriteBuffer(FKCheckLength2, sizeof(Double));
  AStream.WriteBuffer(FKCheckModMS, sizeof(Double));
  AStream.WriteBuffer(FKCheckModDS, sizeof(Double));
  AStream.WriteBuffer(FKCheckFlare, sizeof(Double));
  AStream.WriteBuffer(FCurviformTimbering, sizeof(Boolean));
  AStream.WriteBuffer(FMainRoadCode, sizeof(TMainOrTurnoutRoadLengthOption));
  AStream.WriteBuffer(FTandemTimberCode, sizeof(Integer));
  AStream.WriteBuffer(FBluntNoseWidth, sizeof(Double));
  AStream.WriteBuffer(FBluntNoseToTimber, sizeof(Double));
  AStream.WriteBuffer(FVeeJointHalfSpacing, sizeof(Double));
  AStream.WriteBuffer(FWingJointSpacing, sizeof(Double));
  AStream.WriteBuffer(FWingTimberSpacing, sizeof(Double));
  AStream.WriteBuffer(FVeeTimberSpacing, sizeof(Double));
  AStream.WriteBuffer(FVeeJointSpaceCo1, sizeof(Integer));
  AStream.WriteBuffer(FVeeJointSpaceCo2, sizeof(Integer));
  AStream.WriteBuffer(FVeeJointSpaceCo3, sizeof(Integer));
  AStream.WriteBuffer(FVeeJointSpaceCo4, sizeof(Integer));
  AStream.WriteBuffer(FVeeJointSpaceCo5, sizeof(Integer));
  AStream.WriteBuffer(FVeeJointSpaceCo6, sizeof(Integer));
  AStream.WriteBuffer(FWingJointSpaceCo1, sizeof(Integer));
  AStream.WriteBuffer(FWingJointSpaceCo2, sizeof(Integer));
  AStream.WriteBuffer(FWingJointSpaceCo3, sizeof(Integer));
  AStream.WriteBuffer(FWingJointSpaceCo4, sizeof(Integer));
  AStream.WriteBuffer(FWingJointSpaceCo5, sizeof(Integer));
  AStream.WriteBuffer(FWingJointSpaceCo6, sizeof(Integer));
  AStream.WriteBuffer(FMainRoadEndX, sizeof(Double));
  AStream.WriteBuffer(FHdkn, sizeof(Double));
  AStream.WriteBuffer(FKCustomWingLong, sizeof(Double));
  AStream.WriteBuffer(FKCustomPointLong, sizeof(Double));
  AStream.WriteBuffer(FUseKCustomWingRails, sizeof(Boolean));
  AStream.WriteBuffer(FUseKCustomPointRails, sizeof(Boolean));
  //# endGenSaveVars
  end;
  
procedure TCrossingInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlInteger(AEmitter, 'pattern', FPattern);
  SaveYamlInteger(AEmitter, 'slMode', FSlMode);
  SaveYamlInteger(AEmitter, 'returnCentresMode', FReturnCentresMode);
  SaveYamlDouble(AEmitter, 'k3nUnitAngle', FK3nUnitAngle);
  SaveYamlDouble(AEmitter, 'fixedSt', FFixedSt);
  SaveYamlInteger(AEmitter, 'hdTimbersCode', FHdTimbersCode);
  SaveYamlInteger(AEmitter, 'hdVchecksCode', FHdVchecksCode);
  SaveYamlDouble(AEmitter, 'kCheckLength1', FKCheckLength1);
  SaveYamlDouble(AEmitter, 'kCheckLength2', FKCheckLength2);
  SaveYamlDouble(AEmitter, 'kCheckModMS', FKCheckModMS);
  SaveYamlDouble(AEmitter, 'kCheckModDS', FKCheckModDS);
  SaveYamlDouble(AEmitter, 'kCheckFlare', FKCheckFlare);
  SaveYamlBoolean(AEmitter, 'curviformTimbering', FCurviformTimbering);
  SaveYamlTMainOrTurnoutRoadLengthOption(AEmitter, 'mainRoadCode', FMainRoadCode);
  SaveYamlInteger(AEmitter, 'tandemTimberCode', FTandemTimberCode);
  SaveYamlDouble(AEmitter, 'bluntNoseWidth', FBluntNoseWidth);
  SaveYamlDouble(AEmitter, 'bluntNoseToTimber', FBluntNoseToTimber);
  SaveYamlDouble(AEmitter, 'veeJointHalfSpacing', FVeeJointHalfSpacing);
  SaveYamlDouble(AEmitter, 'wingJointSpacing', FWingJointSpacing);
  SaveYamlDouble(AEmitter, 'wingTimberSpacing', FWingTimberSpacing);
  SaveYamlDouble(AEmitter, 'veeTimberSpacing', FVeeTimberSpacing);
  SaveYamlInteger(AEmitter, 'veeJointSpaceCo1', FVeeJointSpaceCo1);
  SaveYamlInteger(AEmitter, 'veeJointSpaceCo2', FVeeJointSpaceCo2);
  SaveYamlInteger(AEmitter, 'veeJointSpaceCo3', FVeeJointSpaceCo3);
  SaveYamlInteger(AEmitter, 'veeJointSpaceCo4', FVeeJointSpaceCo4);
  SaveYamlInteger(AEmitter, 'veeJointSpaceCo5', FVeeJointSpaceCo5);
  SaveYamlInteger(AEmitter, 'veeJointSpaceCo6', FVeeJointSpaceCo6);
  SaveYamlInteger(AEmitter, 'wingJointSpaceCo1', FWingJointSpaceCo1);
  SaveYamlInteger(AEmitter, 'wingJointSpaceCo2', FWingJointSpaceCo2);
  SaveYamlInteger(AEmitter, 'wingJointSpaceCo3', FWingJointSpaceCo3);
  SaveYamlInteger(AEmitter, 'wingJointSpaceCo4', FWingJointSpaceCo4);
  SaveYamlInteger(AEmitter, 'wingJointSpaceCo5', FWingJointSpaceCo5);
  SaveYamlInteger(AEmitter, 'wingJointSpaceCo6', FWingJointSpaceCo6);
  SaveYamlDouble(AEmitter, 'mainRoadEndX', FMainRoadEndX);
  SaveYamlDouble(AEmitter, 'hdkn', FHdkn);
  SaveYamlDouble(AEmitter, 'kCustomWingLong', FKCustomWingLong);
  SaveYamlDouble(AEmitter, 'kCustomPointLong', FKCustomPointLong);
  SaveYamlBoolean(AEmitter, 'useKCustomWingRails', FUseKCustomWingRails);
  SaveYamlBoolean(AEmitter, 'useKCustomPointRails', FUseKCustomPointRails);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetPattern(const AValue: Integer);
begin
  if AValue <> FPattern then begin
    SetModified;
    FPattern := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetSlMode(const AValue: Integer);
begin
  if AValue <> FSlMode then begin
    SetModified;
    FSlMode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetReturnCentresMode(const AValue: Integer);
begin
  if AValue <> FReturnCentresMode then begin
    SetModified;
    FReturnCentresMode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetK3nUnitAngle(const AValue: Double);
begin
  if AValue <> FK3nUnitAngle then begin
    SetModified;
    FK3nUnitAngle := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetFixedSt(const AValue: Double);
begin
  if AValue <> FFixedSt then begin
    SetModified;
    FFixedSt := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetHdTimbersCode(const AValue: Integer);
begin
  if AValue <> FHdTimbersCode then begin
    SetModified;
    FHdTimbersCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetHdVchecksCode(const AValue: Integer);
begin
  if AValue <> FHdVchecksCode then begin
    SetModified;
    FHdVchecksCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetKCheckLength1(const AValue: Double);
begin
  if AValue <> FKCheckLength1 then begin
    SetModified;
    FKCheckLength1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetKCheckLength2(const AValue: Double);
begin
  if AValue <> FKCheckLength2 then begin
    SetModified;
    FKCheckLength2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetKCheckModMS(const AValue: Double);
begin
  if AValue <> FKCheckModMS then begin
    SetModified;
    FKCheckModMS := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetKCheckModDS(const AValue: Double);
begin
  if AValue <> FKCheckModDS then begin
    SetModified;
    FKCheckModDS := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetKCheckFlare(const AValue: Double);
begin
  if AValue <> FKCheckFlare then begin
    SetModified;
    FKCheckFlare := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetCurviformTimbering(const AValue: Boolean);
begin
  if AValue <> FCurviformTimbering then begin
    SetModified;
    FCurviformTimbering := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetMainRoadCode(const AValue: TMainOrTurnoutRoadLengthOption);
begin
  if AValue <> FMainRoadCode then begin
    SetModified;
    FMainRoadCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetTandemTimberCode(const AValue: Integer);
begin
  if AValue <> FTandemTimberCode then begin
    SetModified;
    FTandemTimberCode := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetBluntNoseWidth(const AValue: Double);
begin
  if AValue <> FBluntNoseWidth then begin
    SetModified;
    FBluntNoseWidth := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetBluntNoseToTimber(const AValue: Double);
begin
  if AValue <> FBluntNoseToTimber then begin
    SetModified;
    FBluntNoseToTimber := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeJointHalfSpacing(const AValue: Double);
begin
  if AValue <> FVeeJointHalfSpacing then begin
    SetModified;
    FVeeJointHalfSpacing := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingJointSpacing(const AValue: Double);
begin
  if AValue <> FWingJointSpacing then begin
    SetModified;
    FWingJointSpacing := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingTimberSpacing(const AValue: Double);
begin
  if AValue <> FWingTimberSpacing then begin
    SetModified;
    FWingTimberSpacing := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeTimberSpacing(const AValue: Double);
begin
  if AValue <> FVeeTimberSpacing then begin
    SetModified;
    FVeeTimberSpacing := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeJointSpaceCo1(const AValue: Integer);
begin
  if AValue <> FVeeJointSpaceCo1 then begin
    SetModified;
    FVeeJointSpaceCo1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeJointSpaceCo2(const AValue: Integer);
begin
  if AValue <> FVeeJointSpaceCo2 then begin
    SetModified;
    FVeeJointSpaceCo2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeJointSpaceCo3(const AValue: Integer);
begin
  if AValue <> FVeeJointSpaceCo3 then begin
    SetModified;
    FVeeJointSpaceCo3 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeJointSpaceCo4(const AValue: Integer);
begin
  if AValue <> FVeeJointSpaceCo4 then begin
    SetModified;
    FVeeJointSpaceCo4 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeJointSpaceCo5(const AValue: Integer);
begin
  if AValue <> FVeeJointSpaceCo5 then begin
    SetModified;
    FVeeJointSpaceCo5 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetVeeJointSpaceCo6(const AValue: Integer);
begin
  if AValue <> FVeeJointSpaceCo6 then begin
    SetModified;
    FVeeJointSpaceCo6 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingJointSpaceCo1(const AValue: Integer);
begin
  if AValue <> FWingJointSpaceCo1 then begin
    SetModified;
    FWingJointSpaceCo1 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingJointSpaceCo2(const AValue: Integer);
begin
  if AValue <> FWingJointSpaceCo2 then begin
    SetModified;
    FWingJointSpaceCo2 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingJointSpaceCo3(const AValue: Integer);
begin
  if AValue <> FWingJointSpaceCo3 then begin
    SetModified;
    FWingJointSpaceCo3 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingJointSpaceCo4(const AValue: Integer);
begin
  if AValue <> FWingJointSpaceCo4 then begin
    SetModified;
    FWingJointSpaceCo4 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingJointSpaceCo5(const AValue: Integer);
begin
  if AValue <> FWingJointSpaceCo5 then begin
    SetModified;
    FWingJointSpaceCo5 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetWingJointSpaceCo6(const AValue: Integer);
begin
  if AValue <> FWingJointSpaceCo6 then begin
    SetModified;
    FWingJointSpaceCo6 := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetMainRoadEndX(const AValue: Double);
begin
  if AValue <> FMainRoadEndX then begin
    SetModified;
    FMainRoadEndX := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetHdkn(const AValue: Double);
begin
  if AValue <> FHdkn then begin
    SetModified;
    FHdkn := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetKCustomWingLong(const AValue: Double);
begin
  if AValue <> FKCustomWingLong then begin
    SetModified;
    FKCustomWingLong := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetKCustomPointLong(const AValue: Double);
begin
  if AValue <> FKCustomPointLong then begin
    SetModified;
    FKCustomPointLong := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetUseKCustomWingRails(const AValue: Boolean);
begin
  if AValue <> FUseKCustomWingRails then begin
    SetModified;
    FUseKCustomWingRails := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TCrossingInfo.SetUseKCustomPointRails(const AValue: Boolean);
begin
  if AValue <> FUseKCustomPointRails then begin
    SetModified;
    FUseKCustomPointRails := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TCrossingInfo.RegisterClass;
  TCrossingInfoOwningList.RegisterClass;
  TCrossingInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TCrossingInfo');
end.
