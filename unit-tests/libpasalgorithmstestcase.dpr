program libpasalgorithmstestcase;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  container.arraylist in '..\source\container.arraylist.pas',
  container.multiarray in '..\source\container.multiarray.pas',
  container.list in '..\source\container.list.pas',
  container.avltree in '..\source\container.avltree.pas',
  container.orderedset in '..\source\container.orderedset.pas',
  container.hashtable in '..\source\container.hashtable.pas',
  container.multihash in '..\source\container.multihash.pas',
  container.memorybuffer in '..\source\container.memorybuffer.pas',
  container.trie in '..\source\container.trie.pas',
  container.sortedarray in '..\source\container.sortedarray.pas',
  container.binaryheap in '..\source\container.binaryheap.pas',
  container.queue in '..\source\container.queue.pas',
  testcase_arraylist in '..\unit-tests\src\testcase_arraylist.pas',
  testcase_arraylist_performance in '..\unit-tests\src\testcase_arraylist_performance.pas',
  testcase_multiarray in '..\unit-tests\src\testcase_multiarray.pas',
  testcase_list in '..\unit-tests\src\testcase_list.pas',
  testcase_list_performance in '..\unit-tests\src\testcase_list_performance.pas',
  testcase_avltree in '..\unit-tests\src\testcase_avltree.pas',
  testcase_avltree_performance in '..\unit-tests\src\testcase_avltree_performance.pas',
  testcase_orderedset in '..\unit-tests\src\testcase_orderedset.pas',
  testcase_orderedset_performance in '..\unit-tests\src\testcase_orderedset_performance.pas',
  testcase_hashtable in '..\unit-tests\src\testcase_hashtable.pas',
  testcase_hashtable_performance in '..\unit-tests\src\testcase_hashtable_performance.pas',
  testcase_multihash in '..\unit-tests\src\testcase_multihash.pas',
  testcase_memorybuffer in '..\unit-tests\src\testcase_memorybuffer.pas',
  testcase_trie in '..\unit-tests\src\testcase_trie.pas',
  testcase_sortedarray in '..\unit-tests\src\testcase_sortedarray.pas',
  testcase_binaryheap in '..\unit-tests\src\testcase_binaryheap.pas',
  testcase_queue in '..\unit-tests\src\testcase_queue.pas',
  testcase_queue_performance in '..\unit-tests\src\testcase_queue_performance.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.