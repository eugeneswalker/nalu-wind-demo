#!/bin/bash -e

SPACK_REF=5af2b1a9338563b4d382a9e12ce70537075c8363
NALU_REF=414e27424ba6861c84a8a894b14062a83ac6ec56

if [ ! -d spack ] ; then
  echo Cloning Spack@${SPACK_REF}
  git clone https://github.com/spack/spack
  (cd spack && git checkout ${SPACK_REF})
else
  echo Spack cloned
fi

. spack/share/spack/setup-env.sh

echo Configuring Spack to use E4S Build Cache
spack mirror rm E4S >/dev/null 2>&1 || :
spack mirror add E4S https://cache.e4s.io/nalu
[ ! -f e4s.pub ] && wget https://oaciss.uoregon.edu/e4s/e4s.pub
spack gpg trust e4s.pub

#echo Installing GCC@7.4.0
#spack install --cache-only gcc@7.4.0 %gcc@4.8.5 target=x86_64
#spack compiler add $(spack location -i gcc@7.4.0)

spack -e . concretize -f | tee nw.dag

echo Installing nalu-wind from cache
time spack -e . install --cache-only

if [ ! -d nalu-wind ]; then
  echo Cloning exawind/nalu-wind@${NALU_REF}
  git clone https://github.com/exawind/nalu-wind
  (cd nalu-wind && git checkout ${NALU_REF} && git submodule update --init --recursive)
else
  echo Exawind/nalu-wind cloned
fi
