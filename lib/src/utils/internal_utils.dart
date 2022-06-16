String get logTrace =>
    '[EVENT] ' +
    StackTrace.current.toString().split("\n").toList()[1].split("      ").last;
