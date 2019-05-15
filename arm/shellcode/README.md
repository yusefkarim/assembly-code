Some examples of ARM assembly shellcode I have used in the past. These were all tested on the Raspberry Pi but should work elsewhere as well. Every assembly file here should be free of NULL bytes and relatively compact.

You can assemble it:
```
as shellcode.s -o shellcode.o
```

Link it:
```
ld shellcode.o -N -o shellcode
```

Create a raw binary file:
```
objcopy -O binary shellcode shellcode.bin
```

Then extract the opcodes:
```
hexdump -v -e '"\\""x" 1/1 "%02x" ""' shellcode.bin
```
