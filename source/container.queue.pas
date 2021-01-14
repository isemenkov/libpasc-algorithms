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

unit container.queue;

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
  { A double ended queue stores a list of values in order. New values can be 
    added and removed from either end of the queue. }
  {$IFDEF FPC}generic{$ENDIF} TQueue<T> = class
  protected

  public
    constructor Create;
    destructor Destroy;

    { Add a value to the head of a queue. }
    function PushHead (AData : T) : Boolean;

    { Remove a value from the head of a queue. }
    function PopHead : T;

    { Read value from the head of a queue, without removing it from the queue. }
    function PeekHead : T;

    { Add a value to the tail of a queue. }
    function PushTail (AData : T) : Boolean;

    { Remove a value from the tail of a queue. }
    function PopTail : T;

    { Read a value from the tail of a queue, without removing it from the 
      queue. }
    function PeekTail : T;

    { Query if any values are currently in a queue. }
    function IsEmpty : Boolean;
  end;

implementation

{ TQueue }

end.