const std = @import("std");
const print = @import("std").debug.print;
const help = @import("help.zig");

pub fn main() !void {

  var allocator = std.heap.page_allocator;
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  const general_allocator = gpa.allocator();

  var argsIter = try std.process.ArgIterator
    .initWithAllocator(allocator);
  defer argsIter.deinit();

  _ = argsIter.next();

  const BASE_TEN = 10;
  var buffer_size: usize = 10;
  //var interpret_input = "test";

  if(argsIter.next()) |buffer_size_string| {
    //print("code: {s}\n", .{brainfuck_code});
  
    buffer_size = try std.fmt.parseInt(usize, buffer_size_string, BASE_TEN);

  }
  else {
    try help.help();
    return; 
  }

  if(argsIter.next()) |code| {

    var buffer_pos: usize = 0;
    const buffer = try general_allocator.alloc(u8, buffer_size);
    defer general_allocator.free(buffer);

    var stack_length: usize = 0;
    var stack: [100]usize = undefined;

    //std.log.debug("{}", .{@TypeOf(buffer)});

    var iter: usize = 0;
    while(iter < buffer_size) : (iter+=1) {
      buffer[iter] = 0;
    }

    buffer_pos = 0;

    // iterating through code byte-by-byte
    for(code) |_, code_pos| {
      _ = switch(code[code_pos]) {
        '>' => {
          buffer_pos += 1;
          buffer_pos %= buffer_size;
        },
        '<' => {
          buffer_pos = switch(buffer_pos) {
            0 => buffer_size-1,
            else => buffer_pos-1
          };
        },
        '+' => {
          buffer[buffer_pos] += 1;
        },
        '-' => {
          buffer[buffer_pos] -= 1;
        },
        '.' => {
          print("{c}", .{buffer[buffer_pos]}); 
        },
        '[' => {
          stack[stack_length] = code_pos;
          stack_length += 1;
        },
        ']' => {
          if(buffer[buffer_pos] != 0) {
            code_pos = stack[stack_length-1];
          } else {
            stack_length -= 1;    
          }
        },
        else => {}
      };
    }
    //print("buffer_pos = {d}\n", .{buffer_pos});


  }
  else {
    try help.help();
    return;
  }
  
}
