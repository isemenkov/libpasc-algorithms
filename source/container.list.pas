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

unit container.list;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils {$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF}
  {$IFNDEF FPC}, utils.functor{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { List item value not exists. }
  EValueNotExistsException = class(Exception);
  {$ENDIF}

  { Doubly-linked list.
    A doubly-linked list stores a collection of values. Each entry in the list 
    (represented by a pointer a @ref ListEntry structure) contains a link to the 
    next entry and the previous entry. It is therefore possible to iterate over 
    entries in the list in either direction. }
  {$IFDEF FPC}generic{$ENDIF} TList<T; BinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<T, 
    Integer>{$ENDIF}> = class
  protected
    type
      { TList item entry type. }
      PPListEntry = ^PListEntry;
      PListEntry = ^TListEntry;
      TListEntry = record
        Value : T;
        Prev : PListEntry;
        Next : PListEntry; 
      end;
  public
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<T>;
      {$ENDIF}

      { TList iterator. }
      TIterator = class
      protected
        { Create new iterator for list item entry. }
        {%H-}constructor Create (APFirstNode : PPListEntry; APLastNode : 
          PPListEntry; APLength : PLongWord; AItem : PListEntry);
      public
        { Return true if iterator has correct value }
        function HasValue : Boolean;

        { Retrieve the previous entry in a list. }
        function Prev : TIterator;

        { Retrieve the next entry in a list. }
        function Next : TIterator;

        { Remove an entry from a list. }
        procedure Remove;

        { Insert new entry in prev position. }
        procedure InsertPrev (AData : T);

        { Insert new entry in next position. }
        procedure InsertNext (AData : T);

        { Return True if we can move to next element. }
        function MoveNext : Boolean;

        { Return enumerator for in operator. }
        function GetEnumerator : TIterator;
      protected
        { Get item value. }
        function GetValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue
          {$ENDIF};

        { Set new item value. }
        procedure SetValue (AValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}
          TOptionalValue{$ENDIF});

        { Return current item iterator and move it to next. }
        function GetCurrent : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue
          {$ENDIF};  
      protected
        var
          { We cann't store pointer to list because generics in pascal it is
            not "real" class see: https://wiki.freepascal.org/Generics 
            
            Other Points
            ============
            1. The compiler parses a generic, but instead of generating code it 
            stores all tokens in a token buffer inside the PPU file.
            2. The compiler parses a specialization; for this it loads the token 
            buffer from the PPU file and parses that again. It replaces the 
            generic parameters (in most examples "T") by the particular given 
            type (e.g. LongInt, TObject).
              The code basically appears as if the same class had been written 
            as the generic but with T replaced by the given type. 
              Therefore in theory there should be no speed differences between a
            "normal" class and a generic one.  

            In this reason we cann't take pointer to list class inside TIterator
            class. But in some methods we need modify original list data, so we
            store pointers to list data. }
          FPFirstNode : PPListEntry;
          FPLastNode : PPListEntry;
          FPLength : PLongWord;

          FItem : PListEntry;
      public
        { Read/Write list item value. If value not exists raise 
          EValueNotExistsException. }
        property Value : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF} 
          read GetValue write SetValue;

        property Current : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF}
          read GetCurrent;
      end;
  public
    { Create new list. }
    constructor Create;
    { Free an entire list. }
    destructor Destroy; override;

    { Prepend a value to the start of a list.
      Return true if the request was successful, false if it was not possible to 
      allocate more memory for the new entry. }
    function Prepend (AData : T) : Boolean;

    { Append a value to the end of a list. 
      Return true if the request was successful, false if it was not possible to 
      allocate more memory for the new entry. }
    function Append (AData : T) : Boolean;

    { Remove all occurrences of a particular value from a list. Return the 
      number of entries removed from the list. }
    function Remove (AData : T) : Cardinal;

    { Retrive the first entry in a list. }
    function FirstEntry : TIterator;

    { Retrive the last entry in a list. }
    function LastEntry : TIterator;

    { Retrieve the entry at a specified index in a list. }
    function NthEntry (AIndex : Cardinal) : TIterator;

    { Find the entry for a particular value in a list. }
    function FindEntry (AData : T) : TIterator;

    { Sort a list. }
    procedure Sort;

    { Clear the list. }
    procedure Clear;

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator;
  protected
    { Function used internally for sorting.  Returns the last entry in the new 
      sorted list }
    function SortInternal (list : PPListEntry) : PListEntry;  
  protected
    var
      FFirstNode : PListEntry;
      FLastNode : PListEntry;     
      FLength : Cardinal;
      FCompareFunctor : BinaryCompareFunctor;
  public
    { Get List length. }
    property Length : Cardinal read FLength;
  end;

implementation

constructor TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Create (APFirstNode : PPListEntry; APLastNode : 
  PPListEntry; APLength : PLongWord; AItem : PListEntry);
begin
  FPFirstNode := APFirstNode;
  FPLastNode := APLastNode;
  FPLength := APLength;
  FItem := AItem;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.HasValue : Boolean;
