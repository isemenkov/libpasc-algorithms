program libpascalgorithmstestcase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testcase_arraylist, testcase_list,
  testcase_avltree, testcase_orderedset, testcase_hashtable,
  testcase_memorybuffer, testcase_trie, utils.functional, testcase_sortedarray,
  testcase_binaryheap, testcase_queue;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

