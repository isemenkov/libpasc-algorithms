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

unit list;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils;

type
  { List item value not exists. }
  EValueNotExistsException = class(Exception);

  { Doubly-linked list.
    A doubly-linked list stores a collection of values. Each entry in the list 
    (represented by a pointer a @ref ListEntry structure) contains a link to the 
    next entry and the previous entry. It is therefore possible to iterate over 
    entries in the list in either direction. }
  generic TList<T> = class
  protected
    type
      { TList pointer type. }
      PList = ^(specialize TList<T>);

      { TList item entry type. }
      PListEntry = ^TListEntry;
      TListEntry = record
        Value : T;
        Prev : PListEntry;
        Next : PListEntry; 
      end;
  public
    type
      { TList iterator. }
      TIterator = class
      public
        { Create new iterator for list item entry. }
        constructor Create (AList : PList; AItem : PListEntry);

        { Retrieve the previous entry in a list. }
        function Prev : TIterator;

        { Retrieve the next entry in a list. }
        function Next : TIterator;

        { Remove an entry from a list. }
        procedure Remove;
      protected
        { Get item value. }
        function GetValue : T;

        { Set new item value. }
        procedure SetValue (AValue : T);
      protected
        var
          FList : PList;
          FItem : PListEntry;
      public
        { Read/Write list item value. If value not exists raise 
          EValueNotExistsException. }
        property Value : T read GetValue write SetValue;
      end;
  public
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
  protected
    var
      FFirstNode : PListEntry;
      FLastNode : PListEntry;     
      FLength : Cardinal;
  public
    { Get List length. }
    property Length : Cardinal read FLength;  
  end;

implementation

constructor TList.TIterator.Create (AList : PList; AItem : PListEntry);
begin
  FList := AList;
  FItem := AItem;
end;

function TList.TIterator.Prev : TIterator;
begin
  if FItem = nil then
  begin
    Result := TIterator.Create(nil);
    Exit;
  end;

  Result := TIterator.Create(FItem.Prev);
end;

function TList.TIterator.Next : TIterator;
begin
  if FItem = nil then
  begin
    Result := TIterator.Create(nil);
    Exit;
  end;

  Result := TIterator.Create(FItem.Next);
end;

procedure TList.TIterator.Remove;
begin
  { If the entry is NULL, always fail }
  if FItem = nil then
  begin
    Exit;
  end;

  { Action to take is different if the entry is the first in the list }
  if FItem.Prev = nil then
  begin
    FList.FFirstNode := FItem.Next;

    {  Update the second entry's prev pointer, if there is a second entry }
    if FItem.Next <> nil then
    begin  
      FItem.Next.Prev := nil;
    end;
  end else
  begin
    { This is not the first in the list, so we must have a previous entry. 
      Update its 'next' pointer to the new value }
    FItem.Prev.Next := FItem.Next;

    { If there is an entry following this one, update its 'prev' pointer to the 
      new value }
    if FItem.Next <> nil then
    begin
      FItem.Next.Prev := FItem.Prev;
    end;
  end;

  { Free the list entry }
  FreeAndNil(FItem);
end;

function TList.TIterator.GetValue : T;
begin
  if FItem = nil then
  begin
    raise EValueNotExistsException.Create('Value not exists.');
  end;

  Result := FItem.Value;
end;

procedure TList.TIterator.SetValue (AValue : T);
begin
  if FItem <> nil then
  begin
    FItem.Value := AValue;
  end;
end;

end.