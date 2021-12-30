module busitsu.http;

import dlog;
import vibe.vibe;
import busitsu.exporter;

struct Config {
  ushort port;
}

void listen(dlog.Logger logger, Config config) {
  auto router = new URLRouter;
  router.get("/", &handleGetIndex);
  router.get("/metrics", &handleGetMetrics);

  auto settings = new HTTPServerSettings;
  settings.port = config.port;

  listenHTTP(settings, router);

  logger.log("starting http listener...");
  scope(exit) logger.log("exiting http listener...");
  runApplication();
}

private:

void handleGetIndex(HTTPServerRequest req, HTTPServerResponse res) {
}

void handleGetMetrics(HTTPServerRequest req, HTTPServerResponse res) {
  import std.algorithm.iteration : map;
  import std.array : join;
  res.writeBody(DefaultExporters.map!`a.str`.join);
}
