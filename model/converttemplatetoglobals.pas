unit ConvertTemplateToGlobals;

//
// Isolate conversion routines between
// global variables (the control template)
// and the new TTemplate model class.
//
// These functions have been extracted from math_unit,
// with the intention that they will be eventually
// deleted once there is no longer a "control template"
// with global variables, and we just have a current
// selected template
//

{$mode Delphi}

interface

uses
  Classes,
  SysUtils,
  Template;

// copy control template data to the keep record.
procedure fill_kd(target: TTemplate);

// get control template data from a keep.
procedure copy_keep(Source: TTemplate);

implementation


procedure fill_kd(target: TTemplate);
begin

end;

procedure copy_keep(Source: TTemplate);
begin

end;

end.

