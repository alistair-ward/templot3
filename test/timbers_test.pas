unit timbers_test;

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  Timbers,
  Timber,
  Curve,
  ShovedTimber,
  TurnoutInfo1,
  ProtoInfo,
  PlainTrackInfo,
  point_ex;

type

  { TTimbersTest }

  TTimbersTest = class(TTestCase)
    private
      FCurve: TCurve;
      FTurnoutInfo: TTurnoutInfo1;
      FProtoInfo: TProtoInfo;
      FPlainTrackInfo: TPlainTrackInfo;
      FTimbers: TTimbers;

    protected
      procedure Setup; override;
      procedure TearDown; override;

      procedure Set30FootRailSleepers;

      procedure CheckTimberDimensions(const ATimber: TTimber; AExpectedWidth, AExpectedLength: Double; ALabel: String);
      procedure CheckTimberCentreline(const ATimber: TTimber; AExpectedLength: Double; const AExpectedMidPoint: Tpex; ALabel: String);


    published
      procedure TestStraightTrackOneRailLength;
    end;

implementation

const
  scaleMMperFoot: Double = 5.5;
  inchScale: Double = 5.5 / 12;

  sleeperLengthFeet: Double = 9;
  sleeperWidthInches: Double = 6;
  jointSleeperWidthInches: Double = 8;

{ TTimbersTest }

procedure TTimbersTest.Setup;
begin
  inherited Setup;

  FCurve := TCurve.Create(nil);
  FTurnoutInfo := TTurnoutInfo1.Create(nil);
  FProtoInfo := TProtoInfo.Create(nil);
  FPlainTrackInfo := TPlainTrackInfo.Create(nil);

  FProtoInfo.scale := scaleMMperFoot;
  FProtoInfo.gauge := 56.5 * inchScale;
  FProtoInfo.railtopWidth := 2.75 * inchScale;
  FProtoInfo.sleeperLength := sleeperLengthFeet * scaleMMperFoot;
  FProtoInfo.sleeperWidthInches := sleeperWidthInches;
  FProtoInfo.sleeperWidthAtRailJointInches := jointSleeperWidthInches;

  FTimbers := TTimbers.Create(nil);
  FTimbers.curve := FCurve;
  FTimbers.turnoutInfo := FTurnoutInfo;
  FTimbers.protoInfo := FProtoInfo;
  FTimbers.plainTrackInfo := FPlainTrackInfo;

  // straight line
  FCurve.isSlewing := False;
  FCurve.isSpiral := False;
  FCurve.fixedRadius := max_rad;

  // 1000mm long...
//  FTurnoutInfo.plainTrack := True;
//  FTurnoutInfo.originToToe := 1000;
//  FTurnoutInfo.turnoutLength := 1000;
//  FTurnoutInfo.stepSize := 5;


end;

procedure TTimbersTest.TearDown;
begin
  FreeAndNil(FTimbers);
  FreeAndNil(FCurve);
  FreeAndNil(FTurnoutInfo);
  FreeAndNil(FProtoInfo);
  FreeAndNil(FPlainTrackInfo);
  inherited TearDown;
end;

procedure TTimbersTest.Set30FootRailSleepers;
begin
  FPlainTrackInfo.railLengthInches:=360;
  FPlainTrackInfo.AddSleeperCentresInches(12);          // 1
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 2
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 3
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 4
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 5
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 6
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 7
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 8
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 9
  FPlainTrackInfo.AddSleeperCentresInches(24);        // 10
  FPlainTrackInfo.AddSleeperCentresInches(24);       // 11
  FPlainTrackInfo.AddSleeperCentresInches(24);       // 12
  FPlainTrackInfo.AddSleeperCentresInches(24);       // 13
  FPlainTrackInfo.AddSleeperCentresInches(24);       // 14
end;

procedure TTimbersTest.CheckTimberDimensions(const ATimber: TTimber; AExpectedWidth, AExpectedLength: Double; ALabel: String);
var
  d: Double;
  d2: Double;
const
  tolerance = 0.01; // 1/100th of a mm
