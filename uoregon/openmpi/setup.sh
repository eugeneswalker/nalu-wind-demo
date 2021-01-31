#!/bin/bash -e

SPACK_REF=5af2b1a9338563b4d382a9e12ce70537075c8363
NALU_REF=414e27424ba6861c84a8a894b14062a83ac6ec56

git clone https://github.com/spack/spack
(
 cd spack
 git checkout ${SPACK_REF}
)

. spack/share/spack/setup-env.sh

spack mirror add e4s-local /e4s-cache
spack buildcache keys -it
spack install --cache-only gcc@7.4.0 %gcc@4.8.5 target=ppc64le
spack compiler add $(spack location -i gcc@7.4.0)

cp -r ./netcdf-c spack/var/spack/repos/builtin/packages/
spack -e . concretize -f
time spack -e . install --cache-only

git clone https://github.com/exawind/nalu-wind
(
 cd nalu-wind
 git checkout ${NALU_REF}
 git submodule update --init --recursive
)
