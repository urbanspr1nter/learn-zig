const std = @import("std");
const writer = std.io.getStdOut().writer();

const OpCode = enum { AddX, AddXImmediate, AddY, AddYImmediate, SubX, SubXImmediate, SubY, SubYImmediate, StoreA, StoreX, StoreY, LoadA, LoadX, LoadY, Halt };

const Capacity = 2048;

var RAM: [Capacity]u8 = [_]u8{0} ** Capacity;

const CPU = struct {
    var ip: u32 = 0;
    var x: u32 = 0;
    var y: u32 = 0;
    var a: u32 = 0;
};

pub fn memWrite(address: u32, value: u8) void {
    RAM[address % Capacity] = value;
}

pub fn memRead(address: u32) u8 {
    return RAM[address % Capacity];
}

pub fn printMem() !void {
    var i: u32 = 0;
    while (i < Capacity) {
        try writer.print("[{x}]: {d}\n", .{ i, memRead(i) });
        i += 1;
    }
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

pub fn addXImmediate(imm: u32) !void {
    try writer.print("ADD X, {d}\n", .{imm});
    CPU.x += imm;
}

pub fn addYImmediate(imm: u32) !void {
    try writer.print("ADD Y, {d}\n", .{imm});
    CPU.y += imm;
}

pub fn subXImmediate(imm: u32) !void {
    try writer.print("SUB X, {d}\n", .{imm});
    CPU.x -= imm;
}

pub fn subYImmediate(imm: u32) !void {
    try writer.print("SUB Y, {d}\n", .{imm});
    CPU.y -= imm;
}

pub fn storeA(address: u32) !void {
    try writer.print("STA {d}\n", .{address});

    memWrite(address, @truncate(CPU.a >> 24));
    memWrite(address + 1, @truncate(CPU.a >> 16));
    memWrite(address + 2, @truncate(CPU.a >> 8));
    memWrite(address + 3, @truncate(CPU.a));
}

pub fn storeX(address: u32) !void {
    try writer.print("STX {d}\n", .{address});

    memWrite(address, @truncate(CPU.x >> 24));
    memWrite(address + 1, @truncate(CPU.x >> 16));
    memWrite(address + 2, @truncate(CPU.x >> 8));
    memWrite(address + 3, @truncate(CPU.x));
}

pub fn storeY(address: u32) !void {
    try writer.print("STY {d}\n", .{address});

    memWrite(address, @truncate(CPU.y >> 24));
    memWrite(address + 1, @truncate(CPU.y >> 16));
    memWrite(address + 2, @truncate(CPU.y >> 8));
    memWrite(address + 3, @truncate(CPU.y));
}

pub fn read2Bytes() u32 {
    const result: u32 = @as(u32, RAM[CPU.ip] << 16) | @as(u32, RAM[CPU.ip + 1]);

    CPU.ip += 2;

    return result;
}

pub fn read4Bytes() u32 {
    const result = (@as(u32, RAM[CPU.ip]) << 24 | @as(u32, RAM[CPU.ip + 1]) << 16 | @as(u32, RAM[CPU.ip + 2]) << 8 | @as(u32, RAM[CPU.ip + 3]));

    CPU.ip += 4;

    return result;
}

pub fn runOp(opcode: OpCode) !void {
    switch (opcode) {
        OpCode.AddX => {
            CPU.ip += 1;
            try addX();
        },
        OpCode.AddXImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            try addXImmediate(read4Bytes());
        },
        OpCode.AddY => {
            CPU.ip += 1;
            try addY();
        },
        OpCode.AddYImmediate => {
            CPU.ip += 1;

            // Read the next 4 bytes as the integer.
            try addYImmediate(read4Bytes());
        },
        OpCode.SubX => {
            CPU.ip += 1;
            try subX();
        },
        OpCode.SubY => {
            CPU.ip += 1;
            try subY();
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
        },
        OpCode.LoadA, OpCode.LoadX, OpCode.LoadY => {},
        OpCode.StoreA => {
            CPU.ip += 1;
            try storeA(read4Bytes());
        },
        OpCode.StoreX => {
            CPU.ip += 1;
            try storeX(read4Bytes());
        },
        OpCode.StoreY => {
            CPU.ip += 1;
            try storeY(read4Bytes());
        },
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
    RAM[12] = @intFromEnum(OpCode.StoreA);
    RAM[13] = 0x00;
    RAM[14] = 0x00;
    RAM[15] = 0x01;
    RAM[16] = 0x00;
    RAM[17] = @intFromEnum(OpCode.Halt);

    while (RAM[CPU.ip] != @as(u8, @intFromEnum(OpCode.Halt))) {
        try runOp(@enumFromInt(RAM[CPU.ip]));
    }

    try printReg();
    try printMem();
}
