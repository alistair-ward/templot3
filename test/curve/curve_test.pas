
(*
    This file is part of OpenTemplot, a computer program for the design of
    model railway track.

    Copyright (C) 2019  OpenTemplot project contributors

    This program is free software: you may redistribute it and/or modify
    it under the terms of the GNU General Public Licence as published by
    the Free Software Foundation, either version 3 of the Licence, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU General Public Licence for more details.

    You should have received a copy of the GNU General Public Licence
    along with this program. See the files: licence.txt or opentemplot.lpr

    Or if not, refer to the web site: https://www.gnu.org/licenses/

                >>>     NOTE TO DEVELOPERS     <<<
                     DO NOT EDIT THIS COMMENT
              It is inserted in this file by running
                  'python3 scripts/addComment.py'
         The original text lives in scripts/addComment.py.

====================================================================================
*)

unit curve_test;

{$mode delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  curve,
  point_ex;

type

  { TTestableCurve }

  TTestableCurve = class(TCurve)
  public
    // expose property for testing
    property curveCalculator;
  end;

  { TTestCurve }

  TTestCurve = class(TTestCase)
  protected
    curve: TTestableCurve;

    procedure Setup; override;
    procedure TearDown; override;

    procedure do_test_transition(r1, r2, initialLength, transitionLength: double);
    procedure do_test_centreline_distance_from_offset_transition(r1, r2,
      initialLength, transitionLength: double);

  published
    procedure test_straight_line;
    procedure test_single_radius_positive;
    procedure test_single_radius_negative;
    procedure test_transition_curve_straight_positive;
    procedure test_transition_curve_straight_negative;
    procedure test_transition_curve_positive_straight;
    procedure test_transition_curve_negative_straight;
    procedure test_transition_curve_positive_positive_increasing;
    procedure test_transition_curve_positive_positive_decreasing;
    procedure test_transition_curve_negative_negative_increasing;
    procedure test_transition_curve_negative_negative_decreasing;
    procedure test_transition_curve_positive_to_larger_negative;
    procedure test_transition_curve_positive_to_smaller_negative;
    procedure test_transition_curve_negative_to_larger_positive;
    procedure test_transition_curve_negative_to_smaller_positive;

    procedure test_straight_line_offset;

    procedure test_calculate_centreline_distance_from_offset_distance_straight;
    procedure test_calculate_centreline_distance_from_offset_distance_single_radius_positive;
    procedure test_calculate_centreline_distance_from_offset_distance_single_radius_negative;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_straight_positive;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_straight_negative;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_straight;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_straight;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_positive_increasing;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_positive_decreasing;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_negative_increasing;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_negative_decreasing;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_to_larger_negative;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_to_smaller_negative;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_to_larger_positive;
    procedure test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_to_smaller_positive;

    procedure test_slew_creation;

    procedure test_CopyFrom;
  end;

implementation

uses
  curve_parameters_interface,
  slew_calculator;

procedure TTestCurve.Setup;
begin
  curve := TTestableCurve.Create(nil);
end;

procedure TTestCurve.TearDown;
begin
  curve.Free;
end;

procedure TTestCurve.test_straight_line;
var
  pt: Tpex;
  direction: Tpex;
  radius: double;
  i: integer;
  distance: double;
begin
  // Given a curve that is defined as straight
  //    ( radius = max_radius, not spiral )
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is on a straight line
  //

  curve.fixedRadius := max_rad_limit;
  curve.isSpiral := False;

  distance := 0;
  for i := 0 to 20 do begin
    curve.CalculateCurveAt(distance, 0, pt, direction, radius);

    CheckEquals(i, pt.X, 1e-6, format('pt.X at %f', [distance]));
    CheckEquals(0, pt.Y, 1e-6, format('pt.Y at %f', [distance]));
    CheckEquals(1, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(0, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(max_rad, radius, 1, format('radius at %f', [distance]));

    curve.CalculateCurveAt(distance, 10, pt, direction, radius);

    CheckEquals(i, pt.X, 1e-6, format('pt.X at %f', [distance]));
    CheckEquals(-10, pt.Y, 1e-6, format('pt.Y at %f', [distance]));
    CheckEquals(1, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(0, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(max_rad, radius, 1, format('radius at %f', [distance]));

    curve.CalculateCurveAt(distance, -10, pt, direction, radius);

    CheckEquals(i, pt.X, 1e-6, format('pt.X at %f', [distance]));
    CheckEquals(10, pt.Y, 1e-6, format('pt.Y at %f', [distance]));
    CheckEquals(1, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(0, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(max_rad, radius, 1, format('radius at %f', [distance]));

    distance := distance + 1.0;
  end;

end;

procedure TTestCurve.test_single_radius_positive;
const
  testRadius = 5000;
var
  i: integer;
  distance: double;
  pt: Tpex;
  direction: Tpex;
  radius: double;
  circleOrigin: Tpex;
  expectedDirection: Tpex;
  angle: double;
  distanceFromOrigin: double;
begin
  // Given a curve that is defined as a single radius
  //    ( radius = 5m, not spiral )
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is a distance of 5m from (0, 5)
  //
  curve.fixedRadius := testRadius;
  curve.isSpiral := False;

  circleOrigin.set_xy(0, testRadius);

  distance := 0;
  for i := 0 to 20 do begin
    curve.CalculateCurveAt(distance, 0, pt, direction, radius);

    angle := distance / testRadius;
    expectedDirection.set_xy(cos(angle), sin(angle));

    distanceFromOrigin := (circleOrigin - pt).magnitude;

    CheckEquals(testRadius, distanceFromOrigin, 1e-6,
      format('distance from origin at %f', [distance]));
    CheckEquals(expectedDirection.X, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(expectedDirection.Y, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(testRadius, radius, 1, format('radius at %f', [distance]));


    // and now check a +ve offset curve - radius should be greater...
    curve.CalculateCurveAt(distance, 100, pt, direction, radius);
    distanceFromOrigin := (circleOrigin - pt).magnitude;

    CheckEquals(testRadius + 100, distanceFromOrigin, 1e-6,
      format('distance from origin at %f', [distance]));
    CheckEquals(expectedDirection.X, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(expectedDirection.Y, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(testRadius + 100, radius, 1, format('radius at %f', [distance]));

    // and now check -ve offset curve - radius should be less...
    curve.CalculateCurveAt(distance, -100, pt, direction, radius);
    distanceFromOrigin := (circleOrigin - pt).magnitude;

    CheckEquals(testRadius - 100, distanceFromOrigin, 1e-6,
      format('distance from origin at %f', [distance]));
    CheckEquals(expectedDirection.X, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(expectedDirection.Y, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(testRadius - 100, radius, 1, format('radius at %f', [distance]));


    distance := distance + 100;
  end;
end;

procedure TTestCurve.test_single_radius_negative;
const
  testRadius = -8000;
var
  i: integer;
  distance: double;
  pt: Tpex;
  direction: Tpex;
  radius: double;
  circleOrigin: Tpex;
  expectedDirection: Tpex;
  angle: double;
  distanceFromOrigin: double;
begin
  // Given a curve that is defined as a single negative radius, turning to the right
  //    ( radius = -8m, not spiral )
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is a distance of 8m from (0, -8)
  //
  curve.fixedRadius := testRadius;
  curve.isSpiral := False;

  circleOrigin.set_xy(0, testRadius);

  distance := 0;
  for i := 0 to 20 do begin
    curve.CalculateCurveAt(distance, 0, pt, direction, radius);

    angle := distance / testRadius;
    expectedDirection.set_xy(cos(angle), sin(angle));

    distanceFromOrigin := (circleOrigin - pt).magnitude;

    CheckEquals(abs(testRadius), distanceFromOrigin, 1e-6,
      format('distance from origin at %f', [distance]));
    CheckEquals(expectedDirection.X, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(expectedDirection.Y, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(testRadius, radius, 1, format('radius at %f', [distance]));

    // check a +ve offset curve, radius should be less..
    curve.CalculateCurveAt(distance, 100, pt, direction, radius);

    distanceFromOrigin := (circleOrigin - pt).magnitude;

    CheckEquals(abs(testRadius) - 100, distanceFromOrigin, 1e-6,
      format('distance from origin at %f', [distance]));
    CheckEquals(expectedDirection.X, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(expectedDirection.Y, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(testRadius + 100, radius, 1, format('radius at %f', [distance]));

    // check a -ve offset curve, radius should be greater..
    curve.CalculateCurveAt(distance, -100, pt, direction, radius);

    distanceFromOrigin := (circleOrigin - pt).magnitude;

    CheckEquals(abs(testRadius) + 100, distanceFromOrigin, 1e-6,
      format('distance from origin at %f', [distance]));
    CheckEquals(expectedDirection.X, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(expectedDirection.Y, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(testRadius - 100, radius, 1, format('radius at %f', [distance]));

    distance := distance + 100;
  end;
end;


procedure TTestCurve.do_test_transition(r1, r2, initialLength, transitionLength: double);
const
  testStepSize = 5;
  testStepTolerance = 0.05;
var
  distance: double;
  pt: Tpex;
  direction: Tpex;
  radius: double;
  previousPoint: Tpex;
  delta: Tpex;
  expectedCurvature: double;
  expectedRadius: double;
  distanceFromPrevious: double;
  curvature1: double;
  curvature2: double;
  offsetPt: Tpex;
  offsetDirection: Tpex;
  offsetRadius: Double;
begin
  curve.transitionStartRadius := r1;
  curve.transitionEndRadius := r2;
  curve.transitionLength := transitionLength;
  curve.distanceToTransition := initialLength;
  curve.isSpiral := True;

  if Abs(r1) < max_rad_test then
    curvature1 := 1 / r1
  else
    curvature1 := 0;
  if Abs(r2) < max_rad_test then
    curvature2 := 1 / r2
  else
    curvature2 := 0;

  curve.CalculateCurveAt(0, 0, previousPoint, direction, radius);
  distance := 5;
  while distance < initialLength * 2 + transitionLength do begin
    curve.CalculateCurveAt(distance, 0, pt, direction, radius);

    // linear interpolation to determine expected curvature
    if distance <= initialLength then begin
      expectedRadius := r1;
    end
    else
    if distance <= initialLength + transitionLength then begin
      // linear interpolation to determine expected curvature
      expectedCurvature := ((curvature2 - curvature1) *
        (distance - initialLength) / transitionLength) + curvature1;
      if abs(expectedCurvature) >= 1 / max_rad_test then
        expectedRadius := 1 / expectedCurvature
      else
        expectedRadius := max_rad;
    end
    else begin
      expectedRadius := r2;
    end;

    delta := pt - previousPoint;
    distanceFromPrevious := delta.magnitude;

    //  distance between testStepSize - 1 and testStepSize...
    CheckEquals(testStepSize - testStepTolerance, distanceFromPrevious, 1,
      format('distance from previous point at %f', [distance]));
    CheckEquals(expectedRadius, radius, testStepTolerance, format('radius at %f', [distance]));

    // check the delta values make sense
    Check(delta.x > 0, format('delta.x at %f = %f', [distance, delta.x]));

    // now check some offsets...
    curve.CalculateCurveAt(distance, -5, offsetPt, offsetDirection, offsetRadius);

    delta := pt - offsetPt;
    CheckEquals(5, delta.magnitude, 1e-3, format('offset -5, distance %f: delta', [distance]));
    if abs(radius) < max_rad_test then
      CheckEquals(radius - 5, offsetRadius, 1e-3,
        format('offset -5, distance %f: radius', [distance]));

    curve.CalculateCurveAt(distance, 5, offsetPt, offsetDirection, offsetRadius);

    delta := pt - offsetPt;
    CheckEquals(5, delta.magnitude, 1e-3, format('offset 5, distance %f: delta', [distance]));
    if abs(radius) < max_rad_test then
      CheckEquals(radius + 5, offsetRadius, 1e-3,
        format('offset 5, distance %f: radius', [distance]));


    // and move on...
    distance := distance + testStepSize;
    previousPoint := pt;
  end;

end;

procedure TTestCurve.test_transition_curve_straight_positive;
begin
  // Given a curve that is defined as a transition from straight to a positive radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (decreasing) radius
  //
  do_test_transition(max_rad, 1000, 100, 100);
end;

procedure TTestCurve.test_transition_curve_straight_negative;
begin
  // Given a curve that is defined as a transition from straight to a negative radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (decreasing) radius
  //
  do_test_transition(max_rad, -1000, 100, 100);
end;


procedure TTestCurve.test_transition_curve_positive_straight;
begin
  // Given a curve that is defined as a transition from a positive radius to straight
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (decreasing) radius
  //
  do_test_transition(1000, max_rad, 100, 100);
end;

procedure TTestCurve.test_transition_curve_negative_straight;
begin
  // Given a curve that is defined as a transition from a negative radius to straight
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (decreasing) radius
  //
  do_test_transition(-1000, max_rad, 100, 100);
end;


procedure TTestCurve.test_transition_curve_positive_positive_increasing;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a larger positive radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (increasing) radius
  //
  do_test_transition(1000, 2000, 100, 100);
end;

procedure TTestCurve.test_transition_curve_positive_positive_decreasing;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a smaller positive radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (increasing) radius
  //
  do_test_transition(2000, 1000, 100, 100);
end;

procedure TTestCurve.test_transition_curve_negative_negative_increasing;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a larger negative radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (increasing) radius
  //
  do_test_transition(-1000, -2000, 100, 100);
end;

procedure TTestCurve.test_transition_curve_negative_negative_decreasing;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a smaller negative radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected (increasing) radius
  //
  do_test_transition(-2000, -1000, 100, 100);
end;

procedure TTestCurve.test_transition_curve_positive_to_larger_negative;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a larger negative radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected  radius
  //
  do_test_transition(1000, -2000, 100, 150);
end;

procedure TTestCurve.test_transition_curve_positive_to_smaller_negative;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a larger negative radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected  radius
  //
  do_test_transition(2000, -1000, 100, 150);
end;

procedure TTestCurve.test_transition_curve_negative_to_larger_positive;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a smaller positive radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected  radius
  //
  do_test_transition(-1000, 2000, 100, 150);
end;

procedure TTestCurve.test_transition_curve_negative_to_smaller_positive;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a smaller positive radius
  //
  // When I ask for a point along the "curve"
  //
  // Then that point is the expected distance from the previous point
  //  and the radius is the expected  radius
  //
  do_test_transition(-2000, 1000, 100, 150);
end;

procedure TTestCurve.test_slew_creation;
var
  pt: Tpex;
  direction: Tpex;
  radius: double;
begin
  // Given a curve defined with a slew
  //
  // When I ask for a point along the curve
  //
  // Then the curveCalculator is a TSlewCalculator

  curve.isSlewing := True;
  curve.isSpiral := False;
  curve.fixedRadius := max_rad;

  curve.CalculateCurveAt(0, 0, pt, direction, radius);

  Check(curve.curveCalculator is TSlewCalculator, 'curveCalculator not expected class');
end;

procedure TTestCurve.test_CopyFrom;
var
  curve2: TCurve;
begin
  // Given 2 curves with different parameters
  //
  // When I call CopyFrom
  //
  // Then the curve parameters are copied

  curve.isSpiral := True;
  curve.isSlewing := True;
  curve.fixedRadius := max_rad;
  curve.transitionStartRadius := 3456;
  curve.transitionEndRadius := 7890;
  curve.distanceToTransition := 123;
  curve.transitionLength := 234;
  curve.distanceToStartOfSlew := 333;
  curve.slewAmount := 23;
  curve.slewLength := 145;
  curve.slewFactor := 1.5;
  curve.slewMode := smTanH;

  curve2 := TCurve.Create(nil);
  try
    curve2.CopyFrom(curve);

    CheckEquals(curve.isSpiral, curve2.isSpiral, 'isSpiral');
    CheckEquals(curve.isSlewing, curve2.isSlewing, 'isSlewing');
    CheckEquals(curve.fixedRadius, curve2.fixedRadius, 'fixedRadius');
    CheckEquals(curve.transitionStartRadius, curve2.transitionStartRadius,
      'transitionStartRadius');
    CheckEquals(curve.transitionEndRadius, curve2.transitionEndRadius, 'transitionEndRadius');
    CheckEquals(curve.distanceToTransition, curve2.distanceToTransition, 'distanceToTransition');
    CheckEquals(curve.transitionLength, curve2.transitionLength, 'transitionLength');
    CheckEquals(curve.distanceToStartOfSlew, curve2.distanceToStartOfSlew,
      'distanceToStartOfSlew');
    CheckEquals(curve.slewAmount, curve2.slewAmount, 'slewAmount');
    CheckEquals(curve.slewLength, curve2.slewLength, 'slewLength');
    CheckEquals(curve.slewFactor, curve2.slewFactor, 'slewFactor');
    CheckEquals(Ord(curve.slewMode), Ord(curve2.slewMode), 'slewMode');

  finally
    curve2.Free;
  end;
end;

procedure TTestCurve.test_straight_line_offset;
var
  pt: Tpex;
  direction: Tpex;
  radius: double;
  i: integer;
  distance: double;
begin
  // Given a curve that is defined as straight
  //    ( radius = max_radius, not spiral )
  //
  // When I ask for a point offset from the "curve"
  //
  // Then that point is on a straight line
  // and is at the expected distance
  //

  curve.fixedRadius := max_rad_limit;
  curve.isSpiral := False;

  distance := 0;
  for i := 0 to 20 do begin
    curve.CalculateCurveAt(distance, -1, pt, direction, radius);

    CheckEquals(i, pt.X, 1e-6, format('pt.X at %f', [distance]));
    CheckEquals(1, pt.Y, 1e-6, format('pt.Y at %f', [distance]));
    CheckEquals(1, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(0, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(max_rad, radius, 1, format('radius at %f', [distance]));

    curve.CalculateCurveAt(distance, 3, pt, direction, radius);

    CheckEquals(i, pt.X, 1e-6, format('pt.X at %f', [distance]));
    CheckEquals(-3, pt.Y, 1e-6, format('pt.Y at %f', [distance]));
    CheckEquals(1, direction.X, 1e-6, format('direction.X at %f', [distance]));
    CheckEquals(0, direction.y, 1e-6, format('direction.Y at %f', [distance]));
    CheckEquals(max_rad, radius, 1, format('radius at %f', [distance]));

    distance := distance + 1.0;
  end;

end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_straight;
var
  dCentreline: Double;
begin
  //
  // Given a curve that is a straight line
  // When CalculateDistanceFromOffset is called
  // Then the result is the same as the original distance
  //
  curve.fixedRadius := max_rad_limit;
  curve.isSpiral := False;

  dCentreLine := curve.CalculateCurveDistanceFromOffset(0, 0, 0);
  CheckEquals(0.0, dCentreline, 1e-6, '(0, 0, 0)');

  dCentreLine := curve.CalculateCurveDistanceFromOffset(5, 5, 10);
  CheckEquals(15, dCentreline, 1e-6, '(5, 5, 10)');

  dCentreLine := curve.CalculateCurveDistanceFromOffset(5, -5, 20);
  CheckEquals(25, dCentreline, 1e-6, '(5, -5, 20)');

end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_single_radius_positive;
const
  testRadius = 5000;
var
  angle: Double;
  newDistance: Double;
  expectedDistanceAlongOriginalPath: Double;
begin
  // Given a curve that is defined as a single radius
  //    ( radius = 5m, not spiral )
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  curve.fixedRadius := testRadius;
  curve.isSpiral := False;

  // with a fixed radius, the original distance doesn't matter...

  // start at an offset to the inside of the curve
  newDistance := curve.CalculateCurveDistanceFromOffset(100, -100, 100);

  // effective radius is testRadius - 100
  // angle = arclength/r
  // so
  angle := 100 / (testRadius - 100);
  expectedDistanceAlongOriginalPath := 100 + angle * testRadius;

  CheckEquals(expectedDistanceAlongOriginalPath, newDistance, 1e-6,
    'newDistance inside of curve');


  // and now check an offset to the outside of the curve...
  newDistance := curve.CalculateCurveDistanceFromOffset(100, 200, 300);
  angle := 300 / (testRadius + 200);
  expectedDistanceAlongOriginalPath := 100 + angle * testRadius;

  CheckEquals(expectedDistanceAlongOriginalPath, newDistance, 1e-6,
    'newDistance outside of curve');

end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_single_radius_negative;
const
  testRadius = -5000;
var
  angle: Double;
  newDistance: Double;
  expectedDistanceAlongOriginalPath: Double;
begin
  // Given a curve that is defined as a single radius
  //    ( radius = 5m, not spiral )
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  curve.fixedRadius := testRadius;
  curve.isSpiral := False;

  // with a fixed radius, the original distance doesn't matter...

  // start at an offset to the outside of the curve
  newDistance := curve.CalculateCurveDistanceFromOffset(100, -100, 100);

  // effective radius is testRadius + 100
  // angle = arclength/r
  // so
  angle := 100 / (abs(testRadius) + 100);
  expectedDistanceAlongOriginalPath := 100 + angle * abs(testRadius);

  CheckEquals(expectedDistanceAlongOriginalPath, newDistance, 1e-6,
    'newDistance outside of curve');


  // and now check an offset to the inside of the curve...
  newDistance := curve.CalculateCurveDistanceFromOffset(100, 200, 300);
  angle := 300 / (abs(testRadius) - 200);
  expectedDistanceAlongOriginalPath := 100 + angle * abs(testRadius);

  CheckEquals(expectedDistanceAlongOriginalPath, newDistance, 1e-6,
    'newDistance inside of curve');

end;

procedure TTestCurve.do_test_centreline_distance_from_offset_transition(
  r1, r2, initialLength, transitionLength: double);
var
  distance: Double;
  newLeftDistance: Double;
  newRightDistance: Double;
  pt: Tpex;
  direction: Tpex;
  radius: double;
  i: Integer;
begin
  curve.transitionStartRadius := r1;
  curve.transitionEndRadius := r2;
  curve.transitionLength := transitionLength;
  curve.distanceToTransition := initialLength;
  curve.isSpiral := True;


  // want to test points:
  //  - immediately before the start of the transition
  //    where the offset distance extends into the transition
  //  - 1/4 along the transition
  //  - 1/2 along the transition
  //  - 3/4 along the transition
  //  - just before the end of the transition
  //    where the offset distance extends past the transition
  //
  for i := 1 to 5 do begin
    case i of
      1: begin
        if initialLength < 10 then
          continue;
        distance := initialLength - 5;
      end;
      2:
        distance := initialLength + transitionLength * 0.25;
      3:
        distance := initialLength + transitionLength * 0.50;
      4:
        distance := initialLength + transitionLength * 0.75;
      5:
        distance := initialLength + transitionLength - 5;
    end;

    // check points to the left and right
    curve.CalculateCurveAt(distance, 0, pt, direction, radius);
    newLeftDistance := curve.CalculateCurveDistanceFromOffset(distance, -10, 10);
    newRightDistance := curve.CalculateCurveDistanceFromOffset(distance, 10, 10);

    if abs(radius) > max_rad_test then begin
      // we're at a straight section of the curve
      CheckEquals( distance+10, newLeftDistance, 1, format('newLeftDistance straight at %d', [i]));
      CheckEquals( distance+10, newRightDistance, 1, format('newRightDistance straight at %d', [i]));
    end
    else if radius > 0 then begin
      // curving to left
      Check(newLeftDistance > distance + 10, format('newLeftDistance curving left at %d', [i]));
      Check(newRightDistance < distance + 10, format('newRightDistance curving left at %d', [i]));
    end
    else begin
      // curving to right
      Check(newLeftDistance < distance + 10, format('newLeftDistance curving right at %d', [i]));
      Check(newRightDistance > distance + 10, format('newRightDistance curving right at %d', [i]));
    end;

  end;
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_straight_positive;
begin
  // Given a curve that is defined as a transition from straight to a positive radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(max_rad, 1000, 100, 100);

end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_straight_negative;
begin
  // Given a curve that is defined as a transition from straight to a negative radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(max_rad, -1000, 100, 100);
end;


procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_straight;
begin
  // Given a curve that is defined as a transition from a positive radius to straight
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(1000, max_rad, 100, 100);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_straight;
begin
  // Given a curve that is defined as a transition from a negative radius to straight
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(-1000, max_rad, 100, 100);
end;


procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_positive_increasing;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a larger positive radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(1000, 2000, 100, 100);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_positive_decreasing;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a smaller positive radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(2000, 1000, 100, 100);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_negative_increasing;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a larger negative radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(-1000, -2000, 100, 100);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_negative_decreasing;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a smaller negative radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(-2000, -1000, 100, 100);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_to_larger_negative;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a larger negative radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(1000, -2000, 100, 150);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_positive_to_smaller_negative;
begin
  // Given a curve that is defined as a transition from a positive radius to
  //   a larger negative radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(2000, -1000, 100, 150);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_to_larger_positive;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a smaller positive radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(-1000, 2000, 100, 150);
end;

procedure TTestCurve.test_calculate_centreline_distance_from_offset_distance_transition_curve_negative_to_smaller_positive;
begin
  // Given a curve that is defined as a transition from a negative radius to
  //   a smaller positive radius
  //
  // When CalculateDistanceFromOffset is called
  // Then if the offset is on the inside of the curve, the result will be greater than the original distance
  //   or if the offset is on the outside of the curve, the result will be less than the original distance
  //
  do_test_centreline_distance_from_offset_transition(-2000, 1000, 100, 150);
end;

initialization
  RegisterTest(TTestCurve);

end.
