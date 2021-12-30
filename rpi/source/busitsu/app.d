import dlog;
import busitsu.serial;
import busitsu.http;


void main() {
  import std.parallelism;

  Logger logger = new DefaultLogger();
  logger.log("booting up...");

  auto serialConfig = busitsu.serial.Config("/dev/ttyUSB0");
  auto serialTask = task!(busitsu.serial.listen)(logger, serialConfig);

  auto httpCOnfig = busitsu.http.Config(8080);
  auto serverTask = task!(busitsu.http.listen)(logger, httpConfig);

  serverTask.executeInNewThread();
  serialTask.executeInNewThread();
}
