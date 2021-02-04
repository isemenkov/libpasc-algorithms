(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(* delphi and object pascal library of  common data structures and algorithms *)
(*                 https://github.com/fragglet/c-algorithms                   *)
(*                                                                            *)
(* Copyright (c) 2020 - 2021                                Ivan Semenkov     *)
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

unit container.avltree;

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

  { The AVL tree structure is a balanced binary tree which stores a collection 
    of nodes. Each node has a key and a value associated with it. The nodes are 
    sorted within the tree based on the order of their keys. Modifications to 
    the tree are constructed such that the tree remains balanced at all times 
    (there are always roughly equal numbers of nodes on either side of the 
    tree).

    Balanced binary trees have several uses. They can be used as a mapping 
    (searching for a value based on its key), or as a set of keys which is 
    always ordered. }
  {$IFDEF FPC}generic{$ENDIF} TAvlTree<K; V; KeyBinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<K, 
    Integer>{$ENDIF}> = class
  protected
    type
      TAvlTreeNodeSide = (
        AVL_TREE_NODE_LEFT                                               = 0,
        AVL_TREE_NODE_RIGHT                                              = 1
      );

      PPAvlTreeNode = ^PAvlTreeNode;
      PAvlTreeNode = ^TAvlTreeNode;
      TAvlTreeNode = record
        children : array [0 .. 1] of PAvlTreeNode;
        parent : PAvlTreeNode;
        key : K;
        value : V;
        height : Integer;
      end;

      PAvlTreeStruct = ^TAvlTreeStruct;
      TAvlTreeStruct = record
        root_node : PAvlTreeNode;
        num_nodes : Cardinal;
      end;
  public 
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<V>;
      {$ENDIF}  

      TAvlKeyValuePair = {$IFDEF FPC}specialize{$ENDIF} TPair<K, V>;
      TAvlKeyValuePairArray = array of TAvlKeyValuePair;

      { TAvlTree iterator }
      TIterator = class;
      TIterator = class ({$IFDEF FPC}specialize{$ENDIF}
        TBidirectionalIterator<TAvlKeyValuePair, TIterator>)
      protected
        { Create new iterator for avltable item entry. }
        {%H-}constructor Create (AItems : PAvlTreeStruct); overload;
        {%H-}constructor Create (var AItems : TAvlKeyValuePairArray;
          ANumItems : Cardinal; AIndex : Cardinal); overload;
      
        { Convert the AVL tree into a array. }
        procedure TreeToArrayAddSubtree (subtree : PAvlTreeNode; index : 
          PInteger);

        { Return current item iterator and move it to next. }
        function GetCurrent : TAvlKeyValuePair;
          {$IFNDEF USE_OPTIONAL}override;{$ELSE}reintroduce;{$ENDIF}

        { Get item key. }
        function GetKey : K;

        { Get item value. }
        function GetValue : V; reintroduce;
      public
        destructor Destroy; override;

        { Return true if iterator has correct value. }
        function HasValue : Boolean; override;

        { Retrieve the previous entry in a avltree. }
        function Prev : TIterator; override;

        { Retrieve the next entry in a avltree. }
        function Next : TIterator; override;

        { Return True if we can move to next element. }
        function MoveNext : Boolean; override;

        { Return enumerator for in operator. }
        function GetEnumerator : TIterator; override;

        { Return key value. }
        property Key : K read GetKey;

        { Return value. }
        property Value : V read GetValue;

        property Current : TAvlKeyValuePair read GetCurrent;
      protected
        var
          FItems : TAvlKeyValuePairArray;
          FNumItems : Cardinal;
          FCurrIndex : Cardinal;
      end;
  public
    { Create a new AVL tree. }
    constructor Create;

    { Destroy an AVL tree. }
    destructor Destroy; override;

    { Insert a new key-value pair into an AVL tree. }
    procedure Insert (Key : K; Value : V);

    { Remove an entry from a tree, specifying the key of the node to remove. 
      Return false if no node with the specified key was found in the tree, true
      if a node with the specified key was removed. }
    function Remove (Key : K) : Boolean;

    { Search an AVL tree for a value corresponding to a particular key. This 
      uses the tree as a mapping. }
    function Search (Key : K) : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue
      {$ENDIF};
    
    { Search an AVL tree for a value corresponding to a particular key. 
      Return default value if Key not exists. }
    function SearchDefault (Key : K; ADefault : V) : V;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrieve the number of entries in the tree. }
    function NumEntries : Cardinal;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return true if container is empty. }
    function IsEmpty : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrive the first entry in avltree. }
    function FirstEntry : TIterator; 
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    { Compare two nodes. }
    function CompareAvlTreeNode (A, B : PAvlTreeNode) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Free node. }
    procedure FreeSubTreeNode (node : PAvlTreeNode);

    { Remove a node from a tree. }
    procedure RemoveNode (node : PAvlTreeNode);

    { Search an AVL tree for a node with a particular key.  This uses the tree 
      as a mapping. }
    function SearchNode (key : K) : PAvlTreeNode;

    { Find the root node of a tree. }
    function RootNode : PAvlTreeNode;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrieve the key for a given tree node. }
    function NodeKey (node : PAvlTreeNode) : K;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrieve the value at a given tree node. }
    function NodeValue (node : PAvlTreeNode) : V;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Find the child of a given tree node. }
    function NodeChild (node : PAvlTreeNode; side : TAvlTreeNodeSide) : 
      PAvlTreeNode;
      {$IFNDEF DEBUG}inline;{$ENDIF}
    
    { Find the parent node of a given tree node. }
    function NodeParent (node : PAvlTreeNode) : PAvlTreeNode;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Find the height of a subtree. }
    function SubTreeHeight (node : PAvlTreeNode) : Integer;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  
    { Update the "height" variable of a node, from the heights of its children. 
      This does not update the height variable of any parent nodes. }
    procedure UpdateTreeHeight (node : PAvlTreeNode);

    { Find what side a node is relative to its parent. }
    function TreeNodeParentSide (node : PAvlTreeNode) : TAvlTreeNodeSide;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Replace node1 with node2 at its parent. }
    procedure TreeNodeReplace (node1 : PAvlTreeNode; node2 : PAvlTreeNode);
      {$IFNDEF DEBUG}inline;{$ENDIF}

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
         A   C                           C   E                                 }
    function TreeRotate (node : PAvlTreeNode; direction : TAVLTreeNodeSide) :
      PAvlTreeNode;

    { Balance a particular tree node. 

      Returns the root node of the new subtree which is replacing the old one. }
    function TreeNodeBalance (node : PAvlTreeNode) : PAvlTreeNode;

    { Walk up the tree from the given node, performing any needed rotations. }
    procedure TreeBalanceToRoot (node : PAvlTreeNode);

    { Find the nearest node to the given node, to replace it. The node returned 
      is unlinked from the tree. Returns NULL if the node has no children. }
    function TreeNodeGetReplacement (node : PAvlTreeNode) : PAvlTreeNode;
  protected
    FTree : PAvlTreeStruct;
    FCompareFunctor : KeyBinaryCompareFunctor;  
  end;

