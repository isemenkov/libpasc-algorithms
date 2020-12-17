unit testcase_list;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.list, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerList = {$IFDEF FPC}specialize{$ENDIF} TList<Integer, 
    TCompareFunctorInteger>;
  TIntegerMultipleCompareFunctor = {$IFDEF FPC}specialize{$ENDIF}
      TUnsortableFunctor<TIntegerList>;
  TIntegerMultipleList = {$IFDEF FPC}specialize{$ENDIF} TList<TIntegerList,
    TIntegerMultipleCompareFunctor>;
  TStringList = {$IFDEF FPC}specialize{$ENDIF} TList<String, 
    TCompareFunctorString>;
  TStringMultipleCompareFunctor = {$IFDEF FPC}specialize{$ENDIF}
      TUnsortableFunctor<TStringList>;
  TStringMultipleList = {$IFDEF FPC}specialize{$ENDIF} TList<TStringList,
    TStringMultipleCompareFunctor>;

  TListTestCase= class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerList_CreateNewEmpty;
    procedure Test_IntegerList_AppendNewValueInto;
    procedure Test_IntegerList_PrependValueInto;
    procedure Test_IntegerList_AppendNewValueAndClear;
    procedure Test_IntegerList_InsertNewValueInto;
    procedure Test_IntegerList_RemoveValueFrom;
    procedure Test_IntegerList_FindNthIndexValueFrom;
    procedure Test_IntegerList_RemoveMultipleValuesFrom;
    procedure Test_IntegerList_Sort;
    procedure Test_IntegerList_IterateValues;
    procedure Test_IntegerList_IterateRange;
    procedure Test_IntegerList_InsertOneMillionValuesInto;
    procedure Test_IntegerList_InsertValueInMultipleList;

    procedure Test_StringList_CreateNewEmpty;
    procedure Test_StringList_AppendNewValueInto;
    procedure Test_StringList_PrependValueInto;
    procedure Test_StringList_AppendNewValueAndClear;
    procedure Test_StringList_InsertNewValueInto;
    procedure Test_StringList_RemoveValueFrom;
    procedure Test_StringList_FindNthIndexValueFrom;
    procedure Test_StringList_RemoveMultipleValuesFrom;
    procedure Test_StringList_Sort;
    procedure Test_StringList_IterateValues;
    procedure Test_StringList_IterateRange;
    procedure Test_StringList_InsertOneMillionValuesInto;
    procedure Test_StringList_InsertValueInMultipleList;
  end;

implementation

{$IFNDEF FPC}
procedure TListTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TListTestCase.Test_IntegerList_CreateNewEmpty;
var
  list : TIntegerList;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_CreateNewEmpty -> ' +
   'IntgerList must be empty', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_CreateNewEmpty;
var
  list : TStringList;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_CreateNewEmpty -> ' +
   'IntgerList must be empty', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_AppendNewValueInto;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'IntegerList value 1 not append', list.Append(1));
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'IntegerList value 4 not append', list.Append(4));
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'IntegerList value 5 not append', list.Append(5));

  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'List length is not correct', list.Length = 3);

  iterator := list.FirstEntry;
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_AppendNewValueInto -> ' +
    'Lists item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_AppendNewValueInto;
