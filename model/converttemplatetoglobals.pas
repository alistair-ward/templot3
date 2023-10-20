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
  ShovedTimber,
  control_room,
  info_unit,
  keep_select,
  math_unit,
  pad_unit,
  BoxDims,
  RailInfo;

//______________________________________________________________________________
//
// copy control template data to the keep template.
//
procedure fill_kd(target: TTemplate);

var
  n: integer;
  rand_label_factor: double;

  bd: TBoxDims;
  ri: TRailInfo;

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
{
    auto_restore_on_startup := False;
    // defaults - changed on saving the backup (these two only read from the first keep in the file)..
    ask_restore_on_startup := True;

    bgnd_code_077 := 0;                  // can't go on background until in keeps box.
    pre077_bgnd_flag := False;           // in case reloaded in older version than 0.77.a

    templot_version := file_version;

    gauge_index := gauge_i;            // index into the gauge list. Only for showing the list,
    // the data comes from the file.

    if gauge_i = gauge_form.gauge_listbox.Items.Count - 1 then
      gauge_exact := True
    // nyi // If true this is an exact-scale template.
    else
      gauge_exact := False;

    if (gauge_i < gauge_form.gauge_listbox.Items.Count - 1) and
      (gauge_i > gauge_form.gauge_listbox.Items.Count - 6)  // 4 custom slots -2, -3, -4, -5.

    then
      gauge_custom := True   // nyi // If true this is (or was when saved) a custom gauge setting.
    else
      gauge_custom := False;

    proto_info := cpi;              // all the current gauge-size dimensions.

    check_diffs := ccd;             // all the check-rail diffs. 0.94.a

    retain_diffs_on_make_flag := retain_diffs_on_make;    // 0.94.a check rail diffs
    retain_diffs_on_mint_flag := retain_diffs_on_mint;    // 0.94.a check rail diffs

    // 0.94.a timber shoving mods..

    retain_shoves_on_make_flag := retain_shoves_on_make;
    retain_shoves_on_mint_flag := retain_shoves_on_mint;

    // 213a  for crossing entry straight

    retain_entry_straight_on_make_flag := retain_entry_straight_on_make;
    retain_entry_straight_on_mint_flag := retain_entry_straight_on_mint;


    box_save_done := False;
    // default, changed on saving backup, read only from first keep on restore previous contents. 23-6-00 v:0.62.a //spare_flag1:boolean;

    // name label position modifiers..

    // 211b mods...

    if (control_room_form.previous_labels_menu_entry.Checked = True)   // 211b option
      or ((GetKeyState(VK_CONTROL) and -2) <> 0)                       // or CTRL-Key down
    then begin
      mod_text_x := label_modx;    // 211b put label back where it was
      mod_text_y := label_mody;
    end
    else begin
      // 0.82.a randomise label position (if currently on default)...

      if control_room_form.fixed_labels_menu_entry.Checked = True then begin
        mod_text_x := 0;
        mod_text_y := 0;
      end
      else begin
        if control_room_form.very_random_labels_menu_entry.Checked = True then
          rand_label_factor := 3.0
        else
          rand_label_factor := 1.0;

        mod_text_x := ((Random * 30) - 15) * scale * rand_label_factor;
        // 0.82.a up to 15ft either way of randomising. arbitrary.
        mod_text_y := ((Random * 12) - 4) * scale * rand_label_factor;
        // 0.82.a add -4ft to +8ft of randomising. arbitrary.
      end;
    end;

    with transform_info do begin

      datum_y := y_datum;                   // y datum (green dot).

      x_go_limit := minfp;                  // nyi // print cropping limits (paper inches)...
      x_stop_limit := minfp;                // nyi


      transforms_apply := True;             // !!! no longer used. False=ignore transform data.

      // transform data...

      x1_shift := xform;                    //  mm    (xform,yform always zero after a normalize,)
      y1_shift := yform;                    //  mm    (e.g. for keeps, etc. (but not roll-back).  )
      k_shift := kform;                     //  radians.
      x2_shift := xshift;                   //  mm
      y2_shift := yshift;                   //  mm

      peg_pos.x := pegx;                    //  mm  peg position.
      peg_pos.y := pegy;

      peg_point_code := peg_code;
      peg_point_rail := peg_rail;

      mirror_on_x := False;                 //  nyi // True= invert on x.
      mirror_on_y := False;                 //  nyi // True= invert on y. (swap hand).

      // also save the peg position in file as notch data..

      notch_info := get_peg_for_notch;
    end;//with

    with platform_trackbed_info do begin   // 0.93.a was  Tcheck_rail_mints=record

      adjacent_edges_keep := adjacent_edges;
      // False=adjacent tracks,  True=trackbed edges and platform edges.

      draw_ms_trackbed_edge_keep := draw_ms_trackbed_edge;
      draw_ts_trackbed_edge_keep := draw_ts_trackbed_edge;

      draw_ts_platform_keep := draw_ts_platform;
      draw_ts_platform_start_edge_keep := draw_ts_platform_start_edge;
      draw_ts_platform_end_edge_keep := draw_ts_platform_end_edge;
      draw_ts_platform_rear_edge_keep := draw_ts_platform_rear_edge;

      platform_ts_front_edge_ins_keep := platform_ts_front_edge_ins;
      // centre-line to platform front edge 57 inches 215a
      platform_ts_start_width_ins_keep := platform_ts_start_width_ins;
      platform_ts_end_width_ins_keep := platform_ts_end_width_ins;

      platform_ts_start_mm_keep := platform_ts_start_mm;
      platform_ts_length_mm_keep := platform_ts_length_mm;


      draw_ms_platform_keep := draw_ms_platform;
      draw_ms_platform_start_edge_keep := draw_ms_platform_start_edge;
      draw_ms_platform_end_edge_keep := draw_ms_platform_end_edge;
      draw_ms_platform_rear_edge_keep := draw_ms_platform_rear_edge;


      platform_ms_front_edge_ins_keep := platform_ms_front_edge_ins;
      // centre-line to platform front edge 57 inches 215a
      platform_ms_start_width_ins_keep := platform_ms_start_width_ins;
      platform_ms_end_width_ins_keep := platform_ms_end_width_ins;

      platform_ms_start_mm_keep := platform_ms_start_mm;
      platform_ms_length_mm_keep := platform_ms_length_mm;


      platform_ms_start_skew_mm_keep := platform_ms_start_skew_mm;    // 207a
      platform_ms_end_skew_mm_keep := platform_ms_end_skew_mm;        // 207a

      platform_ts_start_skew_mm_keep := platform_ts_start_skew_mm;    // 207a
      platform_ts_end_skew_mm_keep := platform_ts_end_skew_mm;        // 207a

      // new trackbed edge functions 215a ...   split MS and TS settings  -  using Single floats to fit available file space ...

      trackbed_ms_width_ins_keep := trackbed_ms_width_ins;     // Single
      trackbed_ts_width_ins_keep := trackbed_ts_width_ins;     // Single

      cess_ms_width_ins_keep := cess_ms_width_ins;             // Single
      cess_ts_width_ins_keep := cess_ts_width_ins;             // Single

      draw_ms_trackbed_cess_edge_keep := draw_ms_trackbed_cess_edge;   // boolean
      draw_ts_trackbed_cess_edge_keep := draw_ts_trackbed_cess_edge;   // boolean


      trackbed_ms_start_mm_keep := trackbed_ms_start_mm;
      // extended   need to be extendeds for def_req
      trackbed_ms_length_mm_keep := trackbed_ms_length_mm;

      trackbed_ts_start_mm_keep := trackbed_ts_start_mm;
      trackbed_ts_length_mm_keep := trackbed_ts_length_mm;

    end;//with platform_trackbed_info


    with align_info do begin

      curving_flag := True;
      // no longer used 0.77.a - all templates curved (straight=max_rad).

      trans_flag := controlTemplate.curve.isSpiral;
      // True=transition, False=fixed radius curving.

      fixed_rad := controlTemplate.curve.fixedRadius;       // fixed radius mm.
      trans_rad1 := controlTemplate.curve.transitionStartRadius;     // first transition radius mm.
      trans_rad2 := controlTemplate.curve.transitionEndRadius;     // second transition radius mm.
      trans_length := controlTemplate.curve.transitionLength;       // length of transition mm.
      trans_start := controlTemplate.curve.distanceToTransition;         // start of transition mm.
      rad_offset := 0;   // curving line offset mm.   // scrapped 26-7-00.

      slewing_flag := controlTemplate.curve.isSlewing;   // slewing flag.             // !!! replacing Tspares 10-7-99...
      slew_start := controlTemplate.curve.distanceToStartOfSlew;      // slewing zone start mm.
      slew_length := controlTemplate.curve.slewLength;     // slewing zone length mm.
      slew_amount := controlTemplate.curve.slewAmount;       // amount of slew mm.

      try
        tanh_kmax := controlTemplate.curve.slewFactor;     // ! double from extended..
        slew_type := SlewModeToByte(controlTemplate.curve.slewMode);      // ! byte from integer.
      except
        // in case of overflows...
        tanh_kmax := 2;
        slew_type := 1;
      end;//try

      cl_only_flag := cl_only;    // for bgnd centre-line only.

      dummy_template_flag := dummy_template;  // 212a

      cl_options_code_int := cl_options_code;                   // 206a
      cl_options_custom_offset_ext := cl_options_custom_offset; // 206a

      reminder_flag := False;          // 216a  defaults no reminder yet
      reminder_colour := clYellow;
      reminder_str := '';
    end;//with

    rail_type := rail_section;               // rail head only or head+foot(BH/FB).
    uninclined_rails := vertical_rails;      // True = rails vertical.

    fb_kludge_template_code := fb_kludge;    // 0.94.a  FB rail-foot kludge

    print_mapping_colour := cur_prmap_col;    // 0.76.a  27-10-01 //spare_inta:integer;
    pad_marker_colour := cur_padmark_col;     // 0.76.a  27-10-01 //spare_intb:integer;

    use_print_mapping_colour := False;  // 0.76.a  27-10-01 //spare_boola:boolean;
    use_pad_marker_colour := False;     // 0.76.a  27-10-01 //spare_boolb:boolean;

    disable_f7_snap := False;           // 0.82.a  14-10-06  default.


    with turnout_info1 do begin

      plain_track_flag := plain_track;            //  True = plain track only.
      hand := hand_i;                             //  hand of turnout.

      timbering_flag := timbers_equalized;        //  True = equalized timbering.

      exit_timbering := exittb_i;           //  exit timbering style.

      front_timbers_flag := include_front_timbers;      //  218a
      switch_timbers_flag := include_switch_timbers;    //  218a
      closure_timbers_flag := include_closure_timbers;  //  218a
      xing_timbers_flag := include_xing_timbers;        //  218a

      approach_rails_only_flag := approach_rails_only;  // 218a

      // compatibility mods 211a  217a ...

      if turnout_road_i = 2          // adjustable turnout road exit
      then begin
        turnout_road_code := 0;
        // so can be loaded in 208 and earlier ( =2 will crash)
        turnout_road_is_adjustable := True;
      end
      else
      if turnout_road_i = 3  // minimum turnout road exit   217a
      then begin
        turnout_road_code := 0;
        // so can be loaded in 208 and earlier ( =3 will crash)
        turnout_road_is_minimum := True;
      end

      else begin
        turnout_road_code := turnout_road_i;    //  length of turnout exit road.
        turnout_road_is_adjustable := False;
        turnout_road_is_minimum := False;       // 217a
      end;

      turnout_length := turnoutx;           //  mm overall length.
      origin_to_toe := xorg;                //  mm approach length.

      step_size := incx;                    //  (use saved step-size on reloading - not default).

    end;//with turnout_info1

  end;//with

  with target.template_info.keep_dims.turnout_info2 do begin

    equalizing_fixed_flag := equalizing_fixed;  // equalizing style 1-4-00
    no_timbering_flag := no_timbering;          // 7-9-00

    chairing_flag := exp_chairing;       // 214a

    angled_on_flag := square_on_angled;         // 29-7-01.
    bonus_timber_count := bontimb;              // 0.76.a  23-10-01.

    diamond_auto_code := auto_diamond;                  // 0.77.a 27-8-02...
    timber_length_inc := timbinc;                       // 0.78.a 1-11-02.
    diamond_proto_timbering_flag := hd_proto_timbering;

    diamond_switch_timbering_flag := hd_switch_timbering;  // 213a

    semi_diamond_flag := half_diamond;
    diamond_fixed_flag := fixed_diamond;   // N.B. fixed diamond will be reset in calc_switch.

    turnout_road_endx_infile := turnout_road_endx;   // 209a

    if plain_track = True                       // 208c (max 6 chars) ...
    then
      template_type_str := '??pt'
    else
    if half_diamond = True then
      template_type_str := '??hd'
    else
      template_type_str := '??to';

    gaunt_flag := gaunt;                      // 0.93.a ex 081
    gaunt_offset_inches := gaunt_offset_in;   // 0.93.a ex 081

    start_draw_x := startx;
    //  turnout startx  3-11-99.

    smallest_radius_stored := smallest_radius;
    // 208a needed for box data -- not loaded to the control

    dpx_stored := dpx;    // 208a needed for ID number creation -- not loaded to the control
    ipx_stored := ipx;    // 208a needed for ID number creation -- not loaded to the control
    fpx_stored := fpx;    // 208a needed for ID number creation -- not loaded to the control

    with plain_track_info do begin

      if pt_i > 4 then
        pt_custom := True       // list index for custom plain track.
      else
        pt_custom := False;

      list_index := pt_i;
      rail_length := railen[pt_i];
      // rail length in inches (only used for custom lengths).
      sleepers_per_length := sleeper_count[pt_i];
      // number of sleepers per length.
      for n := 0 to psleep_c do
        sleeper_centres[n] := psleep[pt_i, n];   // spacings (only used for custom spacings).

      pt_spacing_name_str := Copy(
        plain_track_form.plain_track_spacings_listbox.Items.Strings[pt_i], 1, 198);
      // get name from the list.

      user_pegx := udpegx;    // user-defined peg data (here to use former spare floats in file)
      user_pegy := udpegy;
      user_pegk := udpegangle;
      user_peg_data_valid := udpeg_valid;
      user_peg_rail := udpeg_rail;

      rail_joints_code := rjcode;   // 0=normal, 1=staggered, -1=none (cwr).

      pt_tb_rolling_percent := tb_roll_percent;

      gaunt_sleeper_mod_inches := gaunt_sleeper_mod_in;   // 0.93.a ex 0.81

    end;//with plain_track_info

    // switch stuff ..

    switch_info := csi;  // current switch.

    // crossing stuff...

    with crossing_info do begin

      if retpar_i = 1 then
        pattern := 2
      else
        pattern := xing_type_i;  // 0=straight, 1=curviform, 2=parallel, -1=generic.

      sl_mode := entry_straight_code;   // 0=auto_fit, 1=use fixed_sl, -1=short
      retcent_mode := xing_ret_i;
      // 0=return centres as adjacent track, 1=use custom centres.
      k3n_unit_angle := k3n;         // k3n angle in units.
      hdkn_unit_angle := hdkn;        // K-crossing angle in units. 0.93.a
      fixed_st := fixed_sl;    // length of knuckle straight. mm.

      hd_timbers_code := hd_timbers;       // extending of timbers for slip road.
      hd_vchecks_code := hd_vcheck_rails;
      // shortening code for half-diamond v-crossing check rails.

      k_check_length_1 := kck1_long;   // length of size 1 k-crossing check rail (inches).
      k_check_length_2 := kck2_long;   // length of size 2 k-crossing check rail (inches).

      k_check_flare := k_flare_len;  // length of flare on k-crossing check rails. inches F-S

      curviform_timbering_keep := curviform_timbering;   // 215a

      // 0.75.a  9-10-01...

      blunt_nose_width := bn_wide;         // full-size inches.
      blunt_nose_to_timb := bn_to_a;       // full-size inches - to A timber centre.

      vee_timber_spacing := veetimb_sp;
      // full-size inches - timber spacing for vee point rail part of crossing (on from "A").
      wing_timber_spacing := wingtimb_sp;
      // full-size inches - timber spacing for wing rail front part of crossing (up to "A").

      vee_joint_half_spacing := mvj_sp;
      // full-size inches - rail overlap at vee point rail joint.
      wing_joint_spacing := wingj_sp;      // full-size inches - timber spacing at wing rail joint.

      // number of timbers spanned by vee rail incl. "A" timber...

      vee_joint_space_co1 := vee_spco1;
      vee_joint_space_co2 := vee_spco2;
      vee_joint_space_co3 := vee_spco3;
      vee_joint_space_co4 := vee_spco4;
      vee_joint_space_co5 := vee_spco5;
      vee_joint_space_co6 := vee_spco6;

      // number of timbers spanned by wing rail front excl. "A" timber...

      wing_joint_space_co1 := wing_spco1;
      wing_joint_space_co2 := wing_spco2;
      wing_joint_space_co3 := wing_spco3;
      wing_joint_space_co4 := wing_spco4;
      wing_joint_space_co5 := wing_spco5;
      wing_joint_space_co6 := wing_spco6;

      // 0.95.a  K-crossing wing rails ...

      k_custom_wing_long_keep := k_custom_wing_long;
      // 0.95.a inches full-size k-crossing wing rails
      k_custom_point_long_keep := k_custom_point_long;
      // 0.95.a inches full-size k-crossing point rails   NYI

      use_k_custom_wing_rails_keep := use_k_custom_wing_rails;    // 0.95.a
      use_k_custom_point_rails_keep := use_k_custom_point_rails;  // 0.95.a  NYI

      main_road_endx_infile := main_road_endx;   // 217a
      main_road_code := main_road_i;             // 217a

      tandem_timber_code := tandem_timb;         // 218a

    end;//with crossing_info

    omit_switch_front_joints := omit_swfj_marks;  // 0.79.a  25-02-03
    omit_switch_rail_joints := omit_swrj_marks;
    omit_stock_rail_joints := omit_skj_marks;
    omit_wing_rail_joints := omit_wj_marks;
    omit_vee_rail_joints := omit_vj_marks;
    omit_k_crossing_stock_rail_joints := omit_kx_marks;

  end;//with turnout_info2

  copy_shove_list(False, current_shove_list, target.template_info.keep_shove_list);
  // copy all the current shoved timber data to the keep.
}
end;

procedure copy_keep(Source: TTemplate);
begin

end;

end.
