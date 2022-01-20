Intoduction
-----------
[CompCert](http://compcert.inria.fr/) has a special command line
option `-main` since `October 2020`
[commit](https://github.com/AbsInt/CompCert/commit/b1b853a2e9f7f2143fedd58772a702bc9c6a8ba1)
to give the name of the entry point function. This tutorial
provides steps how to setup automatic integration to run [Monocypher](https://monocypher.org/) test suite under
`CompCert` interpreter with or without CI. You need 6GB of free RAM for one run (blake2b is fattest).

Preparation
-----------
Get required soft and environment for `CompCert` compilation:
```
$ cd ~
$ git clone https://github.com/LoupVaillant/Monocypher.git
$ git clone https://github.com/AbsInt/CompCert.git
$ opam init
$ opam switch create 4.07.1
$ eval `opam env`
$ opam install coq
$ opam install menhir
$ mkdir ccomp-ready
$ cd CompCert
$ ./configure --prefix ~/ccomp-ready x86_64-linux
$ make all
$ make install
$ export PATH=$PATH:~/ccomp-ready/bin
$ # check required ccomp binary in $PATH now
$ which ccomp
/home/mpech/ccomp-ready/bin/ccomp
$ ccomp --help | grep "\-main"
  -main <name>   Start executing at function <name> instead of main()
```

Run
---
Copy script `compcert.sh` from this repo to `tests/` dir in Monocypher's repo.
Script will create run dir, copy and modify required files to run interpreter.
```
$ cp ~/monocypher-compcert/compcert.sh  ~/Monocypher/tests
$ cp ~/monocypher-compcert/ccomp-main.c ~/Monocypher/tests
$ cd ~/Monocypher/tests
$ chmod 755 compcert.sh
$ sh ./compcert.sh
+ set -x
+ mkdir -p compcert
+ cp ../src/monocypher.c ../src/monocypher.h ../src/optional/monocypher-ed25519.c ../src/optional/monocypher-ed25519.h ccomp-main.c compcert
+ cd compcert
+ sed -ie '/static size_t align/,+3 s/^/\/\//' monocypher.c
+ sed -ie '/define FOR(/s/^/\/\//' monocypher.c
+ cat monocypher-ed25519.c monocypher.c ccomp-main.c
+ ccomp -interp -quiet -main p1305 mono.c
+ ccomp -interp -quiet -main blake2b mono.c
+ ccomp -interp -quiet -main verify mono.c
+ ccomp -interp -quiet -main wipe mono.c
+ ccomp -interp -quiet -main lock_unlock mono.c
+ ccomp -interp -quiet -main argon mono.c
+ ccomp -interp -quiet -main key_exchange mono.c
+ ccomp -interp -quiet -main sign_check mono.c
+ ccomp -interp -quiet -main from_eddsa mono.c
+ ccomp -interp -quiet -main hidden mono.c
+ ccomp -interp -quiet -main hchacha mono.c
+ ccomp -interp -quiet -main chacha mono.c
+ ccomp -interp -quiet -main xchacha mono.c
+ ccomp -interp -quiet -main ietf_chacha_ctr mono.c
+ ccomp -interp -quiet -main x25519 mono.c
+ ccomp -interp -quiet -main dirty mono.c
+ ccomp -interp -quiet -main inverse mono.c
+ ccomp -interp -quiet -main sha512 mono.c
+ ccomp -interp -quiet -main hmac mono.c
+ ccomp -interp -quiet -main sign_check_ed25519 mono.c
+ echo "All OK"
All OK
$
```
