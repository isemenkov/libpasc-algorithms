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

unit container.sortedset;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils;

type
  { A set stores a collection of values.  Each value can only exist once in the 
    set. }
  generic TSortedSet<V, BinaryCompareFunctor> = class
  public
    type
      { Hash function.  Generates a hash key for values to be stored in a set. }
      THashSortedSetFunc = function (Value : V) : Cardinal;  
  public
    { Create a new set. }
    constructor Create (HashFunc : THashSortedSetFunc);

    { Destroy a set. }
    destructor Destroy; override;

    { Add a value to a set. }
    function Insert (Value : V) : Boolean;

    { Remove a value from a set. }
    function Remove (Value : V) : Boolean;

    { Retrieve the number of entries in a set }
    function NumEntries : Cardinal;
  
    { Query if a particular value is in a set. }
    function HasValue (Value : V) : Boolean;

    { Perform a union of two sets.
      A new set containing all values which are in the first or second sets, or 
      empty set if it was not possible to allocate memory for the new set. }
    function Union (SortedSet : specialize TSortedSet<V, BinaryCompareFunctor>)
     : specialize TSortedSet<V, BinaryCompareFunctor>;

    { Perform an intersection of two sets.
      A new set containing all values which are in both set, or empty set if it 
      was not possible to allocate memory for the new set. }
    function Intersection (SortedSet : specialize TSortedSet<V,
      BinaryCompareFunctor>) : specialize TSortedSet<V, BinaryCompareFunctor>;

  end;

implementation



end.