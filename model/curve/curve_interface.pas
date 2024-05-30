unit curve_interface;

{$mode delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  point_ex;

type
  {$interfaces corba}
  ICurve = interface
    ['ICurve']
    procedure CalculateCurveAt(distance, offset: Double; out pt, direction: Tpex; out radius: Double);
    function CalculateCurveDistanceFromOffset(distance, offset, distanceFromOffset:
      Double): Double;
  end;

implementation

end.
