call\_read\_str.s is an example of how to use read\_str.s

``` bash
as read_str.s -o read_str.o
as call_read_str.s -o call_read_str.o
gcc read_str.o ../write_str/write_str.o call_read_str.o -o call_read_str
./call_read_str
```
