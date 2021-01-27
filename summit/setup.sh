#!/bin/bash

SPACK_REF=5af2b1a9338563b4d382a9e12ce70537075c8363

#git clone https://github.com/spack/spack
(
 cd spack
 git checkout ${SPACK_REF}
 . share/spack/setup-env.sh
)

spack -e . buildcache keys -it

spack -e . concretize -f | tee concretize.log

for i in {1..5} ; do
 spack -e . install --cache-only &
done
