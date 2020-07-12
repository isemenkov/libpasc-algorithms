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

  AssertTrue('Tree value 1 is not correct', tree.Search(1) = 100);
  AssertTrue('Tree value 2 is not correct', tree.Search(2) = 200);

  FreeAndNil(tree);
end;

initialization

  RegisterTest(TAvlTreeTestCase);

end.

