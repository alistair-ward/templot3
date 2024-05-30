unit template_test;

{$mode Delphi}
{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  Template,
  Curve,
  Feature,
  Centreline,
  TurnoutInfo1;

type
  { TTestTemplate }

  TTestTemplate = class(TTestCase)
  protected

    procedure Setup; override;
    procedure TearDown; override;

    function MakePlainTrackT55Gauge: TTemplate;
    procedure SetStraight(ACurve: TCurve);
    procedure SetStartX(ATemplate: TTemplate; AStart: Double);
    procedure SetApproachLength(ATemplate: TTemplate; AX: Double);
    procedure SetOverallLength(ATemplate: TTemplate; AX: Double);
    procedure SetHand(ATemplate: TTemplate; AHand: TTurnoutHand);
    procedure SetCentreLineOnly(ATemplate: TTemplate; AFlag: Boolean);

  published
    procedure TestStraightPlainTrackCentreLineOnly;
    procedure TestStraightPlainTrack;

  end;


implementation

{ TTestTemplate }

procedure TTestTemplate.Setup;
begin
  inherited Setup;
end;

procedure TTestTemplate.TearDown;
begin
  inherited TearDown;
end;

function TTestTemplate.MakePlainTrackT55Gauge: TTemplate;
begin
  Result := TTemplate.Create(nil);
  Result.boxDims.turnoutInfo1.plainTrack := True;
end;

procedure TTestTemplate.SetStraight(ACurve: TCurve);
begin
  ACurve.isSlewing := False;
  ACurve.isSpiral := False;
  ACurve.fixedRadius := max_rad;
end;

procedure TTestTemplate.SetStartX(ATemplate: TTemplate; AStart: Double);
begin
  ATemplate.turnoutInfo2.startDrawX := AStart;
end;

procedure TTestTemplate.SetApproachLength(ATemplate: TTemplate; AX: Double);
begin
  ATemplate.boxDims.turnoutInfo1.originToToe := AX;
end;

procedure TTestTemplate.SetOverallLength(ATemplate: TTemplate; AX: Double);
begin
  ATemplate.boxDims.turnoutInfo1.turnoutLength := AX;
end;

procedure TTestTemplate.SetHand(ATemplate: TTemplate; AHand: TTurnoutHand);
begin
  ATemplate.boxDims.turnoutInfo1.hand := AHand;
end;

procedure TTestTemplate.SetCentreLineOnly(ATemplate: TTemplate; AFlag: Boolean);
begin
  ATemplate.boxDims.railInfo.drawCentrelineOnly := AFlag;
end;

procedure TTestTemplate.TestStraightPlainTrackCentreLineOnly;
var
  tt: TTemplate;
  c: TCurve;
  feature: TFeature;
begin
  //
  // Given a template with a specified gauge
  // And the template is plain track
  // And the template curve is straight
  // And the template is a fixed length
  // And the template is "right-hand"
  // And the template is "centre-line only"
  //
  // When the template is calculated
  //
  // Then the template has 1 feature
  // And the feature is the track centre-line,
  //

  tt := MakePlainTrackT55Gauge;
  try

    c := tt.curve;
    SetStraight(c);
    SetApproachLength(tt, 500);
    SetOverallLength(tt, 500);
    SetHand(tt, thRight);
    SetCentreLineOnly(tt, True);

    CheckEquals(1, tt.featureCount, 'featureCount');
    feature := tt.features[0];

    Check(feature is TCentreline, 'is TCentreline');

  finally
    tt.Free;
  end;

end;

procedure TTestTemplate.TestStraightPlainTrack;
var
  tt: TTemplate;
  c: TCurve;
begin
  //
  // Given a template with a specified gauge
  // And the template is plain track
  // And the template curve is straight
  // And the template is a fixed length
  // And the template is "right-hand"
  //
  // When the template is calculated
  //
  // Then the template has 3 elements
  // And the elements are:
  //    - the track centre-line,
  //    - mainside stock rail
  //    - turnout side stock rail
  // And the main side rail gauge face is 1/2 the gauge from the centreline (to the left of the centreline)
  // And the main side rail outside face is 1/2 the gauge + rail width from the centreline. (to the left of the centreline)
  // And the turnout side rail gauge face is 1/2 the gauge from the centreline (to the right of the centreline)
  // And the turnout side rail outside face is 1/2 the gauge + rail width from the centreline. (to the right of the centreline)
  //

  tt := MakePlainTrackT55Gauge;
  try

    c := tt.curve;
    SetStraight(c);
    SetStartX(tt, 0);
    SetApproachLength(tt, 500);
    SetOverallLength(tt, 500);
    SetHand(tt, thRight);

    CheckEquals(3, tt.featureCount, 'featureCount');


  finally
    tt.Free;
  end;

end;

initialization
  RegisterTest(TTestTemplate);

end.
