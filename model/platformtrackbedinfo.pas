unit PlatformTrackbedInfo;

{$MODE Delphi}

interface

uses
  Classes,
  SysUtils,
  OTPersistent,
  OTPersistentList,
  OTYamlEmitter;


{
Tplatform_trackbed_info = record   // 0.93.a was  Tcheck_rail_mints=record

(/)  adjacent_edges_keep: boolean;
  // False=adjacent tracks,  True=trackbed edges and platform edges.

  (/)  draw_ms_trackbed_edge_keep: boolean;
  (/)  draw_ts_trackbed_edge_keep: boolean;

  spare_bool1: boolean;

  OUT_OF_USE_trackbed_width_ins_keep: double;
  // 180 inches full-size 15ft.  // not used 215a  TS and MS separated, see below

(/)  draw_ts_platform_keep: boolean;
(/)  draw_ts_platform_start_edge_keep: boolean;
(/)  draw_ts_platform_end_edge_keep: boolean;
(/)  draw_ts_platform_rear_edge_keep: boolean;

(/)  platform_ts_front_edge_ins_keep: double;
     // centre-line to platform front edge 57 inches   4ft-9in  215a
(/)  platform_ts_start_width_ins_keep: double;
(/)  platform_ts_end_width_ins_keep: double;

(/)  platform_ts_start_mm_keep: double;
(/)  platform_ts_length_mm_keep: double;


(/)  draw_ms_platform_keep: boolean;
(/)  draw_ms_platform_start_edge_keep: boolean;
(/)  draw_ms_platform_end_edge_keep: boolean;
(/)  draw_ms_platform_rear_edge_keep: boolean;

(/)  platform_ms_front_edge_ins_keep: double;
  // centre-line to platform front edge 57 inches   4ft-9in  215a
(/)  platform_ms_start_width_ins_keep: double;
(/)  platform_ms_end_width_ins_keep: double;

(/)  platform_ms_start_mm_keep: double;
(/)  platform_ms_length_mm_keep: double;

  OUT_OF_USE_cess_width_ins_keep: double;
  // 206a     // not used 215a  TS and MS separated, see below
  OUT_OF_USE_draw_trackbed_cess_edge_keep: boolean;
  // 206a     // not used 215a  TS and MS separated, see below

  // platform skews added 207a...

(/)  platform_ms_start_skew_mm_keep: double;      // 207a
(/)  platform_ms_end_skew_mm_keep: double;        // 207a

(/)  platform_ts_start_skew_mm_keep: double;      // 207a
(/)  platform_ts_end_skew_mm_keep: double;        // 207a


  spare_bool2: boolean;
  spare_bool3: boolean;
  spare_bool4: boolean;
  spare_bool5: boolean;
  spare_bool6: boolean;
  spare_bool7: boolean;
  spare_bool8: boolean;


  // new trackbed edge functions 215a ...   split MS and TS settings  -  using Single floats to fit available file space ...

(/)  trackbed_ms_width_ins_keep: Single;
(/)  trackbed_ts_width_ins_keep: Single;

(/)  cess_ms_width_ins_keep: Single;
(/)  cess_ts_width_ins_keep: Single;

(/)  draw_ms_trackbed_cess_edge_keep: boolean;
(/)  draw_ts_trackbed_cess_edge_keep: boolean;

  spare1: boolean;
  spare2: boolean;
  // 215a spare_extended1:double; spare_extended2:double;

(/)  trackbed_ms_start_mm_keep: double;
  // 215a spare_extended3:double;    // need to be extendeds for def_req
(/)  trackbed_ms_length_mm_keep: double;   // 215a spare_extended4:double;

(/)  trackbed_ts_start_mm_keep: double;    // 215a spare_extended5:double;
(/)  trackbed_ts_length_mm_keep: double;   // 215a spare_extended6:double;

end;
}

