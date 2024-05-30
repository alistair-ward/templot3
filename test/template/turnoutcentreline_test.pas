unit turnoutcentreline_test;

{$mode Delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  TurnoutCentreline,
  TurnoutCurve,
  Curve,
  Centreline,
  TurnoutInfo1;


type
  { TTestTurnoutCentreline }

  TTestTurnoutCentreline = class(TTestCase)
  protected
    FTurnoutCurve: TTurnoutCurve;
    FCurve: TCurve;
    FTurnoutInfo: TTurnoutInfo1;
    FTurnoutCentreline: TTurnoutCentreLine;

    procedure Setup; override;
    procedure TearDown; override;

  published

    procedure TestPlainTrackTurnoutCentreline;
  end;

implementation

uses
  Feature,
  rail_data_unit,
  line;

{ TTestTurnoutCentreline }

procedure TTestTurnoutCentreline.Setup;
begin
  inherited Setup;

  FCurve := TCurve.Create(nil);
  FTurnoutCurve := TTurnoutCurve.Create(nil);
  FTurnoutInfo := TTurnoutInfo1.Create(nil);

  FTurnoutCentreline := TTurnoutCentreline.Create(nil);
  FTurnoutCentreline.curve := FCurve;
  FTurnoutCentreline.turnoutCurve := FTurnoutCurve;
  FTurnoutCentreline.turnoutInfo := FTurnoutInfo;

  // straight line
  FCurve.isSlewing := False;
  FCurve.isSpiral := False;
  FCurve.fixedRadius := max_rad;

  FTurnoutCurve.curve := FCurve;

  // 100mm long...
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.originToToe := 100;
  FTurnoutInfo.turnoutLength := 100;
  FTurnoutInfo.stepSize := 5;
end;

procedure TTestTurnoutCentreline.TearDown;
begin
  FreeAndNil(FTurnoutCentreline);
  FreeAndNil(FTurnoutCurve);
  FreeAndNil(FCurve);
  FreeAndNil(FTurnoutInfo);
  inherited TearDown;
end;

procedure TTestTurnoutCentreline.TestPlainTrackTurnoutCentreline;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  line: TLine;
begin
  // Given a straight, plain track
  // When the turnout centreline is calculated
  // Then there are the expected number of points on the line
  // and all the points are on the curve.

  // force calculation
  numberOfLines := FTurnoutCentreline.numberOfLines;
  numberOfMarks := FTurnoutCentreline.numberOfMarks;

  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FTurnoutCentreline.lines[0];
  CheckEquals(Ord(rdTurnoutRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

initialization
  RegisterTest(TTestTurnoutCentreline);

end.

