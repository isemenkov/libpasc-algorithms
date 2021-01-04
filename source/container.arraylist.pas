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

unit container.arraylist;

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
  { ArrayList index is not exists. }
  EIndexOutOfRangeException = class(Exception);
  {$ENDIF}

  { Automatically resizing array. 
    ArrayLists are generic arrays of T which automatically increase in size. }
  {$IFDEF FPC}generic{$ENDIF} TArrayList<T; BinaryCompareFunctor
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
      { TArrayList iterator. }
      TIterator = class; { Fix for FreePascal compiler. }
      TIterator = class ({$IFDEF FPC}specialize{$ENDIF}
        TBidirectionalIterator<T, TIterator>)
      protected
        { Create new iterator for arraylist item entry. }
        {%H-}constructor Create (Arr : PDynArray; Len : Cardinal; Pos : 
          Integer);
      public
        { Return true if iterator has correct value }
        function HasValue : Boolean; override;

        { Retrieve the previous entry in a list. }
        function Prev : TIterator; override;

        { Retrieve the next entry in a list. }
        function Next : TIterator; override;

        { Return True if we can move to next element. }
        function MoveNext : Boolean; override;

        { Return enumerator for in operator. }
        function GetEnumerator : TIterator; override;
      protected
        { Get item value. }
        function GetValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue
          {$ENDIF}; override;

        { Set new item value. }
        procedure SetValue (AValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}
          TOptionalValue{$ENDIF});

        { Get item index. }
        function GetItemIndex : {$IFNDEF USE_OPTIONAL}LongInt{$ELSE}
          TOptionalIndex{$ENDIF};

        { Return current item iterator and move it to next. }
        function GetCurrent : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue
          {$ENDIF}; override;
      public
        { Read/Write arraylist item value. If value not exists raise 
          EIndexOutOfRangeException. }
        property Value : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF} 
          read GetValue write SetValue;

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

      TEnumerator = {$IFDEF FPC}specialize{$ENDIF} TEnumerator<T, TIterator>;
  public
    constructor Create (ALength : Cardinal = 0);
    destructor Destroy; override;

    { Append a value to the end of an ArrayList. 
      Return true if the request was successful, false if it was not possible to 
      allocate more memory for the new entry. }
    function Append (AValue : T) : Boolean;

    { Prepend a value to the beginning of an ArrayList. 
      Return true if the request was successful, false if it was not possible to 
      allocate more memory for the new entry. }
    function Prepend (AValue : T) : Boolean;

    { Remove the entry at the specified location in an ArrayList. }
    procedure Remove (AIndex: Cardinal);

    { Remove a range of entries at the specified location in an ArrayList. }
    procedure RemoveRange (AIndex : LongInt; ALength : LongInt);

    { Insert a value at the specified index in an ArrayList.
      The index where the new value can be inserted is limited by the size of 
      the ArrayList.
      Returns false if unsuccessful, else true if successful (due to an invalid 
      index or if it was impossible to allocate more memory). }
    function Insert (AIndex : LongInt; AData : T) : Boolean;

    { Find the index of a particular value in an ArrayList. 
      Return the index of the value if found, or -1 if not found. }
    function IndexOf (AData : T) : Integer;

    { Retrive the first entry in a arraylist. }
    function FirstEntry : TIterator;

    { Retrive the last entry in a arraylist. }
    function LastEntry : TIterator;

    { Remove all entries from an ArrayList. }
    procedure Clear;

    { Sort the values in an ArrayList. }
    procedure Sort;

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator; 
  protected
    { Reallocate the array to the new size }
    function Enlarge : Boolean;

    { Sort the values }
    procedure SortInternal (var AData : array of PData; ALength : Cardinal);

    { Get value by index. }
    function GetValue (AIndex : LongInt) : {$IFNDEF USE_OPTIONAL}T{$ELSE}
      TOptionalValue{$ENDIF};

    { Set new value by index. }
    procedure SetValue (AIndex : LongInt; AData : {$IFNDEF USE_OPTIONAL}T
      {$ELSE}TOptionalValue{$ENDIF});
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
      TOptionalValue{$ENDIF} read GetValue write SetValue;

    { Get ArrayList length. }
    property Length : LongInt read FLength;
  end;

implementation

{ TArrayList.TIterator }

constructor TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Create (Arr : PDynArray; Len : Cardinal; Pos : Integer);
begin
  FArray := Arr;
  FLength := Len;
  FPosition := Pos;
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.HasValue : Boolean;
begin
  if FPosition >= FLength then
  begin
    Exit(False);
  end;

  Result := True;
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Prev : TIterator;
begin
  Result := TIterator.Create(FArray, FLength, FPosition - 1);

  if TIterator(Result).FPosition < 0 then
  begin
    TIterator(Result).FPosition := 0;
  end;
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.Next : TIterator;
begin
  Result := TIterator.Create(FArray, FLength, FPosition + 1); 
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.MoveNext : Boolean;
begin
  Result := FPosition < FLength;
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetEnumerator : TIterator;
begin
  Result := TIterator.Create(FArray, FLength, FPosition);
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
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