{# class TPlatformTrackbedInfo
---
class: TPlatformTrackbedInfo
attributes:
- name: adjacentEdges
  type: Boolean
  comment: False=adjacent tracks,  True=trackbed edges and platform edges.
- name: drawMSTrackbedEdge
  type: Boolean
- name: drawTSTrackbedEdge
  type: Boolean
- name: drawTSPlatform
  type: Boolean
- name: drawTSPlatformStartEdge
  type: Boolean
- name: drawTSPlatformEndEdge
  type: Boolean
- name: drawTSPlatformRearEdge
  type: Boolean
- name: platformTSFrontEdgeIns
  type: Double
  comment: centre-line to platform front edge 57 inches   4ft-9in  215a
- name: platformTSStartWidthIns
  type: Double
- name: platformTSEndWidthIns
  type: Double
- name: platformTSStartMM
  type: Double
- name: platformTSLengthMM
  type: Double
- name: drawMSPlatform
  type: Boolean
- name: drawMSPlatformStartEdge
  type: Boolean
- name: drawMSPlatformEndEdge
  type: Boolean
- name: drawMSPlatformRearEdge
  type: Boolean
- name: platformMSFrontEdgeIns
  type: Double
  comment: centre-line to platform front edge 57 inches   4ft-9in  215a
- name: platformMSStartWidthIns
  type: Double
- name: platformMSEndWidthIns
  type: Double
- name: platformMSStartMM
  type: Double
- name: platformMSLengthMM
  type: Double
- name: platformMSStartSkewMM
  type: Double
- name: platformMSEndSkewMM
  type: Double
- name: platformTSStartSkewMM
  type: Double
- name: platformTSEndSkewMM
  type: Double
- name: trackbedMSWidthIns
  type: Double
- name: trackbedTSWidthIns
  type: Double
- name: cessMSWidthIns
  type: Double
- name: cessTSWidthIns
  type: Double
- name: drawMSTrackbedCessEdge
  type: Boolean
- name: drawTSTrackbedCessEdge
  type: Boolean
- name: trackbedMSStartMM
  type: Double
- name: trackbedMSLengthMM
  type: Double
- name: trackbedTSStartMM
  type: Double
- name: trackbedTSLengthMM
  type: Double
...
}

