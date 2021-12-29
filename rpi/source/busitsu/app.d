import std.concurrency;
import dlog;
import busitsu.serial;
import busitsu.http;

void main() {
  Logger logger = new DefaultLogger();
  logger.log("booting up...");
  scope(exit) logger.log("exit...");

  busitsu.http.listen();
}
