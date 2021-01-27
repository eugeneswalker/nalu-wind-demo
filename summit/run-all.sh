#!/bin/bash -e

nalu_source_root=${NALU_SOURCE_ROOT:-$MEMBERWORK/gen010/nalu-wind/nalu-wind}
testroot=${nalu_source_root}/reg_tests/test_files

for t in $(cat test-list.txt) ; do
  n=$(echo $t | cut -d: -f1)
  np=$(echo $t | cut -d: -f2)
  jsrun -p ${np} ./run-one.sh ${testroot} ${n} ${np}
  (
    cd ${testroot}/${n}
    ../../pass_fail.py ${n} ${n}.norm.gold | tee -a test-results.txt || :
  )
done

sort -o test-results.txt test-results.txt