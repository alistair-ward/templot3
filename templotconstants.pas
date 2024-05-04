unit TemplotConstants;

{$mode Delphi}

interface

uses
  Classes, SysUtils;


const
  // max float value for our calcs.
  maxfp: double = 1.0E300;

  // min float value for our calcs
  // (less than this is regarded as zero to avoid rounding errors).
  minfp: double = 1.0E-12;

implementation

end.

