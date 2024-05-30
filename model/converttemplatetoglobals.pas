unit ConvertTemplateToGlobals;

//
// Isolate conversion routines between
// global variables (the control template)
// and the new TTemplate model class.
//
// These functions have been extracted from math_unit,
// with the intention that they will be eventually
// deleted once there is no longer a "control template"
// with global variables, and we just have a current
// selected template
//

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  Template;

// copy control template data to the keep record.
procedure fill_kd(target: TTemplate);

// get control template data from a keep.
procedure copy_keep(Source: TTemplate);

implementation

uses
  Graphics,
  plain_track_unit,
  jotter_unit,
  switch_select,
  ShovedTimber,
  control_room,
  info_unit,
  keep_select,
  math_unit,
  pad_unit,
  gauge_unit,
  template_records,
  BoxDims,
  Reminder,
  RailInfo,
  ProtoInfo,
  CheckDiffs,
  CheckEndDiff,
  TransformInfo,
  PlatformTrackbedInfo,
  TurnoutInfo1,
  TurnoutInfo2,
  PlainTrackInfo,
  SwitchInfo,
  CrossingInfo,
  Centreline;


procedure CopyToTCheckEndDiff(cd: TCheckEndDiff; const from: Tcheck_end_diff);
begin
  cd.lenDiff := from.len_diff;
  cd.flareDiff := from.flr_diff;
  cd.gapDiff := from.gap_diff;
  case from.type_diff of
    0:
      cd.typeDiff := dtNoDiff;
    1:
      cd.typeDiff := dtBentFlare;
    2:
      cd.typeDiff := dtMachinedFlare;
    3:
      cd.typeDiff := dtNoFlare;
    else
      raise Exception.CreateFmt('Unknown type_diff: %d', [from.type_diff]);
  end;

end;

procedure CopyFromTCheckEndDiff(var cd: Tcheck_end_diff; const from: TCheckEndDiff);
begin
  cd.len_diff := from.lenDiff;
  cd.flr_diff := from.flareDiff;
  cd.gap_diff := from.gapDiff;

  case from.typeDiff of
    dtNoDiff:
      cd.type_diff := 0;
    dtBentFlare:
      cd.type_diff := 1;
    dtMachinedFlare:
      cd.type_diff := 2;
    dtNoFlare:
      cd.type_diff := 3;
    else
      raise Exception.CreateFmt('Unknown typeDiff: %d', [from.typeDiff]);
  end;

end;

//______________________________________________________________________________
//
// copy control template data to the keep template.
//
procedure fill_kd(target: TTemplate);

var
  i: integer;
  rand_label_factor: double;

  bd: TBoxDims;
  ri: TRailInfo;
  pi: TProtoInfo;
  cd: TCheckDiffs;
  ti: TTransformInfo;
  pti: TPlatformTrackbedInfo;
  rem: TReminder;
  ti1: TTurnoutInfo1;
  ti2: TTurnoutInfo2;
  pt: TPlainTrackInfo;
  swi: TSwitchInfo;
  xi: TCrossingInfo;
  cl: TCentreline;

