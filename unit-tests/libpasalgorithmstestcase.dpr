program libpasalgorithmstestcase;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  container.arraylist in '..\source\container.arraylist.pas',
  container.list in '..\source\container.list.pas',
  container.avltree in '..\source\container.avltree.pas',

  testcase_arraylist in '..\unit-tests\testcase_arraylist.pas',
  testcase_list in '..\unit-tests\testcase_list.pas',
  testcase_avltree in '..\unit-tests\testcase_avltree.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

