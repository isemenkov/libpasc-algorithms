program libpascalgorithmstestcase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, arraylisttestcase, listtestcase;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

