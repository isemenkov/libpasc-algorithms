unit arraylisttestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, container.arraylist, utils.functor;

type
  TIntegerArrayList = specialize TArrayList<Integer,
    TCompareFunctorInteger>;

  TArrayListTestCase= class(TTestCase)
  published
    procedure TestCreateArrayList;
    procedure TestArrayListRealloc;
    procedure TestArrayListPrepend;
    procedure TestArrayListInsertRemove;
    procedure TestArrayListSort;
    procedure TestArrayListStoreOneMillionItems;
  end;

implementation

procedure TArrayListTestCase.TestCreateArrayList;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(3);
  arr.Append(1);
  arr.Append(4);
  arr.Append(5);

  AssertTrue('ArrayLists length is not correct', arr.Length = 3);
  AssertTrue('ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);
  AssertTrue('ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.TestArrayListRealloc;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(3);
  arr.Append(12);
  arr.Append(432);
  arr.Append(-34);
  arr.Append(40);
  arr.Append(492);
  arr.Append(301);
  arr.Append(-31);

  AssertTrue('ArrayLists length is not correct', arr.Length = 7);
  AssertTrue('ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
  AssertTrue('ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 432);
  AssertTrue('ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -34);
  AssertTrue('ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40);
  AssertTrue('ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  AssertTrue('ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 301);
  AssertTrue('ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -31);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.TestArrayListPrepend;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;

  arr.Append(43);
  arr.Append(67);
  arr.Prepend(-11);
  arr.Prepend(683);

  AssertTrue('1: ArrayLists length is not correct', arr.Length = 4);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 683);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -11);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 67);

  arr.Clear;

  AssertTrue('2: ArrayLists length is not correct', arr.Length = 0);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.TestArrayListInsertRemove;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;
  arr.Append(342);
  arr.Insert(0, -100);

  AssertTrue('1: ArrayLists length is not correct', arr.Length = 2);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 342);

  arr.Append(65);
  arr.Insert(2, 492);

  AssertTrue('2: ArrayLists length is not correct', arr.Length = 4);
  AssertTrue('2: ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('2: ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 342);
  AssertTrue('2: ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  AssertTrue('2: ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 65);

  arr.Remove(1);

  AssertTrue('3: ArrayLists length is not correct', arr.Length = 3);
  AssertTrue('3: ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('3: ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  AssertTrue('3: ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 65);

  arr.Append(72);
  arr.Append(943);
  arr.RemoveRange(2, 3);

  AssertTrue('4: ArrayLists length is not correct', arr.Length = 2);
  AssertTrue('4: ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('4: ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.TestArrayListSort;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;
  arr.Append(9);
  arr.Append(3);
  arr.Append(-4);
  arr.Append(12);
  arr.Sort;

  AssertTrue('1: ArrayLists length is not correct', arr.Length = 4);
  AssertTrue('1: ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
  AssertTrue('1: ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('1: ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
  AssertTrue('1: ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);

  arr.Insert(2, 43);
  arr.Prepend(5);
  arr.Insert(1, 17);
  arr.Sort;

  AssertTrue('2: ArrayLists length is not correct', arr.Length = 7);
  AssertTrue('2: ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
  AssertTrue('2: ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('2: ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);
  AssertTrue('2: ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
  AssertTrue('2: ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
  AssertTrue('2: ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 17);
  AssertTrue('2: ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.TestArrayListStoreOneMillionItems;
var
  arr : TIntegerArrayList;
  index : Integer;
begin
  arr := TIntegerArrayList.Create;

  for index := 0 to 1000000 do
  begin
    arr.Append(index);
  end;

  AssertTrue('1: ArrayLists length is not correct', arr.Length = 1000001);

  for index := 0 to 1000000 do
  begin
    AssertTrue('2: ArrayLists index ' + IntToStr(index) + ' value is not correct',
      arr.Value[index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index);
  end;

  FreeAndNil(arr);
end;

initialization

  RegisterTest(TArrayListTestCase);
end.

