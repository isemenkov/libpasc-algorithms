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
  { Doubly-linked list.
    A doubly-linked list stores a collection of values. Each entry in the list 
    (represented by a pointer a @ref ListEntry structure) contains a link to the 
    next entry and the previous entry. It is therefore possible to iterate over 
    entries in the list in either direction. }
  generic TList<T> = class
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

    { Retrieve the next entry in a list. 
      The next entry in the list, or nil if this was the last entry in the 
      list. }
    function Next : T;
  protected
    type
      PListEntry = ^TListEntry;
      TListEntry = record
        Value : T;
        Prev : PListEntry;
        Next : PListEntry; 
      end;
    var
      FHead : PListEntry;
      FCurrent : PListEntry;       
  end;

implementation


end.