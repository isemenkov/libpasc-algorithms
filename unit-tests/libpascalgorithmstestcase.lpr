program libpascalgorithmstestcase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testcase_arraylist,
  testcase_arraylist_performance, testcase_multiarray, testcase_avltree,
  testcase_avltree_performance, testcase_binaryheap, testcase_hashtable,
  testcase_hashtable_performance, testcase_multihash, testcase_list,
  testcase_list_performance, testcase_memorybuffer, testcase_orderedset,
  testcase_orderedset_performance, testcase_queue, testcase_queue_performance,
  testcase_sortedarray, testcase_sortedarray_performance, testcase_trie,
  container.multiarray, container.multihash, utils.api.cstring, utils.enumerate;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.
