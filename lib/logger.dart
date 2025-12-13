// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';

final rootLogger = Logger("Root");

class Logger {
  LogLevel _logLevel = LogLevel.Info;
  LogLevel _errLevel = LogLevel.Error;

  set errLevel(LogLevel level) => _errLevel = level;
  set logLevel(LogLevel level) => _logLevel = level;

  bool colors = false;
  bool shortLevel = true;

  final String? name;
  IOSink? logFile;

  Logger(this.name, {LogLevel? logLevel, LogLevel? errLevel, String? logFile}) {
    if (logFile != null) this.logFile = File(logFile).openWrite(mode: FileMode.append);
    _logLevel = logLevel ?? LogLevel.Info;
    _errLevel = errLevel ?? LogLevel.Error;
  }

  Logger clone(String? name, {String? logFile}) {
    Logger newLogger = Logger(name ?? this.name, logFile: logFile);
    newLogger._errLevel = _errLevel;
    newLogger._logLevel = _logLevel;
    newLogger.colors = colors;
    return newLogger;
  }

  void fatal(String msg, {StackTrace? st}) => log(msg, LogLevel.Fatal, stackTrace: st);
  void error(String msg, {StackTrace? st}) => log(msg, LogLevel.Error, stackTrace: st);
  void warning(String msg, {StackTrace? st}) => log(msg, LogLevel.Warning, stackTrace: st);
  void info(String msg, {StackTrace? st}) => log(msg, LogLevel.Info, stackTrace: st);
  void debug(String msg, {StackTrace? st}) => log(msg, LogLevel.Debug, stackTrace: st);
  void trace(String msg, {StackTrace? st}) => log(msg, LogLevel.Trace, stackTrace: st);

  /// Write a log message
  void log(String message, LogLevel level, {StackTrace? stackTrace}) {
    if (level < _logLevel) return;
    String msg = _buildMessage(message, level, stackTrace);
    // Write to file
    if (logFile != null) {
      logFile!.write("$msg\n");
    }
    // Write console
    if (level > _errLevel) {
      return stderr.write("$msg\n");
    }
    return stdout.write("$msg\n");
  }

  /// Build the log message
  String _buildMessage(String message, LogLevel level, StackTrace? stackTrace) {
    StringBuffer buffer = StringBuffer();
    final time = DateTime.now().toLocal();
    final levelName = shortLevel ? "[${LogLevel.shortLevelNames[level.value]}]": "[${LogLevel.levelNames[level.value]}]";
    buffer.write(DateFormat("yyyy-MM-dd HH:mm:ss").format(time));
    buffer.write(" $levelName ");
    if (name != null) {
      buffer.write("[$name] ");
    }
    buffer.write(": $message");
    if (stackTrace != null) {
      final trace = Trace.from(stackTrace).terse;
      buffer.write("\n${trace.toString()}");
    }
    return buffer.toString();
  }
}

class LogLevel {
  LogLevel(int value) : _value = value;
  final int _value;

  int get value => _value;

  /// No log
  static LogLevel get None => LogLevel(2000);

  /// Fatal log that requires program to exit
  static LogLevel get Fatal => LogLevel(1000);

  /// Something clearly wrong
  static LogLevel get Error => LogLevel(800);

  /// Something to be cautious about
  static LogLevel get Warning => LogLevel(600);

  /// Default log level
  static LogLevel get Info => LogLevel(400);

  /// May or may not be of interest
  static LogLevel get Debug => LogLevel(200);

  /// With stack trace
  static LogLevel get Trace => LogLevel(100);

  static Map<int, String> get levelNames => {
    100: 'TRACE',
    200: 'DEBUG',
    400: 'INFO',
    600: 'WARNING',
    800: 'ERROR',
    1000: 'FATAL',
    2000: 'NONE',
  };

  static Map<int, String> get shortLevelNames => const {
    100: 'T',
    200: 'D',
    400: 'I',
    600: 'W',
    800: 'E',
    1000: 'F',
    2000: 'N',
  };

  static Map<int, String> get levelColors => {
    100: '\x1B[34m',
    200: '\x1B[36m',
    400: '\x1B[32m',
    600: '\x1B[33m',
    800: '\x1B[31m',
    1000: '\x1B[35m',
    2000: '\x1B[0m',
  };

  bool operator >(LogLevel other) => _value > other._value;
  bool operator <(LogLevel other) => _value < other._value;
  @override
  bool operator ==(Object other) => other is LogLevel && other.value == value;
}
