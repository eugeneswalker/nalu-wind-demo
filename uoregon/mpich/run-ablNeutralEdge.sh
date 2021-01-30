#!/bin/bash

. spack/share/spack/setup-env.sh

spack load nalu-wind

cd nalu-wind/reg_tests/test_files/ablNeutralEdge
abl_mesh -i nalu_abl_mesh.yaml
nalu_preprocess -i nalu_preprocess.yaml
mpirun -np 160 naluX -i ablNeutralEdge.yaml
