unit testcase_avltree;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.avltree, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntIntTree = {$IFDEF FPC}specialize{$ENDIF} TAvlTree<Integer, Integer, 
    TCompareFunctorInteger>;
  TStrIntTree = {$IFDEF FPC}specialize{$ENDIF} TAvlTree<String, Integer, 
    TCompareFunctorString>;

  TAvlTreeTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerIntegerAvlTree_CreateNewEmpty;
    procedure Test_IntegerIntegerAvlTree_InsertNewValueInto;
    procedure Test_IntegerIntegerAvlTree_RemoveValueFrom;
    procedure Test_IntegerIntegerAvlTree_IterateValues;
    procedure Test_IntegerIntegerAvlTree_IterateRange;
    procedure Test_IntegerIntegerAvlTree_InsertOneMillionValuesInto;

    procedure Test_StringIntegerAvlTree_CreateNewEmpty;
    procedure Test_StringIntegerAvlTree_InsertNewValueInto;
    procedure Test_StringIntegerAvlTree_RemoveValueFrom;
    procedure Test_StringIntegerAvlTree_IterateValues;
    procedure Test_StringIntegerAvlTree_IterateRange;
    procedure Test_StringIntegerAvlTree_InsertOneMillionValuesInto;
  end;

implementation

{$IFNDEF FPC}
procedure TAvlTreeTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TAvlTreeTestCase.Test_IntegerIntegerAvlTree_CreateNewEmpty;
var
  tree : TIntIntTree;
begin
  tree := TIntIntTree.Create;

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_StringIntegerAvlTree_CreateNewEmpty;
var
  tree : TStrIntTree;
begin
  tree := TStrIntTree.Create;

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_IntegerIntegerAvlTree_InsertNewValueInto;
var
  tree : TIntIntTree;
begin
  tree := TIntIntTree.Create;

  tree.Insert(1, 100);
  tree.Insert(2, 200);
  tree.Insert(4, 400);
  tree.Insert(10, 1000);
  tree.Insert(12, 1200);
  tree.Insert(132, 13200);

  AssertTrue('#Test_IntegerIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value 1 is not correct', tree.Search(1)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_IntegerIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value 2 is not correct', tree.Search(2)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 200);
  AssertTrue('#Test_IntegerIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value 4 is not correct', tree.Search(4)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 400);
  AssertTrue('#Test_IntegerIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value 10 is not correct', tree.Search(10)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1000);
  AssertTrue('#Test_IntegerIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value 12 is not correct', tree.Search(12)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1200);
  AssertTrue('#Test_IntegerIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value 132 is not correct', tree.Search(132)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 13200);

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_StringIntegerAvlTree_InsertNewValueInto;
var
  tree : TStrIntTree;
begin
  tree := TStrIntTree.Create;

  tree.Insert('test1', 100);
  tree.Insert('test2', 200);
  tree.Insert('test4', 400);
  tree.Insert('test10', 1000);
  tree.Insert('test12', 1200);
  tree.Insert('test132', 13200);

  AssertTrue('#Test_StringIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value test1 is not correct', tree.Search('test1')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);
  AssertTrue('#Test_StringIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value test2 is not correct', tree.Search('test2')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 200);
  AssertTrue('#Test_StringIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value test4 is not correct', tree.Search('test4')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 400);
  AssertTrue('#Test_StringIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value test10 is not correct', tree.Search('test10')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1000);
  AssertTrue('#Test_StringIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value test12 is not correct', tree.Search('test12')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 1200);
  AssertTrue('#Test_StringIntegerAvlTree_InsertNewValueInto -> ' +
    'Tree value test132 is not correct', tree.Search('test132')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 13200);

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_IntegerIntegerAvlTree_RemoveValueFrom;
var
  tree : TIntIntTree;
begin
  tree := TIntIntTree.Create;

  tree.Insert(1, 20);
  tree.Insert(2, 40);
  tree.Insert(5, 100);

  AssertTrue('#Test_IntegerIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value 1 is not correct', tree.Search(1)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 20);
  AssertTrue('#Test_IntegerIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value 2 is not correct', tree.Search(2)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40);
  AssertTrue('#Test_IntegerIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value 5 is not correct', tree.Search(5)
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);

  AssertTrue('#Test_IntegerIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value 1 is not removed', tree.Remove(1));
  AssertTrue('#Test_IntegerIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value 2 is not removed', tree.Remove(2));
  AssertTrue('#Test_IntegerIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value 5 is not removed', tree.Remove(5));
  AssertTrue('#Test_IntegerIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree not exists value is removed', not tree.Remove(7));

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_StringIntegerAvlTree_RemoveValueFrom;
var
  tree : TStrIntTree;
begin
  tree := TStrIntTree.Create;

  tree.Insert('test1', 20);
  tree.Insert('test2', 40);
  tree.Insert('test5', 100);

  AssertTrue('#Test_StringIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value test1 is not correct', tree.Search('test1')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 20);
  AssertTrue('#Test_StringIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value test2 is not correct', tree.Search('test2')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40);
  AssertTrue('#Test_StringIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value test5 is not correct', tree.Search('test5')
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 100);

  AssertTrue('#Test_StringIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value test1 is not removed', tree.Remove('test1'));
  AssertTrue('#Test_StringIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value test2 is not removed', tree.Remove('test2'));
  AssertTrue('#Test_StringIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree value test5 is not removed', tree.Remove('test5'));
  AssertTrue('#Test_StringIntegerAvlTree_RemoveValueFrom -> ' +
    'Tree not exists value is removed', not tree.Remove('test7'));

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_IntegerIntegerAvlTree_IterateValues;
var
  tree : TIntIntTree;
  iterator : TIntIntTree.TIterator;
begin
  tree := TIntIntTree.Create;

  tree.Insert(1, 20);
  tree.Insert(2, 40);
  tree.Insert(5, 100);

  iterator := tree.FirstEntry;
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateValues -> ' +
    'Tree key 1 is not correct', iterator.Key = 1);
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateValues -> ' +
    'Tree key 1 value is not correct', iterator.Value = 20);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateValues -> ' +
    'Tree key 2 is not correct', iterator.Key = 2);
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateValues -> ' +
    'Tree key 2 value is not correct', iterator.Value = 40);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateValues -> ' +
    'Tree key 5 is not correct', iterator.Key = 5);
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateValues -> ' +
    'Tree key 5 value is not correct', iterator.Value = 100);

  iterator := iterator.Next;
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateValues -> ' +
    'Tree iterator is not correct', iterator.Key = 0);

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_StringIntegerAvlTree_IterateValues;
var
  tree : TStrIntTree;
  iterator : TStrIntTree.TIterator;
