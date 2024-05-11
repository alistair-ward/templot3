unit mainsidestockrail_test;

{$mode Delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  MainsideStockRail,
  Curve,
  TurnoutInfo1,
  ProtoInfo,
  PlainTrackInfo;


type
  { TTestMainsideStockRail }

  TTestMainsideStockRail = class(TTestCase)
  protected
    FCurve: TCurve;
    FTurnoutInfo: TTurnoutInfo1;
    FProtoInfo: TProtoInfo;
    FStockrail: TMainsideStockRail;
    FPlainTrackInfo: TPlainTrackInfo;

    procedure Setup; override;
    procedure TearDown; override;

  published

    procedure TestPlainTrackStraightContinuousLeftHand;
    procedure TestPlainTrackContinuousRightHand;
    procedure TestPlainTrackLeftHand;

  end;

implementation

{ TTestMainsideStockRail }

procedure TTestMainsideStockRail.Setup;
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

  FStockrail := TMainsideStockRail.Create(nil);
  FStockrail.curve := FCurve;
  FStockrail.turnoutInfo := FTurnoutInfo;
  FStockrail.protoInfo := FProtoInfo;

  // straight line
  FCurve.isSlewing := False;
  FCurve.isSpiral := False;
  FCurve.fixedRadius := max_rad;

  // 1000mm long...
  FTurnoutInfo.plainTrack := True;
  FTurnoutInfo.originToToe := 1000;
  FTurnoutInfo.turnoutLength := 1000;
  FTurnoutInfo.stepSize := 5;
end;

procedure TTestMainsideStockRail.TearDown;
begin
  FreeAndNil(FStockrail);
  FreeAndNil(FCurve);
  FreeAndNil(FTurnoutInfo);
  FreeAndNil(FProtoInfo);
  inherited TearDown;
end;

procedure TTestMainsideStockRail.TestPlainTrackStraightContinuousLeftHand;
begin
  //
  // Given straight plain track
  //   and the track is continuous
  //   and the turnout side is Left
  // When the track is calculated
  // Then the stock rail has 2 lines
  //  and the rails are MainsideStockGaugeFace and MainsideStockOuterFace
  //  and the gauge face is 1/2 the gauge to the right of the defined curve
  //  and the outer face is 1/2 the gauge plus the rail width to the right of the defined curve
  //  and there are no marks
  //

  FTurnoutInfo.plainTrack := true;
  FTurnoutInfo.hand := thLeft;
//  FProtoInfo.;
end;

procedure TTestMainsideStockRail.TestPlainTrackContinuousRightHand;
begin
  //
  // Given straight plain track
  //   and the track is continuous
  //   and the turnout side is Right
  // When the track is calculated
  // Then the stock rail has 2 lines
  //  and the rails are MainsideStockGaugeFace and MainsideStockOuterFace
  //  and the gauge face is 1/2 the gauge to the left of the defined curve
  //  and the outer face is 1/2 the gauge plus the rail width to the left of the defined curve
  //  and there are no marks
  //
end;

procedure TTestMainsideStockRail.TestPlainTrackLeftHand;
begin
  //
  // Given straight plain track
  //   and the track is not continuous
  //   and the turnout side is Right
  // When the track is calculated
  // Then the stock rail has 2 lines
  //  and the rails are MainsideStockGaugeFace and MainsideStockOuterFace
  //  and the gauge face is 1/2 the gauge to the left of the defined curve
  //  and the outer face is 1/2 the gauge plus the rail width to the left of the defined curve
  //  and there are rail join marks every ?? prototype feet
  //
end;

initialization
  RegisterTest(TTestMainsideStockRail);

end.

