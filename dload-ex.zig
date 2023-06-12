// example from:
// https://tldp.org/HOWTO/Program-Library-HOWTO/dl-libraries.html
// compile:

// Zig:
// zig build-exe dload-ex.zig -ldl
// ./dload-ex
// info: cos -4.161468365471424e-01
    
//  file -L /lib/x86_64-linux-gnu/libm.so.6
// /lib/x86_64-linux-gnu/libm.so.6: ELF 64-bit LSB shared object, x86-64, version 1 (GNU/Linux), dynamically linked, BuildID[sha1]=ee0a53f1c11e9b31b23373bcc3290b905836c287, for GNU/Linux 3.2.0, stripped

// List functions on dynamic library
// readelf -sW /lib/x86_64-linux-gnu/libm.so.6

// List dynamic libraries opened by process
// lsof -p PROCESS_ID
// ex: lsof -p 3964627

// Check C code translate to Zig
// zig translate-c dload-ex.c -isystem /usr/include

const std = @import("std");
const system = std.os.system;
const log = std.log;

pub fn main() !void {
    var handle: ?*anyopaque = undefined;
    handle = std.c.dlopen("/lib/x86_64-linux-gnu/libm.so.6", system.RTLD.LAZY);
   
    defer if (handle != null) {
        _ = std.c.dlclose(handle.?);
    };

    var cosine: ?*const fn (f64) callconv(.C) f64 = undefined;
    cosine = @ptrCast(
        ?*const fn (f64) callconv(.C) f64,
        @alignCast(
            std.meta.alignment(?*const fn (f64) callconv(.C) f64),
            std.c.dlsym(handle, "cos")));

    log.info("cos {}\n", .{cosine.?(2.0)});
}
