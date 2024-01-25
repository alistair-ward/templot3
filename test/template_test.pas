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
  Curve;

type
  { TTestTemplate }

  TTestTemplate = class(TTestCase)
  protected

    procedure Setup; override;
    procedure TearDown; override;

    function MakePlainTrackT55Gauge: TTemplate;
    procedure SetStraight(ACurve: TCurve);

  published
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
  //
  // When the template is calculated
  //
  // Then the template has 3 elements
  // And the elements are the track centre-line, and mainside stock rail and the turnoutside stock rail.
  // And the rail gauge faces are 1/2 the gauge from the centreline
  // And the rail outside faces are 1/2 the gauge + rail width from the centreline.
  //

  tt := MakePlainTrackT55Gauge;
  try

    c := tt.curve;
    SetStraight(c);


  finally
    tt.Free;
  end;

end;

end.
