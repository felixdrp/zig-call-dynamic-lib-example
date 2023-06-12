// example from:
// https://tldp.org/HOWTO/Program-Library-HOWTO/dl-libraries.html
// compile:
// C:
// gcc -o foo dload-ex.c -ldl
// ./foo
// -0.416147

// Zig:
// zig cc -o fee dload-ex.c -ldl
// ./fee
// -0.416147
    
//  file -L /lib/x86_64-linux-gnu/libm.so.6
// /lib/x86_64-linux-gnu/libm.so.6: ELF 64-bit LSB shared object, x86-64, version 1 (GNU/Linux), dynamically linked, BuildID[sha1]=ee0a53f1c11e9b31b23373bcc3290b905836c287, for GNU/Linux 3.2.0, stripped

// List functions on dynamic library
// readelf -sW /lib/x86_64-linux-gnu/libm.so.6

// List dynamic libraries opened by process
// lsof -p PROCESS_ID
// ex: lsof -p 3964627

#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

int main(int argc, char **argv) {
    void *handle;
    double (*cosine)(double);
    char *error;

    handle = dlopen ("/lib/x86_64-linux-gnu/libm.so.6", RTLD_LAZY);
    if (!handle) {
        fputs (dlerror(), stderr);
        exit(1);
    }

    cosine = dlsym(handle, "cos");
    if ((error = dlerror()) != NULL)  {
        fputs(error, stderr);
        exit(1);
    }

    printf ("%f\n", (*cosine)(2.0));
    dlclose(handle);
}