var
  list : TStringList;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'IntegerList value test1 not append', list.Append('test1'));
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'IntegerList value test4 not append', list.Append('test4'));
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'IntegerList value test5 not append', list.Append('test5'));

  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'List length is not correct', list.Length = 3);

  iterator := list.FirstEntry;
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test4');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_AppendNewValueInto -> ' +
    'Lists item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test5');

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_PrependValueInto;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'IntegerList value 42 not prepend', list.Prepend(42));
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'IntegerList value 1000 not prepend', list.Prepend(1000));
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'IntegerList value 9 not prepend', list.Prepend(9));
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'IntegerList value -1 not prepend', list.Prepend(-1));

  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.LastEntry;
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 42);

  iterator := iterator.Prev;
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1000);

  iterator := iterator.Prev;
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);

  iterator := iterator.Prev;
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_PrependValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -1);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_PrependValueInto;
var
  list : TStringList;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'IntegerList value test42 not prepend', list.Prepend('test42'));
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'IntegerList value test1000 not prepend', list.Prepend('test1000'));
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'IntegerList value test9 not prepend', list.Prepend('test9'));
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'IntegerList value test-1 not prepend', list.Prepend('test-1'));

  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.LastEntry;
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test42');

  iterator := iterator.Prev;
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1000');

  iterator := iterator.Prev;
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9');

  iterator := iterator.Prev;
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_PrependValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-1');

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_AppendNewValueAndClear;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'IntegerList value 43 not append', list.Append(43));
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'IntegerList value 67 not append', list.Append(67));
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'IntegerList value -11 not prepend', list.Prepend(-11));
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'IntegerList value 683 not prepend', list.Prepend(683));

  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.FirstEntry;
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 683);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -11);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 2 value is not correct', iterator.Value
   {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 67);

  list.Clear;

  AssertTrue('#Test_IntegerList_AppendNewValueAndClear -> ' +
    'List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_AppendNewValueAndClear;
var
  list : TStringList;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'IntegerList value test43 not append', list.Append('test43'));
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'IntegerList value test67 not append', list.Append('test67'));
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'IntegerList value test-11 not prepend', list.Prepend('test-11'));
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'IntegerList value test683 not prepend', list.Prepend('test683'));

  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.FirstEntry;
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test683');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-11');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 2 value is not correct', iterator.Value
   {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test43');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test67');

  list.Clear;

  AssertTrue('#Test_StringList_AppendNewValueAndClear -> ' +
    'List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_InsertNewValueInto;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'IntegerList value 43 not append', list.Append(43));

  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List length is not correct', list.Length = 1);

  iterator := list.FirstEntry;
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43);

  list.FirstEntry.InsertNext(67);
  list.FirstEntry.InsertPrev(-11);
  list.FirstEntry.InsertPrev(683);

  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.FirstEntry;
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 683);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -11);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 67);

  list.Clear;

  AssertTrue('#Test_IntegerList_InsertNewValueInto -> ' +
    'List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_InsertNewValueInto;
var
  list : TStringList;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'IntegerList value test43 not append', list.Append('test43'));

  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List length is not correct', list.Length = 1);

  iterator := list.FirstEntry;
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test43');

  list.FirstEntry.InsertNext('test67');
  list.FirstEntry.InsertPrev('test-11');
  list.FirstEntry.InsertPrev('test683');

  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.FirstEntry;
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test683');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-11');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test43');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test67');

  list.Clear;

  AssertTrue('#Test_StringList_InsertNewValueInto -> ' +
    'List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_RemoveValueFrom;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'IntegerList value 32 not append', list.Append(32));
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'IntegerList value 431 not append', list.Append(431));
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'IntegerList value -321 not append', list.Append(-321));
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'IntegerList value 0 not append', list.Append(0));

  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.FirstEntry;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 32);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 431);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -321);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 0);

  iterator := list.LastEntry;
  iterator.Remove;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item iterator not correct', not iterator.HasValue);

  iterator := list.LastEntry;
  iterator.Remove;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item iterator not correct', not iterator.HasValue);

  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List length is not correct', list.Length = 2);

  iterator := list.FirstEntry;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 32);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 431);

  list.FirstEntry.Remove;
  list.FirstEntry.Remove;

  AssertTrue('#Test_IntegetList_RemoveValueFrom -> ' +
    'List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_RemoveValueFrom;
var
  list : TStringList;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'IntegerList value test32 not append', list.Append('test32'));
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'IntegerList value test431 not append', list.Append('test431'));
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'IntegerList value test-321 not append', list.Append('test-321'));
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'IntegerList value test0 not append', list.Append('test0'));

  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List length is not correct', list.Length = 4);

  iterator := list.FirstEntry;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test32');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test431');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-321');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test0');

  iterator := list.LastEntry;
  iterator.Remove;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item iterator not correct', not iterator.HasValue);

  iterator := list.LastEntry;
  iterator.Remove;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item iterator not correct', not iterator.HasValue);

  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List length is not correct', list.Length = 2);

  iterator := list.FirstEntry;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test32');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test431');

  list.FirstEntry.Remove;
  list.FirstEntry.Remove;

  AssertTrue('#Test_StringList_RemoveValueFrom -> ' +
    'List length is not correct', list.Length = 0);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_FindNthIndexValueFrom;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'IntegerList value 1 not append', list.Append(1));
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'IntegerList value 3 not append', list.Append(3));
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'IntegerList value 5 not append', list.Append(5));
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'IntegerList value 11 not append', list.Append(11));
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'IntegerList value 20 not append', list.Append(20));
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'IntegerList value 30 not append', list.Append(30));

  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List length is not correct', list.Length = 6);

  iterator := list.NthEntry(0);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);

  iterator := list.NthEntry(3);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 11);

  iterator := list.NthEntry(5);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 5 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 5 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 30);

  iterator := list.NthEntry(2);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);

  iterator := list.FindEntry(1);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item value 1 not find', iterator.HasValue);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List find item value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);

  iterator := list.FindEntry(20);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item value 20 not find', iterator.HasValue);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List find item value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 20);

  iterator := list.FindEntry(-7);
  AssertTrue('#Test_IntegerList_FindNthIndexValueFrom -> ' +
    'List item value -7 find', not iterator.HasValue);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_FindNthIndexValueFrom;
