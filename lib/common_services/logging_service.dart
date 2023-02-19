
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggingService {

  Logger getLogger(dynamic caller) {

    if ((kDebugMode)) {
      return Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 5,
          lineLength: 50,
          colors: true,
          printEmojis: true,
          printTime: false,
        )
      );

    } else {
      return Logger(printer: SimpleLogPrinter(caller.runtimeType.toString()));
    }
  }

  Logger getLoggerNoCaller() {

    if ((kDebugMode)) {
      return Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 5,
          lineLength: 50,
          colors: true,
          printEmojis: true,
          printTime: false,
        )
      );

    } else {
      return Logger(printer: SimpleLogPrinter(""));
    }
  }
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);  
  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];

    StackTrace? newStackTrace;
    if (event.stackTrace != null) {
      String stackTraceString = event.stackTrace.toString();
      var frames = stackTraceString.split('\n');
      String newStackTraceString = "";

      for (var i = 0; i < 5; i++) {
        if (i == 0) {
          newStackTraceString += "${'\n'}${event.error.message}${'\n'}";
        }
        newStackTraceString += "${frames[i]}${'\n'}";
      }

      newStackTrace = StackTrace.fromString(newStackTraceString);
    }

    return [(color!('$emoji $className - ${event.message}$newStackTrace'))];
  }
}