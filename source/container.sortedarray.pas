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

unit container.sortedarray;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils{$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF}, utils.enumerate
  {$IFNDEF FPC}, utils.functor{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { TSortedArray index is not exists. }
  EIndexOutOfRangeException = class(Exception);
  {$ENDIF}

  { A sorted array structure. 
    The TSortedArray is an automatically resizing array which stores its 
    elements in sorted order. Userdefined functions determine the sorting order.
    All operations on a TSortedArray maintain the sorted property. Most 
    operations are done in O(n) time, but searching can be done in O(log n)
    worst case. }
  {$IFDEF FPC}generic{$ENDIF} TSortedArray<T; BinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<T, 
    Integer>{$ENDIF}> = class
  protected
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<T>;
      TOptionalIndex = {$IFDEF FPC}specialize{$ENDIF} TOptional<LongInt>;
      {$ENDIF}

      { Internal container storage data type. }
      PData = ^TData;
      TData = record
        Value : T;
      end;

      TDynArray = array of PData;
      PDynArray = ^TDynArray;
  public
    type
      { TSortedArray iterator. }
      TIterator = class; { Fix for FreePascal compiler. }
      TIterator = class ({$IFDEF FPC}specialize{$ENDIF}
        TBidirectionalIterator<T, TIterator>)
      protected
        { Create new iterator for sorted array item entry. }
        {%H-}constructor Create (Arr : PDynArray; Len : Cardinal; Pos : 
          Integer);
      public
        { Return true if iterator has correct value }
        function HasValue : Boolean; override;

        { Retrieve the previous entry in a sorted array. }
        function Prev : TIterator; override;

        { Retrieve the next entry in a sorted array. }
        function Next : TIterator; override;

        { Return True if we can move to next element. }
        function MoveNext : Boolean; override;

        { Return enumerator for in operator. }
        function GetEnumerator : TIterator; override;
      protected
        { Get item value. }
        function GetValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue
          {$ENDIF}; override;

        { Get item index. }
        function GetItemIndex : {$IFNDEF USE_OPTIONAL}LongInt{$ELSE}
          TOptionalIndex{$ENDIF};

        { Return current item iterator and move it to next. }
        function GetCurrent : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue
          {$ENDIF}; override;
      public
        { Read/Write sorted array item value. If value not exists raise 
          EIndexOutOfRangeException. }
        property Value : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF} 
          read GetValue;

        { Get current item index. If value not exists raise 
          EIndexOutOfRangeException. }
        property Index : {$IFNDEF USE_OPTIONAL}LongInt{$ELSE}TOptionalIndex
          {$ENDIF} read GetItemIndex;

        property Current : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF}
          read GetCurrent;
      protected
        FArray : PDynArray;
        FLength : LongInt;
        FPosition : LongInt;
      end;
  public
    constructor Create (ALength : Cardinal = 0);
    destructor Destroy; override;

    { Insert a value into a sorted array while maintaining the sorted 
      property. }
    function Append (AData : T) : Boolean;
      
    { Remove a value from a TSortedArray at a specified index while maintaining 
      the sorted property. }
    procedure Remove (AIndex: Cardinal);
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Remove a range of entities from a TSortedArray while maintaining the 
      sorted property. }
    procedure RemoveRange (AIndex : LongInt; ALength : LongInt);

    { Find the index of a value in a TSortedArray. }
    function IndexOf (AData : T) : Integer;

    { Remove all values from a TSortedArray. }
    procedure Clear;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return true if container is empty. }
    function IsEmpty : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrive the first entry in a TSortedArray. }
    function FirstEntry : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrive the last entry in a TSortedArray. }
    function LastEntry : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    { Function for finding first index of range which equals data. An equal 
      value must be present. }
    function FirstIndex (AData : T; ALeft : LongInt; ARight : LongInt) :
      LongInt;

    { Function for finding last index of range which equals data. An equal 
      value must be present. }
    function LastIndex (AData : T; ALeft : LongInt; ARight : LongInt) :
      LongInt;

    { Get value by index. }
    function GetValue (AIndex : LongInt) : {$IFNDEF USE_OPTIONAL}T{$ELSE}
      TOptionalValue{$ENDIF};
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    var
      FData : array of PData;
      FLength : LongInt;
      FAlloced : LongInt;
      FCompareFunctor : BinaryCompareFunctor;
  public
    { Read/Write value in an ArrayList. If index not exists raise
      EIndexOutOfRangeException. }
    property Value [AIndex : LongInt] : {$IFNDEF USE_OPTIONAL}T{$ELSE}
      TOptionalValue{$ENDIF} read GetValue;

    { Get ArrayList length. }
    property Length : LongInt read FLength;
  end;

implementation

{ TSortedArray.TIterator }

constructor TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Create (Arr : PDynArray; Len : Cardinal; Pos : Integer);
begin
  FArray := Arr;
  FLength := Len;
  FPosition := Pos;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.HasValue : Boolean;
begin
  if FPosition >= FLength then
  begin
    Exit(False);
  end;

  Result := True;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Prev : TIterator;
begin
  Result := TIterator.Create(FArray, FLength, FPosition - 1);

  if TIterator(Result).FPosition < 0 then
  begin
    TIterator(Result).FPosition := 0;
  end;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Next : TIterator;
begin
  Result := TIterator.Create(FArray, FLength, FPosition + 1); 
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.MoveNext : Boolean;
begin
  Result := FPosition < FLength;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FArray, FLength, FPosition);
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}
  TOptionalValue{$ENDIF};
begin
  if FPosition > FLength then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EIndexOutOfRangeException.Create('Index out of range.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  Result := {$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}
    FArray^[FPosition]^.Value{$IFDEF USE_OPTIONAL}){$ENDIF};
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetItemIndex : {$IFNDEF USE_OPTIONAL}LongInt
  {$ELSE}TOptionalIndex{$ENDIF};