begin
  Result := FItem <> nil;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Prev : TIterator;
begin
  if FItem = nil then
  begin
    Result := TIterator.Create(FPFirstNode, FPLastNode, FPLength, nil);
    Exit;
  end;

  Result := TIterator.Create(FPFirstNode, FPLastNode, FPLength, FItem^.Prev);
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Next : TIterator;
begin
  if FItem = nil then
  begin
    Result := TIterator.Create(FPFirstNode, FPLastNode, FPLength, nil);
    Exit;
  end;

  Result := TIterator.Create(FPFirstNode, FPLastNode, FPLength, FItem^.Next);
end;

procedure TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Remove;
begin
  { If the entry is NULL, always fail }
  if FItem = nil then
  begin
    Exit;
  end;

  { Action to take is different if the entry is the first in the list }
  if FItem^.Prev = nil then
  begin
    FPFirstNode^ := FItem^.Next;

    {  Update the second entry's prev pointer, if there is a second entry }
    if FItem^.Next <> nil then
    begin  
      FItem^.Next^.Prev := nil;
    end;
  end else
  begin
    { This is not the first in the list, so we must have a previous entry. 
      Update its 'next' pointer to the new value }
    FItem^.Prev^.Next := FItem^.Next;

    { If there is an entry following this one, update its 'prev' pointer to the 
      new value }
    if FItem^.Next <> nil then
    begin
      FItem^.Next^.Prev := FItem^.Prev;
    end else
    begin
      FItem^.Prev^.Next := nil;
      FPLastNode^ := FItem^.Prev;
    end;
  end;
  Dec(FPLength^);
  { Free the list entry }
  Dispose(FItem);
  FItem := nil;
end;

procedure TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.InsertPrev (AData : T);
var
  NewItem : PListEntry;
begin
  New(NewItem);

  { Insert new entry in list first position. }
  if FItem^.Prev = nil then
  begin
    FItem^.Prev := NewItem;
    NewItem^.Prev := nil;
    NewItem^.Next := FItem;
    FPFirstNode^ := NewItem;
  end else
  { Insert new entry in custom list position }
  begin
    FItem^.Prev^.Next := NewItem;
    NewItem^.Prev := FItem^.Prev;
    FItem^.Prev := NewItem;
    NewItem^.Next := FItem;
  end;
  NewItem^.Value := AData;
  Inc(FPLength^);
end;

procedure TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.InsertNext (AData : T);
var
  NewItem : PListEntry;
begin
  New(NewItem);

  { Insert new entry is list last position. }
  if FItem^.Next = nil then
  begin
    FItem^.Next := NewItem;
    NewItem^.Prev := FItem;
    NewItem^.Next := nil;
    FPLastNode^ := NewItem;
  end else
  { Insert new entry in custom list position }
  begin
    NewItem^.Next := FItem^.Next;
    FItem^.Next^.Prev := NewItem;
    FItem^.Next := NewItem;
    NewItem^.Prev := FItem;
  end;
  NewItem^.Value := AData;
  Inc(FPLength^);
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.MoveNext : Boolean;
begin
  Result := FItem <> nil;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FPFirstNode, FPLastNode, FPLength, FItem);
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};
begin
  if FItem = nil then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EValueNotExistsException.Create('Value not exists.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  Result := {$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}FItem^.Value
    {$IFDEF USE_OPTIONAL}){$ENDIF};
end;

procedure TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.SetValue (AValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}
  TOptionalValue{$ENDIF});
begin
  if FItem <> nil then
  begin
    FItem^.Value := {$IFNDEF USE_OPTIONAL}AValue{$ELSE}AValue.Unwrap{$ENDIF};
  end;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetCurrent : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};
begin
  Result := GetValue;
  FItem := FItem^.Next;
end;

constructor TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Create;
begin
  FFirstNode := nil;
  FLastNode := nil;
  FLength := 0;
  FCompareFunctor := BinaryCompareFunctor.Create;
end;

destructor TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Destroy;
begin
  Clear;  

  inherited Destroy;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.GetEnumerator : 
  TIterator;
begin
  Result := FirstEntry;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.FirstEntry : 
  TIterator;
begin
  Result := TIterator.Create(@FFirstNode, @FLastNode, @FLength, FFirstNode);
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.LastEntry : 
  TIterator;
begin
  Result := TIterator.Create(@FFirstNode, @FLastNode, @FLength, FLastNode);
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Prepend (AData : 
  T) : Boolean;
var
  NewItem : PListEntry;
begin
  { Create new entry }
  New(NewItem);
  NewItem^.Value := AData;

  { Hook into the list start }
  if FFirstNode <> nil then
  begin
    FFirstNode^.Prev := NewItem;
  end;
  NewItem^.Prev := nil;
  NewItem^.Next := FFirstNode;
  FFirstNode := NewItem;

  { If list is empty, first and last node are the same }
  if FLastNode = nil then
  begin
    FLastNode := FFirstNode;
  end;

  Inc(FLength);
  Result := True;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Append (AData : 
  T) : Boolean;