begin
  target.Name := Copy(current_name_str, 1, 99);
  target.topLabel := Copy(info_form.gauge_label.Caption, 1, 99);

  bd := target.boxDims;

  //uniqueId :=
  //now_time := time_now_modified(Random($7FFFFFFF));
  // modify Delphi float time format to integer.
  // if conversion problem, returns random integer.

  //timestamp := Now();

  bd.thisWasControlTemplate := False;

  bd.idNumber := highest_id_number + 1;    // 208a

  bd.idNumberStr := create_id_number_str(bd.idNumber, hand_i, startx, turnoutx,
    ipx, fpx, plain_track, half_diamond, any_control_rails_omitted);   // 208a

  //total_length_of_timbering := total_template_timber_length;  // 0.96.a  for box totals info

  ri := bd.railInfo;
  ri.flaredEnds := flare_type;  // 0=straight bent  1=straight machined.

  ri.knuckleCode := knuckle_code;
  ri.knuckleRadius := knuckle_radius;   // 214a  extended;


  ri.drawCentrelineOnly := cl_only;    // for bgnd centre-line only.
  ri.dummyTemplateFlag := dummy_template;  // 212a

  ri.trackCentreLines := track_centre_lines_flag;
  ri.switchDrive := switch_drive_flag;  // 0.82.a
  ri.isolatedCrossing := isolated_crossing;   // 217a

  ri.turnoutRoadStockRail := turnout_road_stock_rail_flag;
  ri.turnoutRoadCheckRail := turnout_road_check_rail_flag;
  ri.turnoutRoadCrossingRail := turnout_road_crossing_rail_flag;
  ri.crossingVee := crossing_vee_flag;
  ri.mainRoadCrossingRail := main_road_crossing_rail_flag;
  ri.mainRoadCheckRail := main_road_check_rail_flag;
  ri.mainRoadStockRail := main_road_stock_rail_flag;
  ri.kDiagonalSideCheckRail := k_diagonal_side_check_rail_flag;
  ri.kMainSideCheckRail := k_main_side_check_rail_flag;

  bd.backgroundCode := bkcUnused;                  // can't go on background until in keeps box.

  bd.gaugeIndex := gauge_i;            // index into the gauge list. Only for showing the list,
  // the data comes from the file.

  if gauge_i = gauge_form.gauge_listbox.Items.Count - 1 then
    bd.gaugeExact := True
  // nyi // If true this is an exact-scale template.
  else
    bd.gaugeExact := False;

  if (gauge_i < gauge_form.gauge_listbox.Items.Count - 1) and
    (gauge_i > gauge_form.gauge_listbox.Items.Count - 6)  // 4 custom slots -2, -3, -4, -5.

  then
    bd.gaugeCustom := True   // nyi // If true this is (or was when saved) a custom gauge setting.
  else
    bd.gaugeCustom := False;

  pi := bd.protoInfo;
  pi.Name := cpi.name_str_pi;
  pi.scale := cpi.scale_pi;
  pi.gauge := cpi.gauge_pi;
  pi.flangeway := cpi.fw_pi;
  pi.flangewayEnd := cpi.fwe_pi;
  pi.flareLength := cpi.xing_fl_pi;
  pi.railtopWidth := cpi.railtop_pi;
  pi.turnoutSideTrackCentres := cpi.trtscent_pi;
  pi.mainSideTrackCentres := cpi.trmscent_pi;
  pi.returnCurveTrackCentres := cpi.retcent_pi;
  pi.minimumRadius := cpi.min_radius_pi;
  pi.turnoutTimberWidth := cpi.tbwide_pi;
  pi.sleeperWidth := cpi.slwide_pi;
  pi.maxTimberSpacing := cpi.ftimbspmax_pi;
  pi.sleeperLength := cpi.tb_pi;
  pi.mainsideEnds := cpi.mainside_ends_pi;
  pi.sleeperWidthAtRailJoint := cpi.jt_slwide_pi;
  pi.timberEndRandomising := cpi.random_end_pi;
  pi.timberThickness := cpi.timber_thick_pi;
  pi.timberAngleRandomising := cpi.random_angle_pi;
  pi.checkRailLengthMainSide1 := cpi.ck_ms_working1_pi;
  pi.checkRailLengthMainSide2 := cpi.ck_ms_working2_pi;
  pi.checkRailLengthMainSide3 := cpi.ck_ms_working3_pi;
  pi.checkRailExtensionMainSide1 := cpi.ck_ms_ext1_pi;
  pi.checkRailExtensionMainSide2 := cpi.ck_ms_ext2_pi;
  pi.wingRailReachMainSide1 := cpi.wing_ms_reach1_pi;
  pi.wingRailReachMainSide2 := cpi.wing_ms_reach2_pi;
  pi.railBottom := cpi.railbottom_pi;
  pi.railHeight := cpi.rail_height_pi;
  pi.seatThick := cpi.seat_thick_pi;
  pi.railInclination := cpi.rail_inclination_pi;
  pi.footHeight := cpi.foot_height_pi;
  pi.chairOutLength := cpi.chair_outlen_pi;
  pi.chairInLength := cpi.chair_inlen_pi;
  pi.chairWidth := cpi.chair_width_pi;
  pi.chairCornerRadius := cpi.chair_corner_pi;


  CopyToTCheckEndDiff(bd.checkDiffs.endDiffMW, ccd.end_diff_mw);
  CopyToTCheckEndDiff(bd.checkDiffs.endDiffME, ccd.end_diff_me);
  CopyToTCheckEndDiff(bd.checkDiffs.endDiffMR, ccd.end_diff_mr);
  CopyToTCheckEndDiff(bd.checkDiffs.endDiffTW, ccd.end_diff_tw);
  CopyToTCheckEndDiff(bd.checkDiffs.endDiffTE, ccd.end_diff_te);
  CopyToTCheckEndDiff(bd.checkDiffs.endDiffTR, ccd.end_diff_tr);

  bd.retainDiffsOnMake := retain_diffs_on_make;    // 0.94.a check rail diffs
  bd.retainDiffsOnMint := retain_diffs_on_mint;    // 0.94.a check rail diffs

  // 0.94.a timber shoving mods..

  bd.retainShovesOnMake := retain_shoves_on_make;
  bd.retainShovesOnMint := retain_shoves_on_mint;

  // 213a  for crossing entry straight

  bd.retainEntryStraightOnMake := retain_entry_straight_on_make;
  bd.retainEntryStraightOnMint := retain_entry_straight_on_mint;


  //box_save_done := False;
  // default, changed on saving backup, read only from first keep on restore previous contents. 23-6-00 v:0.62.a //spare_flag1:boolean;

  // name label position modifiers..

  // 211b mods...

  if (control_room_form.previous_labels_menu_entry.Checked)   // 211b option
  //or ((GetKeyState(VK_CONTROL) and -2) <> 0)                       // or CTRL-Key down
  then begin
    bd.labelModifierX := label_modx;    // 211b put label back where it was
    bd.labelModifierY := label_mody;
  end
  else begin
    // 0.82.a randomise label position (if currently on default)...

    if control_room_form.fixed_labels_menu_entry.Checked then begin
      bd.labelModifierX := 0;
      bd.labelModifierY := 0;
    end
    else begin
      if control_room_form.very_random_labels_menu_entry.Checked then
        rand_label_factor := 3.0
      else
        rand_label_factor := 1.0;

      bd.labelModifierX := ((Random * 30) - 15) * scale * rand_label_factor;
      // 0.82.a up to 15ft either way of randomising. arbitrary.
      bd.labelModifierY := ((Random * 12) - 4) * scale * rand_label_factor;
      // 0.82.a add -4ft to +8ft of randomising. arbitrary.
    end;
  end;

  ti := bd.transformInfo;

  ti.datumY := y_datum;                   // y datum (green dot).

  //x_go_limit := minfp;                  // nyi // print cropping limits (paper inches)...
  //x_stop_limit := minfp;                // nyi


  // transform data...

  ti.x1Shift := xform;                    //  mm    (xform,yform always zero after a normalize,)
  ti.y1Shift := yform;                    //  mm    (e.g. for keeps, etc. (but not roll-back).  )
  ti.kShift := kform;                     //  radians.
  ti.x2Shift := xshift;                   //  mm
  ti.y2Shift := yshift;                   //  mm

  ti.pegPos.set_xy(pegx, pegy);             //  mm  peg position.

  ti.pegPointCode := peg_code;
  ti.pegPointRail := peg_rail;

  ti.mirrorOnX := False;                 //  nyi // True= invert on x.
  ti.mirrorOnY := False;                 //  nyi // True= invert on y. (swap hand).

  // also save the peg position in file as notch data..

  ti.notchInfo.SetNotch(get_peg_for_notch);

  pti := bd.platformTrackbedInfo;

  pti.adjacentEdges := adjacent_edges;
  // False=adjacent tracks,  True=trackbed edges and platform edges.

  pti.drawMSTrackbedEdge := draw_ms_trackbed_edge;
  pti.drawTSTrackbedEdge := draw_ts_trackbed_edge;

  pti.drawTSPlatform := draw_ts_platform;
  pti.drawTSPlatformStartEdge := draw_ts_platform_start_edge;
  pti.drawTSPlatformEndEdge := draw_ts_platform_end_edge;
  pti.drawTSPlatformRearEdge := draw_ts_platform_rear_edge;

  pti.platformTSFrontEdgeIns := platform_ts_front_edge_ins;
  // centre-line to platform front edge 57 inches 215a
  pti.platformTSStartWidthIns := platform_ts_start_width_ins;
  pti.platformTSEndWidthIns := platform_ts_end_width_ins;

  pti.platformTSStartMM := platform_ts_start_mm;
  pti.platformTSLengthMM := platform_ts_length_mm;


  pti.drawMSPlatform := draw_ms_platform;
  pti.drawMSPlatformStartEdge := draw_ms_platform_start_edge;
  pti.drawMSPlatformEndEdge := draw_ms_platform_end_edge;
  pti.drawMSPlatformRearEdge := draw_ms_platform_rear_edge;


  pti.platformMSFrontEdgeIns := platform_ms_front_edge_ins;
  // centre-line to platform front edge 57 inches 215a
  pti.platformMSStartWidthIns := platform_ms_start_width_ins;
  pti.platformMSEndWidthIns := platform_ms_end_width_ins;

  pti.platformMSStartMM := platform_ms_start_mm;
  pti.platformMSLengthMM := platform_ms_length_mm;


  pti.platformMSStartSkewMM := platform_ms_start_skew_mm;    // 207a
  pti.platformMSEndSkewMM := platform_ms_end_skew_mm;        // 207a

  pti.platformTSStartSkewMM := platform_ts_start_skew_mm;    // 207a
  pti.platformTSEndSkewMM := platform_ts_end_skew_mm;        // 207a

  // new trackbed edge functions 215a ...   split MS and TS settings  -  using Single floats to fit available file space ...

  pti.trackbedMSWidthIns := trackbed_ms_width_ins;     // Single
  pti.trackbedTSWidthIns := trackbed_ts_width_ins;     // Single

  pti.cessMSWidthIns := cess_ms_width_ins;             // Single
  pti.cessTSWidthIns := cess_ts_width_ins;             // Single

  pti.drawMSTrackbedCessEdge := draw_ms_trackbed_cess_edge;   // boolean
  pti.drawTSTrackbedCessEdge := draw_ts_trackbed_cess_edge;   // boolean


  pti.trackbedMSStartMM := trackbed_ms_start_mm;
  // extended   need to be extendeds for def_req
  pti.trackbedMSLengthMM := trackbed_ms_length_mm;

  pti.trackbedTSStartMM := trackbed_ts_start_mm;
  pti.trackbedTSLengthMM := trackbed_ts_length_mm;


  target.curve.CopyFrom(controlTemplate.curve);

  rem := target.reminder;

  rem.reminderFlag := False;          // 216a  defaults no reminder yet
  rem.reminderColour := clYellow;
  rem.reminderStr := '';

  cl := target.centreline;
  cl.option := cl_options_code;                   // 206a
  cl.customOffset := cl_options_custom_offset; // 206a


  bd.railSection := rail_section;               // rail head only or head+foot(BH/FB).
  bd.railsInclined := vertical_rails;      // True = rails vertical.

  bd.flatbottomKludge := fb_kludge;    // 0.94.a  FB rail-foot kludge

  bd.printMappingColour := cur_prmap_col;    // 0.76.a  27-10-01 //spare_inta:integer;
  bd.padMarkerColour := cur_padmark_col;     // 0.76.a  27-10-01 //spare_intb:integer;

  bd.usePrintMappingColour := False;  // 0.76.a  27-10-01 //spare_boola:boolean;
  bd.usePadMarkerColour := False;     // 0.76.a  27-10-01 //spare_boolb:boolean;

  bd.disableF7Snap := False;           // 0.82.a  14-10-06  default.


  ti1 := bd.turnoutInfo1;

  ti1.plainTrack := plain_track;            //  True = plain track only.
  ti1.hand := hand_i;                             //  hand of turnout.

  ti1.timbering := timbers_equalized;        //  True = equalized timbering.

  ti1.exitTimbering := exittb_i;           //  exit timbering style.

  ti1.frontTimbers := include_front_timbers;      //  218a
  ti1.switchTimbers := include_switch_timbers;    //  218a
  ti1.closureTimbers := include_closure_timbers;  //  218a
  ti1.xingTimbers := include_xing_timbers;        //  218a

  ti1.approachRailsOnly := approach_rails_only;  // 218a

  // compatibility mods 211a  217a ...

  ti1.turnoutRoadCode:=turnout_road_i;

  ti1.turnoutLength := turnoutx;           //  mm overall length.
  ti1.originToToe := xorg;                //  mm approach length.

  ti1.stepSize := incx;                    //  (use saved step-size on reloading - not default).


  ti2 := target.turnoutInfo2;

  ti2.equalizingFixed := equalizing_fixed;  // equalizing style 1-4-00
  ti2.noTimbering := no_timbering;          // 7-9-00

  ti2.chairing := exp_chairing;       // 214a

  ti2.angledOn := square_on_angled;         // 29-7-01.
  ti2.bonusTimberCount := bontimb;              // 0.76.a  23-10-01.

  ti2.diamondAutoCode := auto_diamond;                  // 0.77.a 27-8-02...
  ti2.timberLengthInc := timbinc;                       // 0.78.a 1-11-02.
  ti2.diamondProtoTimbering := hd_proto_timbering;

  ti2.diamondSwitchTimbering := hd_switch_timbering;  // 213a

  ti2.semiDiamond := half_diamond;
  ti2.diamondFixed := fixed_diamond;   // N.B. fixed diamond will be reset in calc_switch.

  ti2.turnoutRoadEndX := turnout_road_endx;   // 209a

  if plain_track then                       // 208c (max 6 chars) ...
    ti2.templateType := '??pt'
  else
  if half_diamond = True then
    ti2.templateType := '??hd'
  else
    ti2.templateType := '??to';

  ti2.gaunt := gaunt;                      // 0.93.a ex 081
  ti2.gauntOffsetInches := gaunt_offset_in;   // 0.93.a ex 081

  ti2.startDrawX := startx;
  //  turnout startx  3-11-99.

  ti2.smallestRadius := smallest_radius;
  // 208a needed for box data -- not loaded to the control

  ti2.dpx := dpx;    // 208a needed for ID number creation -- not loaded to the control
  ti2.ipx := ipx;    // 208a needed for ID number creation -- not loaded to the control
  ti2.fpx := fpx;    // 208a needed for ID number creation -- not loaded to the control

  pt := target.plainTrackInfo;

  if pt_i > 4 then
    pt.customPlainTrack := True       // list index for custom plain track.
  else
    pt.customPlainTrack := False;

  pt.listIndex := pt_i;
  pt.railLengthInches := railen[pt_i];
  // rail length in inches (only used for custom lengths).
  pt.sleepersPerLength := sleeper_count[pt_i];
  // number of sleepers per length.
  for i := 0 to psleep_c do
    pt.sleeperCentresInches[i] := psleep[pt_i, i];   // spacings (only used for custom spacings).

  pt.plainTrackSpacingName := Copy(
    plain_track_form.plain_track_spacings_listbox.Items.Strings[pt_i], 1, 198);
  // get name from the list.

  pt.userPegX := udpegx;    // user-defined peg data (here to use former spare floats in file)
  pt.userPegY := udpegy;
  pt.userPegK := udpegangle;
  pt.userPegDataValid := udpeg_valid;
  pt.userPegRail := udpeg_rail;

  pt.railJointsCode := rjcode;   // 0=normal, 1=staggered, -1=none (cwr).

  pt.plainTrackTimberRollingPercent := tb_roll_percent;

  pt.gauntSleeperModInches := gaunt_sleeper_mod_in;   // 0.93.a ex 0.81


  // switch stuff ..

  swi := ti2.switchInfo;

  swi.switchPattern := csi.sw_pattern;
  swi.planingLengthInches := csi.planing;
  swi.planingAngle := csi.planing_angle;
  swi.switchRadiusInches := csi.switch_radius_inchormax;
  swi.switchRailLengthInches := csi.switch_rail;
  swi.stockRailLengthInches := csi.stock_rail;
  swi.heelLeadInches := csi.heel_lead_inches;
  swi.heelOffsetInches := csi.heel_offset_inches;
  swi.switchFrontInches := csi.switch_front_inches;
  swi.planingRadiusInches := csi.planing_radius;
  swi.sleeperJ1Inches := csi.sleeper_j1;
  swi.sleeperJ2Inches := csi.sleeper_j2;

  swi.ClearTimberCentres;
  for i := 0 to swtimbco_c do begin
    if (csi.timber_centres[i] = 0) then
      break;
    swi.AddTimberCentres(csi.timber_centres[i]);
  end;

  swi.groupCode := csi.group_code;
  swi.sizeCode := csi.size_code;
  swi.joggleDepthInches := csi.joggle_depth;
  swi.joggleLengthInches := csi.joggle_length;
  swi.groupCount := csi.group_count;
  swi.joggledStockRail := csi.joggled_stock_rail;
  swi.validData := csi.valid_data;
  swi.frontTimbered := csi.front_timbered;
  swi.numBridgeChairsMainRail := csi.num_bridge_chairs_main_rail;
  swi.numBridgeChairsTurnoutRail := csi.num_bridge_chairs_turnout_rail;
  swi.fbTipOffsetInches := csi.fb_tip_offset;
  swi.sleeperJ3Inches := csi.sleeper_j3;
  swi.sleeperJ4Inches := csi.sleeper_j4;
  swi.sleeperJ5Inches := csi.sleeper_j5;
  swi.numSlideChairs := csi.num_slide_chairs;
  swi.numBlockSlideChairs := csi.num_block_slide_chairs;
  swi.numBlockHeelChairs := csi.num_block_heel_chairs;

  // crossing stuff...

  xi := ti2.crossingInfo;

  if retpar_i = 1 then
    xi.pattern := 2
  else
    xi.pattern := xing_type_i;  // 0=straight, 1=curviform, 2=parallel, -1=generic.

  xi.slMode := entry_straight_code;   // 0=auto_fit, 1=use fixed_sl, -1=short
  xi.returnCentresMode := xing_ret_i;
  // 0=return centres as adjacent track, 1=use custom centres.
  xi.k3nUnitAngle := k3n;         // k3n angle in units.
  xi.hdkn := hdkn;        // K-crossing angle in units. 0.93.a
  xi.fixedSt := fixed_sl;    // length of knuckle straight. mm.

  xi.hdTimbersCode := hd_timbers;       // extending of timbers for slip road.
  xi.hdVchecksCode := hd_vcheck_rails;
  // shortening code for half-diamond v-crossing check rails.

  xi.kCheckLength1 := kck1_long;   // length of size 1 k-crossing check rail (inches).
  xi.kCheckLength2 := kck2_long;   // length of size 2 k-crossing check rail (inches).

  xi.kCheckFlare := k_flare_len;  // length of flare on k-crossing check rails. inches F-S

  xi.curviformTimbering := curviform_timbering;   // 215a

  // 0.75.a  9-10-01...

  xi.bluntNoseWidth := bn_wide;         // full-size inches.
  xi.bluntNoseToTimber := bn_to_a;       // full-size inches - to A timber centre.

  xi.veeTimberSpacing := veetimb_sp;
  // full-size inches - timber spacing for vee point rail part of crossing (on from "A").
  xi.wingTimberSpacing := wingtimb_sp;
  // full-size inches - timber spacing for wing rail front part of crossing (up to "A").

  xi.veeJointHalfSpacing := mvj_sp;
  // full-size inches - rail overlap at vee point rail joint.
  xi.wingJointSpacing := wingj_sp;
  // full-size inches - timber spacing at wing rail joint.

  // number of timbers spanned by vee rail incl. "A" timber...

  xi.veeJointSpaceCo1 := vee_spco1;
  xi.veeJointSpaceCo2 := vee_spco2;
  xi.veeJointSpaceCo3 := vee_spco3;
  xi.veeJointSpaceCo4 := vee_spco4;
  xi.veeJointSpaceCo5 := vee_spco5;
  xi.veeJointSpaceCo6 := vee_spco6;

  // number of timbers spanned by wing rail front excl. "A" timber...

  xi.wingJointSpaceCo1 := wing_spco1;
  xi.wingJointSpaceCo2 := wing_spco2;
  xi.wingJointSpaceCo3 := wing_spco3;
  xi.wingJointSpaceCo4 := wing_spco4;
  xi.wingJointSpaceCo5 := wing_spco5;
  xi.wingJointSpaceCo6 := wing_spco6;

  // 0.95.a  K-crossing wing rails ...

  xi.kCustomWingLong := k_custom_wing_long;
  // 0.95.a inches full-size k-crossing wing rails
  xi.kCustomPointLong := k_custom_point_long;
  // 0.95.a inches full-size k-crossing point rails   NYI

  xi.useKCustomWingRails := use_k_custom_wing_rails;    // 0.95.a
  xi.useKCustomPointRails := use_k_custom_point_rails;  // 0.95.a  NYI

  xi.mainRoadEndX := main_road_endx;   // 217a
  xi.mainRoadCode := main_road_i;             // 217a

  xi.tandemTimberCode := tandem_timb;         // 218a


  ti2.omitSwitchFrontJoints := omit_swfj_marks;  // 0.79.a  25-02-03
  ti2.omitSwitchRailJoints := omit_swrj_marks;
  ti2.omitStockRailJoints := omit_skj_marks;
  ti2.omitWingRailJoints := omit_wj_marks;
  ti2.omitVeeRailJoints := omit_vj_marks;
  ti2.omitKCrossingStockRailJoints := omit_kx_marks;


  // copy all the current shoved timber data to the keep.
  target.shovedTimbers.CopyFrom(current_shove_list);
