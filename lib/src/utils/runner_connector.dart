import 'package:flutter_storyboard/src/constants/git_runner_key.dart';

class RunnerConnector {
  static sendMessage(String msgId, String payloadString) {
    print("$STORYBOARD_EVENT_KEY $msgId $payloadString");
  }
}
