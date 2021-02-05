#!/bin/bash -e

SPACK_REF=5af2b1a9338563b4d382a9e12ce70537075c8363
NALU_REF=414e27424ba6861c84a8a894b14062a83ac6ec56

if [ ! -d spack ]; then
  git clone https://github.com/spack/spack
  (
  cd spack
  git checkout ${SPACK_REF}
  )
else
  echo "Spack is checked out"
fi

. spack/share/spack/setup-env.sh
gccloaded=`spack compiler list | grep gcc@7.4.0 | wc -l`
if [ $gccloaded -eq 0 ]; then
  mkdir -p ~/.spack/linux
  [ ! -f ~/.spack/linux/compilers.yaml ] && echo compilers: > ~/.spack/linux/compilers.yaml
  cat gcc-7.4.0-summit.compiler.yaml >> ~/.spack/linux/compilers.yaml
else
  echo "gcc/7.4.0 module is loaded in Spack"
fi

E4Sloaded=`spack mirror list | grep E4S | wc -l`
if [ $E4Sloaded -eq 0 ]; then
  spack mirror add E4S https://cache.e4s.io 
  /bin/rm -f e4s.pub
  wget https://oaciss.uoregon.edu/e4s/e4s.pub
  spack gpg trust e4s.pub
else
  echo "E4S mirror is loaded in Spack"
fi

#spack install --cache-only gcc@7.4.0 %gcc@4.8.5 target=ppc64le
#spack compiler add $(spack location -i gcc@7.4.0)

cp -r ./netcdf-c spack/var/spack/repos/builtin/packages/
spack -e . concretize -f > nw.dag
time spack -e . install --cache-only

if [ ! -d nalu-wind ]; then
  git clone https://github.com/exawind/nalu-wind
  (
   cd nalu-wind
   git checkout ${NALU_REF}
   git submodule update --init --recursive
  )
fi
