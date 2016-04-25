#include <Python.h>
#include <string.h>

#ifndef _WIN32
#include <dlfcn.h>
#endif

#include <bytesobject.h>

#define xstr(a) str(a)
#define str(a) #a

#if PY_MAJOR_VERSION >= 3
#define PY3K
#endif

void py_init(){
    Py_Initialize();
    PyRun_SimpleString("import json");
}

void py_close(){
    Py_Finalize();
}


void py_exec_code(const char** code, int* exit_status )
{
     *exit_status = PyRun_SimpleString(*code); 
}


void py_get_var( const char** var_name, int* found, char** resultado )
{

    *found = 0;

    PyObject * module     = PyImport_AddModule("__main__");
    PyObject * dictionary = PyModule_GetDict(module);
    PyObject * result     = PyDict_GetItemString(dictionary, *var_name );

    if( result == NULL ){
        *found = 1;
        *resultado = "";
        return;
    }

#ifdef PY3K
    *resultado = PyUnicode_AsUTF8(result);
#else
    *resultado = PyString_AS_STRING(result);
#endif
}
