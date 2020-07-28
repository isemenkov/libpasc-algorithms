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
    procedure TestListMove;
    procedure TestListPrepend;
    procedure TestListInsert;
    procedure TestListRemove;
    procedure TestListNthIndexFind;
    procedure TestListRemoveData;
    procedure TestListSort;
    procedure TestListStoreOneMillionItems;
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
  AssertTrue('List item 0 haven''t value', iterator.HasValue);
  AssertTrue('List item 0 value is not correct', iterator.Value = 1);
  iterator := iterator.Next;
  AssertTrue('List item 1 haven''t value', iterator.HasValue);
  AssertTrue('List item 1 value is not correct', iterator.Value = 4);
  iterator := iterator.Next;
  AssertTrue('List item 2 haven''t value', iterator.HasValue);
  AssertTrue('Lists item 2 value is not correct', iterator.Value = 5);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListMove;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  list.Prepend(42);
  list.Prepend(1000);
  list.Prepend(9);
  list.Prepend(-1);

  AssertTrue('List length is not correct', list.Length = 4);
  iterator := list.LastEntry;
  AssertTrue('List item 3 haven''t value', iterator.HasValue);
  AssertTrue('List item 3 value is not correct', iterator.Value = 42);
  iterator := iterator.Prev;
  AssertTrue('List item 2 haven''t value', iterator.HasValue);
  AssertTrue('List item 2 value is not correct', iterator.Value = 1000);
  iterator := iterator.Prev;
  AssertTrue('List item 1 haven''t value', iterator.HasValue);
  AssertTrue('List item 1 value is not correct', iterator.Value = 9);
  iterator := iterator.Prev;
  AssertTrue('List item 0 haven''t value', iterator.HasValue);
  AssertTrue('List item 0 value is not correct', iterator.Value = -1);

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
  AssertTrue('1: List item 0 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 0 value is not correct', iterator.Value = 683);
  iterator := iterator.Next;
  AssertTrue('1: List item 1 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 1 value is not correct', iterator.Value = -11);
  iterator := iterator.Next;
  AssertTrue('1: List item 2 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 2 value is not correct', iterator.Value = 43);
  iterator := iterator.Next;
  AssertTrue('1: List item 3 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 3 value is not correct', iterator.Value = 67);

  list.Clear;

  AssertTrue('2: List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListInsert;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  list.Append(43);
  AssertTrue('1: List length is not correct', list.Length = 1);
  iterator := list.FirstEntry;
  AssertTrue('1: List item 0 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 0 value is not correct', iterator.Value = 43);

  list.FirstEntry.InsertNext(67);
  list.FirstEntry.InsertPrev(-11);
  list.FirstEntry.InsertPrev(683);

  AssertTrue('2: List length is not correct', list.Length = 4);
  iterator := list.FirstEntry;
  AssertTrue('2: List item 0 haven''t value', iterator.HasValue);
  AssertTrue('2: List item 0 value is not correct', iterator.Value = 683);
  iterator := iterator.Next;
  AssertTrue('2: List item 1 haven''t value', iterator.HasValue);
  AssertTrue('2: List item 1 value is not correct', iterator.Value = -11);
  iterator := iterator.Next;
  AssertTrue('2: List item 2 haven''t value', iterator.HasValue);
  AssertTrue('2: List item 2 value is not correct', iterator.Value = 43);
  iterator := iterator.Next;
  AssertTrue('2: List item 3 haven''t value', iterator.HasValue);
  AssertTrue('2: List item 3 value is not correct', iterator.Value = 67);

  list.Clear;

  AssertTrue('3: List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListRemove;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  list.Append(32);
  list.Append(431);
  list.Append(-321);
  list.Append(0);

  AssertTrue('1: List length is not correct', list.Length = 4);
  iterator := list.FirstEntry;
  AssertTrue('1: List item 0 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 0 value is not correct', iterator.Value = 32);
  iterator := iterator.Next;
  AssertTrue('1: List item 1 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 1 value is not correct', iterator.Value = 431);
  iterator := iterator.Next;
  AssertTrue('1: List item 2 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 2 value is not correct', iterator.Value = -321);
  iterator := iterator.Next;
  AssertTrue('1: List item 3 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 3 value is not correct', iterator.Value = 0);

  iterator := list.LastEntry;
  iterator.Remove;
  AssertTrue('2: List item iterator not correct', not iterator.HasValue);
  iterator := list.LastEntry;
  iterator.Remove;
  AssertTrue('2: List item iterator not correct', not iterator.HasValue);

  AssertTrue('3: List length is not correct', list.Length = 2);
  iterator := list.FirstEntry;
  AssertTrue('3: List item 0 haven''t value', iterator.HasValue);
  AssertTrue('3: List item 0 value is not correct', iterator.Value = 32);
  iterator := iterator.Next;
  AssertTrue('3: List item 1 haven''t value', iterator.HasValue);
  AssertTrue('3: List item 1 value is not correct', iterator.Value = 431);

  list.FirstEntry.Remove;
  list.FirstEntry.Remove;

  AssertTrue('3: List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListNthIndexFind;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  list.Append(1);
  list.Append(3);
  list.Append(5);
  list.Append(11);
  list.Append(20);
  list.Append(30);

  AssertTrue('1: List length is not correct', list.Length = 6);
  iterator := list.NthEntry(0);
  AssertTrue('1: List item 0 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 0 value is not correct', iterator.Value = 1);
  iterator := list.NthEntry(3);
  AssertTrue('1: List item 3 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 3 value is not correct', iterator.Value = 11);
  iterator := list.NthEntry(5);
  AssertTrue('1: List item 5 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 5 value is not correct', iterator.Value = 30);
  iterator := list.NthEntry(2);
  AssertTrue('1: List item 2 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 2 value is not correct', iterator.Value = 5);

  iterator := list.FindEntry(1);
  AssertTrue('2: List item value 1 not find', iterator.HasValue);
  AssertTrue('2: List find item value is not correct', iterator.Value = 1);

  iterator := list.FindEntry(20);
  AssertTrue('3: List item value 20 not find', iterator.HasValue);
  AssertTrue('3: List find item value is not correct', iterator.Value = 20);

  iterator := list.FindEntry(-7);
  AssertTrue('2: List item value -7 find', not iterator.HasValue);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListRemoveData;
var
  list : TIntegerList;
  count : Cardinal;
begin
  list := TIntegerList.Create;

  list.Append(43);
  list.Append(32);
  list.Append(43);
  list.Append(1);
  list.Append(1);
  list.Append(1);
  list.Append(431);

  AssertTrue('1: List length is not correct', list.Length = 7);
  count := list.Remove(43);
  AssertTrue('1: List count remove elements is not correct', count = 2);

  AssertTrue('2: List length is not correct', list.Length = 5);
  count := list.Remove(1);
  AssertTrue('2: List count remove elements is not correct', count = 3);

  AssertTrue('3: List length is not correct', list.Length = 2);
  count := list.Remove(431);
  AssertTrue('3: List count remove elements is not correct', count = 1);

  AssertTrue('4: List length is not correct', list.Length = 1);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListSort;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  list.Append(4);
  list.Append(3);
  list.Append(11);
  list.Append(9);
  list.Append(6);

  list.Sort;
  AssertTrue('1: List length is not correct', list.Length = 5);
  iterator := list.FirstEntry;
  AssertTrue('1: List item 0 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 0 value is not correct', iterator.Value = 3);
  iterator := iterator.Next;
  AssertTrue('1: List item 1 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 1 value is not correct', iterator.Value = 4);
  iterator := iterator.Next;
  AssertTrue('1: List item 2 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 2 value is not correct', iterator.Value = 6);
  iterator := iterator.Next;
  AssertTrue('1: List item 3 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 3 value is not correct', iterator.Value = 9);
  iterator := iterator.Next;
  AssertTrue('1: List item 4 haven''t value', iterator.HasValue);
  AssertTrue('1: List item 4 value is not correct', iterator.Value = 11);

  FreeAndNil(list);
end;

procedure TListTestCase.TestListStoreOneMillionItems;
var
  list : TIntegerList;
  index : Integer;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  for index := 0 to 1000000 do
  begin
    list.Append(index);
  end;

  AssertTrue('1: List length is not correct', list.Length = 1000001);

  index := 0;
  iterator := list.FirstEntry;
  while iterator.HasValue do
  begin
    AssertTrue('2: List item ' + IntToStr(index) + ' value is not correct',
      iterator.Value = index);
    iterator := iterator.Next;
    Inc(index);
  end;
end;

initialization

  RegisterTest(TListTestCase);

end.

