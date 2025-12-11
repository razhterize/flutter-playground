// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';

final rootLogger = Logger("Root");

class Logger {
  LogLevel logLevel = LogLevel.Info;
  LogLevel errLevel = LogLevel.Error;
  bool colors = false;

  final String? name;
  IOSink? logFile;

  Logger(this.name, {LogLevel? logLevel, LogLevel? errLevel, String? logFile}) {
    if (logFile != null) this.logFile = File(logFile).openWrite(mode: FileMode.append);
    this.logLevel = logLevel ?? LogLevel.Info;
    this.errLevel = errLevel ?? LogLevel.Error;
  }

  Logger clone(String? name, {String? logFile}) {
    Logger newLogger = Logger(name ?? this.name, logFile: logFile);
    newLogger.errLevel = errLevel;
    newLogger.logLevel = logLevel;
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
    if (level < logLevel) return;
    String msg = _buildMessage(message, level, stackTrace);
    // Write to file
    if (logFile != null) {
      logFile!.write("$msg\n");
    }
    // Write console
    if (level > errLevel) {
      return stderr.write("$msg\n");
    }
    return stdout.write("$msg\n");
  }

  /// Build the log message
  String _buildMessage(String message, LogLevel level, StackTrace? stackTrace) {
    StringBuffer buffer = StringBuffer();
    final time = DateTime.now().toLocal();
    final levelName = "[${LogLevel.levelNames[level]}]";
    buffer.write(DateFormat("yyyy-MM-dd HH:mm:ss").format(time));
    buffer.write(" $levelName ");
    if (name != null) {
      buffer.write("[$name] ");
    }
    buffer.write(": $message");
    if (stackTrace != null) {
      final trace = Trace.from(stackTrace);
      buffer.write("\n${trace.terse}");
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

  static Map<LogLevel, String> get levelNames => {
    Trace: 'TRACE',
    Debug: 'DEBUG',
    Info: 'INFO',
    Warning: 'WARNING',
    Error: 'ERROR',
    Fatal: 'FATAL',
    None: 'NONE',
  };

  static Map<LogLevel, String> get levelColors => {
    Trace: '\x1B[34m',
    Debug: '\x1B[36m',
    Info: '\x1B[32m',
    Warning: '\x1B[33m',
    Error: '\x1B[31m',
    Fatal: '\x1B[35m',
    None: '\x1B[0m',
  };

  bool operator >(LogLevel other) => _value > other._value;
  bool operator <(LogLevel other) => _value < other._value;
  @override
  bool operator ==(Object other) => other is LogLevel && other.value == value;
}