begin
  tree := TStrIntTree.Create;

  tree.Insert('test1', 20);
  tree.Insert('test2', 40);
  tree.Insert('test5', 100);

  iterator := tree.FirstEntry;
  AssertTrue('#Test_StringIntegerAvlTree_IterateValues -> ' +
    'Tree key test1 is not correct', iterator.Key = 'test1');
  AssertTrue('#Test_StringIntegerAvlTree_IterateValues -> ' +
    'Tree key test1 value is not correct', iterator.Value = 20);

  iterator := iterator.Next;
  AssertTrue('#Test_StringIntegerAvlTree_IterateValues -> ' +
    'Tree key test2 is not correct', iterator.Key = 'test2');
  AssertTrue('#Test_StringIntegerAvlTree_IterateValues -> ' +
    'Tree key test2 value is not correct', iterator.Value = 40);

  iterator := iterator.Next;
  AssertTrue('#Test_StringIntegerAvlTree_IterateValues -> ' +
    'Tree key test5 is not correct', iterator.Key = 'test5');
  AssertTrue('#Test_StringIntegerAvlTree_IterateValues -> ' +
    'Tree key test5 value is not correct', iterator.Value = 100);

  iterator := iterator.Next;
  AssertTrue('#Test_StringIntegerAvlTree_IterateValues -> ' +
    'Tree iterator is not correct', iterator.Key = '');

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_IntegerIntegerAvlTree_IterateRange;
var
  tree : TIntIntTree;
  counter : Cardinal;
  value : TIntIntTree.TIterator.TAvlKeyValuePair;
begin
  tree := TIntIntTree.Create;

  tree.Insert(1, 20);
  tree.Insert(2, 40);
  tree.Insert(5, 100);

  counter := 0;
  for value in tree do
  begin
    AssertTrue('#Test_IntegerIntegerAvlTree_IterateRange -> ' +
      'Tree key' + IntToStr(value.First) + ' value not correct',
      tree.Search(value.First){$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} =
      value.Second);
    Inc(counter);
  end;
  AssertTrue('#Test_IntegerIntegerAvlTree_IterateRange -> ' +
    'Tree iterate through not all elements', counter = 3);

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.Test_StringIntegerAvlTree_IterateRange;
var
  tree : TStrIntTree;
  counter : Cardinal;
  value : TStrIntTree.TIterator.TAvlKeyValuePair;
begin
  tree := TStrIntTree.Create;

  tree.Insert('test1', 20);
  tree.Insert('test2', 40);
  tree.Insert('test5', 100);

  counter := 0;
  for value in tree do
  begin
    AssertTrue('#Test_StringIntegerAvlTree_IterateRange -> ' +
      'Tree key' + value.First + ' value not correct',
      tree.Search(value.First){$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} =
      value.Second);
    Inc(counter);
  end;
  AssertTrue('#Test_StringIntegerAvlTree_IterateRange -> ' +
    'Tree iterate through not all elements', counter = 3);

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase
  .Test_IntegerIntegerAvlTree_InsertOneMillionValuesInto;
var
  tree : TIntIntTree;
  index : Integer;
begin
  tree := TIntIntTree.Create;

  for index := 0 to 1000000 do
  begin
    tree.Insert(index, index * 10 + 3);
  end;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntegerIntegerAvlTree_InsertOneMillionValuesInto -> ' +
      'Tree value index ' + IntToStr(index) + ' value is not correct',
      tree.Search(index){$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = index * 10 + 3);
  end;

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase
  .Test_StringIntegerAvlTree_InsertOneMillionValuesInto;
var
  tree : TStrIntTree;
  index : Integer;
begin
  tree := TStrIntTree.Create;

  for index := 0 to 1000000 do
  begin
    tree.Insert('test' + IntToStr(index), index * 10 + 3);
  end;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_StringIntegerAvlTree_InsertOneMillionValuesInto -> ' +
      'Tree value test' + IntToStr(index) + ' value is not correct',
      tree.Search('test' + IntToStr(index)){$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF}
      = index * 10 + 3);
  end;

  FreeAndNil(tree);
end;

initialization
  RegisterTest(TAvlTreeTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

