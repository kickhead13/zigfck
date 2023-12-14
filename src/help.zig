const std = @import("std");

pub fn help() !void {
  try std.io.getStdOut().writer().print(
"Usage: zigfck intp [BUFFER_SIZE] -cl [CODE]\n       zigfck intp [BUFFER_SIZE] -fl [FILE]\n       zigfck comp [LANGUAGE] [FILE] [OUTPUT_FILE]\n\nLANGUAGE:  compile your brainf*ck code to a specified language\n\n   -rs  compile to rust code\n\n   -c  compile to C code\n\n   -asm  compile to ASSEMBLY X86 code\n\n   -zig  compile to zig\n\n",
    .{}
  );
}
