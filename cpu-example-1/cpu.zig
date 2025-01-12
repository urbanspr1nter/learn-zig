const std = @import("std");

pub fn main() !void {
    const writer = std.io.getStdOut().writer();

    var A: i32 = 0;
    var X: i32 = 0;
    var Y: i32 = 0;

    try writer.print("Reg A: {d}\n", .{A});
    try writer.print("Reg X: {d}\n", .{X});
    try writer.print("Reg Y: {d}\n", .{Y});

    try writer.print("LDX 2\n", .{});
    X = 2;

    try writer.print("Reg A: {d}\n", .{A});
    try writer.print("Reg X: {d}\n", .{X});
    try writer.print("Reg Y: {d}\n", .{Y});
    
    try writer.print("LDY 2\n", .{});
    
    Y = 3;

    try writer.print("Reg A: {d}\n", .{A});
    try writer.print("Reg X: {d}\n", .{X});
    try writer.print("Reg Y: {d}\n", .{Y});

    try writer.print("ADD X, Y\n", .{});
    A = X + Y;

    try writer.print("Reg A: {d}\n", .{A});
    try writer.print("Reg X: {d}\n", .{X});
    try writer.print("Reg Y: {d}\n", .{Y});


}
