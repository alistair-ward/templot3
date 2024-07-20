unit timber;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  ShovedTimber,
  curve_interface,
  point_ex;

type

  { TTimber }

  TTimber = class
  private
    // values determined for all timbers
    FTimberString: String;
    FXtb: Double;
    FWidth: Double;
    FLength: Double;
    FOffset: Double;
    FCentrelineExtraLength: Double;

    // values from ShovedTimbers
    FShoveCode: TShoveCode;
    FXtbModifier: Double;
    FAngleModifier: Double;
    FOffsetModifier: Double;
    FLengthModifier: Double;
    FWidthModifier: Double;
    FCrabModifier: Double;

    FCentrelinePoints: array of Tpex;
    FOutlinePoints: array of Tpex;
    FLabelPoint: Tpex;

    function GetCentrelinePointCount: Integer;
    function GetCentrelinePoint(i: Integer): Tpex;
    function GetOutlinePointCount: Integer;
    function GetOutlinePoint(i: Integer): Tpex;
    function GetLabelPoint: Tpex;

  public
    constructor Create(AString: String; AXtb, AWidth, ALength, AOffset, ACentrelineExtraLength: Double);
    destructor Destroy; override;

    procedure Calculate(ACurve: ICurve; AHand: Integer);

    property timberString: String read FTimberString;
    property xtb: Double read FXtb;
    property width: Double read FWidth;
    property length: Double read FLength;
    property offset: Double read FOffset;

    property centrelinePointCount: Integer read GetCentrelinePointCount;
    property centrelinePoint[i: Integer]: Tpex read GetCentrelinePoint;
    property outlinePointCount: Integer read GetOutlinePointCount;
    property outlinePoint[i: Integer]: Tpex read GetOutlinePoint;
    property labelPoint: Tpex read GetLabelPoint;
  end;

implementation



{ TTimber }

constructor TTimber.Create(AString: String; AXtb, AWidth, ALength, AOffset, ACentrelineExtraLength: Double);
begin
  inherited Create;

  FXtb := AXtb;
  FWidth := AWidth;
  FLength := ALength;
  FOffset := AOffset;
  FCentrelineExtraLength := ACentrelineExtraLength;
  FTimberString := AString;
end;

destructor TTimber.Destroy;
begin
  inherited Destroy;
end;

procedure TTimber.Calculate(ACurve: ICurve; AHand: Integer);
var
  pt: Tpex;
  direction: Tpex;
  perpendicular: Tpex;
  radius: Double;
  actualX: Double;
  actualWidth: Double;
  actualLength: Double;
  actualOffset: Double;
begin
  actualX := FXtb; // + FXtbModifier
  actualOffset := FOffset; // + FOffsetModifier
  actualWidth := FWidth; // + FWidthModifier
  actualLength := FLength; // + FLengthModifier

  ACurve.CalculateCurveAt(FXtb, 0, pt, direction, radius);
  perpendicular.set_xy(-direction.y, direction.x);

  SetLength(FOutlinePoints, 4);
  SetLength(FCentrelinePoints, 2);
  pt := pt + perpendicular * AHand * actualOffset;

  FOutlinePoints[0] := pt - direction * actualWidth/2;
  FOutlinePoints[1] := pt + direction * actualWidth/2;
  FCentrelinePoints[0] := pt - perpendicular * AHand * FCentrelineExtraLength;

  pt := pt + perpendicular * AHand * actualLength;
  FOutlinePoints[2] := pt + direction * actualWidth/2;
  FOutlinePoints[3] := pt - direction * actualWidth/2;
  FCentrelinePoints[1] := pt + perpendicular * AHand * FCentrelineExtraLength;

end;

function TTimber.GetCentrelinePointCount: Integer;
begin
  Result := System.Length(FCentrelinePoints);
end;

function TTimber.GetCentrelinePoint(i: Integer): Tpex;
begin
  Result := FCentrelinePoints[i];
end;

function TTimber.GetOutlinePointCount: Integer;
begin
  Result := System.Length(FOutlinePoints);
end;

function TTimber.GetOutlinePoint(i: Integer): Tpex;
begin
  Result := FOutlinePoints[i];
end;

function TTimber.GetLabelPoint: Tpex;
begin
  Result := FLabelPoint;
end;

end.
