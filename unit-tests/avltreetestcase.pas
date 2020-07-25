unit avltreetestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, avl_tree;

type
  TIntIntTree = specialize TAvlTree<Integer, Integer>;

  TAvlTreeTestCase = class(TTestCase)
  published
    procedure TestCreateTree;
  end;

implementation

procedure TAvlTreeTestCase.TestCreateTree;
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

initialization

  RegisterTest(TAvlTreeTestCase);

end.

