import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/model/storyboard_model.dart';
import 'package:flutter_storyboard/src/utils/automation_ui.dart';
import 'package:flutter_storyboard/src/utils/internal_utils.dart';
import 'package:flutter_storyboard/src/utils/services/clock_service.dart';
import 'package:get_it/get_it.dart';

class StoryBoardDelegate implements StoryScreenDelegate {
  final UiAutomationDriver driver;
  final String Function(dynamic stringCode) translator;
  StoryBoardDelegate({required this.translator, required this.driver});

  ClockService get clockService => GetIt.instance.get<ClockService>();

  @override
  Future<void> onEnterText(String text) async {
    driver.testTextInput.enterText(text);
  }

  @override
  Future<void> sendTextInputAction(TextInputAction action) async {
    await driver.testTextInput.receiveAction(action);
  }

  @override
  Future<void> onPump(Duration duration) async {
    await clockService.elapse(duration);
  }

  @override
  Future<void> onPumpAndSettle(Duration duration) {
    return Future.delayed(duration);
  }

  @override
  Future<void> drag({
    required Key from,
    required Key to,
    required Duration during,
  }) async {
    final fromFinder = find.byValueKey((from as ValueKey).value);
    final toCenter =
        await driver.getCenter(find.byValueKey((to as ValueKey).value));
    final fromCenter = await driver.getCenter(fromFinder);
    final dx = toCenter.dx - fromCenter.dx;
    final dy = toCenter.dy - fromCenter.dy;
    print("$logTrace Dragging from $fromFinder with x: $dx, y: $dy");
    await driver.scroll(fromFinder, dx, dy, during);
  }

  @override
  Future<void> onTap({dynamic stringCode, Key? key, String? text}) async {
    if (stringCode != null) {
      await driver.tap(find.text(translator(stringCode)));
    } else if (key != null) {
      await driver.tap(find.byValueKey((key as ValueKey).value));
    } else if (text != null) {
      await driver.tap(find.text(text));
    }
  }

  @override
  Future<void> onLongPress({dynamic stringCode, Key? key, String? text}) async {
    if (stringCode != null) {
      await driver.longPress(find.text(translator(stringCode)));
    } else if (key != null) {
      await driver.longPress(find.byValueKey((key as ValueKey).value));
    } else if (text != null) {
      await driver.longPress(find.text(text));
    }
  }
}
