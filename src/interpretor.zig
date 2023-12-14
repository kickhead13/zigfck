const std = @import("std");
const print = @import("std").debug.print;

pub fn interpret(buffer_size: usize, code: [:0]const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var general_allocator = gpa.allocator();

    var buffer_pos: usize = 0;
    const buffer = try general_allocator.alloc(u8, buffer_size);
    defer general_allocator.free(buffer);

    var stack_length: usize = 0;
    var stack: [100]usize = undefined;

    var iter: usize = 0;
    while(iter < buffer_size) : (iter+=1) {
      buffer[iter] = 0;
    }

    buffer_pos = 0;

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
        '+' => buffer[buffer_pos] += 1,
        '-' => buffer[buffer_pos] -= 1,
        '.' => print("{c}", .{buffer[buffer_pos]}),
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
}
