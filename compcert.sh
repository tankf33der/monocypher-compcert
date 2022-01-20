#!/bin/sh -x

set -x

mkdir -p compcert
cp ../src/monocypher.c                     \
    ../src/monocypher.h                    \
    ../src/optional/monocypher-ed25519.c   \
    ../src/optional/monocypher-ed25519.h   \
    ccomp-main.c                           \
    compcert
cd compcert
sed -ie '/static size_t align/,+3 s/^/\/\//' monocypher.c
sed -ie '/define FOR(/s/^/\/\//' monocypher.c
rm -rf *.ce
cat monocypher-ed25519.c  \
    monocypher.c ccomp-main.c > mono.c
ccomp -interp -quiet -main p1305                mono.c && \
ccomp -interp -quiet -main blake2b              mono.c && \
ccomp -interp -quiet -main verify               mono.c && \
ccomp -interp -quiet -main wipe                 mono.c && \
ccomp -interp -quiet -main lock_unlock          mono.c && \
ccomp -interp -quiet -main argon                mono.c && \
ccomp -interp -quiet -main key_exchange         mono.c && \
ccomp -interp -quiet -main sign_check           mono.c && \
ccomp -interp -quiet -main from_eddsa           mono.c && \
ccomp -interp -quiet -main hidden               mono.c && \
ccomp -interp -quiet -main hchacha              mono.c && \
ccomp -interp -quiet -main chacha               mono.c && \
ccomp -interp -quiet -main xchacha              mono.c && \
ccomp -interp -quiet -main ietf_chacha_ctr      mono.c && \
ccomp -interp -quiet -main x25519               mono.c && \
ccomp -interp -quiet -main dirty                mono.c && \
ccomp -interp -quiet -main inverse              mono.c && \
ccomp -interp -quiet -main sha512               mono.c && \
ccomp -interp -quiet -main hmac                 mono.c && \
ccomp -interp -quiet -main sign_check_ed25519   mono.c && \
echo "All OK"
