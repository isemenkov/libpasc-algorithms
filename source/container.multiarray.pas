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
(* Permission is hereby  granted, free of  charge, to any  person obtaining a *)
(* copy of this software and associated documentation files (the "Software"), *)
(* to deal in the Software without  restriction, including without limitation *)
(* the rights  to use, copy,  modify, merge, publish, distribute, sublicense, *)
(* and/or  sell copies of  the Software,  and to permit  persons to  whom the *)
(* Software  is  furnished  to  do so, subject  to the following  conditions: *)
(*                                                                            *)
(* The above copyright notice and this permission notice shall be included in *)
(* all copies or substantial portions of the Software.                        *)
(*                                                                            *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *)
(* IMPLIED, INCLUDING BUT NOT  LIMITED TO THE WARRANTIES  OF MERCHANTABILITY, *)
(* FITNESS FOR A  PARTICULAR PURPOSE AND  NONINFRINGEMENT. IN NO  EVENT SHALL *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *)
(* LIABILITY,  WHETHER IN AN ACTION OF  CONTRACT, TORT OR  OTHERWISE, ARISING *)
(* FROM,  OUT OF OR  IN  CONNECTION WITH THE  SOFTWARE OR  THE  USE  OR OTHER *)
(* DEALINGS IN THE SOFTWARE.                                                  *)
(*                                                                            *)
(******************************************************************************)

unit container.multiarray;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, container.arraylist, utils.enumerate, utils.functor
  {$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF};

type
  {$IFDEF FPC}generic{$ENDIF} TMultiArray<T; BinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<T, 
    Integer> {$ENDIF}> = class
  public
    type
      TMultiValue = {$IFDEF FPC}specialize{$ENDIF} TArrayList<T, 
        BinaryCompareFunctor>;
  protected
    type
      TContainerUnsortableFunctor = {$IFDEF FPC}specialize{$ENDIF}
        TUnsortableFunctor<TMultiValue>;
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TArrayList<TMultiValue,
        TContainerUnsortableFunctor>;
  public
    type
      { TMultiArrayList iterator. }
      TIterator = TContainer.TIterator;
  public
    constructor Create (ALength : Cardinal = 0);
    destructor Destroy; override;

    { Append new ArrayList to the end of TMultiArray.
      Return True if the request was succesful, false if it was not possible to
      allocate more memory for new entry. }
    function Append (ALength : Cardinal = 0) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Prepend new ArrayList to the beginning of an TMultiArray.
      Return True if the request was succesful, false if it was not possible to
      allocate more memory for new entry. }
    function Prepend (ALength : Cardinal = 0) : Boolean;

    { Remove the entry at the specified location in MultiArray.
      Return true if the request was successful, false if index is not exists. }
    function Remove (AIndex : Cardinal) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Remove a range of entries at the specified location in MultiArray.
      Return true if the request was successful, false is not. }
    function RemoveRange (AIndex : LongInt; ALength : LongInt) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Insert a value at the specified index in MultiArray.
      The index where the new value can be inserted is limited by the size of 
      the MultiArray.
      Returns false if unsuccessful, else true if successful (due to an invalid 
      index or if it was impossible to allocate more memory). }
    function Insert (AIndex : LongInt; ALength : Cardinal = 0) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrive the first entry in MultiArray. }
    function FirstEntry : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrieve the last entry in MultiArray. }
    function LastEntry : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Remove all entries from MultiArray. }
    procedure Clear;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return true if container is empty. }
    function IsEmpty : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    { Get multi value by index.}
    function GetValue (AIndex : LongInt) : {$IFNDEF USE_OPTIONAL}TMultiValue
      {$ELSE}TOptionalMultiValue{$ENDIF};

    { Get container items count. }
    function GetLength : LongInt;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    var
      FContainer : TContainer;
  public
    { Read value in TMultiArray. If index not exists raise
      EIndexOutOfRangeException. }
    property Value [AIndex : LongInt] : {$IFNDEF USE_OPTIONAL}TMultiValue{$ELSE}
      TOptionalMultiValue{$ENDIF} read GetValue;

    { Get TMultiArray length. }
    property Length : LongInt read GetLength;
  end;

implementation

{ TMultiArray }

constructor TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Create(ALength : Cardinal);
begin
  FContainer := TContainer.Create(ALength);
end;

destructor TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}.Destroy;
begin
  FreeAndNil(FContainer);
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Append (ALength : Cardinal) : Boolean;
begin
  Result := FContainer.Append(TMultiValue.Create(ALength));
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Prepend (ALength : Cardinal) : Boolean;
begin
  Result := FContainer.Prepend(TMultiValue.Create(ALength));
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .IsEmpty : Boolean;
begin
  Result := FContainer.IsEmpty;
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .GetValue (AIndex : LongInt) : {$IFNDEF USE_OPTIONAL}TMultiValue{$ELSE}
  TOptionalMultiValue{$ENDIF};
begin
  Result := FContainer.Value[AIndex];
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .GetLength : LongInt;
begin
  Result := FContainer.Length;
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Remove (AIndex : Cardinal) : Boolean;
begin
  Result := FContainer.Remove(AIndex);
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .RemoveRange (AIndex : LongInt; ALength : LongInt) : Boolean;
begin
  Result := FContainer.RemoveRange(AIndex, ALength);
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Insert (AIndex : LongInt; ALength : Cardinal) : Boolean;
begin
  Result := FContainer.Insert(AIndex, TMultiValue.Create(ALength));
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .FirstEntry : TIterator;
begin
  Result := FContainer.FirstEntry;
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .LastEntry : TIterator;
begin
  Result := FContainer.LastEntry;
end;

procedure TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .Clear;
begin
  FContainer.Clear;
end;

function TMultiArray{$IFNDEF FPC}<T, BinaryCompareFunctor>{$ENDIF}
  .GetEnumerator : TIterator;
begin
  Result := FContainer.GetEnumerator;
end;

end.
