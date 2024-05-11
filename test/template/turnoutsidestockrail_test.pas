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
  ProtoInfo;


type
  { TTestTurnoutsideStockRail }

  TTestTurnoutsideStockRail = class(TTestCase)
  protected
    FCurve: TCurve;
    FTurnoutInfo: TTurnoutInfo1;
    FProtoInfo: TProtoInfo;
    FStockrail: TTurnoutsideStockRail;

    procedure Setup; override;
    procedure TearDown; override;

  published

  end;

implementation

{ TTestTurnoutsideStockRail }

procedure TTestTurnoutsideStockRail.Setup;
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

  FStockrail := TTurnoutsideStockRail.Create(nil);
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

procedure TTestTurnoutsideStockRail.TearDown;
begin
  FreeAndNil(FStockrail);
  FreeAndNil(FCurve);
  FreeAndNil(FTurnoutInfo);
  FreeAndNil(FProtoInfo);
  inherited TearDown;
end;

initialization
  RegisterTest(TTestTurnoutsideStockRail);

end.

