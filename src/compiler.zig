const std = @import("std");
const help = @import("help.zig");
const print = @import("std").debug.print;

pub fn rust_compile(file_name: []const u8, output: []const u8) !void {
  print("{s}\n{s}\n", .{file_name, output});
}

pub fn c_compile(file_name: []const u8, output: []const u8) !void {
  print("{s}\n{s}\n", .{file_name, output});
}

pub fn asm_compile(file_name: []const u8, output: []const u8) !void {
  print("{s}\n{s}\n", .{file_name, output});
}

pub fn zig_compile(file_name: [] const u8, output: []const u8) !void {
  print("{s}\n{s}\n", .{file_name, output});
}

pub fn compile(argsIter: *std.process.ArgIterator) !void {

  var language: [5]u8 = [_]u8{0, 0, 0, 0, 0};
  var file_name: [100]u8 = undefined;
  var output_file_name: [100]u8 = undefined ;

  for(output_file_name) |_, pos| {
    output_file_name[pos] = 0;
  }
  output_file_name[0] = 'a';

  for(file_name) |_, pos| {
    file_name[pos]=0;
  }

  if(argsIter.next()) |lang| {
    std.mem.copy(u8, &language, lang);
  }
  else {
    print("comp lang\n", .{});
    try help.help();
    return;
  }
  
  if(argsIter.next()) |file| {
    std.mem.copy(u8, &file_name, file);
  }
  else {
    print("comp file\n", .{});
    try help.help();
    return;
  }

  if(argsIter.*.next()) |output| {
    std.mem.copy(u8, &output_file_name, output);
  }
  
  if(std.mem.eql(u8, language[0..3], "-rs")) {
    try rust_compile(&file_name, &output_file_name);
  }

  if(std.mem.eql(u8, language[0..2], "-c")) {
    try c_compile(&file_name, &output_file_name);
  }

  if(std.mem.eql(u8, language[0..4], "-asm")) {
    try asm_compile(&file_name, &output_file_name);
  }

  if(std.mem.eql(u8, language[0..4], "-zig")) {
    try zig_compile(&file_name, &output_file_name);
  }

  return;
}
