const std = @import("std");
const writer = std.io.getStdOut().writer();

const OpCode = enum { AddX, AddXImmediate, AddY, AddYImmediate, SubX, SubXImmediate, SubY, SubYImmediate };

const CPU = struct {
    var x: i32 = 0;
    var y: i32 = 0;
    var a: i32 = 0;
};

pub fn printReg() !void {
    try writer.print("X: {d}, Y: {d}, A: {d}\n", .{ CPU.x, CPU.y, CPU.a });
}

pub fn addX() !void {
    try writer.print("ADD X\n", .{});
    CPU.a += CPU.x;
}

pub fn addY() !void {
    try writer.print("ADD Y\n", .{});
    CPU.a += CPU.y;
}

pub fn subX() !void {
    try writer.print("SUB X\n", .{});
    CPU.a -= CPU.x;
}

pub fn subY() !void {
    try writer.print("SUB Y\n", .{});
    CPU.a -= CPU.y;
}

pub fn addXImmediate(imm: i32) !void {
    try writer.print("ADD X, {d}\n", .{imm});
    CPU.x += imm;
}

pub fn addYImmediate(imm: i32) !void {
    try writer.print("ADD Y, {d}\n", .{imm});
    CPU.y += imm;
}

pub fn subXImmediate(imm: i32) !void {
    try writer.print("SUB X, {d}\n", .{imm});
    CPU.x -= imm;
}

pub fn subYImmediate(imm: i32) !void {
    try writer.print("SUB Y, {d}\n", .{imm});
    CPU.y -= imm;
}

pub fn runOp(opcode: OpCode) !void {
    switch (opcode) {
        OpCode.AddX => {
            try addX();
        },
        OpCode.AddXImmediate => {
            try addXImmediate(1);
        },
        OpCode.AddY => {
            try addY();
        },
        OpCode.AddYImmediate => {
            try addYImmediate(1);
        },
        OpCode.SubX => {
            try subX();
        },
        OpCode.SubY => {
            try subY();
        },
        OpCode.SubXImmediate => {
            try subXImmediate(1);
        },
        OpCode.SubYImmediate => {
            try subYImmediate(1);
        },
    }
}

pub fn main() !void {
    try printReg();
    try addXImmediate(1);
    try printReg();
    try addX();
    try printReg();

    var i: u32 = 0;
    while (i < 23) {
        try addYImmediate(1);
        i += 1;
    }

    try printReg();
    try addY();
    try printReg();
}
