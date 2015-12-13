# Process this file with autoconf to produce a configure script.
# This file is based on configure.ac file distributed along with the rJava package

AC_INIT(rPython, 0.3, cgb@datanalytics.com)
AC_CONFIG_SRCDIR([src])
#AC_CONFIG_HEADER([src/config.h])

# find R home and set CC/CFLAGS
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
RBIN="${R_HOME}/bin/R"
CC=`"${RBIN}" CMD config CC`;
CFLAGS=`"${RBIN}" CMD config CFLAGS`

RLD=`"${RBIN}" CMD config --ldflags 2>/dev/null`
has_R_shlib=no
if test -n "$RLD"; then
   has_R_shlib=yes
fi

# ----- install the Python package -----
RPYTHON_PYTHON_VERSION=2.7
RPYTHON_PYTHON_VERSION_EXTENDED=2.7.9
PYTHON_ARCHIVE_NAME=Python-${RPYTHON_PYTHON_VERSION_EXTENDED}
PYTHON_RUNTIME_BUNDLE=https://www.python.org/ftp/python/${RPYTHON_PYTHON_VERSION_EXTENDED}/${PYTHON_ARCHIVE_NAME}.tgz
# what follows, delimited by square brackets, is a script to be copied into the 'configure' output file
[
cd inst
wget -O ${PYTHON_ARCHIVE_NAME}.tgz ${PYTHON_RUNTIME_BUNDLE}
if [ "$?" -ne "0" ]; then
	curl -o ${PYTHON_ARCHIVE_NAME}.tgz ${PYTHON_RUNTIME_BUNDLE}
fi
if [ "$?" -ne "0" ]; then
  echo "Failed to download ${PYTHON_RUNTIME_BUNDLE}"
  exit 1
fi
gunzip ${PYTHON_ARCHIVE_NAME}.tgz
# NOTE: 'gunzip' removes the .tgz file leaving just the .tar file
tar -xf ${PYTHON_ARCHIVE_NAME}.tar
rm ${PYTHON_ARCHIVE_NAME}.tar
RPYTHON_PYTHON_DIR=${PWD}
cd ${PYTHON_ARCHIVE_NAME}
# in the following line the '--prefix' parameter is the installation location
./configure --enable-shared --prefix=${RPYTHON_PYTHON_DIR}
make
make altinstall
cd ..
rm -R ${PYTHON_ARCHIVE_NAME}
cd ..
# we're now back where we started, in the base directory for the R package
]


MYPYTHONCONFIG=${RPYTHON_PYTHON_DIR}/bin/python${RPYTHON_PYTHON_VERSION}-config
MYPYTHON=${RPYTHON_PYTHON_DIR}/bin/python${RPYTHON_PYTHON_VERSION}

# Extract the linker and include flags for python
: ${PYTHONCONFIG=`which ${MYPYTHONCONFIG}`}
if test -z "${PYTHONCONFIG}"; then
  echo "could not locate ${MYPYTHONCONFIG}"
  exit 1
fi

PKG_LIBS=`$PYTHONCONFIG --ldflags`
# PUT the static (not shared) library on the library path
PKG_LIBS="-L${RPYTHON_PYTHON_DIR}/lib/python${RPYTHON_PYTHON_VERSION}/config ${PKG_LIBS}"

PKG_CFLAGS=`$PYTHONCONFIG --includes`

AC_SUBST(PKG_LIBS)
AC_SUBST(PKG_CFLAGS)

AC_PREREQ

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.
#AC_HEADER_STDC
#AC_HEADER_SYS_WAIT
#AC_CHECK_HEADERS([string.h])

# Checks for typedefs, structures, and compiler characteristics.
#AC_C_CONST
#AC_HEADER_TIME

AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT
