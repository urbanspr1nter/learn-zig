const std = @import("std");

pub fn main() !void {
    var genPurposeAllocator = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = genPurposeAllocator.allocator();
    const bytes = try allocator.alloc(u32, 5);
    defer allocator.free(bytes);
    
    const size = @sizeOf(u32) * 5;
    bytes[0] = 42;
    bytes[1] = 56;
    bytes[2] = 11;
    bytes[3] = 18;
    bytes[4] = 19;
    try std.io.getStdOut().writer().print("The size: {d}, bytes[0] {d}\n", .{size, bytes[0]});
}

