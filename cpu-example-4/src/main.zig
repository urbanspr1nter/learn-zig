const std = @import("std");
const writer = std.io.getStdOut().writer();

const Capacity = 2048;

var RAM: [Capacity]u8 = [_]u8{0} ** Capacity;

const OpCode = enum { AddX, AddXImmediate, AddY, AddYImmediate, SubX, SubXImmediate, SubY, SubYImmediate };

const CPU = struct {
    var ip: u32 = 0;
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
            CPU.ip += 1;
        },
        OpCode.AddXImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            const immediate = (@as(i32, RAM[CPU.ip]) << 24 | @as(i32, RAM[CPU.ip + 1]) << 16 | @as(i32, RAM[CPU.ip + 2]) << 8 | @as(i32, RAM[CPU.ip + 3]));

            try addXImmediate(immediate);

            CPU.ip += 4;
        },
        OpCode.AddY => {
            try addY();
            CPU.ip += 1;
        },
        OpCode.AddYImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            const immediate = (@as(i32, RAM[CPU.ip]) << 24 | @as(i32, RAM[CPU.ip + 1]) << 16 | @as(i32, RAM[CPU.ip + 2]) << 8 | @as(i32, RAM[CPU.ip + 3]));

            try addYImmediate(immediate);

            CPU.ip += 4;
        },
        OpCode.SubX => {
            try subX();
            CPU.ip += 1;
        },
        OpCode.SubY => {
            try subY();
            CPU.ip += 1;
        },
        OpCode.SubXImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            const immediate = (@as(i32, RAM[CPU.ip]) << 24 | @as(i32, RAM[CPU.ip + 1]) << 16 | @as(i32, RAM[CPU.ip + 2]) << 8 | @as(i32, RAM[CPU.ip + 3]));
            try subXImmediate(immediate);

            CPU.ip += 4;
        },
        OpCode.SubYImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            const immediate = (@as(i32, RAM[CPU.ip]) << 24 | @as(i32, RAM[CPU.ip + 1]) << 16 | @as(i32, RAM[CPU.ip + 2]) << 8 | @as(i32, RAM[CPU.ip + 3]));

            try subYImmediate(immediate);

            CPU.ip += 4;
        },
    }
}

pub fn main() !void {
    RAM[0] = @intFromEnum(OpCode.AddXImmediate);
    RAM[1] = 0x00;
    RAM[2] = 0x00;
    RAM[3] = 0x00;
    RAM[4] = 0x03;
    RAM[5] = @intFromEnum(OpCode.AddYImmediate);
    RAM[6] = 0x00;
    RAM[7] = 0x00;
    RAM[8] = 0x00;
    RAM[9] = 0x04;
    RAM[10] = @intFromEnum(OpCode.AddX);
    RAM[11] = @intFromEnum(OpCode.AddY);

    while (CPU.ip < 12) {
        try runOp(@enumFromInt(RAM[CPU.ip]));
    }

    try printReg();
}
