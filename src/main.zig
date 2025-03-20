const sqlite = @import("sqlite");
const std = @import("std");
const http_server = @import("server.zig");
const router = @import("router.zig");
const handler = @import("handler.zig");
const config = @import("config.zig");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        std.debug.print("mem leak oopsies", .{});
    };
    const allocator = gpa.allocator();

    const envMap = try config.ExtractEnvMap(allocator);
    // Demo print
    std.debug.print("{s}\n", .{envMap.get("APP_ID").?});

    var http_handler = handler.Handler{};
    var server = try http_server.createServer(allocator, &http_handler);
    defer server.deinit();
    defer server.stop();

    try router.setupRouter(&server);

    std.debug.print("listening on http://localhost:{?}/\n", .{server.config.port});
    try server.listen();
}
