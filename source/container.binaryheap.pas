(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(* delphi and object pascal library of  common data structures and algorithms *)
(*                 https://github.com/fragglet/c-algorithms                   *)
(*                                                                            *)
(* Copyright (c) 2021                                       Ivan Semenkov     *)
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

unit container.binaryheap;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils{$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF}
  {$IFNDEF FPC}, utils.functor{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { TBinaryHeap is empty. }
  EHeapEmptyException = class(Exception);
  {$ENDIF}

  { Heap type. If a heap is a min heap, the values with the lowest priority are
    stored at the top of the heap and will be the first returned. If a heap is a 
    max heap, the values with the greatest priority are stored at the top of 
    the heap. }
  {$IFDEF FPC}generic{$ENDIF} TMinBinaryHeap<T; BinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<T,
    Integer>{$ENDIF}> = class
  protected
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<T>;
      {$ENDIF}

      { Internal container storage data type. }
      PData = ^TData;
      TData = record
        Value : T;
      end;
  public
    constructor Create (ALength : Cardinal = 0);
    destructor Destroy; override;

    { Insert a value into a binary heap. }
    function Append (AValue : T) : Boolean;

    { Remove the first value from a binary heap. }
    function Pop : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};

    { Find the number of values stored in a binary heap. }
    function NumEntries : Cardinal;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return true if container is empty. }
    function IsEmpty : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    FData : array of PData;
    FLength : Cardinal;
    FAlloced : Cardinal;
    FCompareFunctor : BinaryCompareFunctor;
  end;

  {$IFDEF FPC}generic{$ENDIF} TMaxBinaryHeap<T; BinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<T,
    Integer>{$ENDIF}> = class
  protected
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<T>;
      {$ENDIF}

      { Internal container storage data type. }
      PData = ^TData;
      TData = record
        Value : T;
      end;
  public
    constructor Create (ALength : Cardinal = 0);
    destructor Destroy; override;

    { Insert a value into a binary heap. }
    function Append (AValue : T) : Boolean;

    { Remove the first value from a binary heap. }
    function Pop : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};

    { Find the number of values stored in a binary heap. }
    function NumEntries : Cardinal;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return true if container is empty. }
    function IsEmpty : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    FData : array of PData;
    FLength : Cardinal;
    FAlloced : Cardinal;
    FCompareFunctor : BinaryCompareFunctor;
  end;

implementation

{ TMinBinaryHeap }

constructor TMinBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Create (ALength : Cardinal);
begin
  if ALength = 0 then
  begin
    ALength := 16;
  end;

  SetLength(FData, ALength);
  FAlloced := ALength;
  FLength := 0;
  FCompareFunctor := BinaryCompareFunctor.Create;
end;

destructor TMinBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

function TMinBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Append (AValue : T) : Boolean;
var
  index, parent : Cardinal;
  NewSize : Cardinal;
begin
  { Possibly realloc the heap to a larger size. }
  if FLength + 1 > FAlloced then
  begin
    { Double the table size. }
    NewSize := FAlloced * 2;
    SetLength(FData, NewSize);
    FAlloced := NewSize;
  end;

  { Add to the bottom of the heap and start from there. }
  index := FLength;
  Inc(FLength);

  { Percolate the value up to the top of the heap. }
  while index > 0 do
  begin
    { The parent index is found by halving the node index. }
    parent := (index - 1) div 2;

    { Compare the node with its parent. }
    if FCompareFunctor.Call(FData[parent]^.Value, AValue) < 0 then
    begin
      { Ordered correctly - insertion is complete. }
      Break;
    end else
    begin
      { Need to swap this node with its parent. }
      FData[index] := FData[parent];

      { Advance up to the parent. }
      index := parent;
    end;
  end;

  { Save the new value in the final location. }
  New(FData[index]);
  FData[index]^.Value := AValue;
  Result := True;
end;

function TMinBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Pop : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};
var
  NewValue : T;
  Index, NextIndex, child1, child2 : Cardinal;
