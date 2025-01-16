const std = @import("std");
const logger = @cImport({
    @cInclude("logger.h");
});

pub fn main() void {
    logger.log("hello, world");
}
