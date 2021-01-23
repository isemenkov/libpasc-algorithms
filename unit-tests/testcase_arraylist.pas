unit testcase_arraylist;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.arraylist, utils.functor, utils.pair,
  utils.enumerate, utils.functional
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

  TPairIntegerArrayList = {$IFDEF FPC}specialize{$ENDIF} 
    TArrayList<TPairInteger, TPairIntegerCompareFunctor>;

  TFilterIntegerOddFunctor = class
    ({$IFDEF FPC}specialize{$ENDIF} TUnaryFunctor<Integer, Boolean>)
  public
    function Call(AValue : Integer) : Boolean; override;
  end;

  TFilterStringFunctor = class
    ({$IFDEF FPC}specialize{$ENDIF} TUnaryFunctor<String, Boolean>)
  public
    function Call(AValue : String) : Boolean; override;
  end;

  TIntegerArrayListFilterEnumerator = {$IFDEF FPC}specialize{$ENDIF} 
    TFilterEnumerator<Integer, TIntegerArrayList.TIterator,
    TFilterIntegerOddFunctor>;
  TStringArrayListFilterEnumerator = {$IFDEF FPC}specialize{$ENDIF}
    TFilterEnumerator<String, TStringArrayList.TIterator,
    TFilterStringFunctor>;

  TIntegerAdditionalAccumalate = {$IFDEF FPC}specialize{$ENDIF} 
    TAccumulate<Integer, TIntegerArrayList.TIterator, TAdditionIntegerFunctor>;
  TStringAdditionalAccumalate = {$IFDEF FPC}specialize{$ENDIF} 
    TAccumulate<String, TStringArrayList.TIterator, TAdditionStringFunctor>;

  TIntegerPow2Functor = class
    ({$IFDEF FPC}specialize{$ENDIF} TUnaryFunctor<Integer, Integer>)
  public
    function Call(AValue : Integer) : Integer; override;
  end;

  TIntegerArrayListMap = {$IFDEF FPC}specialize{$ENDIF}
    TMap<Integer, TIntegerArrayList.TIterator, TIntegerPow2Functor>;

  TSubStringFunctor = class
    ({$IFDEF FPC}specialize{$ENDIF} TUnaryFunctor<String, String>)
  public
    function Call (AValue : String) : String; override;
  end;

  TStringArrayListMap = {$IFDEF FPC}specialize{$ENDIF}
    TMap<String, TStringArrayList.TIterator, TSubStringFunctor>;

  TArrayListTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerArrayList_CreateNewEmpty;
    procedure Test_IntegerArrayList_AppendNewValueInto;
    procedure Test_IntegerArrayList_AppendNewValueAndReallocMemory;
    procedure Test_IntegerArrayList_PrependValueInto;
    procedure Test_IntegerArrayList_PrepentOneMillionValuesInto;
    procedure Test_IntegerArrayList_AppendNewValueAndClear;
    procedure Test_IntegerArrayList_RemoveValueFrom;
    procedure Test_IntegerArrayList_Sort;
    procedure Test_IntegerArrayList_IterateValues;
    procedure Test_IntegerArrayList_IterateRange;
    procedure Test_IntegerArrayList_InsertOneMillionValuesInto;
    procedure Test_PairIntegerArrayList_AppendObject;
    procedure Test_IntegerArrayList_SearchInEmpty;
    procedure Test_IntegerArrayList_LastElementIterator;
    procedure Test_IntegerArrayList_Enumerator;
    procedure Test_IntegerArrayList_FilterEnumerator;
    procedure Test_IntegerArrayList_AdditionalAccumulate;
    procedure Test_IntegerArrayList_MapPow;

    procedure Test_StringArrayList_CreateNewEmpty;
    procedure Test_StringArrayList_AppendNewValueInto;
    procedure Test_StringArrayList_AppendNewValueAndReallocMemory;
    procedure Test_StringArrayList_PrependValueInto;
    procedure Test_StringArrayList_PrepentOneMillionValuesInto;
    procedure Test_StringArrayList_AppendNewValueAndClear;
    procedure Test_StringArrayList_RemoveValueFrom;
    procedure Test_StringArrayList_Sort;
    procedure Test_StringArrayList_IterateValues;
    procedure Test_StringArrayList_IterateRange;
    procedure Test_StringArrayList_InsertOneMillionValuesInto;
    procedure Test_StringArrayList_SearchInEmpty;
    procedure Test_StringArrayList_LastElementIterator;
    procedure Test_StringArrayList_Enumerator;
    procedure Test_StringArrayList_FilterEnumerator;
    procedure Test_StringArrayList_AdditionalAccumulate;
    procedure Test_StringArrayList_MapSubString;

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

