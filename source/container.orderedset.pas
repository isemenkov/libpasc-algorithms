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

unit container.orderedset;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, utils.enumerate {$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF}
  {$IFNDEF FPC}, utils.functor{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { Item value not exists. }
  EValueNotExistsException = class(Exception);
  {$ENDIF}
 
  { A set stores a collection of values.  Each value can only exist once in the 
    set. }
  {$IFDEF FPC}generic{$ENDIF} TOrderedSet<V; BinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<V, 
    Integer>{$ENDIF}> = class
  protected
    type
      PPOrderedSetEntry = ^POrderedSetEntry;
      POrderedSetEntry = ^TOrderedSetEntry;
      TOrderedSetEntry = record
        data : V;
        next : POrderedSetEntry;
      end;
      TArrayOrderedSetEntry = array of POrderedSetEntry;

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
  public
    type
      { Hash function.  Generates a hash key for values to be stored in a set. }
      THashOrderedSetFunc = function (Value : V) : Cardinal;

      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<V>;
      {$ENDIF}  
  
      { TOrderedSet iterator. }
      TIterator = class; { Fix for FreePascal compiler. }
      TIterator = class({$IFDEF FPC}specialize{$ENDIF} 
        TForwardIterator<V, TIterator>)
      protected
        { Create new iterator for orderedset item entry. }
        {%H-}constructor Create (OrderedSet : POrderedSetStruct; 
          Initialize : Boolean);
      public
        { Return true if iterator has correct value }
        function HasValue : Boolean; override;

        { Retrieve the next entry in a orderedset. }
        function Next : TIterator; override;
      protected
        { Get item value. }
        function GetValue : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue
          {$ENDIF}; override;

        { Return current item iterator and move it to next. }
        function GetCurrent : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue
          {$ENDIF};  override;
      public
        { Return True if we can move to next element. }
        function MoveNext : Boolean; override;

        { Return enumerator for in operator. }
        function GetEnumerator : TIterator; override;

        property Value : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF}
          read GetValue;

        property Current : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF}
          read GetCurrent;
      protected
        var
          FOrderedSet : POrderedSetStruct;
          next_entry : POrderedSetEntry;
          next_chain : Cardinal;
      end;

      TEnumerator = {$IFDEF FPC}specialize{$ENDIF} TEnumerator<V, TIterator>;
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
    function Union (OrderedSet : {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<V, 
      BinaryCompareFunctor>) : {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<V, 
      BinaryCompareFunctor>;

    { Perform an intersection of two sets.
      A new set containing all values which are in both set, or empty set if it 
      was not possible to allocate memory for the new set. }
    function Intersection (OrderedSet : {$IFDEF FPC}specialize{$ENDIF} 
      TOrderedSet<V, BinaryCompareFunctor>) : {$IFDEF FPC}specialize{$ENDIF} 
      TOrderedSet<V, BinaryCompareFunctor>;

    { Retrive the first entry in orderedset. }
    function FirstEntry : TIterator; 

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator; 
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
    Result := (Result shl 5) + Result +
      Byte(PChar(AnsiLowerCase(location[i]))[0]);
  end;
end;

{ TOrderedSet.TIterator }

constructor TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Create (OrderedSet : POrderedSetStruct; Initialize : Boolean);
var
  chain : Cardinal;
begin
  FOrderedSet := OrderedSet;
  
  if Initialize then
  begin
    next_entry := nil;

    { Find the first entry }
    for chain := 0 to FOrderedSet^.table_size - 1 do
    begin
      { There is a value at the start of this chain }
      if TArrayOrderedSetEntry(FOrderedSet^.table)[chain] <> nil then
      begin
        next_entry := TArrayOrderedSetEntry(FOrderedSet^.table)[chain];
        Break;    
      end;
    end;
    next_chain := chain;
  end;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .TIterator.HasValue : Boolean;
begin
  Result := next_entry <> nil;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Next : TIterator;
var
  current_entry : POrderedSetEntry;
  chain : Cardinal;
begin
  Result := TIterator.Create (FOrderedSet, False);
  
  if next_entry = nil then
  begin
    Result.next_entry := nil;
    Result.next_chain := next_chain;
    Exit;
  end;

  { We have the result immediately }
  current_entry := next_entry;

  { Advance next_entry to the next SetEntry in the Set. }
  if current_entry^.next <> nil then
  begin
    { Use the next value in this chain }
    next_entry := current_entry^.next;
  end else
  begin
    { Default value if no valid chain is found }
    next_entry := nil;

    { No more entries in this chain. Search the next chain }
    chain := next_chain + 1;
    while chain < FOrderedSet^.table_size do
    begin
      { Is there a chain at this table entry? }
      if TArrayOrderedSetEntry(FOrderedSet^.table)[chain] <> nil then
      begin
        { Valid chain found! }
        next_entry := TArrayOrderedSetEntry(FOrderedSet^.table)[chain];
        Break;
      end;
      { Keep searching until we find an empty chain }
      Inc(chain);
    end;
    next_chain := chain;
  end;

  Result.next_entry := next_entry;
  Result.next_chain := next_chain;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .TIterator.MoveNext : Boolean;
begin
  Result := next_entry <> nil;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetCurrent : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};
begin
  Result := GetValue;
  Next;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetValue : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};
