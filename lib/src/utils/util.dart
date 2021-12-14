bool isCI() {
  String ci = const String.fromEnvironment("CI");
  print("CI Variable is: $ci");

  return ci == "true";
}

String getCiStoryboardFlow() {
  String storyboardFlow = const String.fromEnvironment("STORYBOARD_FLOW");
  print("CI Selected Flow is: $storyboardFlow");
  return storyboardFlow;
}

String get logTrace =>
    '[EVENT] ' +
    StackTrace.current.toString().split("\n").toList()[1].split("      ").last;
