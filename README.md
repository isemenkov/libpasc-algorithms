libPasC-Algorithms
==========

libPasC-Algorithms is delphi and object pascal library of common data structures and algorithms. The library is based on the [c-algorithms](https://github.com/fragglet/c-algorithms) repository and it is a set of containers adapted for the Pascal language and the template system available on it.

### Table of contents

  * [Requirements](#requirements)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Testing](#testing)
  * [Containers](#conteiners)
    * [TArrayList](#tarraylist)
    * [TSortedArray](#tsortedarray)
    * [TList](#tlist)
    * [TAvlTree](#tavltree)
    * [THashTable](#thashtable)
    * [TOrderedSet](#torderedset)
    * [TMinBinaryHeap](#tminbinaryheap)
    * [TMaxBinaryHeap](#tmaxbinaryheap)
    * [TTrie](#ttrie)
    * [TQueue](#tqueue)
    * [TMemoryBuffer](#tmemorybuffer)



### Requirements

* [Embarcadero (R) Rad Studio](https://www.embarcadero.com)
* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/)



Library is tested for 

- Embarcadero (R) Delphi 10.3 on Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)
- FreePascal Compiler (3.2.0) and Lazarus IDE (2.0.10) on Ubuntu Linux 5.8.0-33-generic x86_64



### Installation

Get the sources and add the *source* directory to the project search path. For FPC add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/libpasc-algorithms`.

Add the unit you want to use to the `uses` clause.



### Testing

A testing framework consists of the following ingredients:
1. Test runner project located in `unit-tests` directory.
2. Test cases (DUnit for Delphi and FPCUnit for FPC based) for all containers classes. 



### Containers

#### TArrayList

TArrayList are generic arrays of T which automatically increase in size.

```pascal
uses
  container.arraylist, utils.functor;
  
type
  generic TArrayList<T, BinaryCompareFunctor> = class
```

BinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two array items. Needed for sort and search functions.

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#remove)
  * [Search](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#search)
  * [Sort](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#sort)
  * [Values](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#values)
  * [Length](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#length)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#isempty)
  * [Iterate](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList#iterate)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TArrayList).



#### TSortedArray

The TSortedArray is an automatically resizing array which stores its elements in sorted order. User defined functor determine the sorting order. All operations on a TSortedArray maintain the sorted property. Most operations are done in O(n) time, but searching can be done in O(log n) worst case.

```pascal
uses
  container.sortedarray, utils.functor;
  
type
  generic TSortedArray<T, BinaryCompareFunctor> = class
```

BinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two array items. Needed for search function.

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#create)
  * [Append](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#append)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#remove)
  * [Search](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#search)
  * [Values](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#values)
  * [Length](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#length)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#isempty)
  * [Iterate](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray#iterate)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TSortedArray).



#### TList

A doubly-linked list stores a collection of values. Each entry in the list contains a link to the next entry and the previous entry. It is therefore possible to iterate over entries in the list in either direction.

```pascal
uses
  container.list, utils.functor;

type
  generic TList<T, BinaryCompareFunctor> = class
```

BinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two list items. Needed for sort and search functions.

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#remove)
  * [Search](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#search)
  * [Sort](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#sort)
  * [Length](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#length)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#isempty)
  * [Iterate](https://github.com/isemenkov/libpasc-algorithms/wiki/TList#iterate)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TList).



#### TAvlTree

The AVL tree structure is a balanced binary tree which stores a collection of nodes. Each node has a key and a value associated with it. The nodes are sorted within the tree based on the order of their keys. Modifications to the tree are constructed such that the tree remains balanced at all times (there are always roughly equal numbers of nodes on either side of the tree).

Balanced binary trees have several uses. They can be used as a mapping (searching for a value based on its key), or as a set of keys which is always ordered.

```pascal
uses
  container.avltree;
 
type
  generic TAvlTree<K, V, KeyBinaryCompareFunctor> = class
```

KeyBinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two keys. 

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree#remove)
  * [Search](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree#search)
  * [NumEntries](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree#numentries)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree#isempty)
  * [Iterate](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree#iterate)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TAvlTree).



#### THashTable

A hash table stores a set of values which can be addressed by a key. Given the key, the corresponding value can be looked up quickly.

```pascal
uses
  container.hashtable, utils.functor;
 
type
  generic THashTable<K, V, KeyBinaryCompareFunctor> = class
```

KeyBinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two keys. 

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable#remove)
  * [Search](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable#search)
  * [NumEntries](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable#numentries)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable#isempty)
  * [Iterate](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable#iterate)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/THashTable).



#### TOrderedSet

A set stores a collection of values. Each value can only exist once in the set.

```pascal
uses
  container.orderedset, utils.functor;

type
  generic TOrderedSet<V, BinaryCompareFunctor> = class
```

BinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two items.

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#remove)
  * [HasValue](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#hasvalue)
  * [NumEntries](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#numentries)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#isempty)
  * [Union](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#union)
  * [Intersection](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#intersection)
  * [Iterate](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet#iterate)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TOrderedSet).



#### TMinBinaryHeap

Heap type. The values with the lowest priority are stored at the top of the heap and will be the first returned.

```pascal
uses
  container.binaryheap, utils.functor;

type
  generic TMinBinaryHeap<V, BinaryCompareFunctor> = class
```

BinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two items.

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TMinBinaryHeap#create)
  * [Append](https://github.com/isemenkov/libpasc-algorithms/wiki/TMinBinaryHeap#append)
  * [Pop](https://github.com/isemenkov/libpasc-algorithms/wiki/TMinBinaryHeap#pop)
  * [NumEntries](https://github.com/isemenkov/libpasc-algorithms/wiki/TMinBinaryHeap#numentries)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TMinBinaryHeap#isempty)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TMinBinaryHeap).



#### TMaxBinaryHeap

Heap type. The values with the greatest priority are stored at the top of the heap and will be the first returned.

```pascal
uses
  container.binaryheap, utils.functor;

type
  generic TMaxBinaryHeap<V, BinaryCompareFunctor> = class
```

BinaryCompareFunctor is based on [utils.functor.TBinaryFunctor](https://github.com/isemenkov/pascalutils/wiki/TBinaryFunctor) interface and used to compare two items.

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TMaxBinaryHeap#create)
  * [Append](https://github.com/isemenkov/libpasc-algorithms/wiki/TMaxBinaryHeap#append)
  * [Pop](https://github.com/isemenkov/libpasc-algorithms/wiki/TMaxBinaryHeap#pop)
  * [NumEntries](https://github.com/isemenkov/libpasc-algorithms/wiki/TMaxBinaryHeap#numentries)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TMaxBinaryHeap#isempty)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TMaxBinaryHeap).



#### TTrie

A trie is a data structure which provides fast mappings from strings to values.

```pascal
uses
  container.trie;

type
  generic TTrie<V> = class
```

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TTrie#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/TTrie#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TTrie#remove)
  * [Search](https://github.com/isemenkov/libpasc-algorithms/wiki/TTrie#search)
  * [NumEntries](https://github.com/isemenkov/libpasc-algorithms/wiki/TTrie#numeentries)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TTrie#isempty)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TTrie).



#### TQueue

A double ended queue stores a list of values in order. New values can be added and removed from either end of the queue.

```pascal
uses
  container.queue;

type
  generic TQueue<T> = class
```

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TQueue#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/TQueue#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TQueue#remove)
  * [Values](https://github.com/isemenkov/libpasc-algorithms/wiki/TQueue#values)
  * [NumEntries](https://github.com/isemenkov/libpasc-algorithms/wiki/TQueue#numentries)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TQueue#isempty)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TQueue).



#### TMemoryBuffer

TMemoryBuffer is a useful data structure for storing arbitrary sized blocks of memory. It is guarantees deletion of the memory block when the object is destroyed. This class based on wxWidgets wxMemoryBuffer api interface [https://docs.wxwidgets.org/trunk/classwx_memory_buffer.html](https://docs.wxwidgets.org/trunk/classwx_memory_buffer.html).

```pascal
uses
  container.memorybuffer;

type
  TMemoryBuffer = class
```

  * [Create](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer#create)
  * [Insert](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer#insert)
  * [Remove](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer#remove)
  * [Resize](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer#resize)
  * [Values](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer#values)
  * [Length](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer#length)
  * [IsEmpty](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer#isempty)

*More details read on* [wiki page](https://github.com/isemenkov/libpasc-algorithms/wiki/TMemoryBuffer).