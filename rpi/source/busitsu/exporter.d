module busitsu.exporter;

shared static Gauge!float GaugeTemp;
shared static Gauge!float GaugeHumid;
shared static Exporter[] DefaultExporters;

shared static this() {
  GaugeTemp   = cast(shared Gauge!float)(new Gauge!float("busitsu_temp", "busitsu temperature", -255.));
  GaugeHumid  = cast(shared Gauge!float)(new Gauge!float("busitsu_humid", "busitsu humidity", -255.));
  DefaultExporters = [
    GaugeTemp,
    GaugeHumid,
  ];
}

interface Exporter {
  @property
  shared string str();
}

class Gauge(T) : Exporter {
  string _name;
  string _help;
  T _val;

  this(string name, string help, T val) {
    _name = name;
    _help = help;
    _val = val;
  }

  shared @property {
    string str() {
      import std.format: format;
      return format!"# HELP %s %s\n# TYPE %s gauge\n%s %s\n"
                    (_name, _help, _name, _name, _val);
    }
    T val() {
      return _val;
    }
    void val(T newVal) {
      _val = newVal;
    }
  }
}
