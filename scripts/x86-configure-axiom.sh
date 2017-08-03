#!/bin/sh

BASEDIR=$(dirname "$0")

[ -z "$PREFIX" ] && PREFIX=/usr/local

echo $BASEDIR/../configure --prefix=$PREFIX \
	     --with-gnu-ld --without-binutils --disable-xmltest \
             --enable-nanos --without-mpi --without-unwind \
	     --without-dyninst --without-papi \
	     --enable-instrument-dynamic-memory --enable-instrument-io \
	     "$@"
$BASEDIR/../configure --prefix=$PREFIX \
	     --with-gnu-ld --without-binutils --disable-xmltest \
             --enable-nanos --without-mpi --without-unwind \
	     --without-dyninst --without-papi \
	     --enable-instrument-dynamic-memory --enable-instrument-io \
	     "$@"
