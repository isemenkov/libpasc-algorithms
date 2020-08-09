unit avltreetestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, container.avltree;

type
  TIntIntTree = specialize TAvlTree<Integer, Integer>;
  TStringIntTree = specialize TAvlTree<String, Integer>;

  TAvlTreeTestCase = class(TTestCase)
  published
    procedure TestIntIntTreeInsert;
    procedure TestIntIntTreeRemove;
    procedure TestStringIntTreeInsert;
    procedure TestStringIntTreeRemove;
    procedure TestIntIntTreeStoreOneMillionItems;
  end;

implementation

procedure TAvlTreeTestCase.TestIntIntTreeInsert;
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

  AssertTrue('Tree value 1 is not correct', tree.Search(1) = 100);
  AssertTrue('Tree value 2 is not correct', tree.Search(2) = 200);
  AssertTrue('Tree value 4 is not correct', tree.Search(4) = 400);
  AssertTrue('Tree value 10 is not correct', tree.Search(10) = 1000);
  AssertTrue('Tree value 12 is not correct', tree.Search(12) = 1200);
  AssertTrue('Tree value 132 is not correct', tree.Search(132) = 13200);

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.TestIntIntTreeRemove;
var
  tree : TIntIntTree;
begin
  tree := TIntIntTree.Create;

  tree.Insert(1, 20);
  tree.Insert(2, 40);
  tree.Insert(5, 100);

  AssertTrue('Tree value 1 is not correct', tree.Search(1) = 20);
  AssertTrue('Tree value 2 is not correct', tree.Search(2) = 40);
  AssertTrue('Tree value 5 is not correct', tree.Search(5) = 100);

  AssertTrue('Tree value 1 is not removed', tree.Remove(1));
  AssertTrue('Tree value 2 is not removed', tree.Remove(2));
  AssertTrue('Tree value 5 is not removed', tree.Remove(5));
  AssertTrue('Tree not exists value is removed', not tree.Remove(7));

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.TestStringIntTreeInsert;
var
  tree : TStringIntTree;
begin
  tree := TStringIntTree.Create;

  tree.Insert('test1', 1);
  tree.Insert('test2', 2);
  tree.Insert('test4', 4);
  tree.Insert('test10', 10);
  tree.Insert('test12', 12);
  tree.Insert('test132', 132);

  AssertTrue('Tree value test1 is not correct', tree.Search('test1') = 1);
  AssertTrue('Tree value test2 is not correct', tree.Search('test2') = 2);
  AssertTrue('Tree value test4 is not correct', tree.Search('test4') = 4);
  AssertTrue('Tree value test10 is not correct', tree.Search('test10') = 10);
  AssertTrue('Tree value test12 is not correct', tree.Search('test12') = 12);
  AssertTrue('Tree value test132 is not correct', tree.Search('test132') = 132);

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.TestStringIntTreeRemove;
var
  tree : TStringIntTree;
begin
  tree := TStringIntTree.Create;

  tree.Insert('test1', 1);
  tree.Insert('test2', 2);
  tree.Insert('test4', 4);

  AssertTrue('Tree value test1 is not correct', tree.Search('test1') = 1);
  AssertTrue('Tree value test2 is not correct', tree.Search('test2') = 2);
  AssertTrue('Tree value test4 is not correct', tree.Search('test4') = 4);

  AssertTrue('Tree value test1 is not removed', tree.Remove('test1'));
  AssertTrue('Tree value test2 is not removed', tree.Remove('test2'));
  AssertTrue('Tree value test4 is not removed', tree.Remove('test4'));
  AssertTrue('Tree not exists value is removed', not tree.Remove('test5'));

  FreeAndNil(tree);
end;

procedure TAvlTreeTestCase.TestIntIntTreeStoreOneMillionItems;
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
    AssertTrue('Tree value index ' + IntToStr(index) + ' value is not correct',
      tree.Search(index) = index * 10 + 3);
  end;

  FreeAndNil(tree);
end;

initialization

  RegisterTest(TAvlTreeTestCase);

end.

