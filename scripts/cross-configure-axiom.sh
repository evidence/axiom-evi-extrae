#!/bin/sh

[ -z "$AXIOMHOME" ] && AXIOMHOME=$HOME/axiom-evi
for arg in "$@";do
    echo "$arg" | grep -q '^--with-axiomhome=' \
	&& AXIOMHOME=$(echo "$arg" | sed 's#^--with-axiomhome=##')
done
[ -f "$AXIOMHOME/scripts/start_qemu.sh" ] || {
    echo "AXIOMHOME shell variable or --with-axiomhome are improperly set!"
    echo "(axiom home used is '$AXIOMHOME')"
    exit 255;
}

OUTPUT_DIR=$AXIOMHOME/output
TARGET_DIR=$(realpath ${OUTPUT_DIR}/target)
SYSROOT_DIR=$(realpath ${OUTPUT_DIR}/staging)
HOST_DIR=$(realpath ${OUTPUT_DIR}/host)

BUILD_ID='x86_64-unknown-linux-gnu'
TARGET_ID='aarch64-buildroot-linux-gnu'

CC="$HOST_DIR/usr/bin/aarch64-buildroot-linux-gnu-gcc" ; export CC
CXX="$HOST_DIR/usr/bin/aarch64-buildroot-linux-gnu-g++" ; export CXX
FC="$HOST_DIR/usr/bin/aarch64-buildroot-linux-gnu-gfortran" ; export FC

PATH=$PATH:$SYSROOT_DIR/usr/bin ; export PATH

[ -z "$PREFIX" ] && PREFIX=$SYSROOT_DIR

../configure --prefix=$PREFIX \
	     --build=$BUILD_ID --host=$TARGET_ID --target=$TARGET_ID \
	     --enable-aarch64 --with-sysroot=$SYSROOT_DIR \
	     --without-binutils --disable-xmltest \
             --enable-nanos --disable-xmltest --without-mpi --without-unwind \
	     --without-dyninst --without-papi \
	     --enable-instrument-dynamic-memory --enable-instrument-io \
	     "$@"
