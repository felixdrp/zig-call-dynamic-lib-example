# zig-call-dynamic-lib-example
Zig example Dynamically Loaded (DL) Libraries

Based on [https://tldp.org/HOWTO/Program-Library-HOWTO/dl-libraries.html](https://tldp.org/HOWTO/Program-Library-HOWTO/dl-libraries.html)

Exec cosine function from mat lib `libm.so.6`.

```bash
# List dynamic library's functions.
readelf -sW /lib/x86_64-linux-gnu/libm.so.6
```

## Run

```bash
# Compile C code
# C
gcc -o foo dload-ex.c -ldl
# Run
./foo
# output
# -0.416147

# Zig
zig cc -o zoo dload-ex.c -ldl
# Run
./zoo
# output
# -0.416147

# Compile Zig code
zig build-exe dload-ex.zig -ldl
# Run
./dload-ex
# output
# info: cos -4.161468365471424e-01

```