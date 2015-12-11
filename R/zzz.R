#########################################################
# CGB, 20100716
#########################################################

.onLoad <- function( libname, pkgname ){
	Sys.setenv(PYTHONHOME=system.file(package="rPython"))
	Sys.setenv(PYTHONPATH=system.file("lib", package="rPython"))
	# 'local=FALSE' is crucial, otherwise various shared objects which
	# are part of Python modules will not have access to the symbols in libpython
	library.dynam( "rPython", pkgname, libname, local=FALSE)
  .C( "py_init", PACKAGE = "rPython" )
}

.onUnload <- function( libpath ){
    .C( "py_close", PACKAGE = "rPython" )
    library.dynam.unload( "rPython", libpath )
}
