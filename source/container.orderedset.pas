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
    {function Union (OrderedSet : specialize TOrderedSet<V, 
      BinaryCompareFunctor>) : specialize TSortedSet<V, BinaryCompareFunctor>;}

    { Perform an intersection of two sets.
      A new set containing all values which are in both set, or empty set if it 
      was not possible to allocate memory for the new set. }
    {function Intersection (OrderedSet : specialize TOrderedSet<V,
      BinaryCompareFunctor>) : specialize TOrderedSet<V, BinaryCompareFunctor>;}
  protected
    type
      PPOrderedSetEntry = ^POrderedSetEntry;
      POrderedSetEntry = ^TOrderedSetEntry;
      TOrderedSetEntry = record
        data : V;
        next : POrderedSetEntry;
      end;

      POrderedSetStruct = ^TOrderedSetStruct;
      TOrderedSetStruct = record
        table : PPOrderedSetEntry;
        entries : Cardinal;
        table_size : Cardinal;
        prime_index : Cardinal;
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

    function OrderedSetEnlarge : Boolean;
  protected
    FHashFunc : THashOrderedSetFunc;
    FOrderedSet : POrderedSetStruct;
    FCompareFunctor : BinaryCompareFunctor;
  end;

  { Generate a hash key for a pointer. The value pointed at by the pointer is 
    not used, only the pointer itself. }
  function HashPointer(location : Pointer) : Cardinal;

  {  Generate a hash key for a pointer to an integer. The value pointed at is 
    used to generate the key. }
  function HashInteger(location : Integer) : Cardinal;

  { Generate a hash key from a string. }
  function HashString(location : String) : Cardinal;

  { Generate a hash key from a string, ignoring the case of letters. }
  function HashStringNoCase(location : String) : Cardinal;

implementation

  function HashPointer(location : Pointer) : Cardinal;
begin
  Result := Cardinal({%H-}Longint(location));
end;

function HashInteger(location : Integer) : Cardinal;
begin
  Result := Cardinal(location);
end;

function HashString(location : String) : Cardinal;
var
  i : Cardinal;
begin
  { This is the djb2 string hash function }
  Result := 5381;
  for i := 0 to Length(location) - 1 do
  begin
    Result := (Result shl 5) + Result + Byte(location[i]);
  end;
end;

function HashStringNoCase (location : String) : Cardinal;
var
  i : Cardinal;
begin
  Result := 5381;
  for i := 0 to Length(location) - 1 do
  begin
    Result := (Result shl 5) + Result + Byte(Lowercase(location[i]));
  end;
end;

constructor TOrderedSet.Create (HashFunc : THashOrderedSetFunc);
begin
  FHashFunc := HashFunc;
  FCompareFunctor := BinaryCompareFunctor.Create;

  { Allocate a new set and fill in the fields }
  New(FOrderedSet);

  FOrderedSet^.entries := 0;
  FOrderedSet^.prime_index := 0;
  
  { Allocate the table }
  if not OrderedSetAllocateTable then
  begin
    Dispose(FOrderedSet);
    FOrderedSet := nil;
  end;
end;

destructor TOrderedSet.Destroy;
var
  rover : POrderedSetEntry;
  next : POrderedSetEntry;
  i : Cardinal;
begin
  { Free all entries in all chains }
  for i := 0 to FOrderedSet^.table_size - 1 do
  begin
    rover := FOrderedSet^.table[i];

    while rover <> nil do
    begin
      next := rover^.next;
      OrderedSetFreeEntry(rover);
      rover := next;
    end;
  end;

  { Free the table }
  Dispose(FOrderedSet^.table);
  FOrderedSet^.table := nil;

  { Free the set structure }
  Dispose(FOrderedSet);
  FOrderedSet := nil;

  inherited Destroy;
end;

function TOrderedSet.OrderedSetAllocateTable : Boolean;
begin
  { Determine the table size based on the current prime index. An attempt is 
    made here to ensure sensible behavior if the maximum prime is exceeded, but 
    in practice other things are likely to break long before that happens. }
  if FOrderedSet^.prime_index < OrderedSetNumPrimes then
  begin
    FOrderedSet^.table_size := OrderedSetPrimes[FOrderedSet^.prime_index];
  end else
  begin
    FOrderedSet^.table_size := FOrderedSet^.entries * 10;
  end;

  { Allocate the table and initialise to NULL }
  FOrderedSet^.table := GetMem(Sizeof(POrderedSetEntry) * 
    FOrderedSet^.table_size);
  FillByte(FOrderedSet^.table^, Sizeof(POrderedSetEntry) * 
    FOrderedSet^.table_size, 0);

  Result := FOrderedSet^.table <> nil;
end;

