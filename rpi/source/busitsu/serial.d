module busitsu.serial;

import dlog;
import std.stdio;
import busitsu.exporter;

struct Config {
  string file;
}

void listen(dlog.Logger logger, Config config) {
  auto f = File(config.file, "rw");

  logger.log("starting serial listener...");
  scope(exit) logger.log("exiting serial listener...");
  f.readln; // gomi
  while(true) {
    import std.string : chomp, isNumeric;
    import std.array : split;

    auto data = f.readln.chomp.split(",");
    if(data.length >= 2 && data[0].isNumeric && data[1].isNumeric) {
      import std.conv : to;
      import std.format : format;

      logger.log(format!"(serial) data received : %s, %s"(data[0], data[1]));
      GaugeTemp.val = data[0].to!float;
      GaugeHumid.val = data[1].to!float;
    }
  }
}
