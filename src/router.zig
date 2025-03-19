const handler = @import("handler.zig");
const httpz = @import("httpz");

pub fn setupRouter(server: *httpz.Server(*handler.Handler)) !void {
    var router = try server.router(.{});
    router.get("/", handler.index, .{});
    router.get("/sendmsg", handler.sendMsg, .{});
}
