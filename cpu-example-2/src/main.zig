const std = @import("std");
const writer = std.io.getStdOut().writer();

const CPU = struct {
    var x: i32 = 0;
    var y: i32 = 0;
    var a: i32 = 0;
};

pub fn displayCpu() !void {
    try writer.print("X: {d}, Y: {d}, A: {d}\n", .{ CPU.x, CPU.y, CPU.a });
}

pub fn addXi(imm: i32) !void {
    try writer.print("ADD X, {d}\n", .{imm});
    CPU.x += imm;
}

pub fn addX() !void {
    try writer.print("ADD X\n", .{});
    CPU.a = CPU.a + CPU.x;
}

pub fn main() !void {
    try displayCpu();
    try addXi(3);
    try addX();
    try displayCpu();
}
