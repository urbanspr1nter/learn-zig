const std = @import("std");

pub fn main() !void {
    const writer = std.io.getStdOut().writer();
    const file = try std.fs.cwd().openFile("data/program.txt", .{});
    defer file.close();

    var RAM: [2048]u8 = [_]u8{0} ** 2048;

    var i: u32 = 0;
    while (file.reader().readUntilDelimiterOrEofAlloc(std.heap.c_allocator, '\n', 2048) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {
        defer std.heap.c_allocator.free(line);
        var it = std.mem.splitScalar(u8, line, ' ');
        while (it.next()) |tok| {
            const byte: u8 = try std.fmt.parseInt(u8, tok, 16);
            RAM[i] = byte;
            i += 1;
        }

        i = 0;
        while (i < 2048) {
            if (i % 16 == 0) {
                try writer.print("\n", .{});
            }
            try writer.print("[{x:0>4}]: {d:0>3} ", .{ i, RAM[i] });
            i += 1;
        }
        try writer.print("\n", .{});
    }
}

test "simple test" {}
