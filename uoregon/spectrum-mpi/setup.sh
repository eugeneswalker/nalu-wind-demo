#!/bin/bash -e

SPACK_REF=5af2b1a9338563b4d382a9e12ce70537075c8363

git clone https://github.com/spack/spack
(cd spack && git checkout ${SPACK_REF})

. spack/share/spack/setup-env.sh

cp gcc-spack.yaml spack.yaml
spack -e . buildcache keys -it
spack -e . install --cache-only
spack compiler add $(spack location -i gcc@7.4.0)

rm -rf spack.lock spack.yaml .spack-env
cp -r ./netcdf-c spack/var/spack/repos/builtin/packages/
cp nalu-wind-spack.yaml spack.yaml
spack -e . concretize -f | tee nalu-wind.dag
time spack -e . install --cache-only

git clone https://github.com/exawind/nalu-wind
(cd nalu-wind && git submodule update --init --recursive)