end;

procedure copy_keep(Source: TTemplate);
var
  bd: TBoxDims;
  ri: TRailInfo;
  pi: TProtoInfo;
  ti: TTransformInfo;
  pti: TPlatformTrackbedInfo;
  rem: TReminder;
  ti1: TTurnoutInfo1;
  ti2: TTurnoutInfo2;
  pt: TPlainTrackInfo;
  swi: TSwitchInfo;
  xi: TCrossingInfo;
  cl: TCentreline;

  exact_flag: boolean;
  custom_flag: boolean;
  n: integer;
{
  y_offset: double;
}
begin

  bd := Source.boxDims;

  exact_flag := bd.gaugeExact;
  //nyi ignored in version 0  // If true this is an exact-scale template.
  custom_flag := bd.gaugeCustom;
  //nyi ignored in version 0  // If true this is (or was when saved) a custom gauge setting.

  ri := bd.railInfo;

  flare_type := ri.flaredEnds;  // 0=straight bent  1=straight machined.

  knuckle_code := ri.knuckleCode;
  // 214a  integer;   0=normal, -1=sharp, 1=use knuckle_radius_ri
  knuckle_radius := ri.knuckleRadius;   // 214a  extended;

  // rail switches...

  cl_only := ri.drawCentrelineOnly;   // for bgnd centre-line only.
  dummy_template := ri.dummyTemplateFlag;  // 212a

  track_centre_lines_flag := ri.trackCentreLines;

  switch_drive_flag := ri.switchDrive;  // 0.82.a

  isolated_crossing := ri.isolatedCrossing;    // 217a


  turnout_road_stock_rail_flag := ri.turnoutRoadStockRail;
  turnout_road_check_rail_flag := ri.turnoutRoadCheckRail;
  turnout_road_crossing_rail_flag := ri.turnoutRoadCrossingRail;
  crossing_vee_flag := ri.crossingVee;
  main_road_crossing_rail_flag := ri.mainRoadCrossingRail;
  main_road_check_rail_flag := ri.mainRoadCheckRail;
  main_road_stock_rail_flag := ri.mainRoadStockRail;

  k_diagonal_side_check_rail_flag := ri.kDiagonalSideCheckRail;
  k_main_side_check_rail_flag := ri.kMainSideCheckRail;

  railedges(gauge_faces, outer_edges, centre_lines);   // use these switches.


  pi := bd.protoInfo;
  cpi.name_str_pi := pi.Name;
  cpi.scale_pi := pi.scale;
  cpi.gauge_pi := pi.gauge;
  cpi.fw_pi := pi.flangeway;
  cpi.fwe_pi := pi.flangewayEnd;
  cpi.xing_fl_pi := pi.flareLength;
  cpi.railtop_pi := pi.railtopWidth;
  cpi.trtscent_pi := pi.turnoutSideTrackCentres;
  cpi.trmscent_pi := pi.mainSideTrackCentres;
  cpi.retcent_pi := pi.returnCurveTrackCentres;
  cpi.min_radius_pi := pi.minimumRadius;
  cpi.tbwide_pi := pi.turnoutTimberWidth;
  cpi.slwide_pi := pi.sleeperWidth;
  cpi.ftimbspmax_pi := pi.maxTimberSpacing;
  cpi.tb_pi := pi.sleeperLength;
  cpi.mainside_ends_pi := pi.mainsideEnds;
  cpi.jt_slwide_pi := pi.sleeperWidthAtRailJoint;
  cpi.random_end_pi := pi.timberEndRandomising;
  cpi.timber_thick_pi := pi.timberThickness;
  cpi.random_angle_pi := pi.timberAngleRandomising;
  cpi.ck_ms_working1_pi := pi.checkRailLengthMainSide1;
  cpi.ck_ms_working2_pi := pi.checkRailLengthMainSide2;
  cpi.ck_ms_working3_pi := pi.checkRailLengthMainSide3;
  cpi.ck_ms_ext1_pi := pi.checkRailExtensionMainSide1;
  cpi.ck_ms_ext2_pi := pi.checkRailExtensionMainSide2;
  cpi.wing_ms_reach1_pi := pi.wingRailReachMainSide1;
  cpi.wing_ms_reach2_pi := pi.wingRailReachMainSide2;
  cpi.railbottom_pi := pi.railBottom;
  cpi.rail_height_pi := pi.railHeight;
  cpi.seat_thick_pi := pi.seatThick;
  cpi.rail_inclination_pi := pi.railInclination;
  cpi.foot_height_pi := pi.footHeight;
  cpi.chair_outlen_pi := pi.chairOutLength;
  cpi.chair_inlen_pi := pi.chairInLength;
  cpi.chair_width_pi := pi.chairWidth;
  cpi.chair_corner_pi := pi.chairCornerRadius;


  CopyFromTCheckEndDiff(ccd.end_diff_mw, bd.checkDiffs.endDiffMW);
  CopyFromTCheckEndDiff(ccd.end_diff_me, bd.checkDiffs.endDiffME);
  CopyFromTCheckEndDiff(ccd.end_diff_mr, bd.checkDiffs.endDiffMR);
  CopyFromTCheckEndDiff(ccd.end_diff_tw, bd.checkDiffs.endDiffTW);
  CopyFromTCheckEndDiff(ccd.end_diff_te, bd.checkDiffs.endDiffTE);
  CopyFromTCheckEndDiff(ccd.end_diff_tr, bd.checkDiffs.endDiffTR);

  retain_diffs_on_make := bd.retainDiffsOnMake;    // 0.94.a check rail diffs
  retain_diffs_on_mint := bd.retainDiffsOnMint;    // 0.94.a check rail diffs

  // 0.94.a timber shoving mods..

  retain_shoves_on_make := bd.retainShovesOnMake;
  retain_shoves_on_mint := bd.retainShovesOnMint;

  // 213a  for crossing entry straight

  retain_entry_straight_on_make := bd.retainEntryStraightOnMake;
  retain_entry_straight_on_mint := bd.retainEntryStraightOnMint;

  rail_section := bd.railSection;               // rail head only or head+foot(BH/FB).
  vertical_rails := bd.railsInclined;      // True = rails vertical.

  fb_kludge := bd.flatbottomKludge;    // 0.94.a  FB rail-foot kludge

  label_modx := bd.labelModifierX;
  // 211b not used for control template, but retained for use when stored again
  label_mody := bd.labelModifierY;    // 211b ditto

  ti := bd.transformInfo;

  y_datum := ti.datumY;                   // y datum (green dot).

  xform := ti.x1Shift;                    //  mm    shift info...
  yform := ti.y1Shift;                    //  mm

  kform := ti.kShift;                     //  radians.
  normalize_kform;

  xshift := ti.x2Shift;                   //  mm
  yshift := ti.y2Shift;                   //  mm

  pegx := ti.pegPos.x;      //  mm  peg position.
  pegy := ti.pegPos.y;

  peg_code := ti.pegPointCode;
  if peg_code = -2 then
    peg_code := -1;    // so peg on joints can re-initialise.

  peg_rail := ti.pegPointRail;


  pti := bd.platformTrackbedInfo;

  adjacent_edges := pti.adjacentEdges;
  // False=adjacent tracks,  True=trackbed edges and platform edges.

  draw_ms_trackbed_edge := pti.drawMSTrackbedEdge;
  draw_ts_trackbed_edge := pti.drawTSTrackbedEdge;

  draw_ts_platform := pti.drawTSPlatform;
  draw_ts_platform_start_edge := pti.drawTSPlatformStartEdge;
  draw_ts_platform_end_edge := pti.drawTSPlatformEndEdge;
  draw_ts_platform_rear_edge := pti.drawTSPlatformRearEdge;

  platform_ts_front_edge_ins := pti.platformTSFrontEdgeIns;
  // centre-line to platform front edge 57 inches 4ft-9in  215a            was 2ft-4.3/4in
  platform_ts_start_width_ins := pti.platformTSStartWidthIns;
  platform_ts_end_width_ins := pti.platformTSEndWidthIns;

  platform_ts_start_mm := pti.platformTSStartMM;
  platform_ts_length_mm := pti.platformTSLengthMM;


  draw_ms_platform := pti.drawMSPlatform;
  draw_ms_platform_start_edge := pti.drawMSPlatformStartEdge;
  draw_ms_platform_end_edge := pti.drawMSPlatformEndEdge;
  draw_ms_platform_rear_edge := pti.drawMSPlatformRearEdge;


  platform_ms_front_edge_ins := pti.platformMSFrontEdgeIns;
  // centre-line to platform front edge 57 inches  215a
  platform_ms_start_width_ins := pti.platformMSStartWidthIns;
  platform_ms_end_width_ins := pti.platformMSEndWidthIns;

  platform_ms_start_mm := pti.platformMSStartMM;
  platform_ms_length_mm := pti.platformMSLengthMM;


  platform_ms_start_skew_mm := pti.platformMSStartSkewMM;    // 207a
  platform_ms_end_skew_mm := pti.platformMSEndSkewMM;        // 207a

  platform_ts_start_skew_mm := pti.platformTSStartSkewMM;    // 207a
  platform_ts_end_skew_mm := pti.platformTSEndSkewMM;        // 207a


  // new trackbed edge functions 215a ...   split MS and TS settings  -  using Single floats to fit available file space ...

  trackbed_ms_width_ins := pti.trackbedMSWidthIns;     // Single
  trackbed_ts_width_ins := pti.trackbedTSWidthIns;     // Single

  cess_ms_width_ins := pti.cessMSWidthIns;             // Single
  cess_ts_width_ins := pti.cessTSWidthIns;             // Single

  draw_ms_trackbed_cess_edge := pti.drawMSTrackbedCessEdge;   // boolean
  draw_ts_trackbed_cess_edge := pti.drawTSTrackbedCessEdge;   // boolean


  trackbed_ms_start_mm := pti.trackbedMSStartMM;
  // extended   need to be extendeds for def_req
  trackbed_ms_length_mm := pti.trackbedMSLengthMM;

  trackbed_ts_start_mm := pti.trackbedTSStartMM;
  trackbed_ts_length_mm := pti.trackbedTSLengthMM;


  controlTemplate.curve.CopyFrom(Source.curve);

  cl := Source.centreline;
  cl_options_code := cl.option;                   // 206a
  cl_options_custom_offset := cl.customOffset; // 206a

  rem := Source.reminder;

  if rem.reminderFlag       // 216a
  then begin

    with jotter_form.jotter_memo.Lines do begin

      Add('');
      Add('_______________________');
      Add('');
      Add(DateToStr(Date) + '   ' + TimeToStr(Time) + '   discarded reminder:');
      Add('');
      Add(rem.reminderStr);

    end;//with
  end;


  ti1 := bd.turnoutInfo1;

  plain_track := ti1.plainTrack;               //  True = plain track only.
  hand_i := ti1.hand;                                //  hand of turnout.
  timbers_equalized := ti1.timbering;           //  True = equalized timbering.

  exittb_i := ti1.exitTimbering;           //  exit timbering style.

  include_front_timbers := ti1.frontTimbers;      //  218a
  include_switch_timbers := ti1.switchTimbers;    //  218a
  include_closure_timbers := ti1.closureTimbers;  //  218a
  include_xing_timbers := ti1.xingTimbers;        //  218a

  approach_rails_only := ti1.approachRailsOnly;  // 218a


  // compatibility mods 211a ...

  turnout_road_i := ti1.turnoutRoadCode;

  turnoutx := ti1.turnoutLength;           //  mm overall length.
  xorg := ti1.originToToe;                //  mm approach length.
  incx := ti1.stepSize;                    //  (use saved step-size on reloading - not default).

  turnoutx_max := xy_pts_c * incx;        // limit overall length.


  if turnoutx > turnoutx_max then
    turnoutx := turnoutx_max;
  if xorg > turnoutx then
    xorg := turnoutx;


  ti2 := Source.turnoutInfo2;

  equalizing_fixed := ti2.equalizingFixed;     //     1-4-00
  no_timbering := ti2.noTimbering;             //     7-9-00

  exp_chairing := ti2.chairing;       // 214a

  square_on_angled := ti2.angledOn;            // 29-7-01.
  bontimb := ti2.bonusTimberCount;                 // 0.76.a  23-10-01.

  auto_diamond := ti2.diamondAutoCode;                   // 0.77.a 27-8-02...
  timbinc := ti2.timberLengthInc;                        // 0.78.a 11-11-02.
  hd_proto_timbering := ti2.diamondProtoTimbering;

  hd_switch_timbering := ti2.diamondSwitchTimbering;  // 213a

  half_diamond := ti2.semiDiamond;
  fixed_diamond := ti2.diamondFixed;   // N.B. fixed diamond will be reset in calc_switch.

  turnout_road_endx := ti2.turnoutRoadEndX;   // 209a

  gaunt := ti2.gaunt;                       // 0.93.a ex 0.81
  gaunt_offset_in := ti2.gauntOffsetInches;    // 0.93.a ex 0.81

  startx := ti2.startDrawX;               //    turnout startx  3-11-99

  pt := Source.plainTrackInfo;

  if (pt.customPlainTrack) or (pt.listIndex > 4) then begin
    pt_i := plain_track_form.plain_track_spacings_listbox.Items.Count - 1;
    // list index for current custom plain track.
    railen[pt_i] := pt.railLengthInches;
    // custom rail length in inches.
    sleeper_count[pt_i] := pt.sleepersPerLength;
    // number of sleepers per length.
    for n := 0 to psleep_c do
      psleep[pt_i, n] := pt.sleeperCentresInches[n];   // custom spacings.

    plain_track_form.plain_track_spacings_listbox.Items.Strings[pt_i] :=
      '  ' + Trim(pt.plainTrackSpacingName);   // put name in the list.
  end
  else
    pt_i := pt.listIndex;
  // copy data if custom, otherwise use index into existing list.


  udpegx := pt.userPegX;    // user-defined peg data (here to use former spare floats in file)
  udpegy := pt.userPegY;
  udpegangle := pt.userPegK;
  udpeg_valid := pt.userPegDataValid;
  udpeg_rail := pt.userPegRail;

  rjcode := pt.railJointsCode;   // 0=normal, 1=staggered, -1=none (cwr).

  tb_roll_percent := pt.plainTrackTimberRollingPercent;

  gaunt_sleeper_mod_in := pt.gauntSleeperModInches;   // 0.93.a ex 0.81

  //spares:Tspares;

  // switch stuff...

  if not set_csi_from_switch_info(ti2.switchInfo)  // set current switch from supplied info.
  then begin
    if set_csi_data(2, 2) = False     // set REA B default if copied data invalid.
    then
      run_error(82);         // ?????? no B switch in list?
  end;

  // crossing stuff...

  xi := ti2.crossingInfo;
  case xi.pattern of
    -1: begin
      xing_type_i := -1;
      retpar_i := 0;
    end;  // generic crossing.
    0: begin
      xing_type_i := 0;
      retpar_i := 0;
    end;  // straight crossing...
    1: begin
      xing_type_i := 1;
      retpar_i := 0;
    end;  // curviform V-crossing...
    2: begin
      xing_type_i := 0;
      retpar_i := 1;
    end;  // parallel crossing...
    else begin
      xing_type_i := 0;
      retpar_i := 0;
    end;  // safety ! (default straight crossing)...
  end;//case

  if (xing_type_i <> 0) and (peg_code = 108) then
    peg_code := 0;   // added 205e  not a regular crossing   108=CESP

  entry_straight_code := xi.slMode;       // 0=auto_fit, 1=use fixed_sl, -1=short
  xing_ret_i := xi.returnCentresMode;
  // 0=return centres as adjacent track, 1=use custom centres.
  k3n := xi.k3nUnitAngle;    // k3n angle in units.
  hdkn := xi.hdkn;   // K-crossing angle in units. // 0.93.a
  fixed_sl := xi.fixedSt;          // length of knuckle straight. mm.

  hd_timbers := xi.hdTimbersCode;     // extending of timbers for slip road.
  hd_vcheck_rails := xi.hdVchecksCode;
  // shortening code for half-diamond v-crossing check rails.

  kck1_long := xi.kCheckLength1;  // length of size 1 k-crossing check rail (inches).
  kck2_long := xi.kCheckLength2;  // length of size 2 k-crossing check rail (inches).

  k_flare_len := xi.kCheckFlare;     // length of flare on k-crossing check rails. inches F-S

  curviform_timbering := xi.curviformTimbering;   // 215a

  // 0.75.a  9-10-01...

  bn_wide := xi.bluntNoseWidth;      // full-size inches.
  bn_to_a := xi.bluntNoseToTimber;    // full-size inches - to A timber centre.

  veetimb_sp := xi.veeTimberSpacing;
  // full-size inches - timber spacing for vee point rail part of crossing (on from "A").
  wingtimb_sp := xi.wingTimberSpacing;
  // full-size inches - timber spacing for wing rail front part of crossing (up to "A").

  mvj_sp := xi.veeJointHalfSpacing;
  // full-size inches - rail overlap at vee point rail joint.
  wingj_sp := xi.wingJointSpacing;
  // full-size inches - timber spacing at wing rail joint.


  // number of timbers spanned by vee rail incl. "A" timber...

  vee_spco1 := xi.veeJointSpaceCo1;
  vee_spco2 := xi.veeJointSpaceCo2;
  vee_spco3 := xi.veeJointSpaceCo3;
  vee_spco4 := xi.veeJointSpaceCo4;
  vee_spco5 := xi.veeJointSpaceCo5;
  vee_spco6 := xi.veeJointSpaceCo6;

  // number of timbers spanned by wing rail front excl. "A" timber...

  wing_spco1 := xi.wingJointSpaceCo1;
  wing_spco2 := xi.wingJointSpaceCo2;
  wing_spco3 := xi.wingJointSpaceCo3;
  wing_spco4 := xi.wingJointSpaceCo4;
  wing_spco5 := xi.wingJointSpaceCo5;
  wing_spco6 := xi.wingJointSpaceCo6;

  // 0.95.a  K-crossing wing rails ...

  k_custom_wing_long := xi.kCustomWingLong;
  // 0.95.a inches full-size k-crossing wing rails
  k_custom_point_long := xi.kCustomPointLong;
  // 0.95.a inches full-size k-crossing point rails   NYI

  use_k_custom_wing_rails := xi.useKCustomWingRails;    // 0.95.a
  use_k_custom_point_rails := xi.useKCustomPointRails;  // 0.95.a  NYI

  main_road_endx := xi.mainRoadEndX;   // 217a
  main_road_i := xi.mainRoadCode;             // 217a

  tandem_timb := xi.tandemTimberCode;         // 218a


  omit_swfj_marks := ti2.omitSwitchFrontJoints;  // 0.79.a  25-02-03
  omit_swrj_marks := ti2.omitSwitchRailJoints;
  omit_skj_marks := ti2.omitStockRailJoints;
  omit_wj_marks := ti2.omitWingRailJoints;
  omit_vj_marks := ti2.omitVeeRailJoints;
  omit_kx_marks := ti2.omitKCrossingStockRailJoints;


  // copy all the shoved timber data.
  current_shove_list.CopyFrom(Source.shovedTimbers);

  // and update everything...
  update_menus;

end;

end.