implementation

{ TAvlTree.TIterator }

constructor TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.Create (AItems : PAvlTreeStruct);
var
  Index : Integer;
begin
  FNumItems := AItems^.num_nodes;
  FCurrIndex := 0;

  index := 0;
  SetLength(FItems, AItems^.num_nodes);

  { Add all keys }
  TreeToArrayAddSubtree(AItems^.root_node, @index);
end;

constructor TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.Create (var AItems : TAvlKeyValuePairArray; ANumItems : Cardinal; 
  AIndex : Cardinal);
begin
  FItems := AItems;
  FNumItems := ANumItems;
  FCurrIndex := AIndex;
end;

destructor TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.Destroy;
begin
  SetLength(FItems, 0);
  inherited Destroy;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.HasValue : Boolean;
begin
  if FCurrIndex >= FNumItems then
  begin
    Exit(False);
  end;

  Result := True;
end;

procedure TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.TreeToArrayAddSubtree (subtree : PAvlTreeNode; index : PInteger);
begin
  if subtree = nil then
  begin
    Exit;
  end;

  { Add left subtree first }
  TreeToArrayAddSubtree(subtree^.children[Shortint(AVL_TREE_NODE_LEFT)], index);

  { Add this node }
  FItems[index^] := TAvlKeyValuePair.Create(subtree^.Key,
    subtree^.Value);
  Inc(index^);

  { Finally add right subtree }
  TreeToArrayAddSubtree(subtree^.children[Shortint(AVL_TREE_NODE_RIGHT)], 
    index);
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetCurrent : TAvlKeyValuePair;
begin
  if FCurrIndex < FNumItems then
  begin
    Result := FItems[FCurrIndex];
    Inc(FCurrIndex);
  end else
  begin
    Result := TAvlKeyValuePair.Create;
  end;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetKey : K;
