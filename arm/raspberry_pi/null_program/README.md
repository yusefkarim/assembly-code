### Assemble the assembly source code, --gstabs tells assembler to include debugging information
``` bash
as --gstabs null_prog.s -o null_prog.o
```

### Use gcc as a linker to create an executable
``` bash
gcc -o null_prog.o -o null_prog
```
