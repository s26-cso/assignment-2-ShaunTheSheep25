#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>

int main(void)
{
    char op[6];
    int a, b;
    while (scanf("%s %d %d", op, &a, &b) == 3)
    {
        char name[20] = "./lib"; // was initially just lib, didn't work because full path wasn't specified
        strcat(name, op);
        strcat(name, ".so");
        void* f = dlopen(name, RTLD_LAZY);
        typedef int (*fn)(int, int);
        fn func = dlsym(f, op);
        dlerror();
        printf("%d\n", (*func)(a, b));
        dlclose(f);
    }
}

