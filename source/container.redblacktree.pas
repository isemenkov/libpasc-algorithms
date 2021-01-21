(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(* delphi and object pascal library of  common data structures and algorithms *)
(*                 https://github.com/fragglet/c-algorithms                   *)
(*                                                                            *)
(* Copyright (c) 2021                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpasc-algorithms          ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)

unit container.redblacktree;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, utils.pair, utils.enumerate
  {$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF}
  {$IFNDEF FPC}, utils.functor, System.Generics.Defaults{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { Item key value not exists. }
  EKeyNotExistsException = class(Exception);
  {$ENDIF}

  { The red-black tree structure is a balanced binary tree which stores a 
    collection of nodes. Each node has a key and a value associated with it.  
    The nodes are sorted within the tree based on the order of their keys. 
    Modifications to the tree are constructed such that the tree remains
    balanced at all times (there are always roughly equal numbers of nodes on 
    either side of the tree).
 
    Balanced binary trees have several uses. They can be used as a mapping 
    (searching for a value based on its key), or as a set of keys which is 
    always ordered. }
  {$IFDEF FPC}generic{$ENDIF} TRedBlackTree<K; V; KeyBinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<K, 
    Integer>{$ENDIF}> = class
  protected
    type
      { Each node in a red-black tree is either red or black. }
      TRedBlackNodeColor = (
        RB_TREE_NODE_RED                                                 = 0,
        RB_TREE_NODE_BLACK                                               = 1
      );

      { A RedBlackNode can have left and right children. }
      TRedBlackNodeSide = (
        RB_TREE_NODE_LEFT                                                = 0,
        RB_TREE_NODE_RIGHT                                               = 1
      );

      PPRedBlackNode = ^PRedBlackNode;
      PRedBlackNode = ^TRedBlackNode;
      TRedBlackNode = record
        color : TRedBlackNodeColor;
        key : K;
        value : V;
        parent : PRedBlackNode;
        children : array [0 .. 1] of PRedBlackNode;
      end;

      PRedBlackTreeStruct = ^TRedBlackTreeStruct;
      TRedBlackStruct = record
        root_node : PRedBlackNode;
        num_nodes : Cardinal;
      end;
  public
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<V>;
      {$ENDIF} 
  public
    constructor Create;
    destructor Destroy; override;

    { Insert a new key-value pair into a red-black tree. }
    procedure Insert (AKey : K; AValue : V);

    { Search a red-black tree for a value corresponding to a particular key. 
      This uses the tree as a mapping. }
    function Search (Key : K) : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue
      {$ENDIF};
  protected
    function TreeNodeSide (node : PRedBlackNode) : TRedBlackNodeSide;

    function TreeNodeSibling (node : PRedBlackNode) : PRedBlackNode;

    function TreeNodeUncle (node : PRedBlackNode) : PRedBlackNode;

    { Replace node1 with node2 at its parent. } 
    procedure TreeNodeReplace (node1, node2 : PRedBlackNode);

    { Rotate a section of the tree. 'node' is the node at the top of the section 
      to be rotated. 'direction' is the direction in which to rotate the tree: 
      left or right, as shown in the following diagram:
 
      Left rotation:              Right rotation:
 
          B                             D
         / \                           / \
        A   D                         B   E
           / \                       / \
          C   E                     A   C
        is rotated to:              is rotated to:
  
            D                           B
           / \                         / \
          B   E                       A   D
         / \                             / \
        A   C                           C   E                                  }
    function TreeRotate (node : PRedBlackNode; direction : TRedBlackNodeSide) :
      PRedBlackNode;

    procedure TreeFreeSubTree (node : PRedBlackNode);

    { Insert case 1: If the new node is at the root of the tree, it must be 
      recolored black, as the root is always black. }
    procedure TreeInsertCase1 (node : PRedBlackNode);

    { Insert case 2: If the parent of the new node is red, this conflicts with 
      the red-black tree conditions, as both children of every red node are 
      black. }
    procedure TreeInsertCase2 (node : PRedBlackNode);
    
    { Insert case 3: If the parent and uncle are both red, repaint them both 
      black and repaint the grandparent red. }
    procedure TreeInsertCase3 (node : PRedBlackNode);

    { Case 4: If the parent is red, but the uncle is black, we need to do some 
      rotations to keep the tree balanced and complying with the tree 
      conditions.  If the node is on the opposite side relative to its parent
      as the parent is relative to its grandparent, rotate around the parent.  
      Either way, we will continue to case 5.
 
      eg.
 
           B                              B
          / \                            / \
         R   B          ->     node ->  R   B
          \                            /
           R  <- node                 R                                        }
    procedure TreeInsertCase4 (node : PRedBlackNode);

    { Case 5: The node is on the same side relative to its parent as the parent 
      is relative to its grandparent. The node and its parent are red, but the 
      uncle is black.
 
      Now, rotate at the grandparent and recolor the parent and grandparent to 
      black and red respectively.
 
                 G/B                 P/B
                /   \               /   \
             P/R     U/B    ->   N/R     G/R
            /   \                       /   \
         N/R      ?                   ?      U/B                               }
    procedure TreeInsertCase5 (node : PRedBlackNode);

    { Search a red-black tree for a node with a particular key. This uses the 
      tree as a mapping. }
    function SearchNode (key : K) : PRedBlackNode;
  protected
    FTree : PRedBlackTreeStruct;
    FCompareFunctor : KeyBinaryCompareFunctor;
  end;

implementation

{ TReadBlackTree }

constructor TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Create;
begin
  New(FTree);
  FTree^.root_node := nil;
  FTree^.num_nodes := 0;
  FCompareFunctor := KeyBinaryCompareFunctor.Create;
end;

destructor TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Destroy;
begin
  { Free all nodes in the tree. }
  TreeFreeSubTree(FTree^.root_node);

  { Free back the main tree structure. }
  Dispose(FTree);
end;

function TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeSide (node : PRedBlackNode) : TRedBlackNodeSide;
begin
  if node^.parent^.children[RB_TREE_NODE_LEFT] = node then
    Exit(RB_TREE_NODE_LEFT)
  else
    Exit(RB_TREE_NODE_RIGHT);
end;

function TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeSibling (node : PRedBlackNode) : PRedBlackNode;
var
  side : TRedBlackNodeSide;
begin
  side := TreeNodeSide(node);
  Result := node^.parent^.children[1 - side];
end;

function TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeUncle (node : PRedBlackNode) : PRedBlackNode;
begin
  Result := TreeNodeSibling(node^.parent);
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeReplace (node1, node2 : PRedBlackNode);
var
  side : TRedBlackNodeSide;
begin
  { Set the node's parent pointer. }
  if node2 <> nil then
    node2^.parent := node1^.parent;

  { The root node? }
  if node1^.parent = nil then
  begin
    FTree^.root_node := node2;
  end else
  begin
    side := TreeNodeSide(node1);
    node1^.parent^.children[side] := node2;
  end;
end;

function TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeRotate (node : PRedBlackNode; direction : TRedBlackNodeSide) :
  PRedBlackNode;
var
  new_root : PRedBlackNode;
begin
  { The child of this node will take its place:
	  for a left rotation, it is the right child, and vice versa. }
  new_root := node^.children[1 - direction];

  { Make new_root the root, update parent pointers. }
  TreeNodeReplace(node, new_root);

  { Rearrange pointers. }
  node^.children[1 - direction] := new_root^.children[direction];
  new_root^.children[direction] := node;

  { Update parent references. }
  node^.parent := new_root;

  if node^.children[1 - direction] <> nil then
    node^.children[1 - direction]^.parent := node;

  Result := new_root;
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeFreeSubTree (node : PRedBlackNode);
begin
  if node <> nil then
  begin
    { Recurse to subnodes. }
    TreeFreeSubTree(node^.children[RB_TREE_NODE_LEFT]);
    TreeFreeSubTree(node^.children[RB_TREE_NODE_RIGHT]);

    { Free this node. }
    Dispose(node);
  end;
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeInsertCase1 (node : PRedBlackNode);
begin
  if node^.parent = nil then
  begin
    { The root node is black. }
    node^.color := RB_TREE_NODE_BLACK;
  end else
  begin
    { Not root. }
    TreeInsertCase2(node);
  end;
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeInsertCase2 (node : PRedBlackNode);
begin
  { Note that if this function is being called, we already know the node has a 
    parent, as it is not the root node. }
  if node^.parent^.color <> RB_TREE_NODE_BLACK then
    TreeInsertCase3(node);
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeInsertCase3 (node : PRedBlackNode);
var
  grandparent, uncle : PRedBlackNode;
begin
  { Note that the node must have a grandparent, as the parent is red, and the 
    root node is always black. }
  grandparent := node^.parent^.parent;
  uncle := TreeNodeUncle(node);

  if (uncle <> nil) and (uncle^.color = RB_TREE_NODE_RED) then
  begin
    node^.parent^.color := RB_TREE_NODE_BLACK;
    uncle^.color := RB_TREE_NODE_BLACK;
    grandparent^.color := RB_TREE_NODE_RED;

    { Recurse to grandparent. }
    TreeInsertCase1(grandparent);
  end else
  begin
    TreeInsertCase4(node);
  end;
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeInsertCase4 (node : PRedBlackNode);
var
  next_node : PRedBlackNode;
  side : TRedBlackNodeSide;
begin
  { Note that at this point, by implication from case 3, we know that the parent 
    is red, but the uncle is black. We therefore only need to examine what side 
    the node is on relative to its parent, and the side the parent is on 
    relative to the grandparent. }
  side := TreeNodeSide(node);

  if side <> TreeNodeSide(node^.parent) then
  begin
    { After the rotation, we will continue to case 5, but the parent node will 
      be at the bottom. }
    next_node := node^.parent;

    { Rotate around the parent in the opposite direction to side. }
    TreeRotate(node^.parent, 1 - side);
  end else
  begin
    next_node := node;
  end;

  TreeInsertCase5(next_node);
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeInsertCase5 (node : PRedBlackNode);
var
  parent, grandparent : PRedBlackNode;
  side : TRedBlackNodeSide;
begin
  parent := node^.parent;
  grandparent := parent^.parent;

  { What side are we, relative to the parent? This will determine the direction 
    that we rotate. }
  side := TreeNodeSide(node);

  { Rotate at the grandparent, in the opposite direction to side. }
  TreeRotate(grandparent, 1 - side);

  { Recolor the (old) parent and grandparent. }
  parent^.color := RB_TREE_NODE_BLACK;
  grandparent^.color := RB_TREE_NODE_RED;
end;

procedure TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Insert (AKey : K; AValue : V);
var
  node, parent : PRedBlackNode;
  rover : PPRedBlackNode;
  side : TRedBlackNodeSide;
begin
  { Allocate a new node. }
  New(node);

  { Set up structure. Initially, the node is red. }
  node^.key := Key;
  node^.value := Value;
  node^.color := RB_TREE_NODE_RED;
  node^.children[RB_TREE_NODE_LEFT] := nil;
  node^.children[RB_TREE_NODE_RIGHT] := nil;

  { First, perform a normal binary tree-style insert. }
  parent := nil;
  rover := @(FTree^.root_node);

  while (rover^ <> nil) do
  begin
    { Update parent. }
    parent := rover^;

    { Choose which path to go down, left or right child. }
    if FCompareFunctor.Call(AKey, (rover^)^.key) < 0 then
    begin
      side := RB_TREE_NODE_LEFT;
    end else
    begin
      side := RB_TREE_NODE_RIGHT;
    end;

    rover :=@((rover^))^.children[side];
  end;

  { Insert at the position we have reached. }
  rover^ := node;
  node^.parent := parent;

  { Possibly reorder the tree. }
  TreeInsertCase1(node);

  { Update the node count. }
  Inc(FTree^.num_nodes);
end;

function TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .SearchNode (key : K) : PRedBlackNode;
var
  node : PRedBlackNode;
  side : TRedBlackNodeSide;
  diff : Integer;
begin
  node := FTree^.root_node;
  
  { Search down the tree. }
  while node <> nil do
  begin
    diff := FCompareFunctor.Call(key, node^.key);

    if diff = 0 then
      Exit(node)
    else if diff < 0 then
      side := RB_TREE_NODE_LEFT
    else
      side := RB_TREE_NODE_RIGHT;

    node := node^.children[side];
  end;

  { Not found. }
  Result := nil;
end;

function TRedBlackTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Search (Key : K) : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};
var
  node : PRedBlackNode;
begin
  { Find the node }
  node := SearchNode(Key);

  if node = nil then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EKeyNotExistsException.Create('Key not exists.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end else
  begin
    Result := {$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}node^.value
      {$IFDEF USE_OPTIONAL}){$ENDIF};
  end;
end;



end.