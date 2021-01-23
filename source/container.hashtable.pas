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

unit container.hashtable;

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
  {$IFNDEF FPC}, utils.functor{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { Item key value not exists. }
  EKeyNotExistsException = class(Exception);
  {$ENDIF}

  { A hash table stores a set of values which can be addressed by a key. Given 
    the key, the corresponding value can be looked up quickly. }
  {$IFDEF FPC}generic{$ENDIF} THashTable<K; V; KeyBinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<K, 
    Integer>{$ENDIF}> = class 
  protected
    type
      PHashTablePair = ^THashTablePair;
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
      TArrayHashTableEntry = array of PHashTableEntry;  

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
      HashTablePrimes : array [0 .. 23] of Cardinal =
      (
        193, 389, 769, 1543, 3079, 6151, 12289, 24593, 49157, 98317, 196613,
        393241, 786433, 1572869, 3145739, 6291469, 12582917, 25165843, 50331653,
        100663319, 201326611, 402653189, 805306457, 1610612741
      );
  public 
    type
      { Hash function used to generate hash values for keys used in a hash
        table. }
      THashTableHashFunc = function (Key : K) : Cardinal;

      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<V>;
      {$ENDIF}

      TKeyValuePair = {$IFDEF FPC}specialize{$ENDIF} TPair<K, V>;

      { THashTable iterator. }
      TIterator = class;
      TIterator = class ({$IFDEF FPC}specialize{$ENDIF}
        TForwardIterator<TKeyValuePair, TIterator>)
      protected
        { Create new iterator for hashtable item entry. }
        {%H-}constructor Create (HashTable : PHashTableStruct; 
          Initialize : Boolean); 

        { Get item key. }
        function GetKey : K;
        
        { Get item value. }
        function GetValue : V; reintroduce;

        { Return current item iterator and move it to next. }
        function GetCurrent : TKeyValuePair;
          {$IFNDEF USE_OPTIONAL}override;{$ELSE}reintroduce;{$ENDIF}
      public
        { Return true if iterator has correct value }
        function HasValue : Boolean; override;

        { Retrieve the next entry in a hashtable. }
        function Next : TIterator; override;

        { Return True if we can move to next element. }
        function MoveNext : Boolean; override;

        { Return enumerator for in operator. }
        function GetEnumerator : TIterator; override;

        { Reuturn key value. }
        property Key : K read GetKey;
        
        { Return value. }
        property Value : V read GetValue;

        property Current : TKeyValuePair read GetCurrent;
      protected
        var
          FHashTable : PHashTableStruct;
          FHashTablePair : THashTablePair;
          next_entry : PHashTableEntry;
          next_chain : Cardinal; 
      end; 
  public
    { Create a new hash table. }
    constructor Create (HashFunc : THashTableHashFunc);

    { Destroy a hash table. }
    destructor Destroy; override;

    { Insert a value into a hash table, overwriting any existing entry using the
      same key. }
    function Insert (Key : K; Value : V) : Boolean;

    { Look up a value in a hash table by key. }
    function Search (Key : K) : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue
      {$ENDIF};

    { Remove a value from a hash table. }
    function Remove (Key : K) : Boolean;

    { Retrieve the number of entries in a hash table. }
    function NumEntries : Cardinal;

    { Retrive the first entry in hashtable. }
    function FirstEntry : TIterator; 

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator;
  protected
    { Internal function used to allocate the table on hash table creation and 
      when enlarging the table. }
    function HashTableAllocateTable : Boolean;

    { Free an entry, calling the free functions if there are any registered }
    procedure HashTableFreeEntry (entry : PHashTableEntry);

    function HashTableEnlarge : Boolean;
  protected
    FHashFunc : THashTableHashFunc;
    FHashTable : PHashTableStruct;
    FCompareFunctor : KeyBinaryCompareFunctor;  
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
    Result := (Result shl 5) + Result + Byte(Char(location[i]));
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
      {%H-}Byte(PChar(AnsiLowerCase(location[i])));
  end;
end;

{ THashTable.TIterator }

constructor THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.Create (HashTable : PHashTableStruct; Initialize : Boolean);
var
  chain : Cardinal;
begin
  FHashTable := HashTable;

  if Initialize then
  begin
    { Default value of next if no entries are found. }
    next_entry := nil;

    { Find the first entry }
    for chain := 0 to FHashTable^.table_size - 1 do
    begin
      if TArrayHashTableEntry(FHashTable^.table)[chain] <> nil then
      begin
        next_entry := TArrayHashTableEntry(FHashTable^.table)[chain];
        next_chain := chain;
        Break;
      end;
    end;

    if next_entry <> nil then
    begin
      FHashTablePair := next_entry^.pair;
    end;
  end;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.HasValue : Boolean;
begin
  Result := True;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.Next : TIterator;
var
  current_entry : PHashTableEntry;
  chain : Cardinal;
begin
  Result := TIterator.Create(FHashTable, False);

  if next_entry = nil then
  begin
    Result.next_entry := nil;
    Result.next_chain := next_chain;
    Exit;
  end;

  { Result is immediately available }
  current_entry := next_entry;

  { Find the next entry }
  if current_entry^.next <> nil then
  begin
    { Next entry in current chain }
    next_entry := current_entry^.next;
  end else
  begin
    { None left in this chain, so advance to the next chain }
    chain := next_chain + 1;

    { Default value if no next chain found }
    next_entry := nil;
    while chain < FHashTable^.table_size do
    begin
      { Is there anything in this chain? }
      if TArrayHashTableEntry(FHashTable^.table)[chain] <> nil then
      begin
        next_entry := TArrayHashTableEntry(FHashTable^.table)[chain];
        Break;
      end;
      { Try the next chain }
      Inc(chain);
    end;
    next_chain := chain;
  end;

  if next_entry <> nil then
  begin
    FHashTablePair := next_entry^.pair;
    Result.FHashTablePair := next_entry^.pair;
  end;

  Result.next_entry := next_entry;
  Result.next_chain := next_chain;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.MoveNext : Boolean;
begin
  Result := next_entry <> nil;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetCurrent : TKeyValuePair;
begin
  Result := TKeyValuePair.Create(FHashTablePair.Key, FHashTablePair.Value);
  Next;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetKey : K;
begin
  Result := FHashTablePair.Key;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetValue : V;
begin
  Result := FHashTablePair.Value;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .TIterator.GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FHashTable, True);
