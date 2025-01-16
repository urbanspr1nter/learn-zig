const std = @import("std");
const expect = std.testing.expect;
const cSum = @cImport({
    @cInclude("sum.h");
});

pub fn main() !void {
    const writer = std.io.getStdOut().writer();
    try writer.print("{d}\n", .{cSum.sum2(3, 4)});
}

test "adds 2 numbers" {
    std.debug.print("something!\n", .{});
    try expect(cSum.sum2(3, 7) == 10);
}
