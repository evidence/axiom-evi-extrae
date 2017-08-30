#!/bin/sh

BASEDIR=$(dirname "$0")

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

if [ "$FS" = "seco" ]; then

    TARGET_DIR=$(realpath ${ROOTFS})
#    SYSROOT_DIR=$(realpath ${LINARO}/sysroot)
    SYSROOT_DIR=$(realpath ${ROOTFS})
    HOST_DIR=$(realpath ${LINARO}/host)
        
    BUILD_ID='x86_64-unknown-linux-gnu'
    TARGET_ID='aarch64-linux-gnu'
        
    [ -z "$PREFIX" ] && PREFIX=$HOST_DIR

    export PATH=$PATH:$HOST_DIR/usr/bin
    
    export XML2_CONFIG="$(realpath ${ROOTFS}/usr/bin/xml2-config)"
        
else
    
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

fi

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
