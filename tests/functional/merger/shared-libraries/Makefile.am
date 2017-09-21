include $(top_srcdir)/PATHS

check_PROGRAMS = main_nodebug main_debug
main_nodebug_SOURCES = fA.c fB.c main.c
main_debug_SOURCES = fA.c fB.c main.c

TESTS = 

if HAVE_BINUTILS
TESTS += \
 test-shared-library-nodebug.sh \
 test-shared-library-debug.sh
endif

EXTRA_DIST = \
 test-shared-library-nodebug.sh \
 test-shared-library-debug.sh

libfA_nodebug.so: fA.c
	$(CC) -fPIC -DPIC fA.c -o libfA_nodebug.so -shared

libfB_nodebug.so: fB.c
	$(CC) -fPIC -DPIC fB.c -o libfB_nodebug.so -shared

main_nodebug$(EXEEXT): main.c libfA_nodebug.so libfB_nodebug.so
	$(CC) -g main.c -Wl,-rpath -Wl,../../../../src/tracer/.libs -Wl,-rpath -Wl,. -L ../../../../src/tracer/.libs -L . -lfA_nodebug -lfB_nodebug -lseqtrace $(LDFLAGS) -o main_nodebug

libfA_debug.so: fA.c
	$(CC) -g -fPIC -DPIC fA.c -o libfA_debug.so -shared

libfB_debug.so: fB.c
	$(CC) -g -fPIC -DPIC fB.c -o libfB_debug.so -shared

main_debug$(EXEEXT): main.c libfA_debug.so libfB_debug.so
	$(CC) -g main.c -Wl,-rpath -Wl,../../../../src/tracer/.libs -Wl,-rpath -Wl,. -L ../../../../src/tracer/.libs -L . -lfA_debug -lfB_debug -lseqtrace $(LDFLAGS) -o main_debug

clean-local:
	-rm -rf set-0/ TRACE.mpits main_*.{pcf,prv,row}
	-rm -rf lib*