var
  NewItem : PListEntry;
begin
  { Create new entry }
  New(NewItem);
  NewItem^.Value := AData;

  if FLastNode <> nil then
  begin
    FLastNode^.Next := NewItem;
  end;
  NewItem^.Prev := FLastNode;
  NewItem^.Next := nil;
  FLastNode := NewItem;

  { If list is empty, first and last node are the same }
  if FFirstNode = nil then
  begin
    FFirstNode := FLastNode;
  end;

  Inc(FLength);
  Result := True;
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.NthEntry (AIndex : 
  Cardinal) : TIterator;
var
  Entry : PListEntry;
  i : Cardinal;
begin  
  { Iterate through n list entries to reach the desired entry. Make sure we do 
    not reach the end of the list. }
  Entry := FFirstNode;
  i := 0;
  while (i < AIndex) do
  begin
    if Entry = nil then
    begin
      Result := TIterator.Create(@FFirstNode, @FLastNode, @FLength, nil);
      Exit;
    end;
    Entry := Entry^.Next;
    Inc(i);
  end;

  Result := TIterator.Create(@FFirstNode, @FLastNode, @FLength, Entry);
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Remove (AData : 
  T) : Cardinal;
var
  Iterator : TIterator;
begin
  Result := 0;
  Iterator := FindEntry(AData);
  while Iterator.HasValue do
  begin
    Iterator.Remove;
    Inc(Result);
    Iterator := FindEntry(AData);
  end; 
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.FindEntry (AData : 
  T) : TIterator;
var
  Entry : PListEntry;
begin  
  { Iterate through list entries to find the desired entry. Make sure we do 
    not reach the end of the list. }
  Entry := FFirstNode;
  while (Entry <> nil) do
  begin
    if FCompareFunctor.Call(Entry^.Value, AData) = 0 then
    begin
      Result := TIterator.Create(@FFirstNode, @FLastNode, @FLength, Entry);
      Exit;
    end;
    Entry := Entry^.Next;
  end;

  Result := TIterator.Create(@FFirstNode, @FLastNode, @FLength, nil);
end;

function TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .SortInternal (list : PPListEntry) : PListEntry;
var
  pivot, rover : PListEntry;
  less_list, more_list : PListEntry;
  less_list_end, more_list_end : PListEntry;
  next : PListEntry;
begin
  if list = nil then
  begin
    Result := nil;
    Exit;
  end;

  { If there are less than two entries in this list, it is already sorted }
  if (list^ = nil) or ((list^)^.Next = nil) then
  begin
    Result := list^;
    Exit;
  end;

  { The first entry is the pivot }
  pivot := list^;

  { Iterate over the list, starting from the second entry. Sort all entries into
    the less and more lists based on comparisons with the pivot }
  less_list := nil;
  more_list := nil;
  rover := (list^)^.Next;

  while rover <> nil do
  begin
    next := rover^.Next;

    if FCompareFunctor.Call(rover^.Value, pivot^.Value) < 0 then
    begin
      { Place this in the less list }
      rover^.Prev := nil;
      rover^.Next := less_list;

      if less_list <> nil then
      begin
        less_list^.Prev := rover;
      end;
      less_list := rover;
    end else
    begin
      { Place this in the more list }
      rover^.Prev := nil;
      rover^.Next := more_list;

      if more_list <> nil then
      begin
        more_list^.Prev := rover;
      end;
      more_list := rover;
    end;
    rover := next;
  end;

  { Sort the sublists recursively }
  less_list_end := SortInternal(@less_list);
  more_list_end := SortInternal(@more_list);

  { Create the new list starting from the less list }
  list^ := less_list;

  { Append the pivot to the end of the less list. If the less list was empty, 
    start from the pivot }
  if less_list = nil then
  begin
    pivot^.Prev := nil;
    list^ := pivot;
  end else
  begin
    pivot^.Prev := less_list_end;
    less_list_end^.Next := pivot;
  end;

  { Append the more list after the pivot }
  pivot^.Next := more_list;
  if more_list <> nil then
  begin
    more_list^.Prev := pivot;
  end;

  { Work out what the last entry in the list is. If the more list was empty, the 
    pivot was the last entry. Otherwise, the end of the more list is the end of 
    the total list. }
  if more_list = nil then
  begin
    Result := pivot;
    Exit;
  end else
  begin
    Result := more_list_end;
    Exit;
  end;
end;

procedure TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Sort;
begin
  SortInternal(@FFirstNode);
end;

procedure TList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Clear;
var
  CurrItem, NextItem : PListEntry;
begin
  { Iterate over each entry, freeing each list entry, until the end is reached }
  CurrItem := FFirstNode;
  while CurrItem <> nil do
  begin
    NextItem := CurrItem^.Next;
    Dispose(CurrItem);
    CurrItem := NextItem;
  end;
  
  FFirstNode := nil;
  FLastNode := nil;
  FLength := 0;
end;

end.