end;

{ THashTable }

constructor THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Create(HashFunc : THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>
  {$ENDIF}.THashTableHashFunc);
begin
  FHashFunc := HashFunc;
  FCompareFunctor := KeyBinaryCompareFunctor.Create;

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

destructor THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Destroy;
var
  rover : PHashTableEntry;
  next : PHashTableEntry;
  i : Cardinal;
begin
  { Free all entries in all chains }
  for i := 0 to FHashTable^.table_size - 1 do
  begin
    rover := TArrayHashTableEntry(FHashTable^.table)[i];
  
    while rover <> nil do
    begin
      next := rover^.next;
      HashTableFreeEntry(rover);
      rover := next;
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

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .HashTableAllocateTable : Boolean;
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

  { Allocate the table. }
  GetMem(FHashTable^.table, Sizeof(PHashTableEntry) * FHashTable^.table_size);
  FillChar(FHashTable^.table^, Sizeof(PHashTableEntry) * FHashTable^.table_size,
    $0);

  Result := FHashTable^.table <> nil;
end;

procedure THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .HashTableFreeEntry (entry : THashTable{$IFNDEF FPC}<K, V,
  KeyBinaryCompareFunctor>{$ENDIF}.PHashTableEntry);
var
  pair : PHashTablePair;
begin
  pair := @entry^.pair;

  { Free the data structure }
  Dispose(pair);
  pair := nil;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .HashTableEnlarge : Boolean;
var
  old_table : PPHashTableEntry;
  old_table_size : Cardinal;
  old_prime_index : Cardinal;
  rover : PHashTableEntry;
  pair : PHashTablePair;
  next : PHashTableEntry;
  index : Cardinal;
  i : Cardinal;
begin
  { Store a copy of the old table }
  old_table := FHashTable^.table;
  old_table_size := FHashTable^.table_size;
  old_prime_index := FHashTable^.prime_index;

  { Allocate a new, larger table }
  Inc(FHashTable^.prime_index);

  if not HashTableAllocateTable then
  begin
    { Failed to allocate the new table }
    FHashTable^.table := old_table;
    FHashTable^.table_size := old_table_size;
    FHashTable^.prime_index := old_prime_index;

    Exit(False);
  end;

  { Link all entries from all chains into the new table }
  for i := 0 to old_table_size - 1 do
  begin
    rover := TArrayHashTableEntry(old_table)[i];

    while rover <> nil do
    begin
      next := rover^.next;

      { Fetch rover HashTablePair }
      pair := @rover^.pair;

      { Find the index into the new table }
      index := FHashFunc(pair^.key) mod FHashTable^.table_size;

      { Link this entry into the chain }
      rover^.next := TArrayHashTableEntry(FHashTable^.table)[index];
      TArrayHashTableEntry(FHashTable^.table)[index] := rover;

      { Advance to next in the chain }
      rover := next;
    end;
  end;

  { Free the old table }
  Dispose(old_table);
  Result := True;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Insert (Key : K; Value : V) : Boolean;
