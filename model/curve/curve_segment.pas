
(*
    This file is part of OpenTemplot, a computer program for the design of
    model railway track.

    Copyright (C) 2019  OpenTemplot project contributors

    This program is free software: you may redistribute it and/or modify
    it under the terms of the GNU General Public Licence as published by
    the Free Software Foundation, either version 3 of the Licence, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU General Public Licence for more details.

    You should have received a copy of the GNU General Public Licence
    along with this program. See the files: licence.txt or opentemplot.lpr

    Or if not, refer to the web site: https://www.gnu.org/licenses/

                >>>     NOTE TO DEVELOPERS     <<<
                     DO NOT EDIT THIS COMMENT
              It is inserted in this file by running
                  'python3 scripts/addComment.py'
         The original text lives in scripts/addComment.py.

====================================================================================
*)

unit curve_segment;

{$mode delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  point_ex;

type
  TCurveSegment = class
  private
    FSegmentLength: double;
  public
    property segmentLength: double Read FSegmentLength;

    constructor Create(segLength: double);
    procedure CalculateCurveAt(distance: double; out pt, direction: Tpex; out radius: double);
      virtual; abstract;

    // Calculates the distance from a point on an offset curve to the end of the
    // current segment (along the offset curve).
    // @param(distance is along the original (centreline/non-offset) curve)
    // @param(offset is the offset from the centreline curve(+ve to the ))
    // @returns(the distance along to the offset curve to the end of this segment)
    function CalculateOffsetDistanceToEndOfSegment(distance, offset: Double): Double;
      virtual; abstract;

    // Calculates the distance along the centreline that corresponds to a point that is a
    // given distance along the offset curve
    // @param(distance is along the original (centreline/non-offset) curve)
    // @param(offset is the offset from the centreline curve (+ve to the right))
    // @param(distanceFromOffset is the distance along the offset curve from the specified point)
    // @returns(the distance along the centreline curve that when passed back to CalculateCurveAt() will give a point that is the specified distance along the offset curve)
    function CalculateCurveDistanceFromOffset(distance, offset, distanceFromOffsetPoint:
      Double): Double;
      virtual; abstract;
  end;

  TCurveSegmentList = class(TObjectList<TCurveSegment>)
  end;

implementation

//
//  TCurveSegment
//
constructor TCurveSegment.Create(segLength: double);
begin
  FSegmentLength := segLength;
end;

end.
