#########################################################
# CGB, 20100716
#########################################################

.onLoad <- function( libname, pkgname ) {
	cat(sprintf("in '.onLoad':\n\tlibname: <%s>\n\tpkgname: <%s>\n", libname, pkgname))
	cat("in '.onLoad':  Contents of 'libs' folder:\n\t", list.files(system.file("libs", package="rWithPython")), "\n")
	Sys.setenv(PYTHONHOME=system.file(package="rWithPython"))
	Sys.setenv(PYTHONPATH=system.file("lib", package="rWithPython"))
	# 'local=FALSE' is crucial, otherwise various shared objects which
	# are part of Python modules will not have access to the symbols in libpython
	library.dynam( "rWithPython", pkgname, libname, local=FALSE)
  .C( "py_init", PACKAGE = "rWithPython" )
}

.onUnload <- function( libpath ){
    .C( "py_close", PACKAGE = "rWithPython" )
    library.dynam.unload( "rWithPython", libpath )
}
