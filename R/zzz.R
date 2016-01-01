#########################################################
# CGB, 20100716
#########################################################

addPythonLibrariesToPath<-function(libname, pkgname) {
	# Note: 'pythonLibs' is defined in configure.win
	pathToPythonLibraries<-file.path(libname, pkgname, "pythonLibs")
	pathSep<-":"
	if (Sys.info()['sysname']=="Windows") {
		pathToPythonLibraries<-gsub("/", "\\", pathToPythonLibraries, fixed=T)
		pathSep<-";"
	}
	currentPathString<-Sys.getenv("PATH")
	currentPaths<-strsplit(currentPathString, pathSep, fixed=T)[[1]]
  if (!any(currentPaths==pathToPythonLibraries)) {
		newPathString<-paste(pathToPythonLibraries, currentPathString, sep=pathSep)
		Sys.setenv(PATH=newPathString)
	}
}

.onLoad <- function( libname, pkgname ) {	
	addPythonLibrariesToPath(libname, pkgname)
	cat("in '.onLoad': path is ", Sys.getenv("PATH"), "\n")
	
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