type
  //# genEnumDeclarations
  //# endGenEnumDeclarations

  TPlatformTrackbedInfo = class(TOTPersistent)
  private
    //# genMemberVars
    FAdjacentEdges: Boolean;
    FDrawMSTrackbedEdge: Boolean;
    FDrawTSTrackbedEdge: Boolean;
    FDrawTSPlatform: Boolean;
    FDrawTSPlatformStartEdge: Boolean;
    FDrawTSPlatformEndEdge: Boolean;
    FDrawTSPlatformRearEdge: Boolean;
    FPlatformTSFrontEdgeIns: Double;
    FPlatformTSStartWidthIns: Double;
    FPlatformTSEndWidthIns: Double;
    FPlatformTSStartMM: Double;
    FPlatformTSLengthMM: Double;
    FDrawMSPlatform: Boolean;
    FDrawMSPlatformStartEdge: Boolean;
    FDrawMSPlatformEndEdge: Boolean;
    FDrawMSPlatformRearEdge: Boolean;
    FPlatformMSFrontEdgeIns: Double;
    FPlatformMSStartWidthIns: Double;
    FPlatformMSEndWidthIns: Double;
    FPlatformMSStartMM: Double;
    FPlatformMSLengthMM: Double;
    FPlatformMSStartSkewMM: Double;
    FPlatformMSEndSkewMM: Double;
    FPlatformTSStartSkewMM: Double;
    FPlatformTSEndSkewMM: Double;
    FTrackbedMSWidthIns: Double;
    FTrackbedTSWidthIns: Double;
    FCessMSWidthIns: Double;
    FCessTSWidthIns: Double;
    FDrawMSTrackbedCessEdge: Boolean;
    FDrawTSTrackbedCessEdge: Boolean;
    FTrackbedMSStartMM: Double;
    FTrackbedMSLengthMM: Double;
    FTrackbedTSStartMM: Double;
    FTrackbedTSLengthMM: Double;
    //# endGenMemberVars

  protected
    procedure Calculate; override;
    procedure RestoreAttributes(AStream : TStream); override;
    procedure SaveAttributes(AStream : TStream); override;

    //# genGetSetDeclarations
    procedure SetAdjacentEdges(const AValue: Boolean);
    procedure SetDrawMSTrackbedEdge(const AValue: Boolean);
    procedure SetDrawTSTrackbedEdge(const AValue: Boolean);
    procedure SetDrawTSPlatform(const AValue: Boolean);
    procedure SetDrawTSPlatformStartEdge(const AValue: Boolean);
    procedure SetDrawTSPlatformEndEdge(const AValue: Boolean);
    procedure SetDrawTSPlatformRearEdge(const AValue: Boolean);
    procedure SetPlatformTSFrontEdgeIns(const AValue: Double);
    procedure SetPlatformTSStartWidthIns(const AValue: Double);
    procedure SetPlatformTSEndWidthIns(const AValue: Double);
    procedure SetPlatformTSStartMM(const AValue: Double);
    procedure SetPlatformTSLengthMM(const AValue: Double);
    procedure SetDrawMSPlatform(const AValue: Boolean);
    procedure SetDrawMSPlatformStartEdge(const AValue: Boolean);
    procedure SetDrawMSPlatformEndEdge(const AValue: Boolean);
    procedure SetDrawMSPlatformRearEdge(const AValue: Boolean);
    procedure SetPlatformMSFrontEdgeIns(const AValue: Double);
    procedure SetPlatformMSStartWidthIns(const AValue: Double);
    procedure SetPlatformMSEndWidthIns(const AValue: Double);
    procedure SetPlatformMSStartMM(const AValue: Double);
    procedure SetPlatformMSLengthMM(const AValue: Double);
    procedure SetPlatformMSStartSkewMM(const AValue: Double);
    procedure SetPlatformMSEndSkewMM(const AValue: Double);
    procedure SetPlatformTSStartSkewMM(const AValue: Double);
    procedure SetPlatformTSEndSkewMM(const AValue: Double);
    procedure SetTrackbedMSWidthIns(const AValue: Double);
    procedure SetTrackbedTSWidthIns(const AValue: Double);
    procedure SetCessMSWidthIns(const AValue: Double);
    procedure SetCessTSWidthIns(const AValue: Double);
    procedure SetDrawMSTrackbedCessEdge(const AValue: Boolean);
    procedure SetDrawTSTrackbedCessEdge(const AValue: Boolean);
    procedure SetTrackbedMSStartMM(const AValue: Double);
    procedure SetTrackbedMSLengthMM(const AValue: Double);
    procedure SetTrackbedTSStartMM(const AValue: Double);
    procedure SetTrackbedTSLengthMM(const AValue: Double);
    //# endGenGetSetDeclarations

  public
    constructor Create(AParent: TOTPersistent; AOID: TOID = 0); override;
    destructor Destroy; override;

    //# genPublicDeclarations
    //# endGenPublicDeclarations

    procedure   RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader); override;
    procedure   SaveYamlAttributes(AEmitter: TYamlEmitter); override;

    //# genProperty

    // False=adjacent tracks,  True=trackbed edges and platform edges.
    property adjacentEdges: Boolean read FAdjacentEdges write SetAdjacentEdges;
    property drawMSTrackbedEdge: Boolean read FDrawMSTrackbedEdge write SetDrawMSTrackbedEdge;
    property drawTSTrackbedEdge: Boolean read FDrawTSTrackbedEdge write SetDrawTSTrackbedEdge;
    property drawTSPlatform: Boolean read FDrawTSPlatform write SetDrawTSPlatform;
    property drawTSPlatformStartEdge: Boolean read FDrawTSPlatformStartEdge write SetDrawTSPlatformStartEdge;
    property drawTSPlatformEndEdge: Boolean read FDrawTSPlatformEndEdge write SetDrawTSPlatformEndEdge;
    property drawTSPlatformRearEdge: Boolean read FDrawTSPlatformRearEdge write SetDrawTSPlatformRearEdge;

    // centre-line to platform front edge 57 inches   4ft-9in  215a
    property platformTSFrontEdgeIns: Double read FPlatformTSFrontEdgeIns write SetPlatformTSFrontEdgeIns;
    property platformTSStartWidthIns: Double read FPlatformTSStartWidthIns write SetPlatformTSStartWidthIns;
    property platformTSEndWidthIns: Double read FPlatformTSEndWidthIns write SetPlatformTSEndWidthIns;
    property platformTSStartMM: Double read FPlatformTSStartMM write SetPlatformTSStartMM;
    property platformTSLengthMM: Double read FPlatformTSLengthMM write SetPlatformTSLengthMM;
    property drawMSPlatform: Boolean read FDrawMSPlatform write SetDrawMSPlatform;
    property drawMSPlatformStartEdge: Boolean read FDrawMSPlatformStartEdge write SetDrawMSPlatformStartEdge;
    property drawMSPlatformEndEdge: Boolean read FDrawMSPlatformEndEdge write SetDrawMSPlatformEndEdge;
    property drawMSPlatformRearEdge: Boolean read FDrawMSPlatformRearEdge write SetDrawMSPlatformRearEdge;

    // centre-line to platform front edge 57 inches   4ft-9in  215a
    property platformMSFrontEdgeIns: Double read FPlatformMSFrontEdgeIns write SetPlatformMSFrontEdgeIns;
    property platformMSStartWidthIns: Double read FPlatformMSStartWidthIns write SetPlatformMSStartWidthIns;
    property platformMSEndWidthIns: Double read FPlatformMSEndWidthIns write SetPlatformMSEndWidthIns;
    property platformMSStartMM: Double read FPlatformMSStartMM write SetPlatformMSStartMM;
    property platformMSLengthMM: Double read FPlatformMSLengthMM write SetPlatformMSLengthMM;
    property platformMSStartSkewMM: Double read FPlatformMSStartSkewMM write SetPlatformMSStartSkewMM;
    property platformMSEndSkewMM: Double read FPlatformMSEndSkewMM write SetPlatformMSEndSkewMM;
    property platformTSStartSkewMM: Double read FPlatformTSStartSkewMM write SetPlatformTSStartSkewMM;
    property platformTSEndSkewMM: Double read FPlatformTSEndSkewMM write SetPlatformTSEndSkewMM;
    property trackbedMSWidthIns: Double read FTrackbedMSWidthIns write SetTrackbedMSWidthIns;
    property trackbedTSWidthIns: Double read FTrackbedTSWidthIns write SetTrackbedTSWidthIns;
    property cessMSWidthIns: Double read FCessMSWidthIns write SetCessMSWidthIns;
    property cessTSWidthIns: Double read FCessTSWidthIns write SetCessTSWidthIns;
    property drawMSTrackbedCessEdge: Boolean read FDrawMSTrackbedCessEdge write SetDrawMSTrackbedCessEdge;
    property drawTSTrackbedCessEdge: Boolean read FDrawTSTrackbedCessEdge write SetDrawTSTrackbedCessEdge;
    property trackbedMSStartMM: Double read FTrackbedMSStartMM write SetTrackbedMSStartMM;
    property trackbedMSLengthMM: Double read FTrackbedMSLengthMM write SetTrackbedMSLengthMM;
    property trackbedTSStartMM: Double read FTrackbedTSStartMM write SetTrackbedTSStartMM;
    property trackbedTSLengthMM: Double read FTrackbedTSLengthMM write SetTrackbedTSLengthMM;
    //# endGenProperty
  end;

  TPlatformTrackbedInfoOwningList = class(TOTOwningList<TPlatformTrackbedInfo>);
  TPlatformTrackbedInfoReferenceList = class(TOTReferenceList<TPlatformTrackbedInfo>);

