unit testcase_hashtable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, container.hashtable, utils.functor;

type
  TIntIntHashTable = specialize THashTable<Integer, Integer,
    TCompareFunctorInteger>;
  TStrIntHashTable = specialize THashTable<String, Integer,
    TCompareFunctorString>;

  THashTableTestCase = class(TTestCase)
  published
    procedure Test_IntegerIntegerHashTable_CreateNewEmpty;
    procedure Test_IntegerIntegerHashTable_InsertNewValueInto;
    procedure Test_IntegerIntegerHashTable_RemoveValueFrom;
    procedure Test_IntegerIntegerHashTable_InsertOneMillionValuesInto;

    procedure Test_StringIntegerHashTable_CreateNewEmpty;
    procedure Test_StringIntegerHashTable_InsertNewValueInto;
    procedure Test_StringIntegerHashTable_RemoveValueFrom;
    procedure Test_StringIntegerHashTable_InsertOneMillionValuesInto;
  end;

implementation

procedure THashTableTestCase.Test_IntegerIntegerHashTable_CreateNewEmpty;
var
  hash : TIntIntHashTable;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  AssertTrue('#Test_IntegerIntegerHashTable_CreateNewEmpty -> ' +
    'HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.Test_StringIntegerHashTable_CreateNewEmpty;
var
  hash : TStrIntHashTable;
begin
  hash := TStrIntHashTable.Create(@HashString);

  AssertTrue('#Test_StringIntegerHashTable_CreateNewEmpty -> ' +
    'HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.Test_IntegerIntegerHashTable_InsertNewValueInto;
var
  hash : TIntIntHashTable;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  AssertTrue('#Test_IntegerIntegerHashTable_InsertNewValueInto -> ' +
    'HashTable value 1 not insert', hash.Insert(1, 100));
  AssertTrue('#Test_IntegerIntegerHashTable_InsertNewValueInto -> ' +
    'HashTable value 5 not insert', hash.Insert(5, 100));
  AssertTrue('#Test_IntegerIntegerHashTable_InsertNewValueInto -> ' +
    'HashTable value 121 not insert', hash.Insert(121, 12100));

  AssertTrue('#Test_IntegerIntegerHashTable_InsertNewValueInto -> ' +
    'Hash table value 1 is not correct', hash.Search(1)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_IntegerIntegerHashTable_InsertNewValueInto -> ' +
    'Hash table value 5 is not correct', hash.Search(5)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_IntegerIntegerHashTable_InsertNewValueInto -> ' +
    'Hash table value 121 is not correct', hash.Search(121)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12100);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.Test_StringIntegerHashTable_InsertNewValueInto;
var
  hash : TStrIntHashTable;
begin
  hash := TStrIntHashTable.Create(@HashString);

  AssertTrue('#Test_StringIntegerHashTable_InsertNewValueInto -> ' +
    'HashTable value test1 not insert', hash.Insert('test1', 100));
  AssertTrue('#Test_StringIntegerHashTable_InsertNewValueInto -> ' +
    'HashTable value test5 not insert', hash.Insert('test5', 100));
  AssertTrue('#Test_StringIntegerHashTable_InsertNewValueInto -> ' +
    'HashTable value test121 not insert', hash.Insert('test121', 12100));

  AssertTrue('#Test_StringIntegerHashTable_InsertNewValueInto -> ' +
    'Hash table value test1 is not correct', hash.Search('test1')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_StringIntegerHashTable_InsertNewValueInto -> ' +
    'Hash table value test5 is not correct', hash.Search('test5')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_StringIntegerHashTable_InsertNewValueInto -> ' +
    'Hash table value test121 is not correct', hash.Search('test121')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12100);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.Test_IntegerIntegerHashTable_RemoveValueFrom;
var
  hash : TIntIntHashTable;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable value 1 not insert', hash.Insert(1, 100));
  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable value 5 not insert', hash.Insert(5, 100));
  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable value 121 not insert', hash.Insert(121, 12100));

  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value 1 is not correct', hash.Search(1)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value 5 is not correct', hash.Search(5)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value 121 is not correct', hash.Search(121)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12100);

  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value 1 is not removed', hash.Remove(1));
  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value 5 is not removed', hash.Remove(5));
  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value 121 is not removed', hash.Remove(121));

  AssertTrue('#Test_IntegerIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.Test_StringIntegerHashTable_RemoveValueFrom;
var
  hash : TStrIntHashTable;
begin
  hash := TStrIntHashTable.Create(@HashString);

  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable value test1 not insert', hash.Insert('test1', 100));
  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable value test5 not insert', hash.Insert('test5', 100));
  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable value test121 not insert', hash.Insert('test121', 12100));

  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value test1 is not correct', hash.Search('test1')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value test5 is not correct', hash.Search('test5')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value test121 is not correct', hash.Search('test121')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12100);

  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value test1 is not removed', hash.Remove('test1'));
  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value test5 is not removed', hash.Remove('test5'));
  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'Hash table value test121 is not removed', hash.Remove('test121'));

  AssertTrue('#Test_StringIntegerHashTable_RemoveValueFrom -> ' +
    'HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase
  .Test_IntegerIntegerHashTable_InsertOneMillionValuesInto;
var
  hash : TIntIntHashTable;
  index : Integer;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntegerIntegerHashTable_InsertOneMillionValuesInto -> ' +
      'HashTable index ' + IntToStr(index) + ' value not insert',
      hash.Insert(index, index * 10 + 4));
  end;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntegerIntegerHashTable_InsertOneMillionValuesInto -> ' +
      'Hash table value index ' + IntToStr(index) +
     ' is not correct', hash.Search(index){$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}
     = index * 10 + 4);
  end;

  FreeAndNil(hash);
end;

procedure THashTableTestCase
  .Test_StringIntegerHashTable_InsertOneMillionValuesInto;
var
  hash : TStrIntHashTable;
  index : Integer;
begin
  hash := TStrIntHashTable.Create(@HashString);

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_StringIntegerHashTable_InsertOneMillionValuesInto -> ' +
      'HashTable index ' + IntToStr(index) + ' value not insert',
      hash.Insert('test' + IntToStr(index), index * 10 + 4));
  end;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_StringIntegerHashTable_InsertOneMillionValuesInto -> ' +
      'Hash table value index ' + IntToStr(index) +
     ' is not correct', hash.Search('test' + IntToStr(index))
     {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}= index * 10 + 4);
  end;

  FreeAndNil(hash);
end;

initialization
  RegisterTest(THashTableTestCase);
end.

