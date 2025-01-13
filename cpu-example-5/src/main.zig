const std = @import("std");
const writer = std.io.getStdOut().writer();

const OpCode = enum { AddX, AddXImmediate, AddY, AddYImmediate, SubX, SubXImmediate, SubY, SubYImmediate, StoreA, StoreX, StoreY, LoadA, LoadX, LoadY, Halt };

const Capacity = 2048;

var RAM: [Capacity]u8 = [_]u8{0} ** Capacity;

const CPU = struct {
    var ip: u32 = 0;
    var x: i32 = 0;
    var y: i32 = 0;
    var a: i32 = 0;
};

pub fn memWrite(address: u32, value: u8) void {
    RAM[address % Capacity] = value;
}

pub fn memRead(address: u32) u8 {
    return RAM[address % Capacity];
}

pub fn printReg() !void {
    try writer.print("X: {d}, Y: {d}, A: {d}, IP: {d}\n", .{ CPU.x, CPU.y, CPU.a, CPU.ip });
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

pub fn read2Bytes() i32 {
    const result: i32 = @as(i32, RAM[CPU.ip] << 16) | @as(i32, RAM[CPU.ip + 1]);

    CPU.ip += 2;

    return result;
}

pub fn read4Bytes() i32 {
    const result = (@as(i32, RAM[CPU.ip]) << 24 | @as(i32, RAM[CPU.ip + 1]) << 16 | @as(i32, RAM[CPU.ip + 2]) << 8 | @as(i32, RAM[CPU.ip + 3]));

    CPU.ip += 4;

    return result;
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
            try addXImmediate(read4Bytes());
        },
        OpCode.AddY => {
            try addY();
            CPU.ip += 1;
        },
        OpCode.AddYImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            try addYImmediate(read4Bytes());
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
            try subXImmediate(read4Bytes());
        },
        OpCode.SubYImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            try subYImmediate(read4Bytes());

            CPU.ip += 4;
        },
        OpCode.LoadA, OpCode.LoadX, OpCode.LoadY => {},
        OpCode.StoreA, OpCode.StoreX, OpCode.StoreY => {},
        OpCode.Halt => {},
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
    RAM[12] = @intFromEnum(OpCode.Halt);

    while (RAM[CPU.ip] != @as(u8, @intFromEnum(OpCode.Halt))) {
        try runOp(@enumFromInt(RAM[CPU.ip]));
    }

    try printReg();
}
