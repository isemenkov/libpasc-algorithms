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

unit container.trie;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils{$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { Item key value not exists. }
  EKeyNotExistsException = class(Exception);
  {$ENDIF}

  { A trie is a data structure which provides fast mappings from strings to 
    values. }
  {$IFDEF FPC}generic{$ENDIF} TTrie<V> = class
  {$IFDEF USE_OPTIONAL}
  public
    type  
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<T>;
  {$ENDIF}
  public
    { Create a new trie. }
    constructor Create;

    { Destroy a trie. }
    destructor Destroy; override;

    { Insert a new key-value pair into a trie. The key is a NUL-terminated
      string. Return true if the value was inserted successfully, or zero if it 
      was not possible to allocate memory for the new entry. }
    function Insert (Key : AnsiString; Value : V) : Boolean;

    { Insert a new key-value pair into a trie. The key is a sequence of bytes. }
    function InsertBinary (Key : PByte; KeyLength : Integer; Value : V) : 
      Boolean;

    { Look up a value from its key in a trie. }
    function Search (Key : AnsiString) : {$IFNDEF USE_OPTIONAL}V{$ELSE}
      TOptionalValue{$ENDIF};

    { Look up a value from its key in a trie. The key is a sequence of bytes. }
    function SearchBinary (Key : PByte; KeyLength : Integer) : 
      {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};

    { Remove an entry from a trie. }
    function Remove (Key : AnsiString) : Boolean;

    { Remove an entry from a trie. The key is a sequence of bytes. }
    function RemoveBinary (Key : PByte; KeyLength : Integer) : Boolean;

    { Find the number of entries in a trie. }
    function NumEntries : Cardinal;
  protected
    type
      PPTrieNode = ^PTrieNode;
      PTrieNode = ^TTrieNode;  
      TTrieNode = record
        data : V;
        ptr : Pointer;
        use_count : Cardinal;
        next : array [0 .. 255] of PTrieNode;
      end;

      PTrieStruct = ^TTrieStruct;
      TTrieStruct = record
        root_node : PTrieNode;
      end;
  protected
    FTrie : PTrieStruct;  
  protected
    function FindEnd (Key : AnsiString) : PTrieNode;
    function FindEndBinary (Key : PByte; KeyLength : Integer) : PTrieNode;

    { Roll back an insert operation after a failed GetMem() call. }
    procedure InsertRollback (Key : PByte);
  private
    procedure ListPush (list : PPTrieNode; node : PTrieNode);
    function ListPop (list : PPTrieNode) : PTrieNode;
  end;

implementation

{ TTrie }

procedure TTrie{$IFNDEF FPC}<V>{$ENDIF}.ListPush (list : PPTrieNode; 
  node : PTrieNode);
begin
  node^.ptr := list^;
  list^ := node;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.ListPop (list : PPTrieNode) : 
  PTrieNode;
begin
  Result := list^;
  list^ := Result^.ptr;
end;

constructor TTrie{$IFNDEF FPC}<V>{$ENDIF}.Create;
begin
  New(FTrie);
  FTrie^.root_node := nil;
end;

destructor TTrie{$IFNDEF FPC}<V>{$ENDIF}.Destroy;
var
  free_list, node : PTrieNode;
  i : Integer;
begin
  free_list := nil;

  { Start with the root node. }
  if FTrie^.root_node <> nil then
    ListPush(@free_list, FTrie^.root_node);

  { Go through the free list, freeing nodes. We add new nodes as we encounter 
    them; in this way, all the nodes are freed non-recursively. }
  while free_list <> nil do
  begin
    node := ListPop(@free_list);

    { Add all children of this node to the free list. }
    for i := 0 to 255 do
    begin
      if node^.next[i] <> nil then
        ListPush(@free_list, node^.next[i]);
    end;

    { Free the node. }
    Dispose(node);
  end;

  { Free the trie. }
  Dispose(FTrie);

  inherited Destroy;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.FindEnd (Key : AnsiString) : PTrieNode;
var
  node : PTrieNode;
  key_index : Integer;
  p : AnsiChar;
begin
  { Search down the trie until the end of string is reached }
  node := FTrie^.root_node;

  key_index := 1;
  p := Key[key_index];
  while Byte(p) <> $0 do
  begin
    if node = nil then
    begin
      { Not found in the tree. Return. }
      Exit(nil);
    end;

    { Jump to the next node. }
    node := node^.next[Byte(p)];

    Inc(key_index);
    p := Key[key_index];
  end;

  { This key is present if the value at the last node is not NULL }
  Result := node;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.FindEndBinary (Key : PByte; KeyLength : 
  Integer) : PTrieNode;
var
  node : PTrieNode;
  j, c : Integer;
begin
  { Search down the trie until the end of string is reached }
  node := FTrie^.root_node;

  for j := 0 to KeyLength do
  begin
    if node = nil then
    begin
      { Not found in the tree. Return. }
      Exit(nil);
    end;

    c := Byte(Key[j]);

    { Jump to the next node }
    node := node^.next[c];
  end;

  { This key is present if the value at the last node is not NULL }
  Result := node;
end;

procedure TTrie{$IFNDEF FPC}<V>{$ENDIF}.InsertRollback (Key : PByte);
var
  node : PTrieNode;
  prev_ptr : PPTrieNode;
  next_node : PTrieNode;
  next_prev_ptr : PPTrieNode;
  p : PByte;
begin
  { Follow the chain along. We know that we will never reach the end of the 
    string because Insert never got that far. As a result, it is not necessary 
    to check for the end of string delimiter (NUL). }
  node := FTrie^.root_node;
  prev_ptr := @(FTrie^.root_node);
  p := Key;

  while node <> nil do
  begin
    { Find the next node now. We might free this node. }
    next_prev_ptr := @(node^.next[p^]);
    next_node := next_prev_ptr^;
    Inc(p);

    { Decrease the use count and free the node if it reaches zero. }
    Dec(node^.use_count);

    if node^.use_count = 0 then
    begin
      Dispose(node);

      if prev_ptr <> nil then
      begin
        prev_ptr^ := nil;
      end;

      next_prev_ptr := nil;
    end;

    { Update pointers }
    node := next_node;
    prev_ptr := next_prev_ptr;
  end;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.Insert (Key : AnsiString; Value : V) : 
  Boolean;
var
  rover : PPTrieNode;
  node : PTrieNode;
  key_index : Integer;
  p : AnsiChar;
  c : Integer;
begin
  { Search to see if this is already in the tree }
  node := FindEnd(Key);

  { Already in the tree? If so, replace the existing value and return success. }
  if node <> nil then
  begin
    node^.data := Value;
    Exit(True);
  end;

  { Search down the trie until we reach the end of string, creating nodes as 
    necessary }
  rover := @(FTrie^.root_node);
  key_index := 1;
  p := Key[key_index];

  while True do
  begin
    node := rover^;
    
    if node = nil then
    begin
      { Node does not exist, so create it }
      GetMem(node, Sizeof(TTrieNode));
      
      if node = nil then
      begin
        { Allocation failed.  Go back and undo what we have done so far. }
        InsertRollback(PByte(PAnsiChar(Key)));
        Exit(False);
      end;

      node^.data := Default(V);
      node^.ptr := nil;
      node^.use_count := 0;
      FillChar(node^.next, Sizeof(PTrieNode) * 256, $0);

      { Link in to the trie }
      rover^ := node;
    end;

    { Increase the node use count }
    Inc(node^.use_count);

    { Current character }
    c := Byte(p);

    { Reached the end of string?  If so, we're finished. }
    if c = $0 then
    begin
      { Set the data at the node we have reached }
      node^.data := Value;
      Break;
    end;

    { Advance to the next node in the chain }
    rover := @(node^.next[c]);
    Inc(key_index);
    p := Key[key_index];
  end;

  Result := True;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.InsertBinary (Key : PByte; KeyLength : 
  Integer; Value : V) : Boolean;
var
  rover : PPTrieNode;
  node : PTrieNode;
  p, c : Integer;
begin
  { Search to see if this is already in the tree }
  node := FindEndBinary(Key, KeyLength);

  { Already in the tree? If so, replace the existing value and return success. }
  if node <> nil then
  begin
    node^.data := Value;
    Exit(True);
  end;

  { Search down the trie until we reach the end of string, creating nodes as 
    necessary }
  rover := @(FTrie^.root_node);
  p := 0;

  while True do
  begin
    node := rover^;

    if node = nil then
    begin
      { Node does not exist, so create it }
      GetMem(node, Sizeof(TTrieNode));

      if node = nil then
      begin
        { Allocation failed. Go back and undo what we have done so far. }
        InsertRollback(Key);  
        Exit(False);
      end;

      node^.data := Default(V);
      node^.ptr := nil;
      node^.use_count := 0;
      FillChar(node^.next, Sizeof(PTrieNode) * 256, $0);

      { Link in to the trie }
      rover^ := node;
    end;

    { Increase the node use count }
    Inc(node^.use_count);

    { Current character }
    c := Byte(Key[p]);

    { Reached the end of string? If so, we're finished. }
    if p = KeyLength then
    begin
      { Set the data at the node we have reached }
      node^.data := Value;
      Break;
    end;

    { Advance to the next node in the chain }
    rover := @(node^.next[c]);
    Inc(p);
  end;

  Result := True;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.Remove (Key : AnsiString) : Boolean;
var
  node : PTrieNode;
  next : PTrieNode;
  last_next_ptr : PPTrieNode;
  key_index : Integer;
  p : AnsiChar;
  c : Integer;
begin
  { Find the end node and remove the value }
  node := FindEnd(Key);

  if node <> nil then
    node^.data := Default(V)
  else
    Exit(False);

  { Now traverse the tree again as before, decrementing the use count of each 
    node. Free back nodes as necessary. }
  node := FTrie^.root_node;
  last_next_ptr := @(FTrie^.root_node);
  key_index := 1;
  p := Key[key_index];
  
  while True do
  begin
    { Find the next node }
    c := Byte(p);
    next := node^.next[c];

    { Free this node if necessary }
    Dec(node^.use_count);

    if node^.use_count <= 0 then
    begin
      Dispose(node);

      { Set the "next" pointer on the previous node to NULL, to unlink the freed
        node from the tree. This only needs to be done once in a remove. After 
        the first unlink, all further nodes are also going to be free'd. }
      if last_next_ptr <> nil then
      begin
        last_next_ptr^ := nil;
        last_next_ptr := nil;
      end;
    end;

    { Go to the next character or finish }
    if c = $0 then
      Break
    else
      Inc(key_index);
      p := Key[key_index];

    { If necessary, save the location of the "next" pointer so that it may be 
      set to NULL on the next iteration if the next node visited is freed. }
    if last_next_ptr <> nil then
    begin
      last_next_ptr := @(node^.next[c]);
    end;

    { Jump to the next node }
    node := next;
  end;

  { Removed successfully }
  Result := True;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.RemoveBinary (Key : PByte; KeyLength : 
  Integer) : Boolean;
var
  node : PTrieNode;
  next : PTrieNode;
  last_next_ptr : PPTrieNode;
  p, c : Integer;
begin
  { Find the end node and remove the value }
  node := FindEndBinary(Key, KeyLength);

  if node <> nil then
    node^.data := Default(V)
  else
    Exit(False);

  { Now traverse the tree again as before, decrementing the use count of each 
    node. Free back nodes as necessary. }
  node := FTrie^.root_node;
  last_next_ptr := @(FTrie^.root_node);
  p := 0;

  while True do
  begin
    { Find the next node }
    c := Byte(Key[p]);
    next := node^.next[c];

    { Free this node if necessary }
    Dec(node^.use_count);

    if node^.use_count <= 0 then
    begin
      Dispose(node);

      { Set the "next" pointer on the previous node to NULL, to unlink the freed
        node from the tree. This only needs to be done once in a remove. After 
        the first unlink, all further nodes are also going to be free'd. }
      if last_next_ptr <> nil then
      begin
        last_next_ptr^ := nil;
        last_next_ptr := nil;
      end;      
    end;

    { Go to the next character or finish }
    if p = KeyLength then
      Break
    else
      Inc(p);

    { If necessary, save the location of the "next" pointer so that it may be 
      set to NULL on the next iteration if the next node visited is freed. }
    if last_next_ptr <> nil then
    begin
      last_next_ptr := @(node^.next[c]);
    end;

    { Jump to the next node }
    node := next;
  end;

  { Removed successfully }
  Result := True;
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.Search (Key : AnsiString) : 
  {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};
var
  node : PTrieNode;
begin
  node := FindEnd(Key);
  
  if node <> nil then
    Exit({$IFNDEF USE_OPTIONAL}node^.data{$ELSE}
      TOptionalValue.Create(node^.data){$ENDIF})
  else
    {$IFNDEF USE_OPTIONAL}
    raise EKeyNotExistsException.Create('Key not exists.');
    {$ELSE}
    Exi(TOptionalValue.Create);
    {$ENDIF}
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.SearchBinary (Key : PByte; KeyLength : 
  Integer) : {$IFNDEF USE_OPTIONAL}V{$ELSE}TOptionalValue{$ENDIF};
var
  node : PTrieNode;
begin
  node := FindEndBinary(Key, KeyLength);

  if node <> nil then
    Exit({$IFNDEF USE_OPTIONAL}node^.data{$ELSE}
      TOptionalValue.Create(node^.data){$ENDIF})
  else
    {$IFNDEF USE_OPTIONAL}
    raise EKeyNotExistsException.Create('Key not exists.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
end;

function TTrie{$IFNDEF FPC}<V>{$ENDIF}.NumEntries : Cardinal;
begin
  { To find the number of entries, simply look at the use count of the root 
    node. }
  if FTrie^.root_node <> nil then
    Result := FTrie^.root_node^.use_count
  else
    Result := 0;
end;

end.
