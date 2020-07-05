libPasC-Algorithms
==========
libPasC-Algorithms is object pascal library of common data structures and algorithms. Library rewritten from [c-algorithms](https://github.com/fragglet/c-algorithms) repository. 

##### TArrayLists

```pascal
uses
  arraylists;
  
type
  generic TArrayLists<T> = class
```

Automatically resizing array. ArrayLists are generic arrays of T which automatically increase in size.

##### TList

```pascal
uses
  list;

type
  generic TList<T> = class
```

A doubly-linked list stores a collection of values. Each entry in the list contains a link to the next entry and the previous entry. It is therefore possible to iterate over entries in the list in either direction.