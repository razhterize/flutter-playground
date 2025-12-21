import 'dart:convert';
import 'dart:io';
import 'dart:async';
import '../core/types.dart';

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

/// Parse all json in [Directory] dir
/// Key will be file's name without extension
JsonType getAllJson(Directory dir) {
  JsonType results = {};
  bool pred(File f) => f.path.endsWith('.json');
  final files = dir.listSync().whereType<File>().where(pred);
  for (var f in files) {
    String key = f.path.split('/').last.replaceAll('.json', '');
    JsonType json = jsonDecode(f.readAsStringSync());
    results.addAll({key: json});
  }
  return results;
}

extension PrecisionRound on double {
  double toPrecision(int n) => double.tryParse(toStringAsFixed(n)) ?? this;
}