function TIntegerPow2Functor.Call (AValue : Integer) : Integer;
begin
  Result := AValue * AValue;
end;

function TSubStringFunctor.Call (AValue : String) : String;
begin
  Result := Copy(AValue, 5, Length(AValue) - 4);
end;

function TFilterIntegerOddFunctor.Call (AValue : Integer) : Boolean;
begin
  Result := (AValue mod 2) = 1;
end;

function TFilterStringFunctor.Call (AValue : String) : Boolean;
begin
  Result := (AValue = 'test');
end;

{$IFNDEF FPC}
procedure TArrayListTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TArrayListTestCase.Test_IntegerArrayList_CreateNewEmpty;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(0);

  AssertTrue('#Test_IntegerArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);
  
  FreeAndNil(arr);

  arr := TIntegerArrayList.Create(10);

  AssertTrue('#Test_IntegerArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_CreateNewEmpty;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create(0);

  AssertTrue('#Test_StringArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);
  
  FreeAndNil(arr);

  arr := TStringArrayList.Create(10);

  AssertTrue('#Test_StringArrayList_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_AppendNewValueInto;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(3);

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_AppendNewValueInto;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create(3);

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase
  .Test_IntegerArrayList_AppendNewValueAndReallocMemory;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create(3);

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase
  .Test_StringArrayList_AppendNewValueAndReallocMemory;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create(3);

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_PrependValueInto;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;

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

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_PrependValueInto;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_PrepentOneMillionValuesInto;
var
  arr : TIntegerArrayList;
  index, arr_index : Integer;
begin
  arr := TIntegerArrayList.Create;
  
  for index := 0 to 1000 do
  begin
    AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayList value ' + IntToStr(index) + ' not append', arr.Prepend(Index));
  end;

  AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 1001);

  arr_index := 0;
  for index := 1000 downto 0 do
  begin
    AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(arr_index) + ' value is not correct',
      arr.Value[arr_index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index);
    Inc(arr_index);
  end;

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_PrepentOneMillionValuesInto;
var
  arr : TStringArrayList;
  index, arr_index : Integer;
begin
  arr := TStringArrayList.Create;
  
  for index := 0 to 1000 do
  begin
    AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayList value' + IntToStr(index) + ' not append',
      arr.Prepend('test' + IntToStr(index)));
  end;

  AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 1001);

  arr_index := 0;
  for index := 1000 downto 0 do
  begin
    AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(arr_index) + ' value is not correct',
      arr.Value[arr_index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test' +
      IntToStr(index));
    Inc(arr_index);
  end;

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_AppendNewValueAndClear;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;

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
 
  arr.Clear;

  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
   'ArrayList must be empty', arr.Length = 0);
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_AppendNewValueAndClear;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;

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
  
  arr.Clear;
  
  AssertTrue('#Test_IntegerArrayList_AppendNewValueAndClear -> ' +
   'ArrayList must be empty', arr.Length = 0);
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_RemoveValueFrom;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;

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
  
  arr.Remove(1);

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
  
  arr.RemoveRange(2, 3);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 2);

  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -100);
  AssertTrue('#Test_IntegerArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_RemoveValueFrom;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;
  
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
  
  arr.Remove(1);

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
  
  arr.RemoveRange(2, 3);

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists length is not correct', arr.Length = 2);

  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-100');
  AssertTrue('#Test_StringArrayList_RemoveValueFrom -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test492');
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_Sort;
var
  arr : TIntegerArrayList;
begin
  arr := TIntegerArrayList.Create;
  
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 9 not append', arr.Append(9));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 3 not append', arr.Append(3));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value -4 not append', arr.Append(-4));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value 12 not append', arr.Append(12));
  
  arr.Sort;

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
  
  arr.Sort;

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_Sort;
var
  arr : TStringArrayList;
