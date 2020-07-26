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

unit hash_table;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils;

type
  { A hash table stores a set of values which can be addressed by a key. Given 
    the key, the corresponding value can be looked up quickly. }
  generic THashTable<K, V> = class 
  public 
    type
      { Hash function used to generate hash values for keys used in a hash
        table. }
      THashTableHashFunc = function (Key : K) : Integer of object;   
  public
    { Create a new hash table. }
    constructor Create (HashFunc : THashTableHashFunc);

    { Destroy a hash table. }
    destructor Destroy; override;
  protected
    type
      THashTablePair = record
        key : K;
        value : V;  
      end;  

      PPHashTableEntry = ^PHashTableEntry;  
      PHashTableEntry = ^THashTableEntry;
      THashTableEntry = record
        pair : THashTablePair;
        next : PHashTableEntry;
      end;  

      PHashTableStruct = ^THashTableStruct;
      THashTableStruct = record
        table : PPHashTableEntry;
        table_size : Cardinal;

        entries : Cardinal;
        prime_index : Cardinal;
      end;  
    
    const
      HashTableNumPrimes : Cardinal = 24;

      { This is a set of good hash table prime numbers, from:
        http://planetmath.org/encyclopedia/GoodHashTablePrimes.html
        Each prime is roughly double the previous value, and as far as
        possible from the nearest powers of two. }
      HashTablePrimes : array [0 .. HashTableNumPrimes - 1] of Cardinal = (
        193, 389, 769, 1543, 3079, 6151, 12289, 24593, 49157, 98317,
	      196613, 393241, 786433, 1572869, 3145739, 6291469,
	      12582917, 25165843, 50331653, 100663319, 201326611,
	      402653189, 805306457, 1610612741
      );
  protected
    { Internal function used to allocate the table on hash table creation and 
      when enlarging the table. }
    function HashTableAllocateTable : Boolean;

    { Free an entry, calling the free functions if there are any registered }
    procedure HashTableFreeEntry (entry : PHashTableEntry);
  protected
    FHashFunc : THashTableHashFunc;
    FHashTable : PHashTableStruct;
  end;  

implementation

constructor THashTable.Create(HashFunc : THashTable.THashTableHashFunc);
var
  new_table_size : Cardinal;
begin
  FHashFunc := HashFunc;

  { Allocate a new hash table structure }
  New(FHashTable);

  FHashTable^.entries := 0;
  FHashTable^.prime_index := 0;

  { Allocate the table }
  if not HashTableAllocateTable then
  begin
    Dispose(FHashTable);
    FHashTable := nil;
  end;
end;

destructor THashTable.Destroy;
var
  rover : PHashTableEntry;
  next : PHashTableEntry;
  i : Cardinal;
begin
  { Free all entries in all chains }
  for i := 0 to i < FHashTable^.table_size do
  begin
    rover := FHashTable^.table[i];
    
    while rover <> nil do
    begin
      next := rover^.next;
      HashTableFreeEntry(rover);
    end;
  end;

  { Free the table }
  Dispose(FHashTable^.table);
  FHashTable^.table := nil;

  { Free the hash table structure }
  Dispose(FHashTable);
  FHashTable := nil;

  inherited Destroy;
end;

function THashTable.HashTableAllocateTable : Boolean;
var
  new_table_size : Cardinal;
begin
  { Determine the table size based on the current prime index. An attempt is 
    made here to ensure sensible behavior if the maximum prime is exceeded, but 
    in practice other things are likely to break long before that happens. }
  if FHashTable^.prime_index < HashTableNumPrimes then
  begin
    new_table_size := HashTablePrimes[FHashTable^.prime_index];
  end else
  begin
    new_table_size := FHashTable^.entries * 10;
  end;

  FHashTable^.table_size := new_table_size;

  { Allocate the table and initialise to NULL for all entries. }
  New(FhashTable^.table);

  Result := FHashTable^.table <> nil;
end;

procedure THashTable.HashTableFreeEntry (entry : THashTable.PHashTableEntry);
var
  pair : PHashTablePair;
begin
  pair := @entry^.pair;

  { Free the data structure }
  Dispose(pair);
  pair := nil;
end;

end.