unit testcase_trie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, container.trie;

type
  TIntTrie = specialize TTrie<Integer>;
  TStrTrie = specialize TTrie<String>;

  TTrieTestCase = class(TTestCase)
  published
    procedure Test_IntegerTrie_CreateNewEmpty;
    procedure Test_IntegerTrie_InsertNewValueInto;
    //procedure Test_IntegerIntegerAvlTree_RemoveValueFrom;
    //procedure Test_IntegerIntegerAvlTree_IterateValues;
    //procedure Test_IntegerIntegerAvlTree_IterateRange;
    //procedure Test_IntegerIntegerAvlTree_InsertOneMillionValuesInto;

    //procedure Test_StringIntegerAvlTree_CreateNewEmpty;
    //procedure Test_StringIntegerAvlTree_InsertNewValueInto;
    //procedure Test_StringIntegerAvlTree_RemoveValueFrom;
    //procedure Test_StringIntegerAvlTree_IterateValues;
    //procedure Test_StringIntegerAvlTree_IterateRange;
    //procedure Test_StringIntegerAvlTree_InsertOneMillionValuesInto;
  end;

implementation

procedure TTrieTestCase.Test_IntegerTrie_CreateNewEmpty;
var
  trie : TIntTrie;
begin
  trie := TIntTrie.Create;

  FreeAndNil(trie);
end;

procedure TTrieTestCase.Test_IntegerTrie_InsertNewValueInto;
var
  trie : TIntTrie;
begin
  trie := TIntTrie.Create;

  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'New value isn''t inserted', trie.Insert('test', 21));
  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'New value isn''t inserted', trie.Insert('value', 14));
  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'New value isn''t inserted', trie.Insert('another', 587));

  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'Key ''test'' value is not correct', trie.Search('test') = 21);
  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'Key ''value'' value is not correct', trie.Search('value') = 14);
  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'Key ''another'' value is not correct', trie.Search('another') = 587);

  //FreeAndNil(trie);
end;


initialization
  RegisterTest(TTrieTestCase);
end.