begin
  arr := TStringArrayList.Create;

  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value apple not append', arr.Append('apple'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value orange not append', arr.Append('orange'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value banana not append', arr.Append('banana'));
  AssertTrue('#Test_IntegerArrayList_Sort -> ' +
    'ArrayList value potato not append', arr.Append('potato'));
  
  arr.Sort;

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
  
  arr.Sort;

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_IterateValues;
var
  arr : TIntegerArrayList;
  iterator : TIntegerArrayList.TIterator;
  counter : Cardinal;
begin
  arr := TIntegerArrayList.Create;

  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 9 not append', arr.Append(9));
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 3 not append', arr.Append(3));
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value -4 not append', arr.Append(-4));
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList value 12 not append', arr.Append(12));
  
  counter := 0;
  iterator := arr.FirstEntry;
  while iterator.HasValue do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 9 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
      end;
      1 : begin
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 3 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
      end;
      2 : begin
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value -4 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
      end;
      3 : begin
        AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
          'ArrayList value 12 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
      end;
    end;
    iterator := TIntegerArrayList.TIterator(iterator.Next);
    Inc(counter);
  end;
  AssertTrue('#Test_IntegerArrayList_IterateValues -> ' +
    'ArrayList iterate through not all elements', counter = 4);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_IterateValues;
var
  arr : TStringArrayList;
  iterator : TStringArrayList.TIterator;
  counter : Cardinal;
begin
  arr := TStringArrayList.Create;

  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test9 not append', arr.Append('test9'));
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test3 not append', arr.Append('test3'));
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test-4 not append', arr.Append('test-4'));
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList value test12 not append', arr.Append('test12'));

  counter := 0;
  iterator := arr.FirstEntry;
  while iterator.HasValue do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test9 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9');
      end;
      1 : begin
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test3 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3');
      end;
      2 : begin
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test-4 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-4');
      end;
      3 : begin
        AssertTrue('#Test_StringArrayList_IterateValues -> ' +
          'ArrayList value test12 is not correct', iterator.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12');
      end;
    end;
    iterator := TStringArrayList.TIterator(iterator.Next);
    Inc(counter);
  end;
  AssertTrue('#Test_StringArrayList_IterateValues -> ' +
    'ArrayList iterate through not all elements', counter = 4);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_IterateRange;
var
  arr : TIntegerArrayList;
  value : {$IFNDEF USE_OPTIONAL}Integer{$ELSE}TIntegerArrayList.TOptionalValue
    {$ENDIF};
  counter : Cardinal;
begin
  arr := TIntegerArrayList.Create;

  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 9 not append', arr.Append(9));
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 3 not append', arr.Append(3));
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value -4 not append', arr.Append(-4));
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList value 12 not append', arr.Append(12));

  counter := 0;
  for value in arr do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 9 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
      end;
      1 : begin
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 3 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
      end;
      2 : begin
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value -4 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -4);
      end;
      3 : begin
        AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
          'ArrayList value 12 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
      end;
    end;
    Inc(counter);
  end;
  AssertTrue('#Test_IntegerArrayList_IterateRange -> ' +
    'ArrayList iterate through not all elements', counter = 4);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_IterateRange;
var
  arr : TStringArrayList;
  value : {$IFNDEF USE_OPTIONAL}String{$ELSE}TStringArrayList.TOptionalValue
    {$ENDIF};
  counter : Cardinal;
begin
  arr := TStringArrayList.Create;

  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test9 not append', arr.Append('test9'));
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test3 not append', arr.Append('test3'));
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test-4 not append', arr.Append('test-4'));
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList value test12 not append', arr.Append('test12'));

  counter := 0;
  for value in arr do
  begin
    case counter of
      0 : begin
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test9 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test9');
      end;
      1 : begin
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test3 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test3');
      end;
      2 : begin
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test-4 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test-4');
      end;
      3 : begin
        AssertTrue('#Test_StringArrayList_IterateRange -> ' +
          'ArrayList value test12 is not correct', Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test12');
      end;
    end;
  Inc(counter);
  end;
  AssertTrue('#Test_StringArrayList_IterateRange -> ' +
    'ArrayList iterate through not all elements', counter = 4);

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
    AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayList value ' + IntToStr(index) + ' not append', arr.Append(index));
  end;

  AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 1000001);

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntegerArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(index) + ' value is not correct',
      arr.Value[index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index);
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
    AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayList value' + IntToStr(index) + ' not append',
      arr.Append('test' + IntToStr(index)));
  end;

  AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
    'ArrayLists length is not correct', arr.Length = 1000001);

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_StringArrayList_InsertOneMillionValuesInto -> ' +
      'ArrayLists index ' + IntToStr(index) + ' value is not correct',
      arr.Value[index]{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test' +
      IntToStr(index));
  end;

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_PairIntegerArrayList_AppendObject;
var
  arr : TPairIntegerArrayList;
