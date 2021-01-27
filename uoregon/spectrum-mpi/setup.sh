#!/bin/bash -e

SPACK_REF=5af2b1a9338563b4d382a9e12ce70537075c8363

git clone https://github.com/spack/spack
(cd spack && git checkout ${SPACK_REF})

. spack/share/spack/setup-env.sh

cp compiler-spack.yaml spack.yaml
spack -e . install --cache-only
spack compiler add $(spack location -i gcc@7.4.0)

cp -r ./netcdf-c spack/var/spack/repos/builtin/packages/
cp nalu-wind-spack.yaml spack.yml
spack -e . buildcache keys -it
spack -e . concretize -f | tee concretize.log
time spack -e . install
