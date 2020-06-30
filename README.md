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