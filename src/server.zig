const std = @import("std");
const httpz = @import("httpz");
const handler = @import("handler.zig");

pub fn createServer(allocator: std.mem.Allocator, server_handler: *handler.Handler) !httpz.Server(*handler.Handler) {
    const server = try httpz.Server(*handler.Handler).init(allocator, .{ .port = 8080 }, server_handler);
    return server;
}
