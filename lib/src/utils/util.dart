bool isCI() {
  String ci = const String.fromEnvironment("CI");
  print("CI Variable is: $ci");

  return ci == "true";
}

String get logTrace =>
    '[EVENT] ' +
    StackTrace.current.toString().split("\n").toList()[1].split("      ").last;
