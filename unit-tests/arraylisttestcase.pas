unit arraylisttestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, arraylist;

type
  TIntegerArrayLists = specialize TArrayLists<Integer>;

  TArrayListsTestCase= class(TTestCase)
  published
    procedure TestCreateArrayLists;
    procedure TestArrayListsRealloc;
    procedure TestArrayListsPrepend;
    procedure TestArrayListInsertRemove;
    procedure TestArrayListSort;
  end;

implementation

procedure TArrayListsTestCase.TestCreateArrayLists;
var
  arr : TIntegerArrayLists;
begin
  arr := TIntegerArrayLists.Create(3);
  arr.Append(1);
  arr.Append(4);
  arr.Append(5);

  AssertTrue('ArrayLists length is not correct', arr.Length = 3);
  AssertTrue('ArrayLists index 0 value is not correct', arr.Value[0] = 1);
  AssertTrue('ArrayLists index 1 value is not correct', arr.Value[1] = 4);
  AssertTrue('ArrayLists index 2 value is not correct', arr.Value[2] = 5);

  FreeAndNil(arr);
end;

procedure TArrayListsTestCase.TestArrayListsRealloc;
var
  arr : TIntegerArrayLists;
begin
  arr := TIntegerArrayLists.Create(3);
  arr.Append(12);
  arr.Append(432);
  arr.Append(-34);
  arr.Append(40);
  arr.Append(492);
  arr.Append(301);
  arr.Append(-31);

  AssertTrue('ArrayLists length is not correct', arr.Length = 7);
  AssertTrue('ArrayLists index 0 value is not correct', arr.Value[0] = 12);
  AssertTrue('ArrayLists index 1 value is not correct', arr.Value[1] = 432);
  AssertTrue('ArrayLists index 2 value is not correct', arr.Value[2] = -34);
  AssertTrue('ArrayLists index 3 value is not correct', arr.Value[3] = 40);
  AssertTrue('ArrayLists index 4 value is not correct', arr.Value[4] = 492);
  AssertTrue('ArrayLists index 5 value is not correct', arr.Value[5] = 301);
  AssertTrue('ArrayLists index 6 value is not correct', arr.Value[6] = -31);

  FreeAndNil(arr);
end;

procedure TArrayListsTestCase.TestArrayListsPrepend;
var
  arr : TIntegerArrayLists;
begin
  arr := TIntegerArrayLists.Create;

  arr.Append(43);
  arr.Append(67);
  arr.Prepend(-11);
  arr.Prepend(683);

  AssertTrue('1: ArrayLists length is not correct', arr.Length = 4);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[0] = 683);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[1] = -11);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[2] = 43);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[3] = 67);

  arr.Clear;

  AssertTrue('2: ArrayLists length is not correct', arr.Length = 0);

  FreeAndNil(arr);
end;

procedure TArrayListsTestCase.TestArrayListInsertRemove;
var
  arr : TIntegerArrayLists;
begin
  arr := TIntegerArrayLists.Create;
  arr.Append(342);
  arr.Insert(0, -100);

  AssertTrue('1: ArrayLists length is not correct', arr.Length = 2);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[0] = -100);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[1] = 342);

  arr.Append(65);
  arr.Insert(2, 492);

  AssertTrue('2: ArrayLists length is not correct', arr.Length = 4);
  AssertTrue('2: ArrayLists index 0 value is not correct', arr.Value[0] = -100);
  AssertTrue('2: ArrayLists index 1 value is not correct', arr.Value[1] = 342);
  AssertTrue('2: ArrayLists index 2 value is not correct', arr.Value[2] = 492);
  AssertTrue('2: ArrayLists index 3 value is not correct', arr.Value[3] = 65);

  arr.Remove(1);

  AssertTrue('3: ArrayLists length is not correct', arr.Length = 3);
  AssertTrue('3: ArrayLists index 0 value is not correct', arr.Value[0] = -100);
  AssertTrue('3: ArrayLists index 1 value is not correct', arr.Value[1] = 492);
  AssertTrue('3: ArrayLists index 2 value is not correct', arr.Value[2] = 65);

  arr.Append(72);
  arr.Append(943);
  arr.RemoveRange(2, 3);

  AssertTrue('4: ArrayLists length is not correct', arr.Length = 2);
  AssertTrue('4: ArrayLists index 0 value is not correct', arr.Value[0] = -100);
  AssertTrue('4: ArrayLists index 1 value is not correct', arr.Value[1] = 492);

  FreeAndNil(arr);
end;

procedure TArrayListsTestCase.TestArrayListSort;
var
  arr : TIntegerArrayLists;
begin
  arr := TIntegerArrayLists.Create;
  arr.Append(9);
  arr.Append(3);
  arr.Append(-4);
  arr.Append(12);
  arr.Sort;

  AssertTrue('1: ArrayLists length is not correct', arr.Length = 4);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[0] = -4);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[1] = 3);
  AssertTrue('1: ArrayLists index 2 value is not correct', arr.Value[2] = 9);
  AssertTrue('1: ArrayLists index 3 value is not correct', arr.Value[3] = 12);

  arr.Insert(2, 43);
  arr.Prepend(5);
  arr.Insert(1, 17);
  arr.Sort;

  AssertTrue('2: ArrayLists length is not correct', arr.Length = 7);
  AssertTrue('2: ArrayLists index 0 value is not correct', arr.Value[0] = -4);
  AssertTrue('2: ArrayLists index 1 value is not correct', arr.Value[1] = 3);
  AssertTrue('2: ArrayLists index 2 value is not correct', arr.Value[2] = 5);
  AssertTrue('2: ArrayLists index 3 value is not correct', arr.Value[3] = 9);
  AssertTrue('2: ArrayLists index 4 value is not correct', arr.Value[4] = 12);
  AssertTrue('2: ArrayLists index 5 value is not correct', arr.Value[5] = 17);
  AssertTrue('2: ArrayLists index 6 value is not correct', arr.Value[6] = 43);

  FreeAndNil(arr);
end;

initialization

  RegisterTest(TArrayListsTestCase);
end.

