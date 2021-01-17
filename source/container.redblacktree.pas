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
      TRedBlackNodeSize = (
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
    
  end;

implementation

end.