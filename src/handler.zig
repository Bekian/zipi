const std = @import("std");
const proc = std.process;
const httpz = @import("httpz");

pub const Handler = struct {
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

pub fn index(_: *Handler, _: *httpz.Request, res: *httpz.Response) !void {
    res.body =
        \\<!DOCTYPE html>
        \\<h1>Hello World!</h1>
    ;
}

pub fn sendMsg(_: *Handler, req: *httpz.Request, res: *httpz.Response) !void {
    const output = try std.fmt.allocPrint(res.arena, "<!DOCTYPE html>\n<html><body><h1>Hello {s}!</h1></body></html>", .{req.url.query});
    res.content_type = httpz.ContentType.HTML;
    res.status = 200;
    res.body = output;
}
