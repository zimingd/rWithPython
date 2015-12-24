# Checks that the installed Python instance can be accessed
# by checking the version of the installation.  This does a 
# basic 'roundtrip' from R to Python.
# 
# Author: bhoff
###############################################################################
library(rWithPython)
python.exec("import sys")
result<-python.get("sys.version")
expected<-"2.7.11"
if (is.null(result)) stop("Python version is unexpectedly null.")
if (length(grep(expected, result))==0) stop(sprintf("Expected '%s' in the version string but found '%s'\n", expected, result))