begin
  { Empty heap? }
  if FLength = 0 then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EHeapEmptyException.Create('BinaryHeap is empty.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;
  
  { Take the value from the top of the heap. }
  Result := {$IFNDEF USE_OPTIONAL}FData[0]^.Value{$ELSE}
    TOptionalValue.Create(FData[0]^.Value){$ENDIF};

  { Remove the last value from the heap; we will percolate this down from the 
    top. }
  NewValue := FData[FLength - 1]^.Value;
  Dispose(FData[FLength - 1]);
  Dec(FLength);

  { Percolate the new top value down. }
  index := 0;

  while True do
  begin
    { Calculate the array indexes of the children of this node. }
    child1 := Index * 2 + 1;
    child2 := Index * 2 + 2;

    if (child1 < FLength) and 
      (FCompareFunctor.Call(NewValue, FData[child1]^.Value) > 0) then
    begin
      { Left child is less than the node. We need to swap with one of the 
        children, whichever is less. }
      if (child2 < FLength) and (FCompareFunctor.Call(FData[child1]^.Value,
        FData[child2]^.Value) > 0) then
      begin
        NextIndex := child2;
      end else
      begin
        NextIndex := child1;
      end;
    end else
    if (child2 < FLength) and 
      (FCompareFunctor.Call(NewValue, FData[child2]^.Value) > 0) then
    begin
      { Right child is less than the node. Swap with the right child. }
      NextIndex := child2;
    end else
    begin
      { Node is less than both its children. The heap condition is satisfied. We 
        can stop percolating down. }
      New(FData[index]);
      FData[index]^.Value := NewValue;
      Break;
    end;

    { Swap the current node with the least of the child nodes. }
    FData[index] := FData[NextIndex];

    { Advance to the child we chose. }
    Index := NextIndex;
  end;
end;

function TMinBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .NumEntries : Cardinal;
begin
  Result := FLength;
end;

function TMinBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .IsEmpty : Boolean;
begin
  Result := (NumEntries = 0);
end;

{ TMaxBinaryHeap }

constructor TMaxBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Create (ALength : Cardinal);
begin
  if ALength = 0 then
  begin
    ALength := 16;
  end;

  SetLength(FData, ALength);
  FAlloced := ALength;
  FLength := 0;
  FCompareFunctor := BinaryCompareFunctor.Create;
end;

destructor TMaxBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

function TMaxBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Append (AValue : T) : Boolean;
var
  index, parent : Cardinal;
  NewSize : Cardinal;
begin
  { Possibly realloc the heap to a larger size. }
  if FLength + 1 > FAlloced then
  begin
    { Double the table size. }
    NewSize := FAlloced * 2;
    SetLength(FData, NewSize);
    FAlloced := NewSize;
  end;

  { Add to the bottom of the heap and start from there. }
  index := FLength;
  Inc(FLength);

  { Percolate the value up to the top of the heap. }
  while index > 0 do
  begin
    { The parent index is found by halving the node index. }
    parent := (index - 1) div 2;

    { Compare the node with its parent. }
    if FCompareFunctor.Call(FData[parent]^.Value, AValue) > 0 then
    begin
      { Ordered correctly - insertion is complete. }
      Break;
    end else
    begin
      { Need to swap this node with its parent. }
      FData[index] := FData[parent];

      { Advance up to the parent. }
      index := parent;
    end;
  end;

  { Save the new value in the final location. }
  New(FData[index]);
  FData[index]^.Value := AValue;
  Result := True;
end;

function TMaxBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Pop : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};
var
  NewValue : T;
  Index, NextIndex, child1, child2 : Cardinal;
begin
  { Empty heap? }
  if FLength = 0 then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EHeapEmptyException.Create('BinaryHeap is empty.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;
  
  { Take the value from the top of the heap. }
  Result := {$IFNDEF USE_OPTIONAL}FData[0]^.Value{$ELSE}
    TOptionalValue.Create(FData[0]^.Value){$ENDIF};

  { Remove the last value from the heap; we will percolate this down from the 
    top. }
  NewValue := FData[FLength - 1]^.Value;
  Dispose(FData[FLength - 1]);
  Dec(FLength);

  { Percolate the new top value down. }
  index := 0;

  while True do
  begin
    { Calculate the array indexes of the children of this node. }
    child1 := Index * 2 + 1;
    child2 := Index * 2 + 2;

    if (child1 < FLength) and 
      (FCompareFunctor.Call(NewValue, FData[child1]^.Value) < 0) then
    begin
      { Left child is less than the node. We need to swap with one of the 
        children, whichever is less. }
      if (child2 < FLength) and (FCompareFunctor.Call(FData[child1]^.Value,
        FData[child2]^.Value) < 0) then
      begin
        NextIndex := child2;
      end else
      begin
        NextIndex := child1;
      end;
    end else
    if (child2 < FLength) and 
      (FCompareFunctor.Call(NewValue, FData[child2]^.Value) < 0) then
    begin
      { Right child is less than the node. Swap with the right child. }
      NextIndex := child2;
    end else
    begin
      { Node is less than both its children. The heap condition is satisfied. We 
        can stop percolating down. }
      New(FData[index]);
      FData[index]^.Value := NewValue;
      Break;
    end;

    { Swap the current node with the least of the child nodes. }
    FData[index] := FData[NextIndex];

    { Advance to the child we chose. }
    Index := NextIndex;
  end;
end;

function TMaxBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .NumEntries : Cardinal;
begin
  Result := FLength;
end;

function TMaxBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .IsEmpty : Boolean;
begin
  Result := (NumEntries = 0);
end;

end.