//# genEnumSerialDeclarations
//# endGenEnumSerialDeclarations

implementation

uses
  TLoggerUnit;

var
  log : ILogger;

//# genEnumSerialMethods
//# endGenEnumSerialMethods

{ TPlatformTrackbedInfo }

constructor TPlatformTrackbedInfo.Create(AParent: TOTPersistent; AOID: TOID);
begin
  inherited Create(AParent);
  //# genCreate
  //# endGenCreate
end;

destructor TPlatformTrackbedInfo.Destroy;
begin
  //# genDestroy
  //# endGenDestroy
  inherited;
end;

procedure TPlatformTrackbedInfo.Calculate;
begin
  // Add your calculation code here, and cache the results...
end;

procedure TPlatformTrackbedInfo.RestoreYamlAttribute(AName, AValue : String; AIndex: Integer; ALoader: TOTPersistentLoader);
begin
  //# genRestoreYamlVars
  if AName = 'adjacentEdges' then
    FAdjacentEdges := StrToBoolean(AValue)
  else
  if AName = 'drawMSTrackbedEdge' then
    FDrawMSTrackbedEdge := StrToBoolean(AValue)
  else
  if AName = 'drawTSTrackbedEdge' then
    FDrawTSTrackbedEdge := StrToBoolean(AValue)
  else
  if AName = 'drawTSPlatform' then
    FDrawTSPlatform := StrToBoolean(AValue)
  else
  if AName = 'drawTSPlatformStartEdge' then
    FDrawTSPlatformStartEdge := StrToBoolean(AValue)
  else
  if AName = 'drawTSPlatformEndEdge' then
    FDrawTSPlatformEndEdge := StrToBoolean(AValue)
  else
  if AName = 'drawTSPlatformRearEdge' then
    FDrawTSPlatformRearEdge := StrToBoolean(AValue)
  else
  if AName = 'platformTSFrontEdgeIns' then
    FPlatformTSFrontEdgeIns := StrToDouble(AValue)
  else
  if AName = 'platformTSStartWidthIns' then
    FPlatformTSStartWidthIns := StrToDouble(AValue)
  else
  if AName = 'platformTSEndWidthIns' then
    FPlatformTSEndWidthIns := StrToDouble(AValue)
  else
  if AName = 'platformTSStartMM' then
    FPlatformTSStartMM := StrToDouble(AValue)
  else
  if AName = 'platformTSLengthMM' then
    FPlatformTSLengthMM := StrToDouble(AValue)
  else
  if AName = 'drawMSPlatform' then
    FDrawMSPlatform := StrToBoolean(AValue)
  else
  if AName = 'drawMSPlatformStartEdge' then
    FDrawMSPlatformStartEdge := StrToBoolean(AValue)
  else
  if AName = 'drawMSPlatformEndEdge' then
    FDrawMSPlatformEndEdge := StrToBoolean(AValue)
  else
  if AName = 'drawMSPlatformRearEdge' then
    FDrawMSPlatformRearEdge := StrToBoolean(AValue)
  else
  if AName = 'platformMSFrontEdgeIns' then
    FPlatformMSFrontEdgeIns := StrToDouble(AValue)
  else
  if AName = 'platformMSStartWidthIns' then
    FPlatformMSStartWidthIns := StrToDouble(AValue)
  else
  if AName = 'platformMSEndWidthIns' then
    FPlatformMSEndWidthIns := StrToDouble(AValue)
  else
  if AName = 'platformMSStartMM' then
    FPlatformMSStartMM := StrToDouble(AValue)
  else
  if AName = 'platformMSLengthMM' then
    FPlatformMSLengthMM := StrToDouble(AValue)
  else
  if AName = 'platformMSStartSkewMM' then
    FPlatformMSStartSkewMM := StrToDouble(AValue)
  else
  if AName = 'platformMSEndSkewMM' then
    FPlatformMSEndSkewMM := StrToDouble(AValue)
  else
  if AName = 'platformTSStartSkewMM' then
    FPlatformTSStartSkewMM := StrToDouble(AValue)
  else
  if AName = 'platformTSEndSkewMM' then
    FPlatformTSEndSkewMM := StrToDouble(AValue)
  else
  if AName = 'trackbedMSWidthIns' then
    FTrackbedMSWidthIns := StrToDouble(AValue)
  else
  if AName = 'trackbedTSWidthIns' then
    FTrackbedTSWidthIns := StrToDouble(AValue)
  else
  if AName = 'cessMSWidthIns' then
    FCessMSWidthIns := StrToDouble(AValue)
  else
  if AName = 'cessTSWidthIns' then
    FCessTSWidthIns := StrToDouble(AValue)
  else
  if AName = 'drawMSTrackbedCessEdge' then
    FDrawMSTrackbedCessEdge := StrToBoolean(AValue)
  else
  if AName = 'drawTSTrackbedCessEdge' then
    FDrawTSTrackbedCessEdge := StrToBoolean(AValue)
  else
  if AName = 'trackbedMSStartMM' then
    FTrackbedMSStartMM := StrToDouble(AValue)
  else
  if AName = 'trackbedMSLengthMM' then
    FTrackbedMSLengthMM := StrToDouble(AValue)
  else
  if AName = 'trackbedTSStartMM' then
    FTrackbedTSStartMM := StrToDouble(AValue)
  else
  if AName = 'trackbedTSLengthMM' then
    FTrackbedTSLengthMM := StrToDouble(AValue)
  else
  //# endGenRestoreYamlVars
    inherited RestoreYamlAttribute(AName, AValue, AIndex, ALoader);
