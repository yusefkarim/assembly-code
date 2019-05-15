call\_write\_str.s is an example of how to use write\_str.s

``` bash
as write_str.s -o write_str.o
as call_write_str.s -o call_write_str.o
gcc call_write_str.o write_str.o -o call_write_str
./call_write_str
```
