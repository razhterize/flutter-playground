import 'dart:io';
import 'dart:async';
import 'logger.dart';

final Stopwatch _stopwatch = Stopwatch();

void timeFunction(Function() func, [String? name]) {
  if (_stopwatch.isRunning) {
    _stopwatch.stop();
    _stopwatch.reset();
  }
  _stopwatch.start();
  func();
  _stopwatch.stop();
  final ms = _stopwatch.elapsedMilliseconds;
  final us = _stopwatch.elapsedMicroseconds;
  rootLogger.info("${name ?? func} execution takes $us μs / $ms ms");
}

extension PrecisionRound on double {
  double toPrecision(int n) => double.tryParse(toStringAsFixed(n)) ?? this;
}
