#!/bin/bash -e

if [ $# -ne 1 ] ; then
  echo "Usage: ${0} <nalu-source-dir>"
  exit 1
fi

NALU_SOURCE_DIR=$1
TEST_FILE_DIR=${NALU_SOURCE_DIR}/reg_tests/test_files

for t in $(cat test-list.txt) ; do
  name=$(echo $t | cut -d: -f1)
  np=$(echo $t | cut -d: -f2)
  (
    cd "$TEST_FILE_DIR/${name}" ;
    mpirun -np ${np} naluX -i ${name}.yaml >/dev/null 2>&1
    ../../pass_fail.py ${name} ${name}.norm.gold || :
  )
done
