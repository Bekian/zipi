//! This module provides functionality for the app to run on startup.
//! It programmatically loads and validates environment variables for use in the application.
//!
const std = @import("std");
const fs = std.fs;
const mem = std.mem;
const proc = std.process;

/// Read the env file and extract environment variables into a string hashmap
pub fn ExtractEnvMap(allocator: mem.Allocator) !std.StringHashMap([]const u8) {
    // open and read env file
    const cwd = fs.cwd();
    const file = try cwd.openFileZ(".env", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const content = try file.readToEndAlloc(allocator, file_size);
    defer allocator.free(content);

    // create env map
    var env_map = std.StringHashMap([]const u8).init(allocator);

    var lines = mem.splitScalar(u8, content, '\n');
    while (lines.next()) |line| {
        const trimmed_line = mem.trim(u8, line, &std.ascii.whitespace);
        // skip for empty line and comments
        if (trimmed_line.len == 0 or trimmed_line[0] == '#') continue;

        if (mem.indexOf(u8, trimmed_line, "=")) |equals_pos| {
            const key = mem.trim(u8, trimmed_line[0..equals_pos], &std.ascii.whitespace);
            const value = mem.trim(u8, trimmed_line[equals_pos + 1 ..], &std.ascii.whitespace);

            var clean_value = value;
            if (value.len >= 2 and (value[0] == '"' and value[value.len - 1] == '"' or
                value[0] == '\'' and value[value.len - 1] == '\''))
            {
                clean_value = value[1 .. value.len - 1];
            }

            const key_owned = try allocator.dupe(u8, key);
            const value_owned = try allocator.dupe(u8, clean_value);
            try env_map.put(key_owned, value_owned);
        }
    }

    return env_map;
}