end;

procedure TPlatformTrackbedInfo.RestoreAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genRestoreVars
  AStream.ReadBuffer(FAdjacentEdges, sizeof(Boolean));
  AStream.ReadBuffer(FDrawMSTrackbedEdge, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTSTrackbedEdge, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTSPlatform, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTSPlatformStartEdge, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTSPlatformEndEdge, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTSPlatformRearEdge, sizeof(Boolean));
  AStream.ReadBuffer(FPlatformTSFrontEdgeIns, sizeof(Double));
  AStream.ReadBuffer(FPlatformTSStartWidthIns, sizeof(Double));
  AStream.ReadBuffer(FPlatformTSEndWidthIns, sizeof(Double));
  AStream.ReadBuffer(FPlatformTSStartMM, sizeof(Double));
  AStream.ReadBuffer(FPlatformTSLengthMM, sizeof(Double));
  AStream.ReadBuffer(FDrawMSPlatform, sizeof(Boolean));
  AStream.ReadBuffer(FDrawMSPlatformStartEdge, sizeof(Boolean));
  AStream.ReadBuffer(FDrawMSPlatformEndEdge, sizeof(Boolean));
  AStream.ReadBuffer(FDrawMSPlatformRearEdge, sizeof(Boolean));
  AStream.ReadBuffer(FPlatformMSFrontEdgeIns, sizeof(Double));
  AStream.ReadBuffer(FPlatformMSStartWidthIns, sizeof(Double));
  AStream.ReadBuffer(FPlatformMSEndWidthIns, sizeof(Double));
  AStream.ReadBuffer(FPlatformMSStartMM, sizeof(Double));
  AStream.ReadBuffer(FPlatformMSLengthMM, sizeof(Double));
  AStream.ReadBuffer(FPlatformMSStartSkewMM, sizeof(Double));
  AStream.ReadBuffer(FPlatformMSEndSkewMM, sizeof(Double));
  AStream.ReadBuffer(FPlatformTSStartSkewMM, sizeof(Double));
  AStream.ReadBuffer(FPlatformTSEndSkewMM, sizeof(Double));
  AStream.ReadBuffer(FTrackbedMSWidthIns, sizeof(Double));
  AStream.ReadBuffer(FTrackbedTSWidthIns, sizeof(Double));
  AStream.ReadBuffer(FCessMSWidthIns, sizeof(Double));
  AStream.ReadBuffer(FCessTSWidthIns, sizeof(Double));
  AStream.ReadBuffer(FDrawMSTrackbedCessEdge, sizeof(Boolean));
  AStream.ReadBuffer(FDrawTSTrackbedCessEdge, sizeof(Boolean));
  AStream.ReadBuffer(FTrackbedMSStartMM, sizeof(Double));
  AStream.ReadBuffer(FTrackbedMSLengthMM, sizeof(Double));
  AStream.ReadBuffer(FTrackbedTSStartMM, sizeof(Double));
  AStream.ReadBuffer(FTrackbedTSLengthMM, sizeof(Double));
  //# endGenRestoreVars
  end;

