libPasC-Algorithms
==========
libPasC-Algorithms is object pascal library of common data structures and algorithms. Library rewritten from [c-algorithms](https://github.com/fragglet/c-algorithms) repository and other sources. 

### Table of contents

  * [Requirements](#requirements)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Testing](#testing)
  * [Containers](#conteiners)
    * [TArrayList](#tarraylist)
      * [Examples](#examples)
        * [Create](#create)
        * [Insert](#insert)
        * [Remove](#remove)
        * [Search](#search)
        * [Sort](#sort)
        * [Iterate](#iterate)
    * [TList](#tlist)
      * [Examples](#examples-1)
        * [Create](#create-1)
        * [Insert](#insert-1)
        * [Remove](#remove-1)
        * [Search](#search-1)
        * [Sort](#sort-1)
        * [Iterate](#iterate-1)
    * [TAvlTree](#tavltree)
      * [Examples](#examples-2)
        * [Create](#create-2)
        * [Insert](#insert-2)
        * [Remove](#remove-2)
        * [Iterate](#iterate-2)
    * [THashTable](#thashtable)
    * [TOrderedSet](#torderedset)
    * [TTrie](#ttrie)
    * [TMemoryBuffer](#tmemorybuffer)
  * [Examples](#examples)
    * [TArrayList](#tarraylist-1)
    * [TList](#tlist-1)
    * [TAvlTree](#tavltree-1)
    * [THashTable](#thashtable-1)
    * [TOrderedSet](#torderedset-1)
    * [TTrie](#ttrie-1)
    * [TMemoryBuffer](#tmemorybuffer-1)



### Requirements

* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/) (optional)

Library is tested with latest stable FreePascal Compiler (currently 3.2.0) and Lazarus IDE (currently 2.0.10).



### Installation

Get the sources and add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/libpasc-algorithms`.

Add the unit you want to use to the `uses` clause.



### Testing

A testing framework consists of the following ingredients:
1. Test runner project located in `unit-tests` directory.
2. Test cases (FPCUnit based) for all containers classes. 



### Containers

#### TArrayList

```pascal
uses
  container.arraylist;
  
type
  generic TArrayList<T, BinaryCompareFunctor> = class
```

Automatically resizing array. ArrayList are generic arrays of T which automatically increase in size.

##### Examples

###### Create

```pascal
uses
  container.arraylist, utils.functor;

type
  TIntegerArrayList = specialize TArrayList<Integer, TCompareFunctorInteger>;

var
  arr : TIntegerArrayList;

begin
  arr := TIntegerArrayList.Create;

  FreeAndNil(arr);

  { Create and reserve container for twelve elements. }
  arr := TIntegerArrayList.Create(12);
end;
```

###### Insert

```pascal
  { Add new item at the end. }
  arr.Append(1);

  { Add new item at start position. }
  arr.Prepend(-4);

  { Add item at custom position. }
  arr.Insert(432, 2);
```

###### Remove

```pascal
  { Remove item by index. }
  arr.Remove(1);

  { Remove items range. }
  arr.RemoveRange(0, 3);

  { Remove all items. }
  arr.Clear;
```

###### Search

```pascal
  { Seach element. }
  arr.IndexOf(3);
```

###### Sort

```pascal
  { Sort elements. }
  arr.Sort;
```

###### Iterate

```pascal
var
  iterator : TIntegerArrayList.TIterator;

begin
  { Get first item iterator. }
  iterator := arr.FirstEntry;

  while iterator.HasValue do
  begin
    { Get current value. }
    writeln(iterator.Value);

    { Get next item. }
    iterator := iterator.Next;
  end;
end;
```

```pascal
var
  iterator : TIntegerArrayList.TIterator;

begin
  for iterator in arr do
  begin
    writeln(iterator.Value);
  end;
end;
```


#### TList

```pascal
uses
  container.list;

type
  generic TList<T, BinaryCompareFunctor> = class
```

A doubly-linked list stores a collection of values. Each entry in the list contains a link to the next entry and the previous entry. It is therefore possible to iterate over entries in the list in either direction.

##### Examples

###### Create

```pascal
uses
  container.list, utils.functor;

type
  TStringList = specialize TList<String, TCompareFunctorString>;

var
  list : TStringList;

begin
  list := TStringList.Create;

  FreeAndNil(list);
end;
```

###### Insert

```pascal
  { Add new item at the end. }
  list.Append(4);

  { Add new item at start position. }
  list.Prepend(59);

  { Insert item at next position. }
  list.FirstEntry.InsertNext(7);

  { Insert item at prev position. }
  list.LastEntry.InsertPrev(-4);
```

###### Remove

```pascal
  { Remove all items what have value four. }
  list.Remove(4);

  { Remove custom item. }
  list.FindEntry(2).Remove;
```

###### Search

```pascal
  { Search element by value. }
  list.FindEntry(3);

  { Search element by index. }
  list.NthEntry(1);
```

###### Sort

```pascal
  { Sort elements. }
  list.Sort;
```

###### Iterate

```pascal
var
  iterator : TStringList.TIterator;

begin
  { Get first item iterator. }
  iterator := list.FirstEntry;

  { Get last item iterator. }
  iterator := list.LastEntry;

  while iterator.HasValue do
  begin
    { Get current value. }
    writeln(iterator.Value);

    { Get next item. }
    iterator := iterator.Next;

    { Get previous item. }
    iterator := iterator.Prev;
  end;
end;
```

```pascal
var 
  iterator : TStringList.TIterator;

begin
  for iterator in list do
  begin
    writeln(iterator.Value);
  end;
end;
```



#### TAvlTree

```pascal
uses
  container.avltree;
 
type
  generic TAvlTree<K, V, KeyBinaryCompareFunctor> = class
```

The AVL tree structure is a balanced binary tree which stores a collection of nodes. Each node has a key and a value associated with it. The nodes are sorted within the tree based on the order of their keys. Modifications to the tree are constructed such that the tree remains balanced at all times (there are always roughly equal numbers of nodes on either side of the tree).

Balanced binary trees have several uses. They can be used as a mapping (searching for a value based on its key), or as a set of keys which is always ordered.

##### Examples

###### Create

```pascal
uses
  container.avltree, utils.functor;

type
  TIntStrTree = specialize TAvlTree<Integer, String, TCompareFunctionInteger>;

var
  tree : TIntStrTree;

begin
  tree := TIntStrTree.Create;

  FreeAndNil(tree);
end;
```

###### Insert

```pascal
  { Add new item. }
  tree.Insert(1, "one");

```

###### Remove

```pascal
  { Remove item by key. }
  tree.Remove(1);
```

###### Search

```pascal
  { Search item by key. }
  tree.Search(1);
```

###### Iterate

```pascal
var
  iterator : TIntStrTree.TIterator;

begin
  { Get first item iterator. }
  iterator := tree.FirstEntry;

  { Get current value. }
  writeln(iterator.Key, iterator.Value);

  { Get next item. }
  iterator := iterator.Next;

  { Get prev item. }
  iterator := iterator.Prev; 
end;
```



#### THashTable

```pascal
uses
  container.hashtable;
 
type
  generic THashTable<K, V, KeyBinaryCompareFunctor> = class
```

A hash table stores a set of values which can be addressed by a key. Given the key, the corresponding value can be looked up quickly.



#### TOrderedSet

```pascal
uses
  container.orderedset;

type
  generic TOrderedSet<V, BinaryCompareFunctor> = class
```

A set stores a collection of values. Each value can only exist once in the set.



#### TTrie

```pascal
uses
  container.trie;

type
  generic TTrie<V> = class
```

A trie is a data structure which provides fast mappings from strings to values.



#### TMemoryBuffer

```pascal
uses
  container.memorybuffer;

type
  TMemoryBuffer = class
```

TMemoryBuffer is a useful data structure for storing arbitrary sized blocks of memory. It is guarantees deletion of the memory block when the object is destroyed. This class based on wxWidgets wxMemoryBuffer api interface [https://docs.wxwidgets.org/trunk/classwx_memory_buffer.html](https://docs.wxwidgets.org/trunk/classwx_memory_buffer.html).
