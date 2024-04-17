unit centreline_test;

{$mode Delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  Centreline,
  Curve,
  TurnoutInfo1,
  ProtoInfo;


type
  { TTestCentreline }

  TTestCentreline = class(TTestCase)
  protected
    FCurve: TCurve;
    FTurnoutInfo: TTurnoutInfo1;
    FProtoInfo: TProtoInfo;
    FCentreline: TCentreLine;

    procedure Setup; override;
    procedure TearDown; override;

  published

    procedure TestNormalCentreline;
    procedure TestMainSideSleeperEndsLeftHand;
    procedure TestMainSideSleeperEndsRightHand;
    procedure TestMainSideTrackLeftHand;
    procedure TestMainSideDoubleLeftHand;
    procedure TestTurnoutSideSleeperEndsLeftHand;
    procedure TestTurnoutSideSleeperEndsRightHand;
    procedure TestTurnoutSideTrackLeftHand;
    procedure TestTurnoutSideDoubleLeftHand;
    procedure TestCustomLeftHand;
    procedure TestCustomRightHand;
  end;

implementation

uses
  Feature,
  rail_data_unit,
  line;

{ TTestCentreline }

procedure TTestCentreline.Setup;
var
  inchScale: Double;
const
  scaleMMperFoot: Double = 5.5;
begin
  inherited Setup;

  FCurve := TCurve.Create(nil);
  FTurnoutInfo := TTurnoutInfo1.Create(nil);
  FProtoInfo := TProtoInfo.Create(nil);

  inchScale := scaleMMperFoot / 12;
  FProtoInfo.scale:=scaleMMperFoot;
  FProtoInfo.gauge:=56.5 * inchScale;
  FProtoInfo.sleeperLength:= 9 * scaleMMperFoot;

  FCentreline := TCentreline.Create(nil);
  FCentreline.curve := FCurve;
  FCentreline.turnoutInfo := FTurnoutInfo;
  FCentreline.protoInfo := FProtoInfo;

  // straight line
  FCurve.isSlewing := False;
  FCurve.isSpiral := False;
  FCurve.fixedRadius := max_rad;

  // 100mm long...
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.originToToe := 100;
  FTurnoutInfo.turnoutLength := 100;
  FTurnoutInfo.stepSize := 5;
end;

procedure TTestCentreline.TearDown;
begin
  FreeAndNil(FCentreline);
  FreeAndNil(FCurve);
  FreeAndNil(FTurnoutInfo);
  FreeAndNil(FProtoInfo);
  inherited TearDown;
end;

procedure TTestCentreline.TestNormalCentreline;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the centreline option is set to normal
  // When the centreline is calculated
  // Then the centreline offset is 0
  // and there are the expected number of points on the line
  // and all the points are on the curve.
  FCentreline.option:=cloNormal;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(0, centrelineOffset, 'centrelineOffset');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestMainSideSleeperEndsLeftHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to left-hand
  // and the centreline option is set to Main Side Sleeper Ends
  // When the centreline is calculated
  // Then the centreline offset is 1/2 the sleeper length (+ve)
  // and there are the expected number of points on the line
  // and all the points are to the right of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thLeft;
  FCentreline.option:=cloMainSideSleeperEnds;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(FProtoInfo.sleeperLength/2, centrelineOffset, 'centrelineOffset 1/2 sleeper length');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestMainSideSleeperEndsRightHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to right-hand
  // and the centreline option is set to Main Side Sleeper Ends
  // When the centreline is calculated
  // Then the centreline offset is 1/2 the sleep length (-ve)
  // and there are the expected number of points on the line
  // and all the points are to the left of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thRight;
  FCentreline.option:=cloMainSideSleeperEnds;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(-FProtoInfo.sleeperLength/2, centrelineOffset, 'centrelineOffset 1/2 sleeper length');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestMainSideTrackLeftHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to left-hand
  // and the centreline option is set to Main Side Track
  // When the centreline is calculated
  // Then the centreline offset is 1/2 the gauge (+ve)
  // and there are the expected number of points on the line
  // and all the points are to the left of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thLeft;
  FCentreline.option:=cloMainSideDouble;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(FProtoInfo.mainSideTrackCentres, centrelineOffset, 'mainSideTrackCentres');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestMainSideDoubleLeftHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to left-hand
  // and the centreline option is set to Main Side Double
  // When the centreline is calculated
  // Then the centreline offset is 1/2 the gauge (+ve)
  // and there are the expected number of points on the line
  // and all the points are to the left of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thLeft;
  FCentreline.option:=cloMainSideDouble;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(FProtoInfo.mainSideTrackCentres/2, centrelineOffset, 'mainSideTrackCentres/2');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestTurnoutSideSleeperEndsLeftHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to left-hand
  // and the centreline option is set to Turnout Side Sleeper Ends
  // When the centreline is calculated
  // Then the centreline offset is 1/2 the sleeper length (-ve)
  // and there are the expected number of points on the line
  // and all the points are to the right of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thLeft;
  FCentreline.option:=cloTurnoutSideSleeperEnds;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(-FProtoInfo.sleeperLength/2, centrelineOffset, 'centrelineOffset 1/2 sleeper length');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestTurnoutSideSleeperEndsRightHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to right-hand
  // and the centreline option is set to Turnout Side Sleeper Ends
  // When the centreline is calculated
  // Then the centreline offset is 1/2 the sleeper length (+ve)
  // and there are the expected number of points on the line
  // and all the points are to the right of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thRight;
  FCentreline.option:=cloTurnoutSideSleeperEnds;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(FProtoInfo.sleeperLength/2, centrelineOffset, 'centrelineOffset 1/2 sleeper length');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestTurnoutSideTrackLeftHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to left-hand
  // and the centreline option is set to Turnout Side Track
  // When the centreline is calculated
  // Then the centreline offset is turnoutside track spacing (-ve)
  // and there are the expected number of points on the line
  // and all the points are to the left of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thLeft;
  FCentreline.option:=cloTurnoutSideTrack;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(-FProtoInfo.turnoutSideTrackCentres, centrelineOffset, 'turnoutSideTrackCentres');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestTurnoutSideDoubleLeftHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to left-hand
  // and the centreline option is set to Turnout Side Double
  // When the centreline is calculated
  // Then the centreline offset is 1/2 turnoutside track spacing (-ve)
  // and there are the expected number of points on the line
  // and all the points are to the left of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thLeft;
  FCentreline.option:=cloTurnoutSideTrack;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(-FProtoInfo.turnoutSideTrackCentres/2, centrelineOffset, 'turnoutSideTrackCentres');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestCustomLeftHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to left-hand
  // and the centreline option is set to Custom (offset of 10mm)
  // When the centreline is calculated
  // Then the centreline offset is 10mm (-ve)
  // and there are the expected number of points on the line
  // and all the points are to the left of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thLeft;
  FCentreline.option:=cloCustom;
  FCentreline.customOffset:=10;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(-10, centrelineOffset, 'customOffset');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

procedure TTestCentreline.TestCustomRightHand;
var
  numberOfLines: Integer;
  numberOfMarks: Integer;
  centrelineOffset: Double;
  line: TLine;
begin
  // Given a straight, plain track
  // and the gauge is T55
  // and the template is set to right-hand
  // and the centreline option is set to Custom (offset of 10mm)
  // When the centreline is calculated
  // Then the centreline offset is 10mm (+ve)
  // and there are the expected number of points on the line
  // and all the points are to the left of the curve
  // and at the appropriate offset
  FTurnoutInfo.hand:=thRight;
  FCentreline.option:=cloCustom;
  FCentreline.customOffset:=10;

  // force calculation
  centrelineOffset := FCentreline.centrelineOffset;
  numberOfLines := FCentreline.numberOfLines;
  numberOfMarks := FCentreline.numberOfMarks;

  CheckEquals(10, centrelineOffset, 'customOffset');
  CheckEquals(1, numberOfLines, 'numberOfLines');
  CheckEquals(0, numberOfMarks, 'numberOfMarks');

  line := FCentreline.lines[0];
  CheckEquals(Ord(rdMainRoadCentreLine), Ord(line.railCode), 'railCode');

  CheckEquals(21, line.numberOfPoints);
end;

initialization
  RegisterTest(TTestCentreline);

end.
