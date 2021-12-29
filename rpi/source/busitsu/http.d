module busitsu.http;

import vibe.vibe;
import busitsu.exporter;

enum Port = 8080;

void listen() {
  auto router = new URLRouter;
  router.get("/", &handleGetIndex);
  router.get("/metrics", &handleGetMetrics);

  auto settings = new HTTPServerSettings;
  settings.port = Port;

  listenHTTP(settings, router);

  runApplication();
}

private:

void handleGetIndex(HTTPServerRequest req, HTTPServerResponse res) {
}

void handleGetMetrics(HTTPServerRequest req, HTTPServerResponse res) {
  import std.algorithm.iteration: map;
  import std.array: join;
  res.writeBody(DefaultExporters.map!`a.str`.join);
}
