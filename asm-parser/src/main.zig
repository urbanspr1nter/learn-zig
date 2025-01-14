const std = @import("std");

pub fn main() !void {
    const writer = std.io.getStdOut().writer();
    const file = try std.fs.cwd().openFile("data/program.txt", .{});
    defer file.close();
   
    while (file.reader().readUntilDelimiterOrEofAlloc(std.heap.c_allocator, '\n', 2048) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {
        defer std.heap.c_allocator.free(line);
        try writer.print("{s}\n", .{line});
    }
}

test "simple test" {}
