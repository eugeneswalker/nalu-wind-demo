#!/bin/bash

MIRROR="${1}"

spack find -l | sed -ne '/^[[:alnum:]]\{7\} /p' > i.s

python - <<EOF
fs=open('i.s').read().split("\n")[:-1]
s=['/{}'.format(x.split()[0]) for x in fs]
open('i.s','w').write('\n'.join(s))
EOF

for h in `cat i.s`; do
  spack buildcache create -af --key prl --only package -m "${MIRROR}" "${h}"
done 
