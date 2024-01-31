import 'package:logger/logger.dart';

const DEBUG = true;

Logger logger = Logger(
  filter: Filter(),
  printer: Printer(),
);

void info(String message) => logger.i(message);
void warning(String message) => logger.w(message);
void debug(String message) => logger.d(message);
void fatal(String message) => logger.f(message);
void error(String message) => logger.e(message);
void trace(String message) => logger.t(message);

class Filter extends LogFilter {
  List<Level> logLevels = [Level.error, Level.fatal, Level.info, Level.warning];
  @override
  bool shouldLog(LogEvent event) {
    if (DEBUG) {
      return true;
    } else {
      if (logLevels.contains(event.level)) {
        return true;
      }
      return false;
    }
  }
}

class Printer extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return ["[${event.level.name.toUpperCase()}]: ${event.message}"];
  }
}
