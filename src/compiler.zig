const std = @import("std");
const print = @import("std").debug.print;

const help = @import("help.zig");
const instruction_parsing = @import("instruction_parsing.zig");

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

pub fn exec_compile(
    parser: instruction_parsing.Parser,
    file_name: []const u8,
    output:[]const u8) !void {

  try parser.print();
  print("{s}\n{s}", .{file_name, output});


  //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  //var allocator = gpa.allocator();

  //var file = try std.fs.cwd().openFile(file_name, .{});
  //defer file.close();

  //var buffered = std.io.bufferedReader(file.reader());
  //var reader = buffered.reader();

  //var arr = std.ArrayList(u8).init(allocator);
  //defer arr.deinit();

  //while(true) {

    //reader.readUntilDelimiter(arr.writer(), '\n') 
      //catch |err| switch(err) {
        //error.EndOfStream => break,
        //else => return err,
      //};

    //for(arr) |elem| {
 //     parser.parse(elem);
    //}

  //}

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
    var parser = instruction_parsing.Parser.compile_zig();
    try exec_compile(parser, &file_name, &output_file_name);
  }

  return;
}
