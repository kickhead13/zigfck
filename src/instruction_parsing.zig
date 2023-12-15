const std = @import("std");

pub const Parser = struct {

  file_header: []const u8,
  right_arrow: []const u8,
  left_arrow: []const u8,
  plus_sign: []const u8,
  minus_sign: []const u8,
  open_paranthesis: []const u8,
  closed_paranthesis: []const u8,
  dot: []const u8,
  comma: []const u8,
  file_footer: []const u8,

  pub fn new() Parser {
    return undefined;
  }

  pub fn compile_c() Parser {
    return Parser {
      .file_header = "#include <stdio.h>\n#define BUFFER_SIZE 1000\nint main(){\n\tchar buffer[BUFFER_SIZE];\n\tsize_t position = 0;\n\tfor(size_t iter=0; iter<BUFFER_SIZE; iter++)buffer[iter]=0;\n",
      .right_arrow = "\tposition += 1; \n\tposition %= BUFFER_SIZE;\n",
      .left_arrow = "\tposition = (position == 0 ? BUFFER_SIZE-1 : position-1);\n",
      .plus_sign = "\tbuffer[position]+=1;\n",
      .minus_sign = "\tbuffer[position]-=1;\n",
      .open_paranthesis = "\tdo {\n",
      .closed_paranthesis = "\t} while(buffer[position]);\n",
      .dot = "\tprintf(\"{%c}\",buffer[position]);\n",
      .comma = "\t\n",
      .file_footer = "\treturn 0;\n}\n",
    }; 
  }

  pub fn compile_rust() Parser {
    return Parser.new();
  }

  pub fn compile_asm() Parser {
    return Parser.new();
  }

  pub fn compile_zig() Parser {
    return Parser {
      .file_header = "const std = @import(\"std\");\nconst BUFFER_SIZE=1000;\npub fn main() !void {\n\tconst stdout = std.io.getStdOut().writer();\n\tvar buffer: [BUFFER_SIZE]u8 = undefined;\n\tvar position: usize = 0;\n\tfor(buffer) |_, pos| {\n\t\tbuffer[pos]=0;\n\t}\n",
      .right_arrow = "\tposition +=1;\n\tposition %= BUFFER_SIZE;\n",
      .left_arrow = "\tif(position==0) {position=BUFFER_SIZE-1;}else{position -= 1;}\n",
      .plus_sign = "\tbuffer[position] += 1;\n",
      .minus_sign = "\tbuffer[position] -= 1;\n",
      .open_paranthesis = "\twhile(1) {\n",
      .closed_paranthesis = "\t\tif(buffer[position]==0) { break; }\n\t}\n",
      .dot = "\n\ttry stdout.print(\"{c}\", .{buffer[position]});\n",
      .comma = "\t\n",
      .file_footer = "}",
    };
  }
  
  pub fn print(self: Parser) !void {
    std.debug.print("{s}{s}{s}{s}{s}{s}{s}{s}{s}{s}", self);
  }

  pub fn parse(self: Parser, bf_instruction: u8) !void {
    
    const stdout = std.io.getStdOut().writer();

    try switch(bf_instruction) {

      '>' => stdout.print("{s}", .{self.right_arrow}),
      '<' => stdout.print("{s}", .{self.left_arrow}),
      '+' => stdout.print("{s}", .{self.plus_sign}),
      '-' => stdout.print("{s}", .{self.minus_sign}),
      '.' => stdout.print("{s}", .{self.dot}),
      ',' => stdout.print("{s}", .{self.comma}),
      ']' => stdout.print("{s}", .{self.closed_paranthesis}),
      '[' => stdout.print("{s}", .{self.open_paranthesis}),

    };

  }

};
