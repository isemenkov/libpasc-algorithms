#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking /home/ixaker/code/libpasc-algorithms/unit-tests/libpascalgorithmstestcase
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2     -L. -o /home/ixaker/code/libpasc-algorithms/unit-tests/libpascalgorithmstestcase -T /home/ixaker/code/libpasc-algorithms/unit-tests/link.res -e _start
if [ $? != 0 ]; then DoExitLink /home/ixaker/code/libpasc-algorithms/unit-tests/libpascalgorithmstestcase; fi
IFS=$OFS
