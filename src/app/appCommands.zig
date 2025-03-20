const std = @import("std");

/// enum for app command option types
/// generated with chatgpt from https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-type
pub const ApplicationCommandOptionType = enum(u8) {
    SUB_COMMAND = 1,
    SUB_COMMAND_GROUP = 2,
    STRING = 3,
    INTEGER = 4, // Any integer between -2^53 and 2^53
    BOOLEAN = 5,
    USER = 6,
    CHANNEL = 7, // Includes all channel types + categories
    ROLE = 8,
    MENTIONABLE = 9, // Includes users and roles
    NUMBER = 10, // Any double between -2^53 and 2^53
    ATTACHMENT = 11, // Attachment object

    pub fn fromInt(value: u8) ?ApplicationCommandOptionType {
        return std.meta.intToEnum(ApplicationCommandOptionType, value) catch null;
    }
};

/// enum for app command types
/// not to be confused with the ApplicationCommandOptionType
/// represents the different forms of an application command
/// generated with chatgpt from https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-types
pub const ApplicationCommandType = enum(u8) {
    CHAT_INPUT = 1, // Slash commands; a text-based command that shows up when a user types /
    USER = 2, // A UI-based command that shows up when you right-click or tap on a user
    MESSAGE = 3, // A UI-based command that shows up when you right-click or tap on a message
    PRIMARY_ENTRY_POINT = 4, // A UI-based command that represents the primary way to invoke an app's Activity

    pub fn fromInt(value: u8) ?ApplicationCommandType {
        return std.meta.intToEnum(ApplicationCommandType, value) catch null;
    }
};
