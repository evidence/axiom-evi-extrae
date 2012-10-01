#!/bin/sh

EXTRAE_ON=1 ./check-dump-events
../../../src/merger/mpi2prv -f TRACE.mpits -dump -dump-without-time >& OUTPUT

# Remove headers for mpi2prv dump
grep -v ^mpi2prv OUTPUT   > OUTPUT-1
grep -v ^merger  OUTPUT-1 > OUTPUT-2

# Actual comparison
diff reference OUTPUT-2
