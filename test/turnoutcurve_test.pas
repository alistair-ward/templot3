unit turnoutcurve_test;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  TurnoutCurve,
  Curve,
  TurnoutInfo1;

type

  { TTestTurnoutCurve }

  TTestTurnoutCurve = class(TTestCase)
  protected
    FTurnoutCurve: TTurnoutCurve;
    FCurve: TCurve;
    FTurnoutInfo: TTurnoutInfo1;

    procedure Setup; override;
    procedure TearDown; override;

  published
    procedure TestPlainTrackTurnoutCurveStraight;
    procedure TestPlainTrackTurnoutCurveTransition;
    procedure TestPlainTrackTurnoutCurveSlew;
    procedure TestTurnoutCurveStraightTrackLeftHand;
    procedure TestTurnoutCurveStraightTrackRightHand;
  end;


implementation

uses
  point_ex,
  curve_parameters_interface;

{ TTestTurnoutCurve }

procedure TTestTurnoutCurve.Setup;
begin
  inherited Setup;

  FCurve := TCurve.Create(nil);
  FTurnoutInfo := TTurnoutInfo1.Create(nil);
  FTurnoutCurve := TTurnoutCurve.Create(nil);

  FTurnoutCurve.curve := FCurve;
  FTurnoutCurve.turnoutInfo := FTurnoutInfo;

  // Straight...
  FCurve.isSlewing := False;
  FCurve.isSpiral := False;
  FCurve.fixedRadius := max_rad;

  // 100mm long...
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.originToToe := 100;
  FTurnoutInfo.turnoutLength := 100;
  FTurnoutInfo.stepSize := 5;

end;

procedure TTestTurnoutCurve.TearDown;
begin
  FreeAndNil(FTurnoutCurve);
  FreeAndNil(FCurve);

  inherited TearDown;
end;

procedure TTestTurnoutCurve.TestPlainTrackTurnoutCurveStraight;
const
  testStepSize = 5.0;
var
  d: Double;
  curvePt: Tpex;
  curveDirection: Tpex;
  curveRadius: Double;
  turnoutPt: Tpex;
  turnoutDirection: Tpex;
  turnoutRadius: Double;
begin
  FTurnoutInfo.plainTrack := True;
  FCurve.isSpiral := False;
  FCurve.fixedRadius := max_rad;

  d := 0;
  while d <= FTurnoutInfo.turnoutLength do begin
    FCurve.CalculateCurveAt(d, 0, curvePt, curveDirection, curveRadius);
    FTurnoutCurve.CalculateCurveAt(d, 0, turnoutPt, turnoutDirection, turnoutRadius);

    CheckEquals(curvePt.x, turnoutPt.x, Format('Pt.x at %f', [d]));
    CheckEquals(curvePt.y, turnoutPt.y, Format('Pt.y at %f', [d]));
    CheckEquals(curveDirection.x, turnoutDirection.x, Format('Pt.x at %f', [d]));
    CheckEquals(curveDirection.y, turnoutDirection.y, Format('Pt.y at %f', [d]));
    CheckEquals(curveRadius, turnoutRadius, Format('Radius at %f', [d]));

    d := d + testStepSize;
  end;
end;

procedure TTestTurnoutCurve.TestPlainTrackTurnoutCurveTransition;
const
  testStepSize = 5.0;
var
  d: Double;
  curvePt: Tpex;
  curveDirection: Tpex;
  curveRadius: Double;
  turnoutPt: Tpex;
  turnoutDirection: Tpex;
  turnoutRadius: Double;
begin
  FTurnoutInfo.plainTrack := True;
  FCurve.isSpiral := True;
  FCurve.distanceToTransition:=0;
  FCurve.transitionLength:=100.0;
  FCurve.transitionStartRadius:= max_rad;
  FCurve.transitionEndRadius:= 300.0;

  d := 0;
  while d <= FTurnoutInfo.turnoutLength do begin
    FCurve.CalculateCurveAt(d, 0, curvePt, curveDirection, curveRadius);
    FTurnoutCurve.CalculateCurveAt(d, 0, turnoutPt, turnoutDirection, turnoutRadius);

    CheckEquals(curvePt.x, turnoutPt.x, Format('Pt.x at %f', [d]));
    CheckEquals(curvePt.y, turnoutPt.y, Format('Pt.y at %f', [d]));
    CheckEquals(curveDirection.x, turnoutDirection.x, Format('Pt.x at %f', [d]));
    CheckEquals(curveDirection.y, turnoutDirection.y, Format('Pt.y at %f', [d]));
    CheckEquals(curveRadius, turnoutRadius, Format('Radius at %f', [d]));

    d := d + testStepSize;
  end;
end;

procedure TTestTurnoutCurve.TestPlainTrackTurnoutCurveSlew;
const
  testStepSize = 5.0;
var
  d: Double;
  curvePt: Tpex;
  curveDirection: Tpex;
  curveRadius: Double;
  turnoutPt: Tpex;
  turnoutDirection: Tpex;
  turnoutRadius: Double;
begin
  FTurnoutInfo.plainTrack := True;
  FCurve.isSpiral := False;
  FCurve.isSlewing := True;
  FCurve.fixedRadius := max_rad;
  FCurve.distanceToStartOfSlew:=0;
  FCurve.slewAmount:=20.0;
  FCurve.slewLength:=100;
  FCurve.slewMode:=smCosine;

  d := 0;
  while d <= FTurnoutInfo.turnoutLength do begin
    FCurve.CalculateCurveAt(d, 0, curvePt, curveDirection, curveRadius);
    FTurnoutCurve.CalculateCurveAt(d, 0, turnoutPt, turnoutDirection, turnoutRadius);

    CheckEquals(curvePt.x, turnoutPt.x, Format('Pt.x at %f', [d]));
    CheckEquals(curvePt.y, turnoutPt.y, Format('Pt.y at %f', [d]));
    CheckEquals(curveDirection.x, turnoutDirection.x, Format('Pt.x at %f', [d]));
    CheckEquals(curveDirection.y, turnoutDirection.y, Format('Pt.y at %f', [d]));
    CheckEquals(curveRadius, turnoutRadius, Format('Radius at %f', [d]));

    d := d + testStepSize;
  end;
end;

procedure TTestTurnoutCurve.TestTurnoutCurveStraightTrackLeftHand;
begin
  Fail('not implemented');
end;

procedure TTestTurnoutCurve.TestTurnoutCurveStraightTrackRightHand;
begin
  Fail('not implemented');
end;

initialization
  RegisterTest(TTestTurnoutCurve);

end.
