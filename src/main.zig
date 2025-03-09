const sqlite = @import("sqlite");
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        std.debug.print("mem leak UwU", .{});
    };
    const allocator = gpa.allocator();

    var server = std.http.Server.init(allocator, .{});
    defer server.deinit();

    const addr = try std.net.Address.parseIp("127.0.0.1", 8080);
    try server.listen(addr);

    std.debug.print("Server listening on http://127.0.0.1:8080\n", .{});
}
