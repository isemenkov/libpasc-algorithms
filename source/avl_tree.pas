(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(*       object pascal library of common data structures and algorithms       *)
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

unit avl_tree;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils;

type
  { The AVL tree structure is a balanced binary tree which stores a collection 
    of nodes. Each node has a key and a value associated with it. The nodes are 
    sorted within the tree based on the order of their keys. Modifications to 
    the tree are constructed such that the tree remains balanced at all times 
    (there are always roughly equal numbers of nodes on either side of the 
    tree).

    Balanced binary trees have several uses. They can be used as a mapping 
    (searching for a value based on its key), or as a set of keys which is 
    always ordered. }
  generic AvlTree<K, V> = class
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
    function Search (Key : K) : V;

    
  end;


implementation

end.