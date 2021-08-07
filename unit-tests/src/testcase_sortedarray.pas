unit testcase_sortedarray;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.sortedarray, utils.functor,
  utils.enumerate, container.orderedset
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerSortedArray = {$IFDEF FPC}specialize{$ENDIF} TSortedArray<Integer,
    TCompareFunctorInteger>;
  TStringSortedArray = {$IFDEF FPC}specialize{$ENDIF} TSortedArray<String,
    TCompareFunctorString>;

  TSetStrings = {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<String,
    TCompareFunctorString>;

  TSortedArrayTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerSortedArray_CreateNewEmpty;
    procedure Test_IntegerSortedArray_AppendNewValueInto;
    procedure Test_IntegerSortedArray_AppendNewValueAndReallocMemory;
    procedure Test_IntegerSortedArray_AppendOneMillionValuesInto;

    procedure Test_StringSortedArray_CreateNewEmpty;
    procedure Test_StringSortedArray_AppendNewValueInto;
    procedure Test_StringSortedArray_AppendNewValueAndReallocMemory;
    procedure Test_StringSortedArray_AppendFiftyThousandValuesInto;
  end;

implementation

{$IFNDEF FPC}
procedure TSortedArrayTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TSortedArrayTestCase.Test_IntegerSortedArray_CreateNewEmpty;
var
  arr : TIntegerSortedArray;
begin
  arr := TIntegerSortedArray.Create(0);

  AssertTrue('#Test_IntegerSortedArray_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);

  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase.Test_StringSortedArray_CreateNewEmpty;
var
  arr : TStringSortedArray;
begin
  arr := TStringSortedArray.Create(0);

  AssertTrue('#Test_StringSortedArray_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);
  
  FreeAndNil(arr);

  arr := TStringSortedArray.Create(10);

  AssertTrue('#Test_StringSortedArray_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);

  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase.Test_IntegerSortedArray_AppendNewValueInto;
var
  arr : TIntegerSortedArray;
begin
  arr := TIntegerSortedArray.Create(3);

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayList value 1 not append', arr.Append(4));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayList value 4 not append', arr.Append(3));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayList value 5 not append', arr.Append(8));

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> '+
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);

  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase.Test_StringSortedArray_AppendNewValueInto;
var
  arr : TStringSortedArray;
begin
  arr := TStringSortedArray.Create(3);

  AssertTrue('#Test_StringSortedArray_AppendNewValueInto -> ' +
    'ArrayList value test1 not append', arr.Append('apple'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueInto -> ' +
    'ArrayList value test4 not append', arr.Append('orange'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueInto -> ' +
    'ArrayList value test5 not append', arr.Append('banana'));

  AssertTrue('#Test_StringSortedArray_AppendNewValueInto -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_StringSortedArray_AppendNewValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_StringSortedArray_AppendNewValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringSortedArray_AppendNewValueInto -> '+
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  
  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase
  .Test_IntegerSortedArray_AppendNewValueAndReallocMemory;
var
  arr : TIntegerSortedArray;
begin
  arr := TIntegerSortedArray.Create(3);

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 12 not append', arr.Append(12));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 432 not append', arr.Append(432));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value -34 not append', arr.Append(-34));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 40 not append', arr.Append(40));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 492 not append', arr.Append(492));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 301 not append', arr.Append(301));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value -31 not append', arr.Append(-31));

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists length is not correct', arr.Length = 7);

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -34);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -31);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 301);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 432);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  
  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase
  .Test_StringSortedArray_AppendNewValueAndReallocMemory;
var
  arr : TStringSortedArray;
begin
  arr := TStringSortedArray.Create(3);

  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test12 not append', arr.Append('apple'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test432 not append', arr.Append('banana'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test-34 not append', arr.Append('orange'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test40 not append', arr.Append('potato'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test492 not append', arr.Append('mango'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test301 not append', arr.Append('cherry'));
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test-31 not append', arr.Append('tomato'));

  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists length is not correct', arr.Length = 7);

  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'cherry');
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'mango');
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato');
  AssertTrue('#Test_StringSortedArray_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'tomato');
  
  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase
  .Test_IntegerSortedArray_AppendOneMillionValuesInto;
var
  arr : TIntegerSortedArray;
  iterator : TIntegerSortedArray.TIterator;
  index : Integer;
begin
  arr := TIntegerSortedArray.Create;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntegerSortedArray_AppendOneMillionValuesInto -> ' +
    'ArrayList value ' + IntToStr(index) + ' not append',
    arr.Append(index));  
  end;

  AssertTrue('#Test_IntegerSortedArray_AppendOneMillionValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 1000001);

  index := 0;
  iterator := arr.FirstEntry;
  while iterator.HasValue do
  begin
    AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayLists value is not correct',
    iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index);

    iterator := iterator.Next;
    Inc(index);
  end;

  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase
  .Test_StringSortedArray_AppendFiftyThousandValuesInto;

  function RandomString (len : Integer) : String;
  var
    i : Integer;
    letter : Char;
  begin
    Result := '';
    SetLength(Result, len);
    i := 1;
    while i < len do
    begin
      letter := chr(Random(128));

      if not CharInSet(letter, ['a' .. 'z', 'A' .. 'Z', '0' .. '9']) then
        Continue;

      Result[i] := letter;
      Inc(i);
    end;
  end;

var
  arr : TStringSortedArray;
  iterator : TStringSortedArray.TIterator;
  value : String;
  index, len : Integer;
  stringset : TSetStrings;
begin
  arr := TStringSortedArray.Create;
  stringset := TSetStrings.Create(@HashString);

  Randomize;
  for index := 0 to 50000 do
  begin
    len := 30;
    value := RandomString(len);
    while stringset.HasValue(value) do
      value := RandomString(len);

    stringset.Insert(value);

    AssertTrue('#Test_StringSortedArray_AppendFiftyThousandValuesInto -> ' +
    'New value isn''t inserted', arr.Append(value));  
  end;

  AssertTrue('#Test_StringSortedArray_AppendFiftyThousandValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 50001);

  iterator := arr.FirstEntry;
  while iterator.HasValue do
  begin
    AssertTrue('#Test_StringSortedArray_AppendFiftyThousandValuesInto -> ' +
    'ArrayLists value is not correct',
    stringset.HasValue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}));

    iterator := iterator.Next;
  end;

  FreeAndNil(arr);
end;

initialization
  RegisterTest(TSortedArrayTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.
