unit switchinfo_test;

{$mode delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpcunit,
  testregistry,
  SwitchInfo;

type
  TTestSwitchInfo = class(TTestCase)
  published
    procedure Test1;
  end;

implementation

procedure TTestSwitchInfo.Test1;
begin

end;

initialization
  RegisterTest(TTestSwitchInfo);

end.
