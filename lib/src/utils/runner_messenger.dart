import 'package:flutter_storyboard/src/constants/git_runner_key.dart';

///
/// This function has to be async because from observation, Dart print within the same event loop are mixed together in one stdout event
/// So subsequent sync print after this will be merged into one stdout event
class RunnerMessenger {
  static sendMessage(String msgId, String payloadString) async {
    await Future.delayed(Duration(milliseconds: 1));
    print("$STORYBOARD_EVENT_KEY $msgId $payloadString");
    await Future.delayed(Duration(milliseconds: 1));
  }
}
