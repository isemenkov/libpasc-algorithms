unit testcase_arraylist;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.arraylist, utils.functor, utils.pair
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerArrayList = {$IFDEF FPC}specialize{$ENDIF} TArrayList<Integer,
    TCompareFunctorInteger>;
  TStringArrayList = {$IFDEF FPC}specialize{$ENDIF} TArrayList<String,
    TCompareFunctorString>;

  TPairInteger = {$IFDEF FPC}specialize{$ENDIF} TPair<Integer, Integer>;
  TPairIntegerCompareFunctor = class
    ({$IFDEF FPC}specialize{$ENDIF} TBinaryFunctor<TPairInteger, Integer>)
  public
    function Call(AValue1, AValue2 : TPairInteger) : Integer; override;
  end;

  TPairIntegerArrayList = {$IFDEF FPC}specialize{$ENDIF} TArrayList<TPairInteger,
    TPairIntegerCompareFunctor>;

  TArrayListTestCase = class(TTestCase)
  published
    procedure Test_IntegerArrayList_CreateNewEmpty;
    procedure Test_IntegerArrayList_AppendNewValueInto;
    procedure Test_IntegerArrayList_AppendNewValueAndReallocMemory;
    procedure Test_IntegerArrayList_PrependValueInto;
    procedure Test_IntegerArrayList_AppendNewValueAndClear;
    procedure Test_IntegerArrayList_RemoveValueFrom;
    procedure Test_IntegerArrayList_Sort;
    procedure Test_IntegerArrayList_IterateValues;
    procedure Test_IntegerArrayList_IterateRange;
    procedure Test_IntegerArrayList_InsertOneMillionValuesInto;
    procedure Test_PairIntegerArrayList_AppendObject;
    procedure Test_IntegerArrayList_SearchInEmpty;
    procedure Test_IntegerArrayList_LastElementIterator;

    procedure Test_StringArrayList_CreateNewEmpty;
    procedure Test_StringArrayList_AppendNewValueInto;
    procedure Test_StringArrayList_AppendNewValueAndReallocMemory;
    procedure Test_StringArrayList_PrependValueInto;
    procedure Test_StringArrayList_AppendNewValueAndClear;
    procedure Test_StringArrayList_RemoveValueFrom;
    procedure Test_StringArrayList_Sort;
    procedure Test_StringArrayList_IterateValues;
    procedure Test_StringArrayList_IterateRange;
    procedure Test_StringArrayList_InsertOneMillionValuesInto;
    procedure Test_StringArrayList_SearchInEmpty;
    procedure Test_StringArrayList_LastElementIterator;
  end;

implementation

function TPairIntegerCompareFunctor.Call (AValue1, AValue2 : TPairInteger) :
  Integer;
begin
  if AValue1.First < AValue2.First then
  begin
    Result := -1;
  end else if AValue2.First < AValue1.First then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