begin
  if FPosition > FLength then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EIndexOutOfRangeException.Create('Index out of range.');
    {$ELSE}
    Exit(TOptionalIndex.Create);
    {$ENDIF}
  end;

  Result := {$IFNDEF USE_OPTIONAL}FPosition{$ELSE}
    TOptionalIndex.Create(FPosition){$ENDIF};
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetCurrent : {$IFNDEF USE_OPTIONAL}T{$ELSE}
  TOptionalValue{$ENDIF};
begin
  Result := GetValue;
  Inc(FPosition);
end;

{ TSortedArray }

constructor TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Create(ALength : Cardinal);
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

destructor TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .GetValue (AIndex : LongInt) : {$IFNDEF USE_OPTIONAL}T
  {$ELSE}TOptionalValue{$ENDIF};
begin
  if AIndex > FLength then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EIndexOutOfRangeException.Create('Index out of range.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  Result := {$IFDEF USE_OPTIONAL}TOptionalValue.Create({$ENDIF}FData[AIndex]^
    .Value{$IFDEF USE_OPTIONAL}){$ENDIF};
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Append (AData : T) : Boolean;
var
  left, right, index, order, NewSize : LongInt;
begin
  { Do a binary search like loop to find right position. }
  left := 0;
  right := FLength;
  index := 0;
  
  { When length is 1 set right to 0 so that the loop is not entered. }
  if right <= 1 then
    right := 0;

  while left <> right do
  begin
    index := (left + right) div 2;

    order := FCompareFunctor.Call(AData, FData[index]^.Value);
    if order < 0 then
    begin
      { Value should be left of index. }
      right := index;
    end else if order > 0 then
    begin
      { Value should be right of index. }
      left := index + 1;
    end else
    begin
      { Value should be at index. }
      Break;
    end;
  end;    

  { Look whether the item should be put before or after the index. }
  if (FLength > 0) and (FCompareFunctor.Call(AData, FData[index]^.Value) > 0)
    then
  begin
    Inc(index);
  end;

  { Insert element at index. }
  if FLength + 1 > FAlloced then
  begin
    { Enlarge the array. }
    NewSize := FAlloced * 2;

    { Double the allocated size }
    NewSize := FAlloced * 2;

    { Reallocate the array to the new size }
    SetLength(FData, NewSize);
    FAlloced := NewSize;
  end;

  { Move the contents of the array forward from the index onwards }
  System.Move(FData[index], FData[index + 1], (FLength - index) *
    Sizeof(PData));

  { Insert the new entry at the index }
  New(FData[index]);
  FData[index]^.Value := AData;
  Inc(FLength);

  Result := True;  
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .IndexOf (AData : T) : Integer;
var
  left, right, index, order : LongInt;
begin
  if FLength <= 0 then
    Exit(-1);

  left := 0;
  right := FLength;
  index := 0;

  { Safe subtract 1 of right without going negative. }
  if right <= 1 then
    right := 0;

  while left <> right do
  begin
    index := (left + right) div 2;

    order := FCompareFunctor.Call(AData, FData[index]^.Value);
    if order < 0 then
    begin
      { Value should be left of index. }
      right := index;
    end else if order > 0 then
    begin
      { Value should be right of index. }
      left := index + 1;
    end else
    begin
      { No binary search can be done anymore, search linear now. }
      left := FirstIndex(AData, left, index);
      right := LastIndex(AData, index, right);

      for index := left to right do
      begin
        if FCompareFunctor.Call(AData, FData[index]^.Value) = 0 then
          Exit(index);
      end;

      { Nothing is found. }
      Exit(-1);
    end;
  end;

  Result := -1;
end;

procedure TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Remove (AIndex : Cardinal);
begin
  RemoveRange(AIndex, 1);
end;

procedure TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .RemoveRange (AIndex : LongInt; ALength : LongInt);
begin
  { Check this is a valid range }
  if (AIndex > FLength) or (AIndex + ALength > FLength) then
  begin
    Exit;
  end;

  { Move back the entries following the range to be removed }
  Move(FData[AIndex + ALength], FData[AIndex],
    (FLength - (AIndex + ALength)) * SizeOf(PData));
  Dec(FLength, ALength);
end;

procedure TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Clear;
begin
  FLength := 0;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .FirstEntry : TIterator;
begin
  Result := TIterator.Create(@FData, FLength, 0);
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .LastEntry : TIterator;
begin
  Result := TIterator.Create(@FData, FLength, FLength - 1);
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .GetEnumerator : TIterator;
begin
  Result := TIterator.Create(@FData, FLength, 0);
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .FirstIndex (AData : T; ALeft : LongInt; ARight : LongInt) : LongInt;
var
  index, order : LongInt;
begin
  index := ALeft;

  while ALeft < ARight do
  begin
    index := (ALeft + ARight) div 2;

    order := FCompareFunctor.Call(AData, FData[index]^.Value);

    if order > 0 then
    begin
      ALeft := index + 1;
    end else
    begin
      ARight := index;
    end;
  end;

  Result := index;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .LastIndex (AData : T; ALeft : LongInt; ARight : LongInt) : LongInt;
var
  index, order : LongInt;
begin
  index := ARight;

  while ALeft < ARight do
  begin
    index := (ALeft + ARight) div 2;

    order := FCompareFunctor.Call(AData, FData[index]^.Value);

    if order <= 0 then
    begin
      ALeft := index + 1;
    end else
    begin
      ARight := index;
    end;
  end;

  Result := index;
end;

function TSortedArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .IsEmpty : Boolean;
begin
  Result := (Length = 0);
end;

end.
