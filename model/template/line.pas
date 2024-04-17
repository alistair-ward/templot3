unit Line;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  point_ex,
  rail_data_unit;

type

  { TLine }

  TLine = class
    private
    FRailCode: ERailData;
    FStartxy: Tpex;
    FEndxy: Tpex;
    FPoints: TpexArray;

    function GetNumberOfPoints: Integer;
    function GetPoint(idx: Integer): Tpex;

    public
    constructor Create(ARailCode: ERailData);

    procedure AddPoint(const ACurveCoord: Tpex; const APoint: Tpex);

    property railCode: ERailData read FRailCode;
    property startxy: Tpex read FStartxy;
    property endxy: Tpex read FEndxy;
    property numberOfPoints: Integer read GetNumberOfPoints;
    property point[idx: Integer]: Tpex read GetPoint;
  end;


implementation

uses
  Math;

{ TLine }

function TLine.GetNumberOfPoints: Integer;
begin
  Result := Length(FPoints);
end;

function TLine.GetPoint(idx: Integer): Tpex;
begin
  Result := FPoints[idx];
end;

constructor TLine.Create(ARailCode: ERailData);
begin
  inherited Create;

  FRailCode := ARailCode;
  FStartxy.set_xy(NaN, NaN);
  FEndxy.set_xy(NaN, NaN);
end;

procedure TLine.AddPoint(const ACurveCoord: Tpex; const APoint: Tpex);
begin
  if Length(FPoints) = 0 then begin
    FStartxy := ACurveCoord;
  end;
  FEndxy := ACurveCoord;

  SetLength(FPoints, Length(FPoints)+1);
  FPoints[High(FPoints)] := APoint;
end;

end.
