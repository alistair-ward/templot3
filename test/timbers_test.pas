unit timbers_test;

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  Timbers,
  Curve,
  ShovedTimber,
  TurnoutInfo1,
  ProtoInfo,
  PlainTrackInfo;

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

    published
      procedure TestStraightTrackOneRailLength;
    end;

implementation

const
  scaleMMperFoot: Double = 5.5;
  inchScale: Double = 5.5 / 12;

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
  FProtoInfo.sleeperLength := 9 * scaleMMperFoot;

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
  FPlainTrackInfo.AddSleeperCentresInches(26.5);        // 2
  FPlainTrackInfo.AddSleeperCentresInches(27.5);        // 3
  FPlainTrackInfo.AddSleeperCentresInches(28.5);        // 4
  FPlainTrackInfo.AddSleeperCentresInches(28.5);        // 5
  FPlainTrackInfo.AddSleeperCentresInches(28.5);        // 6
  FPlainTrackInfo.AddSleeperCentresInches(28.5);        // 7
  FPlainTrackInfo.AddSleeperCentresInches(28.5);        // 8
  FPlainTrackInfo.AddSleeperCentresInches(28.5);        // 9
  FPlainTrackInfo.AddSleeperCentresInches(28.5);        // 10
  FPlainTrackInfo.AddSleeperCentresInches(28.5);       // 11
  FPlainTrackInfo.AddSleeperCentresInches(27.5);       // 12
  FPlainTrackInfo.AddSleeperCentresInches(26.5);       // 13
end;

procedure TTimbersTest.TestStraightTrackOneRailLength;
begin
  //
  // Given a straight track
  // And the track is one rail length long (30feet)
  // And there are no shoved timbers
  // When the timbers are calculated
  // Then there are 13 sleepers
  // And the sleepers are the expected spacings
  // And the sleepers are the expected sizes
  // And the sleepers have the expected labels
  //

  Set30FootRailSleepers;
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.originToToe := 30 * scaleMMperFoot;
  FTurnoutInfo.turnoutLength := FTurnoutInfo.originToToe;

  FTimbers.shovedTimbers.Clear;

  // When...
  CheckEquals(13, FTimbers.timberCount, 'timberCount');

end;

initialization
  RegisterTest(TTimbersTest);

end.