procedure TArrayListTestCase.Test_IntegerArrayList_CreateNewEmpty;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(0);

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);
  {$ELSE}
  CheckTrue(arr.Length = 0, '#Test_IntegerArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty');
  {$ENDIF}

  FreeAndNil(arr);

  arr := TIntegerArrayList.Create(10);

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);
  {$ELSE}
  CheckTrue(arr.Length = 0, '#Test_IntegerArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_CreateNewEmpty;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create(0);

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);
  {$ELSE}
  CheckTrue(arr.Length = 0, '#Test_StringArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty');
  {$ENDIF}

  FreeAndNil(arr);

  arr := TStringArrayList.Create(10);

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);
  {$ELSE}
  CheckTrue(arr.Length = 0, '#Test_StringArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_AppendNewValueInto;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(3);

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayList value 1 not append', arr.Append(1));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayList value 4 not append', arr.Append(4));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayList value 5 not append', arr.Append(5));

  AssertTrue('#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueInto -> '+
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);
  {$ELSE}
  CheckTrue(arr.Append(1), '#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayList value 1 not append');
  CheckTrue(arr.Append(4), '#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayList value 4 not append');
  CheckTrue(arr.Append(5), '#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayList value 5 not append');

  CheckTrue(arr.Length = 3, '#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1,
    '#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4,
    '#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5,
    '#Test_IntegerArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 2 value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_AppendNewValueInto;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create(3);

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayList value test1 not append', arr.Append('test1'));
  AssertTrue('#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayList value test4 not append', arr.Append('test4'));
  AssertTrue('#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayList value test5 not append', arr.Append('test5'));

  AssertTrue('#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1');
  AssertTrue('#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test4');
  AssertTrue('#Test_StringArrayList_AppendNewValueInto -> '+
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test5');
  {$ELSE}
  CheckTrue(arr.Append('test1'), '#Test_StringArrayList_AppendNewValueInto -> '+
    'ArrayList value test1 not append');
  CheckTrue(arr.Append('test4'), '#Test_StringArrayList_AppendNewValueInto -> '+
    'ArrayList value test4 not append');
  CheckTrue(arr.Append('test5'), '#Test_StringArrayList_AppendNewValueInto -> '+
    'ArrayList value test5 not append');

  CheckTrue(arr.Length = 3, '#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1',
    '#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test4',
    '#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test5',
    '#Test_StringArrayList_AppendNewValueInto -> ' +
    'ArrayLists index 2 value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase
  .Test_IntegerArrayList_AppendNewValueAndReallocMemory;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(3);

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 12 not append', arr.Append(12));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 432 not append', arr.Append(432));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value -34 not append', arr.Append(-34));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 40 not append', arr.Append(40));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 492 not append', arr.Append(492));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 301 not append', arr.Append(301));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value -31 not append', arr.Append(-31));

  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists length is not correct', arr.Length = 7);

  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 432);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -34);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 301);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -31);
  {$ELSE}
  CheckTrue(arr.Append(12),
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 12 not append');
  CheckTrue(arr.Append(432),
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 432 not append');
  CheckTrue(arr.Append(-34),
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value -34 not append');
  CheckTrue(arr.Append(40),
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 40 not append');
  CheckTrue(arr.Append(492),
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 492 not append');
  CheckTrue(arr.Append(301),
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value 301 not append');
  CheckTrue(arr.Append(-31),
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value -31 not append');

  CheckTrue(arr.Length = 7,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 432,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -34,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 3 value is not correct');
  CheckTrue(arr.Value[4]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 4 value is not correct');
  CheckTrue(arr.Value[5]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 301,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 5 value is not correct');
  CheckTrue(arr.Value[6]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -31,
    '#Test_IntegerArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 6 value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase
  .Test_StringArrayList_AppendNewValueAndReallocMemory;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create(3);

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test12 not append', arr.Append('test12'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test432 not append', arr.Append('test432'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test-34 not append', arr.Append('test-34'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test40 not append', arr.Append('test40'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test492 not append', arr.Append('test492'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test301 not append', arr.Append('test301'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test-31 not append', arr.Append('test-31'));

  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists length is not correct', arr.Length = 7);

  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test432');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-34');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test40');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test301');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-31');
  {$ELSE}
  CheckTrue(arr.Append('test12'),
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test12 not append');
  CheckTrue(arr.Append('test432'),
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test432 not append');
  CheckTrue(arr.Append('test-34'),
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test-34 not append');
  CheckTrue(arr.Append('test40'),
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test40 not append');
  CheckTrue(arr.Append('test492'),
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test492 not append');
  CheckTrue(arr.Append('test301'),
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test301 not append');
  CheckTrue(arr.Append('test-31'),
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayList value test-31 not append');

  CheckTrue(arr.Length = 7,
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12',
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test432',
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-34',
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test40',
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 3 value is not correct');
  CheckTrue(arr.Value[4]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492',
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 4 value is not correct');
  CheckTrue(arr.Value[5]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test301',
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 5 value is not correct');
  CheckTrue(arr.Value[6]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-31',
    '#Test_StringArrayList_AppendNewValueAndReallocMemory -> ' +
    'ArrayLists index 6 value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_PrependValueInto;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value 43 not append', arr.Append(43));
  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value 67 not append', arr.Append(67));
  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value -11 not prepend', arr.Prepend(-11));
  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value 683 not prepend', arr.Prepend(683));

  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists length is not correct', arr.Length = 4);

  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 683);
  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -11);
  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43);
  AssertTrue('#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 67);
  {$ELSE}
  CheckTrue(arr.Append(43), '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value 43 not append');
  CheckTrue(arr.Append(67), '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value 67 not append');
  CheckTrue(arr.Prepend(-11), '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value -11 not prepend');  
  CheckTrue(arr.Prepend(683), '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayList value 683 not prepend');

  CheckTrue(arr.Length = 4, '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 683, 
    '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -11, 
    '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43, 
    '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 2 value is not correct');   
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 67, 
    '#Test_IntegerArrayList_PrependValueInto -> ' +
    'ArrayLists index 3 value is not correct'); 
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_PrependValueInto;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test43 not append', arr.Append('test43'));
  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test67 not append', arr.Append('test67'));
  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test-11 not prepend', arr.Prepend('test-11'));
  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test683 not prepend', arr.Prepend('test683'));

  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists length is not correct', arr.Length = 4);

  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test683');
  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-11');
  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test43');
  AssertTrue('#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test67');
  {$ELSE}
  CheckTrue(arr.Append('test43'), '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test43 not append');
  CheckTrue(arr.Append('test67'), '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test67 not append');
  CheckTrue(arr.Prepend('test-11'), 
    '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test-11 not prepend');
  CheckTrue(arr.Prepend('test683'), 
    '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayList value test683 not prepend');

  CheckTrue(arr.Length = 4, '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test683', 
    '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-11', 
    '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test43', 
    '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test67', 
    '#Test_StringArrayList_PrependValueInto -> ' +
    'ArrayLists index 3 value is not correct');    
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_AppendNewValueAndClear;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value 1 not append', arr.Append(1));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value 4 not append', arr.Append(4));
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value 5 not append', arr.Append(5));

  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> '+
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);
  {$ELSE}
  CheckTrue(arr.Append(1), '#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value 1 not append');
  CheckTrue(arr.Append(4), '#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value 4 not append');
  CheckTrue(arr.Append(5), '#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value 5 not append');  

  CheckTrue(arr.Length = 3, '#Test_IntegerArrayList_AppendNewValueAndClear -> '+
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1, 
    '#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4, 
    '#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5, 
    '#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 2 value is not correct');
  {$ENDIF}

  arr.Clear;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
   'ArrayList must be empty', arr.Length = 0);
  {$ELSE}
  CheckTrue(arr.Length = 0, '#Test_IntegerArrayList_AppendNewValueAndClear -> '+
   'ArrayList must be empty');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_AppendNewValueAndClear;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value test1 not append', arr.Append('test1'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value test4 not append', arr.Append('test4'));
  AssertTrue('#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value test5 not append', arr.Append('test5'));

  AssertTrue('#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test4');
  AssertTrue('#Test_StringArrayList_AppendNewValueAndClear -> '+
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test5');
  {$ELSE}
  CheckTrue(arr.Append('test1'), 
    '#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value test1 not append');
  CheckTrue(arr.Append('test4'), 
    '#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value test4 not append');
  CheckTrue(arr.Append('test5'), 
    '#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayList value test5 not append');

  CheckTrue(arr.Length = 3, '#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test1', 
    '#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test4', 
    '#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test5', 
    '#Test_StringArrayList_AppendNewValueAndClear -> ' +
    'ArrayLists index 2 value is not correct');
  {$ENDIF}

  arr.Clear;
  
  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
   'ArrayList must be empty', arr.Length = 0);
  {$ELSE}
  CheckTrue(arr.Length = 0, '#Test_IntegerArrayList_AppendNewValueAndClear -> '+
   'ArrayList must be empty');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_RemoveValueFrom;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 342 not append', arr.Append(342));
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value -100 not insert at position 0', arr.Insert(0, -100));

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 2);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 342);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 65 not append', arr.Append(65));
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 492 not insert at position 2', arr.Insert(2, 492));

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 4);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 342);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 65);
  {$ELSE}
  CheckTrue(arr.Append(342), '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 342 not append');
  CheckTrue(arr.Insert(0, -100), '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value -100 not insert at position 0');

  CheckTrue(arr.Length = 2, '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 342,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');

  CheckTrue(arr.Append(65), '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 65 not append');
  CheckTrue(arr.Insert(2, 492), '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 492 not insert at position 2');

  CheckTrue(arr.Length = 4, '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 342,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 65,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 3 value is not correct');
  {$ENDIF}

  arr.Remove(1);

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 65);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 72 not append', arr.Append(72));
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 943 not append', arr.Append(943));
  {$ELSE}
  CheckTrue(arr.Length = 3, '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 65,
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct');

  CheckTrue(arr.Append(72), '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 72 not append');
  CheckTrue(arr.Append(943), '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayList value 943 not append');
  {$ENDIF}

  arr.RemoveRange(2, 3);

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 2);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  {$ELSE}
  CheckTrue(arr.Length = 2, '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100, 
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492, 
    '#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_RemoveValueFrom;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;
  
  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test342 not append', arr.Append('test342'));
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test-100 not insert at position 0', arr.Insert(0,
    'test-100'));

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 2);

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test342');

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test65 not append', arr.Append('test65'));
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test492 not insert at position 2', arr.Insert(2,
    'test492'));

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 4);

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test342');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test65');
  {$ELSE}
  CheckTrue(arr.Append('test342'),
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test342 not append');
  CheckTrue(arr.Insert(0, 'test-100'),
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test-100 not insert at position 0');

  CheckTrue(arr.Length = 2, 
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test342',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');

  CheckTrue(arr.Append('test65'),
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test65 not append');
  CheckTrue(arr.Insert(2, 'test492'),
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test492 not insert at position 2');

  CheckTrue(arr.Length = 4,
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test342',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test65',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 3 value is not correct');
  {$ENDIF}

  arr.Remove(1);

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test65');

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test72 not append', arr.Append('test72'));
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test943 not append', arr.Append('test943'));
  {$ELSE}
  CheckTrue(arr.Length = 3,
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test65',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 2 value is not correct');

  CheckTrue(arr.Append('test72'),
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test72 not append');
  CheckTrue(arr.Append('test943'),
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayList value test943 not append');
  {$ENDIF}

  arr.RemoveRange(2, 3);

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 2);

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492');
  {$ELSE}
  CheckTrue(arr.Length = 2,
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492',
    '#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_Sort;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;
  
  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 9 not append', arr.Append(9));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 3 not append', arr.Append(3));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value -4 not append', arr.Append(-4));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 12 not append', arr.Append(12));
  {$ELSE}
  CheckTrue(arr.Append(9),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 9 not append');
  CheckTrue(arr.Append(3),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 3 not append');
  CheckTrue(arr.Append(-4),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value -4 not append');
  CheckTrue(arr.Append(12),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 12 not append');
  {$ENDIF}

  arr.Sort;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct', arr.Length = 4);

  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);

  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 43 not insert at position 2', arr.Insert(2, 43));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 5 not prepend', arr.Prepend(5));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 17 not insert at position 1', arr.Insert(1, 17));
  {$ELSE}
  CheckTrue(arr.Length = 4,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct');

  CheckTrue(arr.Insert(2, 43),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 43 not insert at position 2');
  CheckTrue(arr.Prepend(5),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 5 not prepend');
  CheckTrue(arr.Insert(1, 17),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 17 not insert at position 1');
  {$ENDIF}

  arr.Sort;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct', arr.Length = 7);

  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 17);
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43);
  {$ELSE}
  CheckTrue(arr.Length = 7,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct'); 

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct'); 
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct'); 
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct'); 
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct'); 
  CheckTrue(arr.Value[4]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 4 value is not correct'); 
  CheckTrue(arr.Value[5]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 17,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 5 value is not correct'); 
  CheckTrue(arr.Value[6]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 43,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 6 value is not correct'); 
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_Sort;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value apple not append', arr.Append('apple'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value orange not append', arr.Append('orange'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value banana not append', arr.Append('banana'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value potato not append', arr.Append('potato'));
  {$ELSE}
  CheckTrue(arr.Append('apple'),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value apple not append');
  CheckTrue(arr.Append('orange'),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value orange not append');
  CheckTrue(arr.Append('banana'),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value banana not append');
  CheckTrue(arr.Append('potato'),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value potato not append');
  {$ENDIF}

  arr.Sort;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct', arr.Length = 4);

  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato');

  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value mango not insert at position 2', arr.Insert(2, 'mango'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value cherry not prepend', arr.Prepend('cherry'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value tomato not insert at position 1', arr.Insert(1, 'tomato'));
  {$ELSE}
  CheckTrue(arr.Length = 4,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct'); 

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct');  
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct');   

  CheckTrue(arr.Insert(2, 'mango'),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value mango not insert at position 2');
  CheckTrue(arr.Prepend('cherry'),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value cherry not prepend');
  CheckTrue(arr.Insert(1, 'tomato'),
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value tomato not insert at position 1');
  {$ENDIF}


  arr.Sort;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct', arr.Length = 7);

  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'cherry');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct', arr.Value[3]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'mango');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 4 value is not correct', arr.Value[4]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 5 value is not correct', arr.Value[5]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato');
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 6 value is not correct', arr.Value[6]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'tomato');
  {$ELSE}
  CheckTrue(arr.Length = 7,
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists length is not correct');

  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 0 value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 1 value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'cherry',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 2 value is not correct');
  CheckTrue(arr.Value[3]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'mango',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 3 value is not correct');
  CheckTrue(arr.Value[4]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 4 value is not correct');
  CheckTrue(arr.Value[5]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 5 value is not correct');
  CheckTrue(arr.Value[6]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'tomato',
    '#Test_IntegerArrayList_Sort -> ' +
    'ArrayLists index 6 value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_IterateValues;
var
  arr : TIntegerArrayList;
  iterator : TIntegerArrayList.TIterator;
  counter : Cardinal;
begin
  arr := TIntegerArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 9 not append', arr.Append(9));
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 3 not append', arr.Append(3));
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value -4 not append', arr.Append(-4));
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 12 not append', arr.Append(12));
  {$ELSE}
  CheckTrue(arr.Append(9),
    '#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 9 not append');
  CheckTrue(arr.Append(3),
    '#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 3 not append');
  CheckTrue(arr.Append(-4),
    '#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value -4 not append');
  CheckTrue(arr.Append(12),
    '#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 12 not append');
  {$ENDIF}

  counter := 0;
  iterator := arr.FirstEntry;
  while iterator.HasValue do
  begin
    case counter of
      0 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 9 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9,
          '#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 9 is not correct');
        {$ENDIF}
      end;
      1 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 3 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3,
          '#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 3 is not correct');
        {$ENDIF}
      end;
      2 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value -4 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4,
          '#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value -4 is not correct');
        {$ENDIF}
      end;
      3 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 12 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12,
          '#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 12 is not correct');
        {$ENDIF}
      end;
    end;
    iterator := iterator.Next;
    Inc(counter);
  end;
  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList iterate through not all elements', counter = 4);
  {$ELSE}
  CheckTrue(counter = 4,
    '#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList iterate through not all elements');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_IterateValues;
var
  arr : TStringArrayList;
  iterator : TStringArrayList.TIterator;
  counter : Cardinal;
begin
  arr := TStringArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test9 not append', arr.Append('test9'));
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test3 not append', arr.Append('test3'));
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test-4 not append', arr.Append('test-4'));
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test12 not append', arr.Append('test12'));
  {$ELSE}
  CheckTrue(arr.Append('test9'),
    '#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test9 not append');
  CheckTrue(arr.Append('test3'),
    '#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test3 not append');
  CheckTrue(arr.Append('test-4'),
    '#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test-4 not append');
  CheckTrue(arr.Append('test12'),
    '#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test12 not append');
  {$ENDIF}

  counter := 0;
  iterator := arr.FirstEntry;
  while iterator.HasValue do
  begin
    case counter of
      0 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test9 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9');
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9',
          '#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test9 is not correct');
        {$ENDIF}
      end;
      1 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test3 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3');
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3',
          '#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test3 is not correct');
        {$ENDIF}
      end;
      2 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test-4 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-4');
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-4',
          '#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test-4 is not correct');
        {$ENDIF}
      end;
      3 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test12 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12');
        {$ELSE}
        CheckTrue(iterator.Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12',
          '#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test12 is not correct');
        {$ENDIF}
      end;
    end;
    iterator := iterator.Next;
    Inc(counter);
  end;
  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList iterate through not all elements', counter = 4);
  {$ELSE}
  CheckTrue(counter = 4,
    '#Test_StringArrayList_IterateValues -> ' +
    'ArrayList iterate through not all elements');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_IterateRange;
var
  arr : TIntegerArrayList;
  value : Integer;
  counter : Cardinal;
begin
  arr := TIntegerArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 9 not append', arr.Append(9));
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 3 not append', arr.Append(3));
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value -4 not append', arr.Append(-4));
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 12 not append', arr.Append(12));
  {$ELSE}
  CheckTrue(arr.Append(9),
    '#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 9 not append');
  CheckTrue(arr.Append(3),
    '#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 3 not append');
  CheckTrue(arr.Append(-4),
    '#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value -4 not append');
  CheckTrue(arr.Append(12),
    '#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 12 not append');  
  {$ENDIF}

  counter := 0;
  for value in arr do
  begin
    case counter of
      0 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 9 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9,
          '#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 9 is not correct');
        {$ENDIF}
      end;
      1 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 3 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3,
          '#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 3 is not correct');
        {$ENDIF}
      end;
      2 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value -4 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4,
          '#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value -4 is not correct');
        {$ENDIF}
      end;
      3 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 12 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12,
          '#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 12 is not correct');
        {$ENDIF}
      end;
    end;
    Inc(counter);
  end;
  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList iterate through not all elements', counter = 4);
  {$ELSE}
  CheckTrue(counter = 4,
    '#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList iterate through not all elements');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_IterateRange;
var
  arr : TStringArrayList;
  value : String;
  counter : Cardinal;
begin
  arr := TStringArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test9 not append', arr.Append('test9'));
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test3 not append', arr.Append('test3'));
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test-4 not append', arr.Append('test-4'));
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test12 not append', arr.Append('test12'));
  {$ELSE}
  CheckTrue(arr.Append('test9'),
    '#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test9 not append');
  CheckTrue(arr.Append('test3'),
    '#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test3 not append');
  CheckTrue(arr.Append('test-4'),
    '#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test-4 not append');
  CheckTrue(arr.Append('test12'),
    '#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test12 not append');
  {$ENDIF}

  counter := 0;
  for value in arr do
  begin
    case counter of
      0 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test9 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9');
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9',
          '#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test9 is not correct');
        {$ENDIF}
      end;
      1 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test3 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3');
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3',
          '#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test3 is not correct');
        {$ENDIF}
      end;
      2 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test-4 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-4');
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-4',
          '#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test-4 is not correct');
        {$ENDIF}
      end;
      3 : begin
        {$IFDEF FPC}
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test12 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12');
        {$ELSE}
        CheckTrue(Value{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12',
          '#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test12 is not correct');
        {$ENDIF}
      end;
    end;
  Inc(counter);
  end;
  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList iterate through not all elements', counter = 4);
  {$ELSE}
  CheckTrue(counter = 4,
    '#Test_StringArrayList_IterateRange -> ' +
    'ArrayList iterate through not all elements');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_InsertOneMillionValuesInto;
var
  arr : TIntegerArrayList;
  index : Integer;
begin
  arr := TIntegerArrayList.Create;

  for index := 0 to 1000000 do
  begin
    {$IFDEF FPC}
    AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayList value ' + IntToStr(index) + ' not append', arr.Append(index));
    {$ELSE}
    CheckTrue(arr.Append(index),
      '#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayList value ' + IntToStr(index) + ' not append');
    {$ENDIF}
  end;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 1000001);
  {$ELSE}
  CheckTrue(arr.Length = 1000001,
    '#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct');
  {$ENDIF}

  for index := 0 to 1000000 do
  begin
    {$IFDEF FPC}
    AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(index) + ' value is not correct',
      arr.Value[index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index);
    {$ELSE}
    CheckTrue(arr.Value[index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index,
      '#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(index) + ' value is not correct');
    {$ENDIF}
  end;

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_InsertOneMillionValuesInto;
var
  arr : TStringArrayList;
  index : Integer;
begin
  arr := TStringArrayList.Create;

  for index := 0 to 1000000 do
  begin
    {$IFDEF FPC}
    AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayList value' + IntToStr(index) + ' not append',
      arr.Append('test' + IntToStr(index)));
    {$ELSE}
    CheckTrue(arr.Append('test' + IntToStr(index)),
      '#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayList value' + IntToStr(index) + ' not append');
    {$ENDIF}
  end;

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 1000001);
  {$ELSE}
  CheckTrue(arr.Length = 1000001,
    '#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct');
  {$ENDIF}

  for index := 0 to 1000000 do
  begin
    {$IFDEF FPC}
    AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(index) + ' value is not correct',
      arr.Value[index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test' +
      IntToStr(index));
    {$ELSE}
    CheckTrue(arr.Value[index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test' +
      IntToStr(index), '#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(index) + ' value is not correct');
    {$ENDIF}
  end;

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_PairIntegerArrayList_AppendObject;
var
  arr : TPairIntegerArrayList;
begin
  arr := TPairIntegerArrayList.Create;

  {$IFDEF FPC}
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayList pair value <1, 3> not append',
    arr.Append(TPairInteger.Create(1, 3)));
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayList pair value <4, 5> not append',
    arr.Append(TPairInteger.Create(4, 5)));
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayList pair value <5, -11> not append',
    arr.Append(TPairInteger.Create(5, -11)));

  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 0 first value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.First = 1);
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 0 second value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.Second = 3);
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 1 first value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.First = 4);
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 1 second value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.Second = 5);
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> '+
    'ArrayLists index 2 first value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.First = 5);
  AssertTrue('#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 2 second value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.Second = -11);
  {$ELSE}
  CheckTrue(arr.Append(TPairInteger.Create(1, 3)),
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayList pair value <1, 3> not append');
  CheckTrue(arr.Append(TPairInteger.Create(4, 5)),
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayList pair value <4, 5> not append');
  CheckTrue(arr.Append(TPairInteger.Create(5, -11)),
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayList pair value <5, -11> not append');

  CheckTrue(arr.Length = 3,
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists length is not correct');
  
  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.First = 1,
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 0 first value is not correct');
  CheckTrue(arr.Value[0]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.Second = 3,
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 0 first value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.First = 4,
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 1 first value is not correct');
  CheckTrue(arr.Value[1]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.Second = 5,
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 1 first value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.First = 5,
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 2 first value is not correct');
  CheckTrue(arr.Value[2]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}.Second = -11,
    '#Test_PairIntegerArrayList_AppendObject -> ' +
    'ArrayLists index 2 first value is not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_SearchInEmpty;
var
  arr : TIntegerArrayList;
  index : Integer;
begin
  arr := TIntegerArrayList.Create;
  index := arr.IndexOf(2);

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_SearchInEmpty -> ' +
    'ArrayLists impossible element index', index = -1);
  {$ELSE}
  CheckTrue(index = -1,
    '#Test_IntegerArrayList_SearchInEmpty -> ' +
    'ArrayLists impossible element index');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_SearchInEmpty;
var
  arr : TStringArrayList;
  index : Integer;
begin
  arr := TStringArrayList.Create;
  index := arr.IndexOf('none');

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_SearchInEmpty -> ' +
    'ArrayLists impossible element index', index = -1);
  {$ELSE}
  CheckTrue(index = -1,
    '#Test_StringArrayList_SearchInEmpty -> ' +
    'ArrayLists impossible element index');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_LastElementIterator;
var
  arr : TIntegerArrayList;
  iterator : TIntegerArrayList.TIterator;
begin
  arr := TIntegerArrayList.Create;

  arr.Append(2);
  iterator := arr.LastEntry;

  {$IFDEF FPC}
  AssertTrue('#Test_IntegerArrayList_LastElementIterator -> ' +
    'ArrayLists value not correct', iterator.Value = 2);
  {$ELSE}
  CheckTrue(iterator.Value = 2,
    '#Test_IntegerArrayList_LastElementIterator -> ' +
    'ArrayLists value not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_LastElementIterator;
var
  arr : TStringArrayList;
  iterator : TStringArrayList.TIterator;
begin
  arr := TStringArrayList.Create;

  arr.Append('String');
  iterator := arr.LastEntry;

  {$IFDEF FPC}
  AssertTrue('#Test_StringArrayList_LastElementIterator -> ' +
    'ArrayLists value not correct', iterator.Value = 'String');
  {$ELSE}
  CheckTrue(iterator.Value = 'String',
    '#Test_IntegerArrayList_LastElementIterator -> ' +
    'ArrayLists value not correct');
  {$ENDIF}

  FreeAndNil(arr);
end;

initialization
  RegisterTest(TArrayListTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