begin
  if FCurrIndex < FNumItems then
  begin
    Result := FItems[FCurrIndex].First;
  end else
  begin
    Result := Default(K);
  end;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetValue : V;
begin
  if FCurrIndex < FNumItems then
  begin
    Result := FItems[FCurrIndex].Second;
  end else
  begin
    Result := Default(V);
  end;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.Prev : TIterator;
begin
  if FCurrIndex = 0 then
  begin
    Result := TIterator.Create(FItems, FNumItems, 0);
  end else
  begin
    Result := TIterator.Create(FItems, FNumItems, FCurrIndex - 1);
  end;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.Next : TIterator;
begin
  Result := TIterator.Create(FItems, FNumItems, FCurrIndex + 1);
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.MoveNext : Boolean;
begin
  Result := FCurrIndex < FNumItems;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FItems, FNumItems, 0);
end;

{ TAvlTree }

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .CompareAvlTreeNode (A, B : PAvlTreeNode) : Boolean;
begin
  Result := (A^.children[0] = B^.children[0]) and
            (A^.children[1] = B^.children[1]) and
            (A^.parent = B^.parent) and
            (FCompareFunctor.Call(A^.key, B^.key) = 0) and
            {$IFDEF FPC}
            (A^.value = B^.value) and
            {$ELSE}
            (TComparer<V>.Default.Compare(A^.Value, B^.Value) = 1) and
            {$ENDIF}
            (A^.height = B^.height);
end;

constructor TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}.Create;
begin
  New(FTree);
  FTree^.root_node := nil;
  FTree^.num_nodes := 0;
  FCompareFunctor := KeyBinaryCompareFunctor.Create;
end;

procedure TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .FreeSubTreeNode (node : PAvlTreeNode);
begin
  if node <> nil then
  begin
    FreeSubtreeNode(node^.children[Shortint(AVL_TREE_NODE_LEFT)]);
    FreeSubtreeNode(node^.children[Shortint(AVL_TREE_NODE_RIGHT)]);

    Dispose(node);
    node := nil;
  end;
end;

destructor TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Destroy;
begin
  { Destroy all nodes }
  FreeSubtreeNode(FTree^.root_node);
  { Free back the main tree data structure }
  Dispose(FTree);
  FTree := nil;

  inherited Destroy;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .SubTreeHeight (node : PAvlTreeNode) : Integer;
begin
  if node <> nil then
  begin
    Result := node^.height;
  end else
  begin
    Result := 0;
  end;
end;

procedure TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .UpdateTreeHeight (node : PAvlTreeNode);
var
  left_subtree : PAvlTreeNode;
  right_subtree : PAvlTreeNode;
  left_height, right_height : Integer;
