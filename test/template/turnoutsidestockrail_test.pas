unit turnoutsidestockrail_test;

{$mode Delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  TurnoutsideStockRail,
  Curve,
  TurnoutInfo1,
  TurnoutCurve,
  ProtoInfo,
  PlainTrackInfo;


type
  { TTestTurnoutsideStockRail }

  TTestTurnoutsideStockRail = class(TTestCase)
  protected
    FCurve: TCurve;
    FTurnoutCurve: TTurnoutCurve;
    FTurnoutInfo: TTurnoutInfo1;
    FProtoInfo: TProtoInfo;
    FStockrail: TTurnoutsideStockRail;
    FPlainTrackInfo: TPlainTrackInfo;

    procedure Setup; override;
    procedure TearDown; override;

  published
    procedure TestPlainTrackStraightContinuousLeftHand;
    procedure TestPlainTrackStraightContinuousRightHand;
    procedure TestPlainTrackLeftHand;
    procedure TestPlainTrackLeftHandStaggered;
  end;

implementation

uses
  rail_data_unit,
  mark_unit,
  Line;

const
  scaleMMperFoot: Double = 5.5;
  inchScale: Double = 5.5 / 12;


  { TTestTurnoutsideStockRail }

procedure TTestTurnoutsideStockRail.Setup;
begin
  inherited Setup;

  FCurve := TCurve.Create(nil);
  FTurnoutInfo := TTurnoutInfo1.Create(nil);
  FProtoInfo := TProtoInfo.Create(nil);
  FPlainTrackInfo := TPlainTrackInfo.Create(nil);
  FTurnoutCurve := TTurnoutCurve.Create(nil);

  FProtoInfo.scale := scaleMMperFoot;
  FProtoInfo.gauge := 56.5 * inchScale;
  FProtoInfo.sleeperLength := 9 * scaleMMperFoot;

  FStockrail := TTurnoutsideStockRail.Create(nil);
  FStockrail.curve := FCurve;
  FStockrail.turnoutCurve := FTurnoutCurve;
  FStockrail.turnoutInfo := FTurnoutInfo;
  FStockrail.protoInfo := FProtoInfo;
  FStockrail.plainTrackInfo := FPlainTrackInfo;

  // straight line
  FCurve.isSlewing := False;
  FCurve.isSpiral := False;
  FCurve.fixedRadius := max_rad;

  FTurnoutCurve.curve := FCurve;
  FTurnoutCurve.turnoutInfo := FTurnoutInfo;

  // 1000mm long...
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.originToToe := 1000;
  FTurnoutInfo.turnoutLength := 1000;
  FTurnoutInfo.stepSize := 5;
end;

procedure TTestTurnoutsideStockRail.TearDown;
begin
  FreeAndNil(FStockrail);
  FreeAndNil(FTurnoutCurve);
  FreeAndNil(FCurve);
  FreeAndNil(FTurnoutInfo);
  FreeAndNil(FProtoInfo);
  FreeAndNil(FPlainTrackInfo);
  inherited TearDown;
end;

procedure TTestTurnoutsideStockRail.TestPlainTrackStraightContinuousLeftHand;
var
  i: Integer;
  n: Integer;
  line: TLine;
begin
  //
  // Given straight plain track
  //   and the track is continuous
  //   and the turnout side is Left
  // When the track is calculated
  // Then the stock rail has 2 lines
  //  and the rails are CurvedStockGaugeFace and CurvedStockOuterFace
  //  and the gauge face is 1/2 the gauge to the left of the defined curve
  //  and the outer face is 1/2 the gauge plus the rail width to the leftt of the defined curve
  //  and there are no marks
  //

  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.hand := thLeft;
  FPlainTrackInfo.railJointsCode := rjNone;

  CheckEquals(2, FStockRail.numberOfLines, 'numberOfLines');
  CheckEquals(0, FStockRail.numberOfMarks, 'numberOfMarks');

  for n := 0 to FStockRail.numberOfLines - 1 do begin
    line := FStockRail.Lines[n];
    Check(line.railCode in [rdCurvedStockGaugeFace, rdCurvedStockOuterFace],
      Format('unexpected railCode: ', [Ord(line.railCode)]));
    Check(line.numberOfPoints > 0);
    case line.railCode of
      rdCurvedStockGaugeFace: begin
        for i := 0 to line.numberOfPoints - 1 do begin
          CheckEquals(FProtoInfo.gauge / 2, line.points[i].y,
            Format('rdCurvedStockGaugeFace point %d:', [i]));
        end;
      end;
      rdCurvedStockOuterFace: begin
        for i := 0 to line.numberOfPoints - 1 do begin
          CheckEquals(FProtoInfo.gauge / 2 + FProtoInfo.railtopWidth,
            line.points[i].y, Format('rdCurvedStockOuterFace point %d:', [i]));
        end;
      end;
      else
        Check(False);
    end;
  end;
end;

procedure TTestTurnoutsideStockRail.TestPlainTrackStraightContinuousRightHand;
var
  i: Integer;
  n: Integer;
  line: TLine;
begin
  //
  // Given straight plain track
  //   and the track is continuous
  //   and the turnout side is Right
  // When the track is calculated
  // Then the stock rail has 2 lines
  //  and the rails are CurvedStockGaugeFace and CurvedStockOuterFace
  //  and the gauge face is 1/2 the gauge to the right of the defined curve
  //  and the outer face is 1/2 the gauge plus the rail width to the right of the defined curve
  //  and there are no marks
  //

  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.hand := thRight;
  FPlainTrackInfo.railJointsCode := rjNone;

  CheckEquals(2, FStockRail.numberOfLines, 'numberOfLines');
  CheckEquals(0, FStockRail.numberOfMarks, 'numberOfMarks');

  for n := 0 to FStockRail.numberOfLines - 1 do begin
    line := FStockRail.Lines[n];
    Check(line.railCode in [rdCurvedStockGaugeFace, rdCurvedStockOuterFace],
      Format('unexpected railCode: ', [Ord(line.railCode)]));
    Check(line.numberOfPoints > 0);
    case line.railCode of
      rdCurvedStockGaugeFace: begin
        for i := 0 to line.numberOfPoints - 1 do begin
          CheckEquals(-FProtoInfo.gauge / 2, line.points[i].y,
            Format('rdStraightStockGaugeFace point %d:', [i]));
        end;
      end;
      rdCurvedStockOuterFace: begin
        for i := 0 to line.numberOfPoints - 1 do begin
          CheckEquals(-(FProtoInfo.gauge / 2 + FProtoInfo.railtopWidth),
            line.points[i].y, Format('rdStraightStockOuterFace point %d:', [i]));
        end;
      end;
      else
        Check(False);
    end;
  end;
end;

procedure TTestTurnoutsideStockRail.TestPlainTrackLeftHand;
var
  i: Integer;
  n: Integer;
  expectedMarks: Integer;
  line: TLine;
  mark: TMarkEx;
  insideY: Double;
  outsideY: Double;
begin
  //
  // Given straight plain track
  //   and the track is not continuous (30' proto length)
  //   and the turnout side is Left
  // When the track is calculated
  // Then the stock rail has 2 lines
  //  and the rails are CurvedStockGaugeFace and CurvedStockOuterFace
  //  and the gauge face is 1/2 the gauge to the left of the defined curve
  //  and the outer face is 1/2 the gauge plus the rail width to the left of the defined curve
  //  and there are rail join marks every 30 prototype feet
  //
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.hand := thLeft;
  FPlainTrackInfo.railJointsCode := rjNormal;
  FPlainTrackInfo.railLengthInches := 30 * 12;

  expectedMarks := Trunc(FTurnoutInfo.turnoutLength / (FPlainTrackInfo.railLengthInches * inchScale)) + 1;

  CheckEquals(2, FStockRail.numberOfLines, 'numberOfLines');
  CheckEquals(expectedMarks, FStockRail.numberOfMarks, 'numberOfMarks');

  for n := 0 to FStockRail.numberOfLines - 1 do begin
    line := FStockRail.Lines[n];
    Check(line.railCode in [rdCurvedStockGaugeFace, rdCurvedStockOuterFace],
      Format('unexpected railCode: ', [Ord(line.railCode)]));
    Check(line.numberOfPoints > 0);
    case line.railCode of
      rdCurvedStockGaugeFace: begin
        for i := 0 to line.numberOfPoints - 1 do begin
          CheckEquals(FProtoInfo.gauge / 2, line.points[i].y,
            Format('rdCurvedStockGaugeFace point %d:', [i]));
        end;
      end;
      rdCurvedStockOuterFace: begin
        for i := 0 to line.numberOfPoints - 1 do begin
          CheckEquals(FProtoInfo.gauge / 2 + FProtoInfo.railtopWidth,
            line.points[i].y, Format('rdCurvedStockOuterFace point %d:', [i]));
        end;
      end;
      else
        Check(False);
    end;
  end;

  insideY := FProtoInfo.gauge/2 - FProtoInfo.insideFaceMarkLength;
  outsideY := FProtoInfo.gauge/2 + FProtoInfo.railtopWidth + FProtoInfo.outsideFaceMarkLength;

  for n := 0 to FStockRail.numberOfMarks - 1 do begin
    mark := FStockRail.marks[n];

    if (n = 0) then begin
      // first mark should be at the *end* of the template
      CheckEquals(1000, mark.p1.x, 'First mark p1.x');
      CheckEquals(1000, mark.p2.x, 'First mark p2.x');
    end;

    CheckEquals(Ord(eMC_6_RailJoint), Ord(mark.code), Format('Mark %d', [n]));
    CheckEquals(mark.p1.x, mark.p2.x, Format('Mark %d px', [n]));
    CheckEquals(insideY, mark.P1.y, Format('Mark %d p1.y', [n]));
    CheckEquals(outsideY, mark.P2.y, Format('Mark %d p2.y', [n]));
  end;
end;

procedure TTestTurnoutsideStockRail.TestPlainTrackLeftHandStaggered;
var
  n: Integer;
  expectedMarks: Integer;
  mark: TMarkEx;
  insideY: Double;
  outsideY: Double;
begin
  //
  // Given straight plain track
  //   and the track is not continuous (30' proto length)
  //   and the rail joints are staggered
  //   and the turnout side is Left
  // When the track is calculated
  // Then the stock rail has 2 lines
  //  and the rails are CurvedStockGaugeFace and CurvedStockOuterFace
  //  and the gauge face is 1/2 the gauge to the left of the defined curve
  //  and the outer face is 1/2 the gauge plus the rail width to the left of the defined curve
  //  and there are rail join marks every 30 prototype feet
  //  and the first mark is at the end of the template
  //      (all the same as for non-staggered joints)
  //
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.hand := thLeft;
  FPlainTrackInfo.railJointsCode := rjStaggered;
  FPlainTrackInfo.railLengthInches := 30 * 12;

  expectedMarks := Trunc(FTurnoutInfo.turnoutLength / (FPlainTrackInfo.railLengthInches * inchScale)) + 1;

  CheckEquals(2, FStockRail.numberOfLines, 'numberOfLines');
  CheckEquals(expectedMarks, FStockRail.numberOfMarks, 'numberOfMarks');

  // don't bother checking rail gauge-face coordinates, as they'll be the same as
  // plain track with non-staggered joints.

  // check marks are the same as for non-staggered joints
  insideY := FProtoInfo.gauge/2 - FProtoInfo.insideFaceMarkLength;
  outsideY := FProtoInfo.gauge/2 + FProtoInfo.railtopWidth + FProtoInfo.outsideFaceMarkLength;

  for n := 0 to FStockRail.numberOfMarks - 1 do begin
    mark := FStockRail.marks[n];

    if (n = 0) then begin
      // first mark should be at the *end* of the template
      CheckEquals(1000, mark.p1.x, 'First mark p1.x');
      CheckEquals(1000, mark.p2.x, 'First mark p2.x');
    end;

    CheckEquals(Ord(eMC_6_RailJoint), Ord(mark.code), Format('Mark %d', [n]));
    CheckEquals(mark.p1.x, mark.p2.x, Format('Mark %d px', [n]));
    CheckEquals(insideY, mark.P1.y, Format('Mark %d p1.y', [n]));
    CheckEquals(outsideY, mark.P2.y, Format('Mark %d p2.y', [n]));
  end;
end;

initialization
  RegisterTest(TTestTurnoutsideStockRail);

end.
