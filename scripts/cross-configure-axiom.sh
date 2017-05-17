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

if [ "$P" = "1" ]; then

    TARGET_DIR=$(realpath ${ROOTFS})
#    SYSROOT_DIR=$(realpath ${LINARO}/sysroot)
    SYSROOT_DIR=$(realpath ${ROOTFS})
    HOST_DIR=$(realpath ${LINARO}/host)
        
    BUILD_ID='x86_64-unknown-linux-gnu'
    TARGET_ID='aarch64-linux-gnu'
    
#    CC="$LINARO/host/usr/bin/aarch64-linux-gnu-gcc" ; export CC
#    CXX="$LINARO/host/usr/bin/aarch64-linux-gnu-g++" ; export CXX
#    FC="$LINARO/host/usr/bin/aarch64-linux-gnu-gfortran" ; export FC
#    export PATH=$PATH:$LINARO/host/usr/bin
    
    [ -z "$PREFIX" ] && PREFIX=$HOST_DIR

    export PATH=$PATH:$HOST_DIR/usr/bin
    # questo risolve i problemi alla fine (ma li crea all'inizio)
    #export LDFLAGS="-Wl,-rpath-link -Wl,${TARGET_DIR}/lib/aarch64-linux-gnu -Wl,-rpath-link -Wl,${TARGET_DIR}/usr/lib/aarch64-linux-gnu         -Wl,-rpath-link -Wl,${TARGET_DIR}/lib -Wl,-rpath-link -Wl,${TARGET_DIR}/usr/lib"
    
#    export CFLAGS="-I${ROOTFS}/usr/include/aarch64-linux-gnu"
#    export LDFLAGS="-L${ROOTFS}/usr/lib/aarch64-linux-gnu -L${ROOTFS}/lib/aarch64-linux-gnu"
    
#    export CPPFLAGS="-isystem ${ROOTFS}/usr/include -isystem ${ROOTFS}/usr/include/aarch64-linux-gnu"
#     export CFLAGS="-L${ROOTFS}/usr/lib -L${ROOTFS}/lib -L${ROOTFS}/usr/lib/aarch64-linux-gnu -L${ROOTFS}/lib/aarch64-linux-gnu"
    
    export XML2_CONFIG="$(realpath ${ROOTFS}/usr/bin/xml2-config)"
#    export CFLAGS="--sysroot=${ROOTFS}"
#    export CPPFLAGS="--sysroot=${ROOTFS}"
#    export CXXFLAGS="--sysroot=${ROOTFS}"
        
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
	     --without-dyninst --without-papi \
	     --enable-instrument-dynamic-memory --enable-instrument-io \
	     "$@"