var
  list : TStringList;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'IntegerList value test1 not append', list.Append('test1'));
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'IntegerList value test3 not append', list.Append('test3'));
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'IntegerList value test5 not append', list.Append('test5'));
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'IntegerList value test11 not append', list.Append('test11'));
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'IntegerList value test20 not append', list.Append('test20'));
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'IntegerList value test30 not append', list.Append('test30'));

  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List length is not correct', list.Length = 6);

  iterator := list.NthEntry(0);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1');

  iterator := list.NthEntry(3);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test11');

  iterator := list.NthEntry(5);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 5 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 5 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test30');

  iterator := list.NthEntry(2);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test5');

  iterator := list.FindEntry('test1');
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item value 1 not find', iterator.HasValue);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List find item value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1');

  iterator := list.FindEntry('test20');
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item value 20 not find', iterator.HasValue);
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List find item value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test20');

  iterator := list.FindEntry('test-7');
  AssertTrue('#Test_StringList_FindNthIndexValueFrom -> ' +
    'List item value test-7 find', not iterator.HasValue);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_RemoveMultipleValuesFrom;
var
  list : TIntegerList;
  count : Cardinal;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value 43 not append', list.Append(43));
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value 32 not append', list.Append(32));
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value 43 not append', list.Append(43));
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value 1 not append', list.Append(1));
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value 1 not append', list.Append(1));
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value 1 not append', list.Append(1));
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value 431 not append', list.Append(431));

  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 7);

  count := list.Remove(43);
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'List count remove elements is not correct', count = 2);

  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 5);

  count := list.Remove(1);
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'List count remove elements is not correct', count = 3);

  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 2);

  count := list.Remove(431);
  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'List count remove elements is not correct', count = 1);

  AssertTrue('#Test_IntegerList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 1);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_RemoveMultipleValuesFrom;
var
  list : TStringList;
  count : Cardinal;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value test43 not append', list.Append('test43'));
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value test32 not append', list.Append('test32'));
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value test43 not append', list.Append('test43'));
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value test1 not append', list.Append('test1'));
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value test1 not append', list.Append('test1'));
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value test1 not append', list.Append('test1'));
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'IntegerList value test431 not append', list.Append('test431'));

  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 7);

  count := list.Remove('test43');
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'List count remove elements is not correct', count = 2);

  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 5);

  count := list.Remove('test1');
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'List count remove elements is not correct', count = 3);

  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 2);

  count := list.Remove('test431');
  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'List count remove elements is not correct', count = 1);

  AssertTrue('#Test_StringList_RemoveMultipleValuesFrom -> ' +
    'List length is not correct', list.Length = 1);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_Sort;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_Sort -> ' +
    'IntegerList value 4 not append', list.Append(4));
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'IntegerList value 3 not append', list.Append(3));
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'IntegerList value 11 not append', list.Append(11));
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'IntegerList value 9 not append', list.Append(9));
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'IntegerList value 6 not append', list.Append(6));

  list.Sort;
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List length is not correct', list.Length = 5);

  iterator := list.FirstEntry;
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 6);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 4 haven''t value', iterator.HasValue);
  AssertTrue('#Test_IntegerList_Sort -> ' +
    'List item 4 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 11);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_Sort;
var
  list : TStringList;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_Sort -> ' +
    'IntegerList value apple not append', list.Append('apple'));
  AssertTrue('#Test_StringList_Sort -> ' +
    'IntegerList value orange not append', list.Append('orange'));
  AssertTrue('#Test_StringList_Sort -> ' +
    'IntegerList value banana not append', list.Append('banana'));
  AssertTrue('#Test_StringList_Sort -> ' +
    'IntegerList value mango not append', list.Append('mango'));
  AssertTrue('#Test_StringList_Sort -> ' +
    'IntegerList value potato not append', list.Append('potato'));

  list.Sort;
  AssertTrue('#Test_StringList_Sort -> ' +
    'List length is not correct', list.Length = 5);

  iterator := list.FirstEntry;
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 0 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 0 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 1 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 1 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 2 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 2 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'mango');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 3 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 3 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');

  iterator := iterator.Next;
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 4 haven''t value', iterator.HasValue);
  AssertTrue('#Test_StringList_Sort -> ' +
    'List item 4 value is not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato');

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_IterateValues;
var
  list : TIntegerList;
  iterator : TIntegerList.TIterator;
  counter : Cardinal;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_IterateValues -> ' +
    'IntegerList value 4 not append', list.Append(4));
  AssertTrue('#Test_IntegerList_IterateValues -> ' +
    'IntegerList value 3 not append', list.Append(3));
  AssertTrue('#Test_IntegerList_IterateValues -> ' +
    'IntegerList value 11 not append', list.Append(11));
  AssertTrue('#Test_IntegerList_IterateValues -> ' +
    'IntegerList value 9 not append', list.Append(9));
  AssertTrue('#Test_IntegerList_IterateValues -> ' +
    'IntegerList value 6 not append', list.Append(6));

  counter := 0;
  iterator := list.FirstEntry;
  while iterator.HasValue do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_IntegerList_IterateValues -> ' +
          'List item 0 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
      end;
      1 : begin
        AssertTrue('#Test_IntegerList_IterateValues -> ' +
          'List item 1 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
      end;
      2 : begin
        AssertTrue('#Test_IntegerList_IterateValues -> ' +
          'List item 2 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 11);
      end;
      3 : begin
        AssertTrue('#Test_IntegerList_IterateValues -> ' +
          'List item 3 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
      end;
      4 : begin
        AssertTrue('#Test_IntegerList_IterateValues -> ' +
          'List item 4 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 6);
      end;
    end;
    iterator := iterator.Next;
    Inc(counter);
  end;
  AssertTrue('#Test_IntegerList_IterateValues -> ' +
    'List iterate through not all elements', counter = 5);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_IterateValues;
var
  list : TStringList;
  iterator : TStringList.TIterator;
  counter : Cardinal;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_IterateValues -> ' +
    'IntegerList value test4 not append', list.Append('test4'));
  AssertTrue('#Test_StringList_IterateValues -> ' +
    'IntegerList value test3 not append', list.Append('test3'));
  AssertTrue('#Test_StringList_IterateValues -> ' +
    'IntegerList value test11 not append', list.Append('test11'));
  AssertTrue('#Test_StringList_IterateValues -> ' +
    'IntegerList value test9 not append', list.Append('test9'));
  AssertTrue('#Test_StringList_IterateValues -> ' +
    'IntegerList value test6 not append', list.Append('test6'));

  counter := 0;
  iterator := list.FirstEntry;
  while iterator.HasValue do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_StringList_IterateValues -> ' +
          'List item 0 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test4');
      end;
      1 : begin
        AssertTrue('#Test_StringList_IterateValues -> ' +
          'List item 1 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3');
      end;
      2 : begin
        AssertTrue('#Test_StringList_IterateValues -> ' +
          'List item 2 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test11');
      end;
      3 : begin
        AssertTrue('#Test_StringList_IterateValues -> ' +
          'List item 3 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9');
      end;
      4 : begin
        AssertTrue('#Test_StringList_IterateValues -> ' +
          'List item 4 value is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test6');
      end;
    end;
    iterator := iterator.Next;
    Inc(counter);
  end;
  AssertTrue('#Test_StringList_IterateValues -> ' +
    'List iterate through not all elements', counter = 5);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_IterateRange;
var
  list : TIntegerList;
  value : Integer;
  counter : Cardinal;
begin
  list := TIntegerList.Create;

  AssertTrue('#Test_IntegerList_IterateRange -> ' +
    'IntegerList value 4 not append', list.Append(4));
  AssertTrue('#Test_IntegerList_IterateRange -> ' +
    'IntegerList value 3 not append', list.Append(3));
  AssertTrue('#Test_IntegerList_IterateRange -> ' +
    'IntegerList value 11 not append', list.Append(11));
  AssertTrue('#Test_IntegerList_IterateRange -> ' +
    'IntegerList value 9 not append', list.Append(9));
  AssertTrue('#Test_IntegerList_IterateRange -> ' +
    'IntegerList value 6 not append', list.Append(6));

  counter := 0;
  for value in list do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_IntegerList_IterateRange -> ' +
          'List item 0 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
      end;
      1 : begin
        AssertTrue('#Test_IntegerList_IterateRange -> ' +
          'List item 1 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
      end;
      2 : begin
        AssertTrue('#Test_IntegerList_IterateRange -> ' +
          'List item 2 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 11);
      end;
      3 : begin
        AssertTrue('#Test_IntegerList_IterateRange -> ' +
          'List item 3 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
      end;
      4 : begin
        AssertTrue('#Test_IntegerList_IterateRange -> ' +
          'List item 4 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 6);
      end;
    end;
    Inc(counter);
  end;
  AssertTrue('#Test_IntegerList_IterateRange -> ' +
    'List iterate through not all elements', counter = 5);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_IterateRange;
var
  list : TStringList;
  value : String;
  counter : Cardinal;
begin
  list := TStringList.Create;

  AssertTrue('#Test_StringList_IterateRange -> ' +
    'IntegerList value test4 not append', list.Append('test4'));
  AssertTrue('#Test_StringList_IterateRange -> ' +
    'IntegerList value test3 not append', list.Append('test3'));
  AssertTrue('#Test_StringList_IterateRange -> ' +
    'IntegerList value test11 not append', list.Append('test11'));
  AssertTrue('#Test_StringList_IterateRange -> ' +
    'IntegerList value test9 not append', list.Append('test9'));
  AssertTrue('#Test_StringList_IterateRange -> ' +
    'IntegerList value test6 not append', list.Append('test6'));

  counter := 0;
  for value in list do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_StringList_IterateRange -> ' +
          'List item 0 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test4');
      end;
      1 : begin
        AssertTrue('#Test_StringList_IterateRange -> ' +
          'List item 1 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3');
      end;
      2 : begin
        AssertTrue('#Test_StringList_IterateRange -> ' +
          'List item 2 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test11');
      end;
      3 : begin
        AssertTrue('#Test_StringList_IterateRange -> ' +
          'List item 3 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9');
      end;
      4 : begin
        AssertTrue('#Test_StringList_IterateRange -> ' +
          'List item 4 value is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test6');
      end;
    end;
    Inc(counter);
  end;
  AssertTrue('#Test_StringList_IterateRange -> ' +
    'List iterate through not all elements', counter = 5);

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_InsertOneMillionValuesInto;
var
  list : TIntegerList;
  index : Integer;
  iterator : TIntegerList.TIterator;
begin
  list := TIntegerList.Create;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntegerList_InsertOneMillionValuesInto -> ' +
    'IntegerList value ' + IntToStr(index) + ' not append', list.Append(index));
  end;

  AssertTrue('#Test_IntegerList_InsertOneMillionValuesInto -> ' +
    'List length is not correct', list.Length = 1000001);

  index := 0;
  iterator := list.FirstEntry;
  while iterator.HasValue do
  begin
    AssertTrue('#Test_IntegerList_InsertOneMillionValuesInto -> ' +
      'List item ' + IntToStr(index) + ' value is not correct',
      iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index);
    iterator := iterator.Next;
    Inc(index);
  end;

  FreeAndNil(list);
end;

procedure TListTestCase.Test_StringList_InsertOneMillionValuesInto;
var
  list : TStringList;
  index : Integer;
  iterator : TStringList.TIterator;
begin
  list := TStringList.Create;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_StringList_InsertOneMillionValuesInto -> ' +
    'IntegerList value test' + IntToStr(index) + ' not append',
    list.Append('test' + IntToStr(index)));
  end;

  AssertTrue('#Test_StringList_InsertOneMillionValuesInto -> ' +
    'List length is not correct', list.Length = 1000001);

  index := 0;
  iterator := list.FirstEntry;
  while iterator.HasValue do
  begin
    AssertTrue('#Test_StringList_InsertOneMillionValuesInto -> ' +
      'List item test' + IntToStr(index) + ' value is not correct',
      iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test' +
      IntToStr(index));
    iterator := iterator.Next;
    Inc(index);
  end;

  FreeAndNil(list);
end;

procedure TListTestCase.Test_IntegerList_InsertValueInMultipleList;
var
  list : TIntegerMultipleList;
  inner_list : TIntegerList;
  value : Integer;
  index, inner_index : Integer;
begin
  list := TIntegerMultipleList.Create;

  for index := 0 to 1000 do
  begin
    AssertTrue('#Test_IntegerList_InsertValueInMultipleList -> ' +
    'TIntegerMultipleList list index' + IntToStr(index) + ' not append',
    list.Append(TIntegerList.Create));

    for inner_index := 0 to 1000 do
    begin
      AssertTrue('#Test_IntegerList_InsertValueInMultipleList -> ' +
        'Inner TIntegerList value ' + IntToStr(inner_index) + ' not append',
        list.LastEntry.Value.Append(inner_index));
    end;
  end;

  index := 0;
  for inner_list in list do
  begin
    inner_index := 0;
    for value in inner_list do
    begin
      AssertTrue('#Test_IntegerList_InsertValueInMultipleList -> ' +
        'List ' + IntToStr(index) + ' item index ' + IntToStr(inner_index) +
        ' value is not correct', value = inner_index);

      Inc(inner_index);
    end;
  Inc(index);
  end;

  FreeAndNil(list);
end;


procedure TListTestCase.Test_StringList_InsertValueInMultipleList;
var
  list : TStringMultipleList;
  inner_list : TStringList;
  value : String;
  index, inner_index : Integer;
begin
  list := TStringMultipleList.Create;

  for index := 0 to 1000 do
  begin
    AssertTrue('#Test_StringList_InsertValueInMultipleList -> ' +
    'TStringMultipleList list index ' + IntToStr(index) + ' not append',
    list.Append(TStringList.Create));

    for inner_index := 0 to 1000 do
    begin
      AssertTrue('#Test_StringList_InsertValueInMultipleList -> ' +
        'Inner TStringList value test' + IntToStr(inner_index) + ' not append',
        list.LastEntry.Value.Append('test' + IntToStr(inner_index)));
    end;
  end;

  index := 0;
  for inner_list in list do
  begin
    inner_index := 0;
    for value in inner_list do
    begin
      AssertTrue('#Test_StringList_InsertValueInMultipleList -> ' +
        'List ' + IntToStr(index) + ' item index ' + IntToStr(inner_index) +
        ' value is not correct', value = 'test' + IntToStr(inner_index));

      Inc(inner_index);
    end;
  Inc(index);
  end;

  FreeAndNil(list);
end;

initialization
  RegisterTest(TListTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