begin
  left_subtree := node^.children[Shortint(AVL_TREE_NODE_LEFT)];
  right_subtree := node^.children[Shortint(AVL_TREE_NODE_RIGHT)];
  left_height := SubTreeHeight(left_subtree);
  right_height := SubTreeHeight(right_subtree);

  if left_height > right_height then
  begin
    node^.height := left_height + 1;
  end else 
  begin
    node^.height := right_height + 1;
  end;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeParentSide (node : PAvlTreeNode) : TAvlTreeNodeSide;
begin
  if node^.parent^.children[Shortint(AVL_TREE_NODE_LEFT)] = node then
  begin
    Result := AVL_TREE_NODE_LEFT;
  end else
  begin
    Result := AVL_TREE_NODE_RIGHT;
  end;
end;

procedure TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeReplace (node1 : PAvlTreeNode; node2 : PAvlTreeNode);
var
  side : Integer;
begin
  { Set the node's parent pointer. }
  if node2 <> nil then
  begin
    node2^.parent := node1^.parent;
  end;

  { The root node? }
  if node1^.parent = nil then
  begin
    FTree^.root_node := node2;
  end else begin
    side := Integer(Ord(TreeNodeParentSide(node1)));
    node1^.parent^.children[side] := node2;
    UpdateTreeHeight(node1^.parent);
  end;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeRotate (node : PAvlTreeNode; direction : TAVLTreeNodeSide) 
  : PAvlTreeNode;
var
  new_root : PAvlTreeNode;
begin
  { The child of this node will take its place:
	  for a left rotation, it is the right child, and vice versa. }
  new_root := node^.children[1 - Shortint(direction)];

  { Make new_root the root, update parent pointers. }
  TreeNodeReplace(node, new_root);

  { Rearrange pointers }
  node^.children[1 - Shortint(direction)] :=
    new_root^.children[Shortint(direction)];
  new_root^.children[Shortint(direction)] := node;

  { Update parent references }
  node^.parent := new_root;

  if node^.children[1 - Shortint(direction)] <> nil then
  begin
    node^.children[1 - Shortint(direction)]^.parent := node;
  end;

  { Update heights of the affected nodes }
  UpdateTreeHeight(new_root);
  UpdateTreeHeight(node);

  Result := new_root;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeBalance (node : PAvlTreeNode) : PAvlTreeNode;
var
  left_subtree : PAvlTreeNode;
  right_subtree : PAvlTreeNode;
  child : PAvlTreeNode;
  diff : Integer;
begin
  left_subtree := node^.children[Shortint(AVL_TREE_NODE_LEFT)];
  right_subtree := node^.children[Shortint(AVL_TREE_NODE_RIGHT)];

  { Check the heights of the child trees. If there is an unbalance (difference 
    between left and right > 2), then rotate nodes around to fix it. }
  diff := SubTreeHeight(right_subtree) - SubTreeHeight(left_subtree);

  if diff >= 2 then
  begin
    { Biased toward the right side too much. }
    child := right_subtree;

    if SubTreeHeight(child^.children[Shortint(AVL_TREE_NODE_RIGHT)]) <
       SubTreeHeight(child^.children[Shortint(AVL_TREE_NODE_LEFT)]) then
    begin
      { If the right child is biased toward the left side, it must be rotated 
        right first (double rotation). }
      TreeRotate(right_subtree, AVL_TREE_NODE_RIGHT);
    end;  

    { Perform a left rotation. After this, the right child will take the place 
      of this node. Update the node pointer. }
    node := TreeRotate(node, AVL_TREE_NODE_LEFT);
  end else if diff <= -2 then
  begin
    { Biased toward the left side too much. }
    child := node^.children[Shortint(AVL_TREE_NODE_LEFT)];

    if SubTreeHeight(child^.children[Shortint(AVL_TREE_NODE_LEFT)]) <
       SubTreeHeight(child^.children[Shortint(AVL_TREE_NODE_RIGHT)]) then
    begin
      { If the left child is biased toward the right side, it must be rotated 
        right left (double rotation). }
      TreeRotate(left_subtree, AVL_TREE_NODE_LEFT);
    end; 

    { Perform a right rotation. After this, the left child will take the place 
      of this node. Update the node pointer. }
    node := TreeRotate(node, AVL_TREE_NODE_RIGHT);
  end;

  { Update the height of this node. }
  UpdateTreeHeight(node);
  Result := node;
end;

procedure TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeBalanceToRoot (node : PAvlTreeNode);
var
  rover : PAvlTreeNode;
begin
  rover := node;
  while rover <> nil do
  begin
    { Balance this node if necessary. }
    rover := TreeNodeBalance(rover);  

    { Go to this node's parent. }
    rover := rover^.parent;
  end;
end;

procedure TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Insert (Key : K; Value : V);
var
  rover : PPAvlTreeNode;
  new_node : PAvlTreeNode;
  previous_node : PAvlTreeNode;
begin
  { Walk down the tree until we reach a NULL pointer. }
  rover := @(FTree^.root_node);
  previous_node := nil;

  while rover^ <> nil do
  begin
    previous_node := rover^;
    if FCompareFunctor.Call(Key, (rover^)^.key) < 0 then
    begin
      rover := @((rover^)^.children[Shortint(AVL_TREE_NODE_LEFT)]);
    end else
    begin
      rover := @((rover^)^.children[Shortint(AVL_TREE_NODE_RIGHT)]);
    end;
  end;

  { Create a new node. Use the last node visited as the parent link. }
  New(new_node);
  new_node^.children[Shortint(AVL_TREE_NODE_LEFT)] := nil;
  new_node^.children[Shortint(AVL_TREE_NODE_RIGHT)] := nil;
  new_node^.parent := previous_node;
  new_node^.key := Key;
  new_node^.value := Value;
  new_node^.height := 1;

  { Insert at the NULL pointer that was reached. }
  rover^ := new_node;

  { Rebalance the tree, starting from the previous node. }
  TreeBalanceToRoot(previous_node);

  { Keep track of the number of entries. }
  Inc(FTree^.num_nodes);
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TreeNodeGetReplacement (node : PAvlTreeNode) : PAvlTreeNode;
var
  left_subtree : PAvlTreeNode;
  right_subtree : PAvlTreeNode;
  res : PAvlTreeNode;
  child : PAvlTreeNode;
  left_height, right_height : Integer;
  side : Integer;
begin
  left_subtree := node^.children[Shortint(AVL_TREE_NODE_LEFT)];
  right_subtree := node^.children[Shortint(AVL_TREE_NODE_RIGHT)];

  { No children? }
  if (left_subtree = nil) and (right_subtree = nil) then
  begin
    Result := nil;
    Exit;
  end;

  { Pick a node from whichever subtree is taller. This helps to keep the tree 
    balanced. }
  left_height := SubTreeHeight(left_subtree);
  right_height := SubTreeHeight(right_subtree);

  if left_height < right_height then
  begin
    side := Shortint(AVL_TREE_NODE_RIGHT);
  end else
  begin
    side := Shortint(AVL_TREE_NODE_LEFT);
  end;

  { Search down the tree, back towards the center. }
  res := node^.children[side];

  while res^.children[1 - side] <> nil do
  begin
    res := res^.children[1 - side];
  end;

  { Unlink the result node, and hook in its remaining child (if it has one) to 
    replace it. }
  child := res^.children[side];
  TreeNodeReplace(res, child);

  { Update the subtree height for the result node's old parent. }
  UpdateTreeHeight(res^.parent);

  Result := res;
end;

procedure TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .RemoveNode (node : PAvlTreeNode);
var
  swap_node : PAvlTreeNode;
  balance_startpoint : PAvlTreeNode;
  i : Integer;
begin
  { The node to be removed must be swapped with an "adjacent" node, ie. one 
    which has the closest key to this one. Find a node to swap with. }
  swap_node := TreeNodeGetReplacement(node);

  if swap_node = nil then
  begin
    { This is a leaf node and has no children, therefore it can be immediately 
      removed. }

    { Unlink this node from its parent. }
    TreeNodeReplace(node, nil);

    { Start rebalancing from the parent of the original node. }
    balance_startpoint := node^.parent;
  end else
  begin
    { We will start rebalancing from the old parent of the swap node. Sometimes,
      the old parent is the node we are removing, in which case we must start 
      rebalancing from the swap node. }
    if swap_node = node then
    begin
      balance_startpoint := swap_node;
    end else
    begin
      balance_startpoint := swap_node^.parent;
    end;

    { Copy references in the node into the swap node. }
    for i := 0 to 1 do
    begin
      swap_node^.children[i] := node^.children[i];

      if swap_node^.children[i] <> nil then
      begin
        swap_node^.children[i]^.parent := swap_node;
      end;
    end;

    swap_node^.height := node^.height;

    { Link the parent's reference to this node. }
    TreeNodeReplace(node, swap_node);
  end;

  { Destroy the node }
  Dispose(node);
  node := nil;

  { Keep track of the number of nodes }
  Dec(FTree^.num_nodes);

  { Rebalance the tree }
  TreeBalanceToRoot(balance_startpoint);
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Remove(Key : K) : Boolean;
var
  node : PAvlTreeNode;
begin
  { Find the node to remove }
  node := SearchNode(Key);

  if node = nil then
  begin
    { Not found in tree }
    Result := False;
    Exit;
  end;

  { Remove the node }
  RemoveNode(node);
  Result := True;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .SearchNode (Key : K) : PAvlTreeNode;
var
  node : PAvlTreeNode;
  diff : Integer;
begin
  { Search down the tree and attempt to find the node which has the specified 
    key }
  node := FTree^.root_node;

  while node <> nil do
  begin
    diff := FCompareFunctor.Call(Key, node^.key);
    if diff = 0 then
    begin
      { Keys are equal: return this node }
      Result := node;
      Exit;
    end else if diff < 0 then
    begin
      node := node^.children[Shortint(AVL_TREE_NODE_LEFT)];
    end else
    begin
      node := node^.children[Shortint(AVL_TREE_NODE_RIGHT)];
    end;
  end; 

  { Not found }
  Result := nil; 
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Search (Key : K) : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};
var
  node : PAvlTreeNode;
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
  end;
    
  Result := {$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}node^.value
    {$IFDEF USE_OPTIONAL}){$ENDIF};
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .SearchDefault (Key : K; ADefault : V) : V;
var
  node : PAvlTreeNode;
begin
  { Find the node }
  node := SearchNode(Key);

  if node = nil then
  begin
    Exit(ADefault);
  end;

  Result := {$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}node^.value
    {$IFDEF USE_OPTIONAL}){$ENDIF};
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .RootNode : PAvlTreeNode;
begin
  Result := FTree^.root_node;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .NodeKey (node : PAvlTreeNode) : K;
begin
  Result := node^.key;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .NodeValue (node : PAvlTreeNode) : V;
begin
  Result := node^.value;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .NodeChild (node : PAvlTreeNode; side : TAvlTreeNodeSide) : PAvlTreeNode;
begin
  if (side = AVL_TREE_NODE_LEFT) or (side = AVL_TREE_NODE_RIGHT) then
  begin
    Result := node^.children[Shortint(side)];
  end else
  begin
    Result := nil;
  end;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .NodeParent (node : PAvlTreeNode) : PAvlTreeNode;
begin
  Result := node^.parent;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .NumEntries : Cardinal;
begin
  Result := FTree^.num_nodes;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .FirstEntry : TIterator;
begin
  Result := TIterator.Create(FTree);
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .GetEnumerator : TIterator;
begin
  Result := FirstEntry;
end;

function TAvlTree{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .IsEmpty : Boolean;
begin
  Result := (NumEntries = 0);
end;

end.