procedure TOrderedSet.OrderedSetFreeEntry (entry : POrderedSetEntry);
begin
  Dispose(entry);
  entry := nil;
end;

function TOrderedSet.OrderedSetEnlarge : Boolean;
var
  rover : POrderedSetEntry;
  next : POrderedSetEntry;
  old_table : PPOrderedSetEntry;
  old_table_size : Cardinal;
  old_prime_index : Cardinal;
  index : Cardinal;
  i : Cardinal;
begin
  { Store the old table }
  old_table := FOrderedSet^.table;
  old_table_size := FOrderedSet^.table_size;
  old_prime_index := FOrderedSet^.prime_index;

  { Use the next table size from the prime number array }
  Inc(FOrderedSet^.prime_index);

  { Allocate the new table }
  if not OrderedSetAllocateTable then
  begin
    FOrderedSet^.table := old_table;
    FOrderedSet^.table_size := old_table_size;
    FOrderedSet^.prime_index := old_prime_index;

    Exit(False);
  end;

  { Iterate through all entries in the old table and add them to the new one }
  for i := 0 to old_table_size - 1 do
  begin
    { Walk along this chain }
    rover := old_table[i];

    while rover <> nil do
    begin
      next := rover^.next;

      { Hook this entry into the new table }
      index := FHashFunc(rover^.data) mod FOrderedSet^.table_size;
      rover^.next := FOrderedSet^.table[index];
      FOrderedSet^.table[index] := rover;

      { Advance to the next entry in the chain }
      rover := next;
    end;
  end;

  { Free back the old table }
  Dispose(old_table);

  { Resized successfully }
  Result := True;
end;

function TOrderedSet.Insert (Value : V) : Boolean;
var
  newentry : POrderedSetEntry;
  rover : POrderedSetEntry;
  index : Cardinal;
begin
  { The hash table becomes less efficient as the number of entries increases. 
    Check if the percentage used becomes large. }
  if ((FOrderedSet^.entries * 3) div FOrderedSet^.table_size) > 0 then 
  begin
    { The table is more than 1/3 full and must be increased in size }
    if not OrderedSetEnlarge then
    begin
      Exit(False);
    end;
  end;

  { Use the hash of the data to determine an index to insert into the table at }
  index := FHashFunc(Value) mod FOrderedSet^.table_size;

  { Walk along this chain and attempt to determine if this data has already been
    added to the table }
  rover := FOrderedSet^.table[index];

  while rover <> nil do
  begin
    if FCompareFunctor.Call(rover^.data, Value) = 0 then
    begin
      { This data is already in the set }
      Exit(False);
    end;

    rover := rover^.next;
  end;

  { Not in the set.  We must add a new entry. Make a new entry for this data }
  New(newentry);
  newentry^.data := Value;

  { Link into chain }
  newentry^.next := FOrderedSet^.table[index];
  FOrderedSet^.table[index] := newentry;

  { Keep track of the number of entries in the set }
  Inc(FOrderedSet^.entries);

  { Added successfully }
  Result := True;
end;

function TOrderedSet.Remove (Value : V) : Boolean;
var
  rover : PPOrderedSetEntry;
  entry : POrderedSetEntry;
  index : Cardinal;
begin
  { Look up the data by its hash key }
  index := FHashFunc(Value) mod FOrderedSet^.table_size;

  { Search this chain, until the corresponding entry is found }
  rover := @FOrderedSet^.table[index];

  while rover^ <> nil do
  begin
    if FCompareFunctor.Call((rover^)^.data, Value) = 0 then
    begin
      { Found the entry }
      entry := rover^;

      { Unlink from the linked list }
      rover^ := entry^.next;

      { Update counter }
      Dec(FOrderedSet^.entries);

      { Free the entry and return }
      OrderedSetFreeEntry(entry);
      
      Exit(True);
    end;
    
    { Advance to the next entry }
    rover := @(rover^)^.next;
  end;

  { Not found in set }
  Result := False;
end;

function TOrderedSet.HasValue (Value : V) : Boolean;
var 
  rover : POrderedSetEntry;
  index : Cardinal;
begin
  { Look up the data by its hash key }
  index := FHashFunc(Value) mod FOrderedSet^.table_size;

  { Search this chain, until the corresponding entry is found }
  rover := FOrderedSet^.table[index];

  while rover <> nil do
  begin
    if FCompareFunctor.Call(rover^.data, Value) = 0 then
    begin
      { Found the entry }
      Exit(True);
    end;

    { Advance to the next entry in the chain }
    rover := rover^.next;
  end;

  { Not found }
  Result := False;
end;

function TOrderedSet.NumEntries : Cardinal;
begin
  Result := FOrderedSet^.entries;
end;



end.