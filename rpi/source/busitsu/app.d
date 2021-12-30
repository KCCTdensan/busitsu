import dlog;
import busitsu.serial;
import busitsu.http;

void main() {
  import std.parallelism;

  Logger logger = new DefaultLogger();
  logger.log("booting up...");

  auto serialConfig = busitsu.serial.Config("/dev/ttyUSB0");
  auto serialTask = task!(busitsu.serial.listen)(logger, serialConfig);

  auto httpConfig = busitsu.http.Config(8080);
  auto httpTask = task!(busitsu.http.listen)(logger, httpConfig);

  serialTask.executeInNewThread();
  httpTask.executeInNewThread();
}