begin
  if next_entry = nil then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EValueNotExistsException.Create('Value not exits.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  Result := {$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}next_entry^.data
    {$IFDEF USE_OPTIONAL}){$ENDIF};
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FOrderedSet, True);
end;

{ TOrderedSet }

constructor TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}.Create 
  (HashFunc : THashOrderedSetFunc);
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

destructor TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}.Destroy;
var
  rover : POrderedSetEntry;
  next : POrderedSetEntry;
  i : Cardinal;
begin
  { Free all entries in all chains }
  for i := 0 to FOrderedSet^.table_size - 1 do
  begin
    rover := TArrayOrderedSetEntry(FOrderedSet^.table)[i];

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
  //SetLength(FOrderedSet^.table, 0);

  { Free the set structure }
  Dispose(FOrderedSet);
  FOrderedSet := nil;

  inherited Destroy;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .OrderedSetAllocateTable : Boolean;
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

  { Allocate the table. }
  GetMem(FOrderedSet^.table, Sizeof(POrderedSetEntry) * 
    FOrderedSet^.table_size);
  FillChar(FOrderedSet^.table^, Sizeof(POrderedSetEntry) * 
    FOrderedSet^.table_size, $0);

  Result := FOrderedSet^.table <> nil;
  //SetLength(FOrderedSet^.table, FOrderedSet^.table_size);

  //Result := True;
end;

procedure TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .OrderedSetFreeEntry (entry : POrderedSetEntry);
begin
  Dispose(entry);
  entry := nil;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .OrderedSetEnlarge : Boolean;
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
    rover := TArrayOrderedSetEntry(old_table)[i];

    while rover <> nil do
    begin
      next := rover^.next;

      { Hook this entry into the new table }
      index := FHashFunc(rover^.data) mod FOrderedSet^.table_size;
      rover^.next := TArrayOrderedSetEntry(FOrderedSet^.table)[index];
      TArrayOrderedSetEntry(FOrderedSet^.table)[index] := rover;

      { Advance to the next entry in the chain }
      rover := next;
    end;
  end;

  { Free back the old table }
  Dispose(old_table);
  //SetLength(old_table, 0);

  { Resized successfully }
  Result := True;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .Insert (Value : V) : Boolean;
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
  rover := TArrayOrderedSetEntry(FOrderedSet^.table)[index];

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
  newentry^.next := TArrayOrderedSetEntry(FOrderedSet^.table)[index];
  TArrayOrderedSetEntry(FOrderedSet^.table)[index] := newentry;

  { Keep track of the number of entries in the set }
  Inc(FOrderedSet^.entries);

  { Added successfully }
  Result := True;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}.Remove 
  (Value : V) : Boolean;
var
  rover : PPOrderedSetEntry;
  entry : POrderedSetEntry;
  index : Cardinal;
begin
  { Look up the data by its hash key }
  index := FHashFunc(Value) mod FOrderedSet^.table_size;

  { Search this chain, until the corresponding entry is found }
  rover := @(TArrayOrderedSetEntry(FOrderedSet^.table)[index]);

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

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}.HasValue 
  (Value : V) : Boolean;
var 
  rover : POrderedSetEntry;
  index : Cardinal;
begin
  { Look up the data by its hash key }
  index := FHashFunc(Value) mod FOrderedSet^.table_size;

  { Search this chain, until the corresponding entry is found }
  rover := TArrayOrderedSetEntry(FOrderedSet^.table)[index];

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

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}.NumEntries : 
  Cardinal;
begin
  Result := FOrderedSet^.entries;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}.FirstEntry : 
  TIterator;
begin
  Result := TIterator.Create (FOrderedSet, True);
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FOrderedSet, True);
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .Union (OrderedSet : {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<V,
  BinaryCompareFunctor>) : {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<V,
  BinaryCompareFunctor>;
var
  Value : V;
begin
  Result := TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
    .Create(FHashFunc);

  { Add all values from the first set. }
  for Value in Self do
  begin
    { Copy the value into the new set. }
    if not Result.Insert(Value) then
    begin
      { Failed to insert. }
      FreeAndNil(Result);
      Exit(nil);
    end;  
  end;

  { Add all values from the second set. }
  for Value in OrderedSet do
  begin
    { Has this value been put into the new set already?
		  If so, do not insert this again. }
    if not Result.HasValue(Value) then
      if not Result.Insert(Value) then
      begin
        { Failed to insert. }
        FreeAndNil(Result);
        Exit(nil);
      end;
  end;
end;

function TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
  .Intersection (OrderedSet : {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<V, 
  BinaryCompareFunctor>) : {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<V, 
  BinaryCompareFunctor>;
var
  Value : V;
begin
  Result := TOrderedSet{$IFNDEF FPC}<V, BinaryCompareFunctor>{$ENDIF}
    .Create(FHashFunc);
  
  { Iterate over all values in self set. }
  for Value in Self do
  begin
    { Is this value in OrderedSet as well? If so, it should be in the new set. }
    if OrderedSet.HasValue(Value) then
      { Copy the value first before inserting, if necessary. }
      if not OrderedSet.Insert(Value) then
      begin
        FreeAndNil(Result);
        Exit(nil);
      end;
  end;
end;

end.
