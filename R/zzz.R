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
#	currentPathString<-Sys.getenv("PATH")
#	pathSep<-";"
#	currentPaths<-strsplit(currentPathString, pathSep, fixed=T)[[1]]
#  if (!any(currentPaths==pathToPythonLibraries)) {
#		newPathString<-paste(pathToPythonLibraries, currentPathString, sep=pathSep)
#		Sys.setenv(PATH=newPathString)
#	}
	Sys.setenv(PATH=pathToPythonLibraries(libname, pkgname))
#	cat("In addPythonLibrariesToWindowsPath, 'machine': ", Sys.info()['machine'], "\n")
#	if (length(grep("64",  Sys.info()['machine'], fixed=T))==0) {
#		# i386
#		Sys.setenv(PATH=paste(pathToPythonLibraries, "c:\\bin\\R\\bin", "C:\\Windows\\system32", sep=pathSep))
#	} else {
#		# x64
#		Sys.setenv(PATH=paste(pathToPythonLibraries, "c:\\bin\\R\\bin", "C:\\Windows\\SysWOW64", sep=pathSep))
#	}
}

.onLoad <- function( libname, pkgname ) {	
	addPythonLibrariesToWindowsPath(libname, pkgname)
	cat("in '.onLoad': path is ", Sys.getenv("PATH"), "\n")
	
	Sys.setenv(PYTHONHOME=system.file(package="rWithPython"))
	Sys.setenv(PYTHONPATH=system.file("lib", package="rWithPython"))
	# 'local=FALSE' is crucial, otherwise various shared objects which
	# are part of Python modules will not have access to the symbols in libpython
	library.dynam( "rWithPython", pkgname, libname, local=FALSE)
	
	# This is an experiment.  Does loading up all the Python dlls
	dlls <- list.files(path=pathToPythonLibraries(libname, pkgname), 
			pattern="dll$", full.names=TRUE, recursive=TRUE, ignore.case=TRUE)
	for (dll in dlls) {
		dyn.load(dll, local=FALSE, now=TRUE)
	}
  .C( "py_init", PACKAGE = "rWithPython" )
}

.onUnload <- function( libpath ){
    .C( "py_close", PACKAGE = "rWithPython" )
    library.dynam.unload( "rWithPython", libpath )
}
