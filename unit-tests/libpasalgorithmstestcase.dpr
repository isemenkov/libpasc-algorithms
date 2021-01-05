program libpasalgorithmstestcase;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  container.arraylist in '..\source\container.arraylist.pas',
  container.list in '..\source\container.list.pas',
  container.avltree in '..\source\container.avltree.pas',
  container.orderedset in '..\source\container.orderedset.pas',
  container.hashtable in '..\source\container.hashtable.pas',
  container.memorybuffer in '..\source\container.memorybuffer.pas',
  container.trie in '..\source\container.trie.pas',

  testcase_arraylist in '..\unit-tests\testcase_arraylist.pas',
  testcase_list in '..\unit-tests\testcase_list.pas',
  testcase_avltree in '..\unit-tests\testcase_avltree.pas',
  testcase_orderedset in '..\unit-tests\testcase_orderedset.pas',
  testcase_hashtable in '..\unit-tests\testcase_hashtable.pas',
  testcase_memorybuffer in '..\unit-tests\testcase_memorybuffer.pas',
  testcase_trie in '..\unit-tests\testcase_trie.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

