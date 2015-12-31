#########################################################
# CGB, 20100716
#########################################################

addPythonLibrariesToPath<-function() {
	currentPathString<-Sys.getenv("PATH")
	pathSep<-":"
	if (Sys.info()['sysname']=="Windows") {
		pathSep<-";"
	}
	currentPaths<-strsplit(currentPathString, pathSep, fixed=T)[[1]]
	# Note: 'pythonLibs' is defined in configure.win
	pathToPythonLibraries<-system.file("pythonLibs", package="rWithPython")
  if (!any(currentPaths==pathToPythonLibraries)) {
		newPathString<-paste(pathToPythonLibraries, currentPathString, sep="pathSep")
		Sys.setenv(PATH=newPathString)
	}
}

.onLoad <- function( libname, pkgname ) {
	cat(sprintf("in '.onLoad':\n\tlibname: <%s>\n\tpkgname: <%s>\n", libname, pkgname))
	cat("in '.onLoad':  Contents of 'libs' folder:\n")
	cat(list.files(system.file("libs", package="rWithPython"), recursive=T), sep="\n\t")
	
	addPythonLibrariesToPath()
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
