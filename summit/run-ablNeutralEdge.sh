#!/bin/bash -e

. spack/share/spack/setup-env.sh

spack load nalu-wind

cd nalu-wind/reg_tests/test_files/ablNeutralEdge

jsrun -n1 -a1 abl_mesh -i nalu_abl_mesh.yaml

jsrun -n1 -a1 nalu_preprocess -i nalu_preprocess.yaml

time jsrun -a1 naluX -i ablNeutralEdge.yaml
