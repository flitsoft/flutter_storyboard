import 'package:stack_trace/stack_trace.dart';

const allowedPackage = ["ride_app"];
const ignoredLibrary = ["test/utils", "test/widget_tests/common"];

Trace formatFilterStack(Chain stack) {
  print("[Chain] Warning!Showing only errors "
      "from Package $allowedPackage. "
      "And ignored folder $ignoredLibrary."
      "There could be more. If you are debugging "
      "and you don't see your log, disable this");
  final packageFrames = stack.toTrace().frames.where((element) {
    if (element.isCore) return false;
    for (final lib in ignoredLibrary) {
      if (element.library.startsWith(lib)) return false;
    }
    return element.package == null || allowedPackage.contains(element.package);
  });
  return Trace(packageFrames);
}

void prettyPrintChainTrace(Object error, Chain stack) {
  print(
      "\n\n======================== CHAIN ERROR CAPTURING FULL TRACE ========================");
  print("$error");

  final trace = formatFilterStack(stack);
  // print("Chain ${Trace.from(stack).terse}");
  print("[Chain] filtered trace  \n$trace ");

  print(
      "======================== CHAIN ERROR CAPTURING FULL COMPLETED ========================");
}