procedure TPlatformTrackbedInfo.SaveAttributes(AStream : TStream);
  var
    i: Integer;
  begin
  inherited;

  //# genSaveVars
  AStream.WriteBuffer(FAdjacentEdges, sizeof(Boolean));
  AStream.WriteBuffer(FDrawMSTrackbedEdge, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTSTrackbedEdge, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTSPlatform, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTSPlatformStartEdge, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTSPlatformEndEdge, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTSPlatformRearEdge, sizeof(Boolean));
  AStream.WriteBuffer(FPlatformTSFrontEdgeIns, sizeof(Double));
  AStream.WriteBuffer(FPlatformTSStartWidthIns, sizeof(Double));
  AStream.WriteBuffer(FPlatformTSEndWidthIns, sizeof(Double));
  AStream.WriteBuffer(FPlatformTSStartMM, sizeof(Double));
  AStream.WriteBuffer(FPlatformTSLengthMM, sizeof(Double));
  AStream.WriteBuffer(FDrawMSPlatform, sizeof(Boolean));
  AStream.WriteBuffer(FDrawMSPlatformStartEdge, sizeof(Boolean));
  AStream.WriteBuffer(FDrawMSPlatformEndEdge, sizeof(Boolean));
  AStream.WriteBuffer(FDrawMSPlatformRearEdge, sizeof(Boolean));
  AStream.WriteBuffer(FPlatformMSFrontEdgeIns, sizeof(Double));
  AStream.WriteBuffer(FPlatformMSStartWidthIns, sizeof(Double));
  AStream.WriteBuffer(FPlatformMSEndWidthIns, sizeof(Double));
  AStream.WriteBuffer(FPlatformMSStartMM, sizeof(Double));
  AStream.WriteBuffer(FPlatformMSLengthMM, sizeof(Double));
  AStream.WriteBuffer(FPlatformMSStartSkewMM, sizeof(Double));
  AStream.WriteBuffer(FPlatformMSEndSkewMM, sizeof(Double));
  AStream.WriteBuffer(FPlatformTSStartSkewMM, sizeof(Double));
  AStream.WriteBuffer(FPlatformTSEndSkewMM, sizeof(Double));
  AStream.WriteBuffer(FTrackbedMSWidthIns, sizeof(Double));
  AStream.WriteBuffer(FTrackbedTSWidthIns, sizeof(Double));
  AStream.WriteBuffer(FCessMSWidthIns, sizeof(Double));
  AStream.WriteBuffer(FCessTSWidthIns, sizeof(Double));
  AStream.WriteBuffer(FDrawMSTrackbedCessEdge, sizeof(Boolean));
  AStream.WriteBuffer(FDrawTSTrackbedCessEdge, sizeof(Boolean));
  AStream.WriteBuffer(FTrackbedMSStartMM, sizeof(Double));
  AStream.WriteBuffer(FTrackbedMSLengthMM, sizeof(Double));
  AStream.WriteBuffer(FTrackbedTSStartMM, sizeof(Double));
  AStream.WriteBuffer(FTrackbedTSLengthMM, sizeof(Double));
  //# endGenSaveVars
  end;
  
