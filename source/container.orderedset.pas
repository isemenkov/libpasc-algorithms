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

unit container.orderedset;

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
  generic TOrderedSet<V, BinaryCompareFunctor> = class
  public
    type
      { Hash function.  Generates a hash key for values to be stored in a set. }
      THashOrderedSetFunc = function (Value : V) : Cardinal;  
  public
    { Create a new set. }
    constructor Create (HashFunc : THashOrderedSetFunc);

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
    function Union (OrderedSet : specialize TOrderedSet<V, 
      BinaryCompareFunctor>) : specialize TSortedSet<V, BinaryCompareFunctor>;

    { Perform an intersection of two sets.
      A new set containing all values which are in both set, or empty set if it 
      was not possible to allocate memory for the new set. }
    function Intersection (OrderedSet : specialize TOrderedSet<V,
      BinaryCompareFunctor>) : specialize TOrderedSet<V, BinaryCompareFunctor>;
  protected
    type
      PPOrderedSetEntry = ^POrderedSetEntry;
      POrderedSetEntry = ^TOrderedSetEntry;
      TOrderedSetEntry = record
        data : V;
        next : POrderedSetEntry;
      end;

    const
      OrderedSetNumPrimes : Cardinal = 24;

      { This is a set of good hash table prime numbers, from:
        http://planetmath.org/encyclopedia/GoodHashTablePrimes.html
        Each prime is roughly double the previous value, and as far as possible 
        from the nearest powers of two. }
      OrderedSetPrimes : array [0 .. 23] of Cardinal =
      (
        193, 389, 769, 1543, 3079, 6151, 12289, 24593, 49157, 98317, 196613, 
        393241, 786433, 1572869, 3145739, 6291469, 12582917, 25165843, 50331653, 
        100663319, 201326611, 402653189, 805306457, 1610612741
      ); 
  protected
    { Internal function used to allocate the ordered set on creation and when 
      enlarging the table. }
    function OrderedSetAllocateTable : Boolean;

    { Free an entry }
    procedure OrderedSetFreeEntry (entry : POrderedSetEntry);
  protected
    FTable : PPOrderedSetEntry;
    FEntries : Cardinal;
    FTable_size : Cardinal;
    FPrime_index : Cardinal;
    FHashFunc : THashOrderedSetFunc;
    FCompareFunctor : BinaryCompareFunctor;
  end;

implementation



end.