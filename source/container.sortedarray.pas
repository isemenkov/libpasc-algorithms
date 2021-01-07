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
  SysUtils{$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF}
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

        { Return current item iterator and move it to next. }
        function GetCurrent : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue
          {$ENDIF}; override;
      public
        { Read/Write sorted array item value. If value not exists raise 
          EIndexOutOfRangeException. }
        property Value : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF} 
          read GetValue;

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
    function Append (AValue : T) : Boolean;

    { Remove a value from a TSortedArray at a specified index while maintaining 
      the sorted property. }
    procedure Remove (AIndex: Cardinal);

    { Remove a range of entities from a TSortedArray while maintaining the 
      sorted property. }
    procedure RemoveRange (AIndex : LongInt; ALength : LongInt);

    { Insert a value into a TSortedArray while maintaining the sorted 
      property. }
    function Insert (AIndex : LongInt; AData : T) : Boolean;

    { Find the index of a value in a TSortedArray. }
    function IndexOf (AData : T) : Integer;

    { Remove all values from a TSortedArray. }
    procedure Clear;

    { Retrive the first entry in a TSortedArray. }
    function FirstEntry : TIterator;

    { Retrive the last entry in a TSortedArray. }
    function LastEntry : TIterator;

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator;
  protected
    { Get value by index. }
    function GetValue (AIndex : LongInt) : {$IFNDEF USE_OPTIONAL}T{$ELSE}
      TOptionalValue{$ENDIF};
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


end.