procedure TPlatformTrackbedInfo.SaveYamlAttributes(AEmitter : TYamlEmitter);
  var
    i: Integer;
  begin
  inherited;
  
  //# genSaveYamlVars
  SaveYamlBoolean(AEmitter, 'adjacentEdges', FAdjacentEdges);
  SaveYamlBoolean(AEmitter, 'drawMSTrackbedEdge', FDrawMSTrackbedEdge);
  SaveYamlBoolean(AEmitter, 'drawTSTrackbedEdge', FDrawTSTrackbedEdge);
  SaveYamlBoolean(AEmitter, 'drawTSPlatform', FDrawTSPlatform);
  SaveYamlBoolean(AEmitter, 'drawTSPlatformStartEdge', FDrawTSPlatformStartEdge);
  SaveYamlBoolean(AEmitter, 'drawTSPlatformEndEdge', FDrawTSPlatformEndEdge);
  SaveYamlBoolean(AEmitter, 'drawTSPlatformRearEdge', FDrawTSPlatformRearEdge);
  SaveYamlDouble(AEmitter, 'platformTSFrontEdgeIns', FPlatformTSFrontEdgeIns);
  SaveYamlDouble(AEmitter, 'platformTSStartWidthIns', FPlatformTSStartWidthIns);
  SaveYamlDouble(AEmitter, 'platformTSEndWidthIns', FPlatformTSEndWidthIns);
  SaveYamlDouble(AEmitter, 'platformTSStartMM', FPlatformTSStartMM);
  SaveYamlDouble(AEmitter, 'platformTSLengthMM', FPlatformTSLengthMM);
  SaveYamlBoolean(AEmitter, 'drawMSPlatform', FDrawMSPlatform);
  SaveYamlBoolean(AEmitter, 'drawMSPlatformStartEdge', FDrawMSPlatformStartEdge);
  SaveYamlBoolean(AEmitter, 'drawMSPlatformEndEdge', FDrawMSPlatformEndEdge);
  SaveYamlBoolean(AEmitter, 'drawMSPlatformRearEdge', FDrawMSPlatformRearEdge);
  SaveYamlDouble(AEmitter, 'platformMSFrontEdgeIns', FPlatformMSFrontEdgeIns);
  SaveYamlDouble(AEmitter, 'platformMSStartWidthIns', FPlatformMSStartWidthIns);
  SaveYamlDouble(AEmitter, 'platformMSEndWidthIns', FPlatformMSEndWidthIns);
  SaveYamlDouble(AEmitter, 'platformMSStartMM', FPlatformMSStartMM);
  SaveYamlDouble(AEmitter, 'platformMSLengthMM', FPlatformMSLengthMM);
  SaveYamlDouble(AEmitter, 'platformMSStartSkewMM', FPlatformMSStartSkewMM);
  SaveYamlDouble(AEmitter, 'platformMSEndSkewMM', FPlatformMSEndSkewMM);
  SaveYamlDouble(AEmitter, 'platformTSStartSkewMM', FPlatformTSStartSkewMM);
  SaveYamlDouble(AEmitter, 'platformTSEndSkewMM', FPlatformTSEndSkewMM);
  SaveYamlDouble(AEmitter, 'trackbedMSWidthIns', FTrackbedMSWidthIns);
  SaveYamlDouble(AEmitter, 'trackbedTSWidthIns', FTrackbedTSWidthIns);
  SaveYamlDouble(AEmitter, 'cessMSWidthIns', FCessMSWidthIns);
  SaveYamlDouble(AEmitter, 'cessTSWidthIns', FCessTSWidthIns);
  SaveYamlBoolean(AEmitter, 'drawMSTrackbedCessEdge', FDrawMSTrackbedCessEdge);
  SaveYamlBoolean(AEmitter, 'drawTSTrackbedCessEdge', FDrawTSTrackbedCessEdge);
  SaveYamlDouble(AEmitter, 'trackbedMSStartMM', FTrackbedMSStartMM);
  SaveYamlDouble(AEmitter, 'trackbedMSLengthMM', FTrackbedMSLengthMM);
  SaveYamlDouble(AEmitter, 'trackbedTSStartMM', FTrackbedTSStartMM);
  SaveYamlDouble(AEmitter, 'trackbedTSLengthMM', FTrackbedTSLengthMM);
  //# endGenSaveYamlVars
  end;

//# genGetSetMethods
// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetAdjacentEdges(const AValue: Boolean);
begin
  if AValue <> FAdjacentEdges then begin
    SetModified;
    FAdjacentEdges := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawMSTrackbedEdge(const AValue: Boolean);
begin
  if AValue <> FDrawMSTrackbedEdge then begin
    SetModified;
    FDrawMSTrackbedEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawTSTrackbedEdge(const AValue: Boolean);
begin
  if AValue <> FDrawTSTrackbedEdge then begin
    SetModified;
    FDrawTSTrackbedEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawTSPlatform(const AValue: Boolean);
begin
  if AValue <> FDrawTSPlatform then begin
    SetModified;
    FDrawTSPlatform := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawTSPlatformStartEdge(const AValue: Boolean);
begin
  if AValue <> FDrawTSPlatformStartEdge then begin
    SetModified;
    FDrawTSPlatformStartEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawTSPlatformEndEdge(const AValue: Boolean);
begin
  if AValue <> FDrawTSPlatformEndEdge then begin
    SetModified;
    FDrawTSPlatformEndEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawTSPlatformRearEdge(const AValue: Boolean);
begin
  if AValue <> FDrawTSPlatformRearEdge then begin
    SetModified;
    FDrawTSPlatformRearEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformTSFrontEdgeIns(const AValue: Double);
begin
  if AValue <> FPlatformTSFrontEdgeIns then begin
    SetModified;
    FPlatformTSFrontEdgeIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformTSStartWidthIns(const AValue: Double);
begin
  if AValue <> FPlatformTSStartWidthIns then begin
    SetModified;
    FPlatformTSStartWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformTSEndWidthIns(const AValue: Double);
begin
  if AValue <> FPlatformTSEndWidthIns then begin
    SetModified;
    FPlatformTSEndWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformTSStartMM(const AValue: Double);