begin
  CheckEquals(4, ATimber.outlinePointCount, Format('%s: outlinePointCount', [ALabel]));

  // points should form a rectable
  // check width and length, and diagonals

  d := ATimber.outlinePoint[0].distanceTo(ATimber.outlinePoint[1]);
  CheckEquals(AExpectedWidth, d, tolerance, Format('%s: width points(0,1)', [ALabel]));

  d := ATimber.outlinePoint[1].distanceTo(ATimber.outlinePoint[2]);
  CheckEquals(AExpectedLength, d, tolerance, Format('%s: length points(1,2)', [ALabel]));

  d := ATimber.outlinePoint[2].distanceTo(ATimber.outlinePoint[3]);
  CheckEquals(AExpectedWidth, d, tolerance, Format('%s: width points(2,3)', [ALabel]));

  d := ATimber.outlinePoint[3].distanceTo(ATimber.outlinePoint[0]);
  CheckEquals(AExpectedLength, d, tolerance, Format('%s: length points(3,0)', [ALabel]));

  d := ATimber.outlinePoint[0].distanceTo(ATimber.outlinePoint[2]);
  d2 := ATimber.outlinePoint[1].distanceTo(ATimber.outlinePoint[3]);

  CheckEquals(0, d - d2, tolerance, Format('%s: diagonals', [ALabel]));
end;

procedure TTimbersTest.CheckTimberCentreline(const ATimber: TTimber; AExpectedLength: Double; const AExpectedMidPoint: Tpex; ALabel: String);
var
  d: Double;
  midPoint: Tpex;
const
  tolerance = 0.01; // 1/100th of a mm
begin
  CheckEquals(2, ATimber.centrelinePointCount, Format('%s: centrelinePointCount', [ALabel]));

  d := ATimber.centrelinePoint[0].distanceTo(ATimber.centrelinePoint[1]);
  CheckEquals(AExpectedLength, d, tolerance, Format('%s: centrelineLength', [ALabel]));

  midPoint :=ATimber.centrelinePoint[0] + (ATimber.centrelinePoint[1] - ATimber.centrelinePoint[0]) * 0.5;
  CheckEquals(AExpectedMidPoint.x, midPoint.x, tolerance, Format('%s: midpoint.x', [ALabel]));
  CheckEquals(AExpectedMidPoint.y, midPoint.y, tolerance, Format('%s: midpoint.y', [ALabel]));
end;

procedure TTimbersTest.TestStraightTrackOneRailLength;
var
  i: Integer;
  x: Double;
  t: TTimber;
  name: String;
  expectedWidth: Double;
  expectedLength: Double;
  expectedCentrelineLength: Double;
  expectedMidpoint: Tpex;
  dummyDir: Tpex;
  dummyRadius: Double;
begin
  //
  // Given a straight track
  // And the track is one rail length long (30feet)
  // And the sleepers are spaced 2 feet apart
  // And there are no shoved timbers
  // When the timbers are calculated
  // Then there are 14 sleepers
  // And the sleepers have the expected labels
  // And the sleepers are the expected spacings
  // And the sleepers are the expected sizes
  //

  Set30FootRailSleepers;
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.originToToe := 30 * scaleMMperFoot;
  FTurnoutInfo.turnoutLength := FTurnoutInfo.originToToe;

  FTimbers.shovedTimbers.Clear;

  // When...
  CheckEquals(14, FTimbers.timberCount, 'timberCount');

  x := 30 * scaleMMperFoot;

  for i := 0 to 13 do begin
    x := (29 - 2*i) * scaleMMperFoot;
    name := 'A' + IntToStr(i+1);

    t := FTimbers.timber[i];
    CheckEquals(name, t.timberString, Format('timber[%d].timberString', [i]));
    CheckEquals(x, t.xtb, Format('timber[%d].xtb', [i]));

    if (i = 0) or (i = 13) then
      expectedWidth := jointSleeperWidthInches * inchScale
    else
      expectedWidth := sleeperWidthInches * inchScale;

    expectedLength := sleeperLengthFeet * scaleMMperFoot;
    expectedCentrelineLength := (sleeperLengthFeet + 2) * scaleMMperFoot;
    FCurve.CalculateCurveAt(t.xtb, 0.0, expectedMidPoint, dummyDir, dummyRadius);

    CheckTimberDimensions(t, expectedWidth, expectedLength, Format('timber[%d]', [i]));
    CheckTimberCentreline(t, expectedCentrelineLength, expectedMidpoint, Format('timber[%d]', [i]));
  end;


end;

initialization
  RegisterTest(TTimbersTest);

end.