procedure TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.SetValue (AValue : {$IFNDEF USE_OPTIONAL}T{$ELSE}
  TOptionalValue{$ENDIF});
begin
  if FPosition > FLength then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EIndexOutOfRangeException.Create('Index out of range.');
    {$ELSE}
    Exit;
    {$ENDIF}
  end;

  FArray^[FPosition]^.Value := AValue{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF};
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
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

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .TIterator.GetCurrent : {$IFNDEF USE_OPTIONAL}T{$ELSE}
  TOptionalValue{$ENDIF};
begin
  Result := GetValue;
  Inc(FPosition);
end;

{ TArrayList }

constructor TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
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

destructor TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
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

procedure TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .SetValue (AIndex : LongInt; AData : {$IFNDEF USE_OPTIONAL}
  T{$ELSE}TOptionalValue{$ENDIF});
begin
  if AIndex > FLength then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EIndexOutOfRangeException.Create('Index out of range.');
    {$ELSE}
    Exit;
    {$ENDIF}
  end;  

  New(FData[AIndex]);
  FData[AIndex]^.Value := AData{$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF};
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Enlarge : Boolean;
var
  NewSize : Cardinal;
begin
  { Double the allocated size }
  NewSize := FAlloced * 2;

  { Reallocate the array to the new size }
  SetLength(FData, NewSize);
  FAlloced := NewSize;
  
  Result := True;  
end;

procedure TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .SortInternal (var AData : array of PData; ALength : Cardinal);
var
  pivot, tmp : PData;
  list1_length, list2_length : Cardinal;
  i : Cardinal;
begin
  { If less than two items, it is always sorted. }
  if ALength <= 1 then
  begin
    Exit;
  end;

  { Take the last item as the pivot. }
  pivot := AData[ALength - 1];

  { Divide the list into two lists:

    List 1 contains data less than the pivot.
    List 2 contains data more than the pivot.

    As the lists are build up, they are stored sequentially after each other, 
    ie. AData[ALength - 1] is the last item in list 1, AData[ALength] is the 
    first item in list 2. }
  list1_length := 0;

  for i := 0 to ALength - 1 do
  begin
    if FCompareFunctor.Call(AData[i]^.Value, pivot^.Value) < 0 then
    begin
      { This should be in list 1. Therefore it is in the wrong position. Swap 
        the data immediately following the last item in list 1 with this data. }
      tmp := AData[i];
      AData[i] := AData[list1_length];
      AData[list1_length] := tmp;
      
      Inc(list1_length);
    end else
    begin
      { This should be in list 2. This is already in the right position. }
    end;
  end;

  { The length of list 2 can be calculated. }
  list2_length := ALength - list1_length - 1;

  { AData[0..list1_length - 1] now contains all items which are before the 
    pivot.
    AData[list1_length..ALength - 2] contains all items after or equal to the 
    pivot.

    Move the pivot into place, by swapping it with the item immediately 
    following the end of list 1. }
  AData[ALength - 1] := AData[list1_length];
  AData[list1_length] := pivot;

  { Recursively sort the sublists. } 
  SortInternal(AData, list1_length);
  SortInternal(AData[list1_length + 1], list2_length);
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Insert (AIndex : LongInt; AData : T) : Boolean;
begin
  { Sanity check the index }
  if AIndex > FLength then
  begin
    Result := False;
    Exit;
  end;
 
  { Increase the size if necessary }
  if FLength + 1 > FAlloced then
  begin
    if not Enlarge then
    begin
      Result := False;
      Exit;
    end;
  end;

  { Move the contents of the array forward from the index onwards }
  System.Move(FData[AIndex], FData[AIndex + 1], (FLength - AIndex) * 
    Sizeof(PData));

  { Insert the new entry at the index }
  New(FData[AIndex]);
  FData[AIndex]^.Value := AData;
  Inc(FLength);

  Result := True;
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Append (AValue : T) : Boolean;
begin
  Result := Insert(FLength, AValue);
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Prepend (AValue : T) : Boolean;
begin
  Result := Insert(0, AValue);
end;

procedure TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
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

procedure TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Remove (AIndex : Cardinal);
begin
  RemoveRange(AIndex, 1);
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .IndexOf (AData : T) : Integer;
var
  i : Cardinal;
begin
  if FLength <= 0 then
    Exit(-1);

  for i := 0 to FLength - 1 do
  begin
    if FCompareFunctor.Call(FData[i]^.Value, AData) = 0 then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .FirstEntry : TIterator;
begin
  Result := TIterator.Create(@FData, FLength, 0);
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .LastEntry : TIterator;
begin
  Result := TIterator.Create(@FData, FLength, FLength - 1);
end;

procedure TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Clear;
begin
  FLength := 0;
end;

procedure TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Sort;
begin
  { Perform the recursive sort. }
  SortInternal(FData, FLength);
end;

function TArrayList{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .GetEnumerator : TIterator;
begin
  Result := TIterator.Create(@FData, FLength, 0);
end;

end.
