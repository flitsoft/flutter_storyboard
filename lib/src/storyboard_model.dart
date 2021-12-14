import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/utils/util.dart';

class StoryboardGraph {
  bool enabled;
  bool showInPullRequest;
  final BaseStoryScreen story;
  final String relationDescription;
  final List<StoryboardGraph> children;

  StoryboardGraph(
      {this.enabled = true,
      this.showInPullRequest = false,
      required this.story,
      required this.relationDescription,
      required this.children});
}

class StoryBoardRelationship {
  final BaseStoryScreen parent;
  final BaseStoryScreen child;
  final String relationDescription;

  StoryBoardRelationship({
    required this.parent,
    required this.child,
    required this.relationDescription,
  });
}

class ResolvedGraph {
  final StoryboardGraph graph;
  final ui.Image image;
  final List<ResolvedGraph> children;

  ResolvedGraph({
    required this.graph,
    required this.image,
    required this.children,
  });
}

abstract class StoryScreenDelegate<T> {
  Future<void> onPumpAndSettle(Duration duration);
  Future<void> onTap({T? stringCode, Key? key, String? text});
  Future<void> onEnterText(String text);
  Future<void> sendTextInputAction(TextInputAction action);
  Future<void> drag({
    required Key from,
    required Key to,
    required Duration during,
  });
  Future<void> onPump(Duration duration);
}

abstract class StoryScreen {
  late StoryScreenDelegate delegate;
  late Widget widget;

  /// Called before build and after container is ready
  /// Init things that Cannot be done within Constructor
  /// because dependant on Container being ready
  void init();

  /// Called after widget is built
  Future<void> arrangeAfterBuild();

  /// Called after build
  Future<void> stageForScreenshot();

  /// Called after screenshot
  Future<void> cleanSnapshotLayer();
}

////////////////// DATA
class BaseStoryScreen<T> extends StoryScreen {
  final List<String> setLogs = [];
  void step() {
    final stackList = StackTrace.current.toString().split("\n").toList();
    final trace = '[ARRANGE] ' + stackList[1].split("      ").last;
    final traceSource = '[ARRANGE] ' + stackList[2].split("      ").last;
    setLogs.add(traceSource);
    setLogs.add(trace);
  }

  /// [duration] real duration as pump and settle is not working in real device
  Future<void> pumpAndSettle(Duration duration) async {
    await delegate.onPumpAndSettle(duration);
  }

  Future<void> pump(Duration duration) async {
    await delegate.onPump(duration);
  }

  Future<void> enterText(String text) async {
    await delegate.onEnterText(text);
  }

  Future<void> sendTextInputAction(TextInputAction action) async {
    await delegate.sendTextInputAction(action);
  }

  Future<void> drag({
    required Key from,
    required Key to,
    required Duration during,
  }) async {
    await delegate.drag(from: from, to: to, during: during);
  }

  /// only use [textRaw] when absolutely needed
  /// Prefer using [text] because it is Localization safe
  Future<void> tap({T? text, Key? key, String? textRaw}) async {
    final item = [text, key, textRaw].where((e) => e != null);
    if (item.length != 1) throw "Choose only either a key or text or textRaw";
    try {
      await delegate.onTap(stringCode: text, key: key, text: textRaw);
    } catch (e, trace) {
      Zone.current.parent?.handleUncaughtError(e, trace);
    }
    // print("$logTrace Attempt to tap while story is not yet built");
  }

  void printSetupTrace() {
    print("\n=================================SETUP INFO=====================");
    print("[Test Setup Info] This is how the widget has been setup initially");
    setLogs.reversed.forEach((element) {
      print(element);
    });
    print(
        "=================================SETUP INFO DONE =====================\n");

    // print(setLogs);
  }

  @override
  Future<void> arrangeAfterBuild() async {
    print("$logTrace Overide me");
  }

  @override
  void init() {
    print("$logTrace Overide me");
  }

  @override
  Future<void> stageForScreenshot() async {
    print("$logTrace Overide me");
  }

  @override
  Future<void> cleanSnapshotLayer() async {
    print("$logTrace Overide me");
  }

  // void isExpected() {
  //   print("$logTrace Overide me");
  // }
}
