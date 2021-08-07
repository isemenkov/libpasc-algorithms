unit testcase_trie;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.trie, container.orderedset, container.arraylist,
  utils.functor, {$IFNDEF FPC}System.AnsiStrings,{$ENDIF}
  utils.api.cstring{$IFDEF FPC}, fpcunit, testregistry
  {$ELSE}, TestFramework{$ENDIF};

type
  TIntTrie = {$IFDEF FPC}specialize{$ENDIF} TTrie<Integer>;
  TStrTrie = {$IFDEF FPC}specialize{$ENDIF} TTrie<String>;

  TListStrings = {$IFDEF FPC}specialize{$ENDIF} TArrayList<AnsiString,
    TCompareFunctorAnsiString>;
  TSetStrings = {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<AnsiString,
    TCompareFunctorAnsiString>;

  TTrieTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerTrie_CreateNewEmpty;
    procedure Test_IntegerTrie_InsertNewStringValueInto;
    procedure Test_IntegerTrie_RemoveStringValueFrom;
    procedure Test_IntegerTrie_InsertOneMillionStringValuesInto;

    //procedure Test_StringIntegerAvlTree_CreateNewEmpty;
    //procedure Test_StringIntegerAvlTree_InsertNewValueInto;
    //procedure Test_StringIntegerAvlTree_RemoveValueFrom;
    //procedure Test_StringIntegerAvlTree_InsertOneMillionValuesInto;
  end;

implementation

{$IFNDEF FPC}
procedure TTrieTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TTrieTestCase.Test_IntegerTrie_CreateNewEmpty;
var
  trie : TIntTrie;
begin
  trie := TIntTrie.Create;

  AssertTrue('#Test_IntegerTrie_CreateNewEmpty ->' +
    'Trie must be empty', trie.NumEntries = 0);

  FreeAndNil(trie);
end;

procedure TTrieTestCase.Test_IntegerTrie_InsertNewStringValueInto;
var
  trie : TIntTrie;
begin
  trie := TIntTrie.Create;

  AssertTrue('#Test_IntegerTrie_InsertNewStringValueInto ->' +
    'New value isn''t inserted', trie.Insert(API.CString.Create('test')
    .ToPAnsiChar, 21));
  AssertTrue('#Test_IntegerTrie_InsertNewStringValueInto ->' +
    'New value isn''t inserted', trie.Insert(API.CString.Create('value')
    .ToPAnsiChar, 14));
  AssertTrue('#Test_IntegerTrie_InsertNewStringValueInto ->' +
    'New value isn''t inserted', trie.Insert(API.CString.Create('another')
    .ToPAnsiChar, 587));

  AssertTrue('#Test_IntegerTrie_InsertNewStringValueInto ->' +
    'Trie items value is not correct', trie.NumEntries = 3);

  AssertTrue('#Test_IntegerTrie_InsertNewStringValueInto ->' +
    'Key ''test'' value is not correct', trie.Search('test')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 21);
  AssertTrue('#Test_IntegerTrie_InsertNewStringValueInto ->' +
    'Key ''value'' value is not correct', trie.Search('value')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 14);
  AssertTrue('#Test_IntegerTrie_InsertNewStringValueInto ->' +
    'Key ''another'' value is not correct', trie.Search('another')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 587);

  FreeAndNil(trie);
end;

procedure TTrieTestCase.Test_IntegerTrie_RemoveStringValueFrom;
var
  trie : TIntTrie;
begin
  trie := TIntTrie.Create;

  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'New value isn''t inserted', trie.Insert('test', 21));
  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'New value isn''t inserted', trie.Insert('value', 14));
  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'New value isn''t inserted', trie.Insert('another', 587));

  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Trie items value is not correct', trie.NumEntries = 3);

  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Key ''test'' value is not correct', trie.Search('test')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 21);
  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Key ''value'' value is not correct', trie.Search('value')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 14);
  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Key ''another'' value is not correct', trie.Search('another')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 587);

  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Key ''value'' is not removed', trie.Remove('value'));
  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Key ''another'' is not removed', trie.Remove('another'));
  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Key ''test'' is not removed', trie.Remove('test'));

  AssertTrue('#Test_IntegerTrie_RemoveStringValueFrom ->' +
    'Trie must be empty', trie.NumEntries = 0);
end;

procedure TTrieTestCase.Test_IntegerTrie_InsertOneMillionStringValuesInto;

  function RandomString (len : Integer) : AnsiString;
  var
    i : Integer;
    letter : AnsiChar;
  begin
    Result := '';
    SetLength(Result, len);
    i := 1;
    while i < len do
    begin
      letter := AnsiChar(chr(Random(128)));

      if not (letter in ['a' .. 'z', 'A' .. 'Z', '0' .. '9']) then
        Continue;

      Result[i] := letter;
      Inc(i);
    end;
    Result[len] := #0;
  end;

var
  trie : TIntTrie;
  value : AnsiString;
  index, len : Integer;
  strings : TListStrings;
  stringset : TSetStrings;
begin
  trie := TIntTrie.Create;
  stringset := TSetStrings.Create(@HashString);
  strings := TListStrings.Create;

  Randomize;
  for index := 0 to 50000 do
  begin
    len := 30;
    value := RandomString(len);
    while stringset.HasValue(value) do
      value := RandomString(len);

    stringset.Insert(value);
    strings.Append(value);
    AssertTrue('#Test_IntegerTrie_InsertOneMillionStringValuesInto ->' +
      'New value isn''t inserted', trie.Insert(value, index));
  end;

  AssertTrue('#Test_IntegerTrie_InsertOneMillionStringValuesInto ->' +
    'Trie items value is not correct', trie.NumEntries = 50001);

  for index := 0 to 50000 do
  begin
    AssertTrue('#Test_IntegerTrie_InsertOneMillionStringValuesInto ->' +
      'Key value is not correct', trie.Search(strings.Value[index]
      {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF})
      {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index);
  end;

  FreeAndNil(trie);
  FreeAndNil(strings);
end;

initialization
  RegisterTest(TTrieTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

