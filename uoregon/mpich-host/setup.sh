#!/bin/bash -e

SPACK_REF=5af2b1a9338563b4d382a9e12ce70537075c8363
NALU_REF=414e27424ba6861c84a8a894b14062a83ac6ec56

git clone https://github.com/spack/spack
(cd spack && git checkout ${SPACK_REF})

. spack/share/spack/setup-env.sh

spack mirror add e4s-local /e4s-cache || :

spack buildcache keys -it
time spack install --cache-only gcc@7.4.0%gcc@4.8.5 target=ppc64le
spack compiler add $(spack location -i gcc@7.4.0)

spack -e . concretize -f | tee nalu-wind.dag
time spack -e . install --cache-only

git clone https://github.com/exawind/nalu-wind
(
 cd nalu-wind
 git checkout ${NALU_REF}
 git submodule update --init --recursive
)

cd nalu-wind/reg_tests/test_files/ablNeutralEdge
spack load nalu-wind
abl_mesh -i nalu_abl_mesh.yaml
nalu_preprocess -i nalu_preprocess.yaml
mpirun -np 160 naluX -i ablNeutralEdge.yaml