begin
  if AValue <> FPlatformTSStartMM then begin
    SetModified;
    FPlatformTSStartMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformTSLengthMM(const AValue: Double);
begin
  if AValue <> FPlatformTSLengthMM then begin
    SetModified;
    FPlatformTSLengthMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawMSPlatform(const AValue: Boolean);
begin
  if AValue <> FDrawMSPlatform then begin
    SetModified;
    FDrawMSPlatform := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawMSPlatformStartEdge(const AValue: Boolean);
begin
  if AValue <> FDrawMSPlatformStartEdge then begin
    SetModified;
    FDrawMSPlatformStartEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawMSPlatformEndEdge(const AValue: Boolean);
begin
  if AValue <> FDrawMSPlatformEndEdge then begin
    SetModified;
    FDrawMSPlatformEndEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawMSPlatformRearEdge(const AValue: Boolean);
begin
  if AValue <> FDrawMSPlatformRearEdge then begin
    SetModified;
    FDrawMSPlatformRearEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformMSFrontEdgeIns(const AValue: Double);
begin
  if AValue <> FPlatformMSFrontEdgeIns then begin
    SetModified;
    FPlatformMSFrontEdgeIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformMSStartWidthIns(const AValue: Double);
begin
  if AValue <> FPlatformMSStartWidthIns then begin
    SetModified;
    FPlatformMSStartWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformMSEndWidthIns(const AValue: Double);
begin
  if AValue <> FPlatformMSEndWidthIns then begin
    SetModified;
    FPlatformMSEndWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformMSStartMM(const AValue: Double);
begin
  if AValue <> FPlatformMSStartMM then begin
    SetModified;
    FPlatformMSStartMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformMSLengthMM(const AValue: Double);
begin
  if AValue <> FPlatformMSLengthMM then begin
    SetModified;
    FPlatformMSLengthMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformMSStartSkewMM(const AValue: Double);
begin
  if AValue <> FPlatformMSStartSkewMM then begin
    SetModified;
    FPlatformMSStartSkewMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformMSEndSkewMM(const AValue: Double);
begin
  if AValue <> FPlatformMSEndSkewMM then begin
    SetModified;
    FPlatformMSEndSkewMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformTSStartSkewMM(const AValue: Double);
begin
  if AValue <> FPlatformTSStartSkewMM then begin
    SetModified;
    FPlatformTSStartSkewMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetPlatformTSEndSkewMM(const AValue: Double);
begin
  if AValue <> FPlatformTSEndSkewMM then begin
    SetModified;
    FPlatformTSEndSkewMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetTrackbedMSWidthIns(const AValue: Double);
begin
  if AValue <> FTrackbedMSWidthIns then begin
    SetModified;
    FTrackbedMSWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetTrackbedTSWidthIns(const AValue: Double);
begin
  if AValue <> FTrackbedTSWidthIns then begin
    SetModified;
    FTrackbedTSWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetCessMSWidthIns(const AValue: Double);
begin
  if AValue <> FCessMSWidthIns then begin
    SetModified;
    FCessMSWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetCessTSWidthIns(const AValue: Double);
begin
  if AValue <> FCessTSWidthIns then begin
    SetModified;
    FCessTSWidthIns := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawMSTrackbedCessEdge(const AValue: Boolean);
begin
  if AValue <> FDrawMSTrackbedCessEdge then begin
    SetModified;
    FDrawMSTrackbedCessEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetDrawTSTrackbedCessEdge(const AValue: Boolean);
begin
  if AValue <> FDrawTSTrackbedCessEdge then begin
    SetModified;
    FDrawTSTrackbedCessEdge := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetTrackbedMSStartMM(const AValue: Double);
begin
  if AValue <> FTrackbedMSStartMM then begin
    SetModified;
    FTrackbedMSStartMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetTrackbedMSLengthMM(const AValue: Double);
begin
  if AValue <> FTrackbedMSLengthMM then begin
    SetModified;
    FTrackbedMSLengthMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetTrackbedTSStartMM(const AValue: Double);
begin
  if AValue <> FTrackbedTSStartMM then begin
    SetModified;
    FTrackbedTSStartMM := AValue;
  end;
end;

// GENERATED METHOD - DO NOT EDIT
procedure TPlatformTrackbedInfo.SetTrackbedTSLengthMM(const AValue: Double);
begin
  if AValue <> FTrackbedTSLengthMM then begin
    SetModified;
    FTrackbedTSLengthMM := AValue;
  end;
end;

//# endGenGetSetMethods

initialization
  TPlatformTrackbedInfo.RegisterClass;
  TPlatformTrackbedInfoOwningList.RegisterClass;
  TPlatformTrackbedInfoReferenceList.RegisterClass;

  //log := Logger.GetInstance('TPlatformTrackbedInfo');
end.
