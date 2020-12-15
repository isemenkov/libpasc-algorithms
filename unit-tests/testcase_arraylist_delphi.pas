unit testcase_arraylist_delphi;

interface

uses
  TestFramework, SysUtils, container.arraylist, utils.functor;

type


  TestTIterator = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHasValue;
  end;

implementation

procedure TestTIterator.SetUp;
begin

end;

procedure TestTIterator.TearDown;
begin

end;

procedure TestTIterator.TestHasValue;
var
  ReturnValue: Boolean;
begin
  ReturnValue := True;
  // TODO: Validate method results
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTIterator.Suite);
end.

