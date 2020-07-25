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

unit hash_table;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils;

type
  { A hash table stores a set of values which can be addressed by a key. Given 
    the key, the corresponding value can be looked up quickly. }
  generic THashTable<K, V> = class  
  public
    { Create a new hash table. }
    constructor Create;

    { Destroy a hash table. }
    destructor Destroy; override;
  protected
    type
      THashTablePair = record
        key : K;
        value : V;  
      end;  

      PPHashTableEntry = ^PHashTableEntry;  
      PHashTableEntry = ^THashTableEntry;
      THashTableEntry = record
        pair : THashTablePair;
        next : PHashTableEntry;
      end;  

      THashTableStruct = record
        table : PPHashTableEntry;
        table_size : Cardinal;

        entries : Cardinal;
        prime_index : Cardinal;
      end;  

          
  end;  

implementation

end.