begin
  arr := TPairIntegerArrayList.Create;

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
  
  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_SearchInEmpty;
var
  arr : TIntegerArrayList;
  index : Integer;
begin
  arr := TIntegerArrayList.Create;
  index := arr.IndexOf(2);

  AssertTrue('#Test_IntegerArrayList_SearchInEmpty -> ' +
    'ArrayLists impossible element index', index = -1);

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_StringArrayList_SearchInEmpty;
var
  arr : TStringArrayList;
  index : Integer;
begin
  arr := TStringArrayList.Create;
  index := arr.IndexOf('none');

  AssertTrue('#Test_StringArrayList_SearchInEmpty -> ' +
    'ArrayLists impossible element index', index = -1);

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

  AssertTrue('#Test_IntegerArrayList_LastElementIterator -> ' +
    'ArrayLists value not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 2);

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

  AssertTrue('#Test_StringArrayList_LastElementIterator -> ' +
    'ArrayLists value not correct', iterator.Value
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'String');

  FreeAndNil(arr);
end;

procedure TArrayListTestCase.Test_IntegerArrayList_Enumerator;
var
  arr : TIntegerArrayList;
  arr_iter : TIntegerArrayList.TIterator;
  iter : TIntegerArrayList.TEnumerator.TIterator;
begin
  arr := TIntegerArrayList.Create;

  arr.Append(1);
  arr.Append(2);
  arr.Append(3);
  arr.Append(4);
  arr.Append(5);

  AssertTrue('#Test_IntegerArrayList_Enumerator -> ' +
    'ArrayLists length is not correct', arr.Length = 5);

  arr_iter := arr.FirstEntry;
  for iter in TIntegerArrayList.TEnumerator.Create(arr_iter) do
  begin
    case iter.Index of
      0 : begin
        AssertTrue('#Test_IntegerArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);
      end;
      1 : begin
        AssertTrue('#Test_IntegerArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 2);
      end;
      2 : begin
        AssertTrue('#Test_IntegerArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
      end;
      3 : begin
        AssertTrue('#Test_IntegerArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
      end;
      4 : begin
        AssertTrue('#Test_IntegerArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);
      end;
      5 : begin
        Fail('#Test_IntegerArrayList_Enumerator -> ' +
          'Impossible iterator index');
      end;
    end;
  end;
end;

procedure TArrayListTestCase.Test_StringArrayList_Enumerator;
var
  arr : TStringArrayList;
  arr_iter : TStringArrayList.TIterator;
  iter : TStringArrayList.TEnumerator.TIterator;
begin
  arr := TStringArrayList.Create;

  arr.Append('string1');
  arr.Append('string2');
  arr.Append('string3');
  arr.Append('string4');
  arr.Append('string5');

  AssertTrue('#Test_StringArrayList_Enumerator -> ' +
    'ArrayLists length is not correct', arr.Length = 5);

  arr_iter := arr.FirstEntry;
  for iter in TStringArrayList.TEnumerator.Create(arr_iter) do
  begin
    case iter.Index of
      0 : begin
        AssertTrue('#Test_StringArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'string1');
      end;
      1 : begin
        AssertTrue('#Test_StringArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'string2');
      end;
      2 : begin
        AssertTrue('#Test_StringArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'string3');
      end;
      3 : begin
        AssertTrue('#Test_StringArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'string4');
      end;
      4 : begin
        AssertTrue('#Test_StringArrayList_Enumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'string5');
      end;
      5 : begin
        Fail('#Test_StringArrayList_Enumerator -> ' +
          'Impossible iterator index');
      end;
    end;
  end;
end;

procedure TArrayListTestCase.Test_IntegerArrayList_FilterEnumerator;
var
  arr : TIntegerArrayList;
  iter : TIntegerArrayListFilterEnumerator.TIterator;
  index : Integer;
begin
  arr := TIntegerArrayList.Create;

  arr.Append(1);
  arr.Append(2);
  arr.Append(3);
  arr.Append(4);
  arr.Append(5);
  arr.Append(6);

  AssertTrue('#Test_IntegerArrayList_FilterEnumerator -> ' +
    'ArrayLists length is not correct', arr.Length = 6);

  index := 0;
  for iter in TIntegerArrayListFilterEnumerator.Create(arr.FirstEntry,
    TFilterIntegerOddFunctor.Create) do
  begin
    case Index of
      0 : begin
        AssertTrue('#Test_IntegerArrayList_FilterEnumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1);
      end;
      1 : begin
        AssertTrue('#Test_IntegerArrayList_FilterEnumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
      end;
      2 : begin
        AssertTrue('#Test_IntegerArrayList_FilterEnumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 5);
      end;
      3 : begin
        Fail('#Test_IntegerArrayList_FilterEnumerator -> ' +
          'Impossible iterator index');
      end;
    end;

    Inc(Index);
  end;
end;

procedure TArrayListTestCase.Test_StringArrayList_FilterEnumerator;
var
  arr : TStringArrayList;
  iter : TStringArrayListFilterEnumerator.TIterator;
  index : Integer;
begin
  arr := TStringArrayList.Create;

  arr.Append('some string');
  arr.Append('test');
  arr.Append('test');
  arr.Append('another string');
  arr.Append('test string');
  arr.Append('string');
  arr.Append('test');

  AssertTrue('#Test_StringArrayList_FilterEnumerator -> ' +
    'ArrayLists length is not correct', arr.Length = 7);

  index := 0;
  for iter in TStringArrayListFilterEnumerator.Create(arr.FirstEntry,
    TFilterStringFunctor.Create) do
  begin
    case Index of
      0 : begin
        AssertTrue('#Test_StringArrayList_FilterEnumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test');
      end;
      1 : begin
        AssertTrue('#Test_StringArrayList_FilterEnumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test');
      end;
      2 : begin
        AssertTrue('#Test_StringArrayList_FilterEnumerator -> ' +
          'Iterator value is not correct', iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test');
      end;
      3 : begin
        Fail('#Test_StringArrayList_FilterEnumerator -> ' +
          'Impossible iterator index');
      end;
    end;

    Inc(Index);
  end;
end;

procedure TArrayListTestCase.Test_IntegerArrayList_AdditionalAccumulate;
var
  arr : TIntegerArrayList;
  accum : TIntegerAdditionalAccumalate;
begin
  arr := TIntegerArrayList.Create;

  arr.Append(1);
  arr.Append(2);
  arr.Append(3);
  arr.Append(4);
  arr.Append(5);

  AssertTrue('#Test_IntegerArrayList_AdditionalAccumulate -> ' +
    'ArrayLists length is not correct', arr.Length = 5);

  accum := TIntegerAdditionalAccumalate.Create(arr.FirstEntry, 0);
  AssertTrue('#Test_IntegerArrayList_AdditionalAccumulate -> ' +
    'ArrayLists accumulate value is not correct', accum.Value = 15);  
end;

procedure TArrayListTestCase.Test_StringArrayList_AdditionalAccumulate;
var
  arr : TStringArrayList;
  accum : TStringAdditionalAccumalate;
begin
  arr := TStringArrayList.Create;

  arr.Append('1');
  arr.Append('2');
  arr.Append('3');
  arr.Append('4');
  arr.Append('5');

  AssertTrue('#Test_StringArrayList_AdditionalAccumulate -> ' +
    'ArrayLists length is not correct', arr.Length = 5);

  accum := TStringAdditionalAccumalate.Create(arr.FirstEntry, '');
  AssertTrue('#Test_StringArrayList_AdditionalAccumulate -> ' +
    'ArrayLists accumulate value is not correct', accum.Value = '12345');  
end;

procedure TArrayListTestCase.Test_IntegerArrayList_MapPow;
var
  arr : TIntegerArrayList;
  map_iter : TIntegerArrayListMap.TIterator;
  index : Integer;
begin
  arr := TIntegerArrayList.Create;

  arr.Append(2);
  arr.Append(3);
  arr.Append(4);
  arr.Append(5);
  arr.Append(6);

  AssertTrue('#Test_IntegerArrayList_MapPow -> ' +
    'ArrayLists length is not correct', arr.Length = 5);
  
  index := 0;
  for map_iter in TIntegerArrayListMap.Create(arr.FirstEntry, 
    TIntegerPow2Functor.Create) do
  begin
    case index of
      0 : begin
        AssertTrue('#Test_IntegerArrayList_MapPow -> ' +
          'ArrayLists value 0 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
      end;
      1 : begin
        AssertTrue('#Test_IntegerArrayList_MapPow -> ' +
          'ArrayLists value 1 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 9);
      end;
      2 : begin
        AssertTrue('#Test_IntegerArrayList_MapPow -> ' +
          'ArrayLists value 2 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 16);
      end;
      3 : begin
        AssertTrue('#Test_IntegerArrayList_MapPow -> ' +
          'ArrayLists value 3 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 25);
      end;
      4 : begin
        AssertTrue('#Test_IntegerArrayList_MapPow -> ' +
          'ArrayLists value 4 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 36);
      end;
      5 : begin
        Fail('#Test_IntegerArrayList_MapPow -> ' +
          'Impossible iterator index');
      end;
    end;

    Inc(index);
  end;  
end;

procedure TArrayListTestCase.Test_StringArrayList_MapSubString;
var
  arr : TStringArrayList;
  map_iter : TStringArrayListMap.TIterator;
  index : Integer;
begin
  arr := TStringArrayList.Create;

  arr.Append('test2');
  arr.Append('test3');
  arr.Append('test4');
  arr.Append('test5');
  arr.Append('testtest');

  AssertTrue('#Test_StringArrayList_MapSubString -> ' +
    'ArrayLists length is not correct', arr.Length = 5);
  
  index := 0;
  for map_iter in TStringArrayListMap.Create(arr.FirstEntry, 
    TSubStringFunctor.Create) do
  begin
    case index of
      0 : begin
        AssertTrue('#Test_StringArrayList_MapSubString -> ' +
          'ArrayLists value 0 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = '2');
      end;
      1 : begin
        AssertTrue('#Test_StringArrayList_MapSubString -> ' +
          'ArrayLists value 1 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = '3');
      end;
      2 : begin
        AssertTrue('#Test_StringArrayList_MapSubString -> ' +
          'ArrayLists value 2 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = '4');
      end;
      3 : begin
        AssertTrue('#Test_StringArrayList_MapSubString -> ' +
          'ArrayLists value 3 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = '5');
      end;
      4 : begin
        AssertTrue('#Test_StringArrayList_MapSubString -> ' +
          'ArrayLists value 4 is not correct', map_iter.Value
          {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'test');
      end;
      5 : begin
        Fail('#Test_StringArrayList_MapSubString -> ' +
          'Impossible iterator index');
      end;
    end;

    Inc(index);
  end;  
end;

initialization
  RegisterTest(TArrayListTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

