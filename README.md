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

##### TAvlTree

```pascal
uses
  avl_tree;
 
type
  generic TAvlTree<K, V> = class
```

The AVL tree structure is a balanced binary tree which stores a collection of nodes. Each node has a key and a value associated with it. The nodes are sorted within the tree based on the order of their keys. Modifications to the tree are constructed such that the tree remains balanced at all times (there are always roughly equal numbers of nodes on either side of the tree).

Balanced binary trees have several uses. They can be used as a mapping (searching for a value based on its key), or as a set of keys which is always ordered.