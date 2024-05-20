unit line_test;

{$mode Delphi}
{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  Line;

type
  { TTestLine }

  TTestLine = class(TTestCase)
  protected

  published
    procedure TestRailCode;
    procedure TestInitiallyEmpty;
    procedure TestAddPoints;

  end;


implementation

uses
  Math,
  point_ex,
  rail_data_unit;

  { TTestLine }

procedure TTestLine.TestRailCode;
var
  line: TLine;
begin
  //
  // Given
  // When a line is created with a specified railcode
  // Then the railCode property matches the constructor value
  //
  line := TLine.Create(rdMainSideCheckOuterFace);
  try
    CheckEquals(Ord(rdMainSideCheckOuterFace), Ord(line.railCode), 'railCode');
  finally
    line.Free;
  end;
end;

procedure TTestLine.TestInitiallyEmpty;
var
  line: TLine;
begin
  //
  // Given/When a newly created line
  // Then the line is empty (0 points);
  // and the startx and endx properties are NaN values
  //
  line := TLine.Create(rdMainRoadCentreLine);
  try
    CheckEquals(0, line.numberOfPoints, 'numberOfPoints');
    Check(IsNan(line.startxy.x), 'startxy.x');
    Check(IsNan(line.startxy.y), 'startxy.y');
    Check(IsNan(line.endxy.x), 'endxy.x');
    Check(IsNan(line.endxy.y), 'endxy.y');
  finally
    line.Free;
  end;
end;

procedure TTestLine.TestAddPoints;
const
  testData: array[0..4] of record
      curveX, curveY, ptX, ptY: Double;
      end
  =
    (
    (curveX: 0; curveY: 0; ptX: 10; ptY: 20),
    (curveX: 1; curveY: 0; ptX: 11; ptY: 20),
    (curveX: 2; curveY: 0; ptX: 12; ptY: 20),
    (curveX: 3; curveY: 0; ptX: 13; ptY: 20),
    (curveX: 4; curveY: 0; ptX: 14; ptY: 20)
    );
var
  line: TLine;
  i: Integer;
  curveCoordinate: Tpex;
  pointCoordinate: Tpex;
begin
  //
  // Give a line
  // When several points are added
  // Then the numberOfPoints property is correct
  // and the points property accesses the correct points
  // and the startx property matches the first point
  // and the endx property matches the last point
  //
  line := TLine.Create(rdMainRoadCentreLine);
  try
    // When...
    for i := 0 to High(testData) do begin
      curveCoordinate.set_xy(testData[i].curveX, testData[i].curveY);
      pointCoordinate.set_xy(testData[i].ptX, testData[i].ptY);
      line.AddPoint(curveCoordinate, pointCoordinate);
    end;

    // Then...
    CheckEquals(Length(testData), line.numberOfPoints, 'numberOfPoints');

    for i := 0 to High(testData) do begin
      CheckEquals(testData[i].ptX, line.points[i].x, Format('ptX[%d]', [i]));
      CheckEquals(testData[i].ptY, line.points[i].y, Format('ptY[%d]', [i]));
    end;

    CheckEquals(testData[0].curveX, line.startxy.x, 'startxy.x');
    CheckEquals(testData[0].curveY, line.startxy.y, 'startxy.y');
    CheckEquals(testData[High(testData)].curveX, line.endxy.x, 'endxy.x');
    CheckEquals(testData[High(testData)].curveY, line.endxy.y, 'endxy.y');

  finally
    line.Free;
  end;

end;

initialization
  RegisterTest(TTestLine);

end.
