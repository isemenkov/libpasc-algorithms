program libpascalgorithmstestcase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, 
  testcase_arraylist,
  testcase_arraylist_performance,
  testcase_avltree,
  testcase_avltree_performance,
  testcase_binaryheap,
  testcase_hashtable,
  testcase_list,
  testcase_list_performance,
  testcase_memorybuffer,
  testcase_orderedset,
  testcase_queue,
  testcase_queue_performance,
  testcase_sortedarray,
  testcase_sortedarray_performance,
  testcase_trie;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.
