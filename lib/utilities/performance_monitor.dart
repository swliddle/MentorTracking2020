class PerformanceMonitor {
  var _start = DateTime.now();

  void start() {
    _start = DateTime.now();
  }

  Duration timeElapsed() {
    return DateTime.now().difference(_start);
  }
}
