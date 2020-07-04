unit listtestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, list;

type
  TIntegerList = specialize TList<Integer>;

  TListTestCase= class(TTestCase)
  published
    procedure TestCreateList;
    procedure TestListPrepend;
  end;

implementation

procedure TListTestCase.TestCreateList;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;
  list.Append(1);
  list.Append(4);
  list.Append(5);

  AssertTrue('List length is not correct', list.Length = 3);
  iterator := list.FirstEntry;
  AssertTrue('List item 0 value is not correct', iterator.Value = 1);
  iterator := iterator.Next;
  AssertTrue('List item 1 value is not correct', iterator.Value = 4);
  iterator := iterator.Next;
  AssertTrue('Lists item 2 value is not correct', iterator.Value = 5);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListPrepend;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  list.Append(43);
  list.Append(67);
  list.Prepend(-11);
  list.Prepend(683);

  AssertTrue('1: List length is not correct', list.Length = 4);
  iterator := list.FirstEntry;
  AssertTrue('1: List item 0 value is not correct', iterator.Value = 683);
  iterator := iterator.Next;
  AssertTrue('1: List item 1 value is not correct', iterator.Value = -11);
  iterator := iterator.Next;
  AssertTrue('1: List item 0 value is not correct', iterator.Value = 43);
  iterator := iterator.Next;
  AssertTrue('1: List item 1 value is not correct', iterator.Value = 67);

  //list.Clear;

  //AssertTrue('2: List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

initialization

  RegisterTest(TListTestCase);

end.