var
  rover : PHashTableEntry;
  pair : PHashTablePair;
  newentry : PHashTableEntry;
  index : Cardinal;
begin
  { If there are too many items in the table with respect to the table size, the 
    number of hash collisions increases and performance decreases. Enlarge the 
    table size to prevent this happening }
  if ((FHashTable^.entries * 3) div FHashTable^.table_size) > 0 then
  begin
    { Table is more than 1/3 full }
    if not HashTableEnlarge then
    begin
      { Failed to enlarge the table }
      Exit(False);  
    end;
  end;

  { Generate the hash of the key and hence the index into the table }
  index := FHashFunc(key) mod FHashTable^.table_size;

  { Traverse the chain at this location and look for an existing entry with the 
    same key }
  rover := TArrayHashTableEntry(FHashTable^.table)[index];

  while rover <> nil do
  begin
    { Fetch rover's HashTablePair entry }
    pair := @rover^.pair;

    if FCompareFunctor.Call(pair^.key, key) = 0 then
    begin
      { Same key: overwrite this entry with new data. }
      { Same with the key: use the new key value and free the old one }
      pair^.key := key;
      pair^.value := value;

      { Finished }
      Exit(True);
    end;

    rover := rover^.next;
  end;

  { Not in the hash table yet. Create a new entry }
  New(newentry);

  newentry^.pair.key := key;
  newentry^.pair.value := value;

  { Link into the list }
  newentry^.next := TArrayHashTableEntry(FHashTable^.table)[index];
  TArrayHashTableEntry(FHashTable^.table)[index] := newentry;

  { Maintain the count of the number of entries }
  Inc(FHashTable^.entries);

  { Added successfully }
  Result := True;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Search (Key : K) : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};
var
  rover : PHashTableEntry;
  pair : PHashTablePair;
  index : Cardinal;
begin
  { Generate the hash of the key and hence the index into the table }
  index := FHashFunc(key) mod FHashTable^.table_size;

  { Walk the chain at this index until the corresponding entry is found }
  rover := TArrayHashTableEntry(FHashTable^.table)[index];

  while rover <> nil do
  begin
    pair := @rover^.pair;

    if FCompareFunctor.Call(pair^.key, key) = 0 then
    begin
      { Found the entry. Return the data. }
      Exit({$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}pair^.value
        {$IFDEF USE_OPTIONAL}){$ENDIF});
    end;

    rover := rover^.next;
  end;

  {$IFNDEF USE_OPTIONAL}
  raise EKeyNotExistsException.Create('Key not exists.');
  {$ELSE}
  Exit(TOptionalValue.Create);
  {$ENDIF}
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .Remove (Key : K) : Boolean;
var
  rover : PPHashTableEntry;
  entry : PHashTableEntry;
  pair : PHashTablePair;
  index : Cardinal;
begin
  { Generate the hash of the key and hence the index into the table }
  index := FHashFunc(key) mod FHashTable^.table_size;

  { Rover points at the pointer which points at the current entry in the chain 
    being inspected. ie. the entry in the table, or the "next" pointer of the 
    previous entry in the chain. This allows us to unlink the entry when we find
    it. }
  Result := False;
  rover := @(TArrayHashTableEntry(FHashTable^.table)[index]);

  while rover^ <> nil do
  begin
    pair := @(rover^)^.pair;

    if FCompareFunctor.Call(pair^.key, key) = 0 then 
    begin
      { This is the entry to remove }
      entry := rover^;

      { Unlink from the list }
      rover^ := entry^.next;

      { Destroy the entry structure }
      HashTableFreeEntry(entry);

      { Track count of entries }
      Dec(FHashTable^.entries);
      
      Result := True;
      Break;
    end;

    { Advance to the next entry }
    rover := @(rover^)^.next;
  end;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .NumEntries : Cardinal;
begin
  Result := FHashTable^.entries;
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .FirstEntry : TIterator;
begin
  Result := TIterator.Create(FHashTable, True);
end;

function THashTable{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor>{$ENDIF}
  .GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FHashTable, True);
end;

end.
