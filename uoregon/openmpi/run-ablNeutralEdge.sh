#!/bin/bash -e

. spack/share/spack/setup-env.sh

spack load nalu-wind

cd nalu-wind/reg_tests/test_files/ablNeutralEdge
abl_mesh -i nalu_abl_mesh.yaml
nalu_preprocess -i nalu_preprocess.yaml
mpirun --use-hwthread-cpus naluX -i ablNeutralEdge.yaml
