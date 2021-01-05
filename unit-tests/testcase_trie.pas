unit testcase_trie;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.trie
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntTrie = {$IFDEF FPC}specialize{$ENDIF} TTrie<Integer>;
  TStrTrie = {$IFDEF FPC}specialize{$ENDIF} TTrie<String>;

  TTrieTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerTrie_CreateNewEmpty;
    procedure Test_IntegerTrie_InsertNewValueInto;
    //procedure Test_IntegerIntegerAvlTree_RemoveValueFrom;
    //procedure Test_IntegerIntegerAvlTree_InsertOneMillionValuesInto;

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
    'Key ''test'' value is not correct', trie.Search('test')
    {$IFDEF USE_OPTIOANL}.Unwrap{$ENDIF} = 21);
  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'Key ''value'' value is not correct', trie.Search('value')
    {$IFDEF USE_OPTIOANL}.Unwrap{$ENDIF} = 14);
  AssertTrue('#Test_IntegerTrie_InsertNewValueInto ->' +
    'Key ''another'' value is not correct', trie.Search('another')
    {$IFDEF USE_OPTIOANL}.Unwrap{$ENDIF} = 587);

  FreeAndNil(trie);
end;


initialization
  RegisterTest(TTrieTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

