(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(* delphi and object pascal library of  common data structures and algorithms *)
(*                 https://github.com/fragglet/c-algorithms                   *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
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
  protected
    FTree : PRedBlackTreeStruct;
    FCompareFunctor : KeyBinaryCompareFunctor;
  end;

implementation

{ TReadBlackTree }

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

end.