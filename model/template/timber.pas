unit timber;

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  ShovedTimber,
  curve_interface;

type

  { TTimber }

  TTimber = class
  private
    FOffset: Double;
    FTimberString: String;
    FShoveCode: TShoveCode;
    FXtbModifier: Double;
    FAngleModifier: Double;
    FOffsetModifier: Double;
    FLengthModifier: Double;
    FWidthModifier: Double;
    FCrabModifier: Double;

  public
    constructor Create(AString: String; AOffset: Double);
    destructor Destroy; override;

    procedure Calculate(ACurve: ICurve);

  end;

implementation



{ TTimber }

constructor TTimber.Create(AString: String; AOffset: Double);
begin
  inherited Create;

  FOffset := AOffset;
  FTimberString := AString;
end;

destructor TTimber.Destroy;
begin
  inherited Destroy;
end;

procedure TTimber.Calculate(ACurve: ICurve);
begin

end;

end.
