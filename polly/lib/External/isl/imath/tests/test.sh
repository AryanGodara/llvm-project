#!/bin/bash
## 
## Name:     test.sh
## Purpose:  Run test suites for IMath library.
##
## Copyright (C) 2002-2007 Michael J. Fromberger. All Rights Reserved.
##

set -o pipefail

if [ ! -f ../imtest ] ; then
  echo "The imath test driver 'imtest' was not found."
  echo "It needs to be build before proceeding with the unit tests."
  exit 2
fi

echo "-- Running all available unit tests"
if ../imtest *.tc | (grep -v 'OK'||true) ; then
    echo "ALL PASSED"
else
    echo "FAILED"
    exit 1
fi

echo ""
echo "-- Running test to compute 1024 decimal digits of pi"
if [ ! -f ../pi ] ; then
  echo "The pi computing program was not found."
  echo "It needs to be built before proceeding with the pi test."
  exit 1
fi

tempfile="/tmp/pi.1024.$$"

../pi 1024 | tr -d '\r\n' > ${tempfile}
if cmp -s ${tempfile} ./pi1024.txt ; then
  echo "  PASSED 1024 digits"
else
  echo "  FAILED"
  echo "Obtained:"
  cat ${tempfile}
  echo "Expected:"
  cat ./pi1024.txt
fi
rm -f ${tempfile}

tempfile="/tmp/pi.1698.$$"

echo "-- Running test to compute 1698 hexadecimal digits of pi"

../pi 1698 16 | tr -d '\r\n' > ${tempfile}
if cmp -s ${tempfile} ./pi1698-16.txt ; then
  echo "  PASSED 1698 digits"
else
  echo "  FAILED"
  echo "Obtained:"
  cat ${tempfile}
  echo "Expected:"
  cat ./pi1698-16.txt
fi
rm -f ${tempfile}

tempfile="/tmp/pi.1500.$$"

echo "-- Running test to compute 1500 decimal digits of pi"

../pi 1500 10 | tr -d '\r\n' > ${tempfile}
if cmp -s ${tempfile} ./pi1500-10.txt ; then
  echo "  PASSED 1500 digits"
else
  echo "  FAILED"
  echo "Obtained:"
  cat ${tempfile}
  echo "Expected:"
  cat ./pi1500-10.txt
fi
rm -f ${tempfile}

echo "-- Running regression tests"

for bug in bug-swap ; do
    ../${bug}
done

exit 0
