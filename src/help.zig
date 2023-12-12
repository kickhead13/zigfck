const std = @import("std");

pub fn help() !void {

  try std.io.getStdOut().writer().print(

    "Usage: zigfck [BUFFER_SIZE] -c [CODE]\n       zigfck [BUFFER_SIZE] -f [FILE]\n",
    .{}

  );

}
