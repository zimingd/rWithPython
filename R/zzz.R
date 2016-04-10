#########################################################
# CGB, 20100716
#########################################################

pathToPythonLibraries<-function(libname, pkgname) {
	# Note: 'pythonLibs' is defined in configure.win
	pathToPythonLibraries<-file.path(libname, pkgname, "pythonLibs")
	pathToPythonLibraries<-gsub("/", "\\", pathToPythonLibraries, fixed=T)
	pathToPythonLibraries
}

# on Windows we need to add Python dll's to library search path
addPythonLibrariesToWindowsPath<-function(libname, pkgname) {
	if (Sys.info()['sysname']!="Windows") return
	Sys.setenv(PATH=pathToPythonLibraries(libname, pkgname))
}

.onLoad <- function( libname, pkgname ) {	
	addPythonLibrariesToWindowsPath(libname, pkgname)
	# cat("in '.onLoad': path is ", Sys.getenv("PATH"), "\n")
	
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
