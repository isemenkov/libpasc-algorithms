unit arraylisttestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, arraylist;

type
  TIntegerArrayLists = specialize TArrayLists<Integer>;

  TArrayListsTestCase= class(TTestCase)
  published
    procedure Test;
  end;

implementation

procedure TArrayListsTestCase.Test;
var
  arr : TIntegerArrayLists;
begin
  arr := TIntegerArrayLists.Create(3);
  arr.Append(1);
  arr.Append(4);
  arr.Append(5);
  FreeAndNil(arr);
end;

initialization

  RegisterTest(TArrayListsTestCase);
end.

