#!/bin/sh

# usage
# AXIOM_DIR=... PREFIX=... ROOTFS=... LINARO=... ./aarch64-configure-axiom.sh

BASEDIR=$(dirname "$0")

#default AXIOM_DIR
[ -z "$AXIOM_DIR" ] && AXIOM_DIR=$HOME/axiom-evi

# check AXIOM_DIR
[ -f "$AXIOM_DIR/scripts/configure.mk" ] || {
    echo "AXIOM_DIR shell improperly set!"
    echo "(axiom dir used is '$AXIOM_DIR')"
    exit 255;
}

# default PREFIX
[ -z "$PREFIX" ] && PREFIX=/usr

# check LINARO and ROOTFS
[ -z "$ROOTFS" ] && echo "ROOTFS env variable not set!" && exit -1
[ -z "$LINARO" ] && echo "LINARO env variable not set!" && exit -1

BUILD_ID='x86_64-unknown-linux-gnu'
TARGET_ID='aarch64-linux-gnu'

TARGET_DIR=$(realpath ${ROOTFS})
SYSROOT_DIR=$(realpath ${ROOTFS})
HOST_DIR=$(realpath ${LINARO}/host)

export PATH=$PATH:$HOST_DIR/usr/bin    
export XML2_CONFIG="$(realpath ${ROOTFS}/usr/bin/xml2-config)"        

# NOTE:
#
# these env variable are required to compile BUT if they are used thorught
# the configure script they do not work; it seems that they must passed during
#the make invocation :-(
#
#export CFLAGS="--sysroot=${ROOTFS} -I${ROOTFS}/usr/include/aarch64-linux-gnu -L${ROOTFS}/usr/lib/aarch64-linux-gnu -L${ROOTFS}/lib/aarch64-linux-gnu -fPIE"
#export LDFLAGS="--sysroot=${ROOTFS} -L${ROOTFS}/usr/lib/aarch64-linux-gnu -L${ROOTFS}/lib/aarch64-linux-gnu -Wl,-rpath-link -Wl,${ROOTFS}/usr/lib/aarch64-linux-gnu -Wl,-rpath-link -Wl,${ROOTFS}/lib/aarch64-linux-gnu --shared"

echo $BASEDIR/../configure --prefix=$PREFIX \
	     --build=$BUILD_ID --host=$TARGET_ID --target=$TARGET_ID \
	     --enable-aarch64 --with-sysroot=$SYSROOT_DIR \
	     --with-gnu-ld --without-binutils --disable-xmltest \
             --enable-nanos --without-mpi --without-unwind \
	     --without-dyninst --without-papi \
	     --enable-instrument-dynamic-memory --enable-instrument-io \
	     "$@"

$BASEDIR/../configure --prefix=$PREFIX \
	     --build=$BUILD_ID --host=$TARGET_ID --target=$TARGET_ID \
	     --enable-aarch64 --with-sysroot=$SYSROOT_DIR \
	     --with-gnu-ld --without-binutils --disable-xmltest \
             --enable-nanos --without-mpi --without-unwind \
	     --without-dyninst --without-papi --enable-shared \
	     --enable-instrument-dynamic-memory --enable-instrument-io \
	     "$@"
