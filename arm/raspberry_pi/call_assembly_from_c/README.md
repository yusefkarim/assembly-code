This exercise is made up of four files.
One c program and three assembly programs.

The c program is compiled but not linked, its job is to get linked with the
three assembly files that have been assembled then call each one and
print their return values.

Steps:

### This command will compile our c program to an object file but will NOT link it
**-g is for debugging -c is to tell gcc not to link**
``` bash
gcc -g -c caller.c -o caller.o
```

### These commands assemble our ARM functions into object file, they can now be linked together
**--gtsabs enables debugging**
``` bash
as --gstabs f.s -o f.o
as --gstabs g.s -o g.o
as --gstabs h.s -o h.o
```

### This command uses the linking phase of gcc to link all our object files
``` bash
gcc caller.o f.o g.o h.o -o linked_caller
```

### Run linked executable
```bash
./linked_caller
```
