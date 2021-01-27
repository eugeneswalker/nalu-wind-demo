#!/bin/bash

module purge

. /ccs/home/lpeyrala/spack-nalu/share/spack/setup-env.sh

spack load nalu-wind

TEST_ROOT=${1}
TEST_NAME=${2}

cd ${TEST_ROOT}/${TEST_NAME}
naluX -i ${TEST_NAME}.yaml >/dev/null 2>&1
