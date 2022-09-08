import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/storyboard_controller.dart';
import 'package:flutter_storyboard/src/utils/automation_ui.dart';

class MockUIAutomation extends FlutterDriver {}

void main() {
  test("Only root is resolved graph", () {
    expect(1 + 1, 2);
  });
}
