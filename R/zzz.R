#########################################################
# CGB, 20100716
#########################################################
printfiles<-function(dir, indent) {
	cat(indent, dir, "\n")
	if (file.info(dir)['isdir']) {
		for (file in list.files(dir)) {
			printfiles(file, paste(indent, "\t", sep=""))
		}
	}
}

.onLoad <- function( libname, pkgname ) {
	cat(sprintf("in '.onLoad':\n\tlibname: <%s>\n\tpkgname: <%s>\n", libname, pkgname))
	cat("in '.onLoad':  Contents of 'libs' folder:\n")
	printfiles(system.file("libs", package="rWithPython"), "\t")
	cat("\n")
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
