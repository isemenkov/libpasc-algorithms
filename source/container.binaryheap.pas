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
  SysUtils{$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF}, utils.enumerate
  {$IFNDEF FPC}, utils.functor{$ENDIF};

type
  TBinaryHeapType = (
    { A minimum heap. }
    BINARY_HEAP_TYPE_MIN,

    { A maximum heap. }
    BINARY_HEAP_TYPE_MAX
  );

  { Heap type. If a heap is a min heap, the values with the lowest priority are
    stored at the top of the heap and will be the first returned. If a heap is a 
    max heap, the values with the greatest priority are stored at the top of 
    the heap. }
  {$IFDEF FPC}generic{$ENDIF} TBinaryHeap<T; BinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<T,
    Integer>{$ENDIF}; HeapType{$IFNDEF FPC}: TBinaryHeapType{$ENDIF}> = class
  protected
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
    function Insert (AValue : V) : Boolean;

    { Remove the first value from a binary heap. }
    function Pop : V;

    { Find the number of values stored in a binary heap. }
    function NumEntries : Cardinal;
  protected
    function CompareData (AData1, AData2 : V) : Integer;
  protected
    FHeapType : TBinaryHeapType;
    FData : array of PData;
    FLength : Cardinal;
    FAlloced : Cardinal;
    FCompareFunctor : BinaryCompareFunctor;
  end;

implementation

{ TBinaryHeap }

constructor TBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor, HeapType>{$ENDIF}
  .Create (ALength : Cardinal);
begin
  if ALength = 0 then
  begin
    ALength := 16;
  end;

  SetLength(FData, ALength);
  FAlloced := ALength;
  FLength := 0;
  FHeapType := HeapType;
  FCompareFunctor := BinaryCompareFunctor.Create;
end;

destructor TBinaryHeap{$IFNDEF FPC}<T, BinaryCompareFunctor, HeapType>{$ENDIF}
  .Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

end.
  