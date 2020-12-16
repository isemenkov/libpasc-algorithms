program libpasalgorithmstestcase;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  container.arraylist in '..\source\container.arraylist.pas',
  testcase_arraylist in '..\unit-tests\testcase_arraylist.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

