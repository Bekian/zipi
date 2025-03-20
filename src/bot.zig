const httpz = @import("httpz");
const std = @import("std");
const appCommands = @import("app/appCommands.zig");

// i need a way to easily make requests to the api
// without having to deal with writing code to create and read requests every time i make a request
// this function is inspired from here: https://github.com/discord/discord-example-app/blob/main/utils.js#L3
pub fn discordReq(allocator: std.mem.Allocator, endpoint: []const u8, envMap: std.StringHashMap([]const u8)) !httpz.Response {
    const uri = std.mem.concat(allocator, u8, &[_][]const u8{ "https://discord.com/api/v10/", endpoint });
    defer try allocator.free(uri);
}
