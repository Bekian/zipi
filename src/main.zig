const sqlite = @import("sqlite");
const std = @import("std");
const httpz = @import("httpz");
// first we base the app on the httpz example 2
// global consts are CAPS
const PORT = 8080;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        std.debug.print("mem leak oopsies", .{});
    };
    const allocator = gpa.allocator();

    var handler = Handler{};
    var server = try httpz.Server(*Handler).init(allocator, .{ .port = PORT }, &handler);
    defer server.deinit();
    defer server.stop();

    var router = try server.router(.{});
    router.get("/", index, .{});
    router.get("/sendmsg", sendMsg, .{});

    std.debug.print("listening on http://localhost:{d}/\n", .{PORT});

    try server.listen();
}

const Handler = struct {
    _hits: usize = 0,

    // this is for a 400 error
    pub fn not_found(_: *Handler, _: *httpz.Request, res: *httpz.Response) !void {
        res.status = 404;
        res.body = "Not found";
    }

    // this is for a 500 error
    pub fn uncaughtError(_: *Handler, req: *httpz.Request, res: *httpz.Response, err: anyerror) void {
        std.debug.print("uncaught http error at {s}: {}\n", .{ req.url.path, err });

        res.headers.add("content-type", "text/html; charset=utf-8");
        res.status = 505;
        res.body = "<!DOCTYPE html> 505 error";
    }
};

fn index(_: *Handler, _: *httpz.Request, res: *httpz.Response) !void {
    res.body =
        \\<!DOCTYPE html>
        \\<h1>Hello World!</h1>
    ;
}

fn sendMsg(_: *Handler, req: *httpz.Request, res: *httpz.Response) !void {
    const output = try std.fmt.allocPrint(res.arena, "<!DOCTYPE html>\n<html><body><h1>Hello {s}!</h1></body></html>", .{req.url.query});
    res.content_type = httpz.ContentType.HTML;
    res.status = 200;
    res.body = output;
}
