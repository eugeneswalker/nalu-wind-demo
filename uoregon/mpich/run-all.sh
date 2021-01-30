#!/bin/bash -e

nalu_source_root=${NALU_SOURCE_ROOT:-$(pwd)/nalu-wind}
testroot=${nalu_source_root}/reg_tests/test_files
wd=$(pwd)
testfile=${wd}/test-results.txt

for t in $(cat test-list.txt) ; do
  n=$(echo $t | cut -d: -f1)
  np=$(echo $t | cut -d: -f2)
  (
    cd ${testroot}/${n}
    mpirun -np ${np} naluX -i ${n}.yaml >/dev/null 2>&1
    ../../pass_fail.py ${n} ${n}.norm.gold | tee -a ${testfile} || :
  )
done

sort -o ${testfile} ${testfile}
