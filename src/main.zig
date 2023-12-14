const std = @import("std");
const print = @import("std").debug.print;
const help = @import("help.zig");
const interpretor = @import("interpretor.zig");
const compiler = @import("compiler.zig");
const instruction_parsing = @import("instruction_parsing.zig");

const BASE_TEN = 10;

pub fn main() !void {

  var allocator = std.heap.page_allocator;
 
  var argsIter = try std.process.ArgIterator
    .initWithAllocator(allocator);
  defer argsIter.deinit();

  _ = argsIter.next();
 
  var buffer_size: usize = 10;
  var comp_intp_help: [4]u8 = [_]u8{0, 0, 0, 0};

  if(argsIter.next()) |comp_or_intp| {
    std.mem.copy(u8, &comp_intp_help, comp_or_intp);
  }
  else {
    try help.help();
    return;
  }
  
  if(std.mem.eql(u8, &comp_intp_help, "help")) {
    try help.help();
    return;
  }

  if(std.mem.eql(u8, &comp_intp_help, "comp")) {
    try compiler.compile(&argsIter);
    return;
  }

  if(!std.mem.eql(u8, &comp_intp_help, "intp")) {
    try help.help();
    return; 
  }

  if(argsIter.next()) |buffer_size_string| {
    buffer_size = try std.fmt.parseInt(usize, buffer_size_string, BASE_TEN);
  }
  else {
    try help.help();
    return; 
  }
  
  var mode_box: [3]u8 = undefined;
  if(argsIter.next()) |mode| {
    std.mem.copy(u8, &mode_box, mode);
  }
  else {
    try help.help();
    return;
  }

  if(std.mem.eql(u8, &mode_box, "-cl")) {
    if(argsIter.next()) |code| { 
      try interpretor.interpret(buffer_size, code);
     return;
    }
    else {
      try help.help();
      return;
    }
  }
  else if(std.mem.eql(u8, &mode_box, "-fl")) {}
  else {
    print("{s} {d}\n", .{mode_box, mode_box.len});
  }
}
