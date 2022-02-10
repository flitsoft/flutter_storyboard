import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_page.dart';
import 'package:flutter_storyboard/src/storyboard_model.dart';
import 'package:flutter_storyboard/src/storyboard_view.dart';
import 'package:flutter_storyboard/src/utils/automation_ui.dart';
import 'package:flutter_storyboard/src/utils/screenshotable.dart';
import 'package:flutter_storyboard/src/utils/services/clock_service.dart';
import 'package:flutter_storyboard/src/utils/ui_image_widget.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
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
}

class StoryBoardController {
  Widget spotLight = Container();
  ResolvedGraph? resovedGraphRoot;
  final spotLightScreenshotCtrl = ScreenshotController();
  final graphAreaScreenshotCtrl = ScreenshotController();

  StoryboardGraph? currentGraph;
  final driver = UiAutomationDriver();
  late StoryBoardState view;

  bool spotLightVisible = true;
  bool showFlowInPullRequest = false;
  static bool isFlitWeb = kIsWeb;

  void attach(StoryBoardState storyBoardState) {
    this.view = storyBoardState;
  }

  void toggle() {
    spotLightVisible = !spotLightVisible;
    this.view.applyState();
  }

  void reload() {
    resovedGraphRoot = null;
    onReady();
  }

  void chooseStoryBoard() {
    StoryboardGraph? _graphForStoryboard = view.widget.graphForStoryboard;
    if (_graphForStoryboard == null) return;
    Navigator.push(
      view.context,
      MaterialPageRoute(
          builder: (context) => ChooseStoryBoardPage(
                translator: view.widget.translator,
                onMockEmAll: view.widget.onMockEmAll,
                graphForStoryboard: _graphForStoryboard,
                widgetParent: view.widget.widgetParent,
              )),
    );
  }

  Future<void> onReady() async {
    print("$logTrace");

    if (isCI()) {
      StoryboardGraph? _graphForCiAuto = view.widget.graphForCiAuto;
      if (_graphForCiAuto == null) return;
      await recurse(_graphForCiAuto);
    } else {
      StoryboardGraph? _graphForStoryboard = view.widget.graphForStoryboard;
      if (_graphForStoryboard == null) return;
      await recurse(_graphForStoryboard);
    }
    print("$logTrace All Graph Completed!");
    spotLightVisible = false;
    this.view.applyState();
    await save();

    // await _saveAllGraphScreenshot();
  }

  Future<ResolvedGraph?> recurse(
    StoryboardGraph graph, {
    ResolvedGraph? parent,
  }) async {
    final resolvedGraph = await putOnSpotLight(graph);

    if (resolvedGraph == null) return null;
    if (!graph.enabled) return resolvedGraph;

    resovedGraphRoot ??= resolvedGraph;
    parent?.children.add(resolvedGraph);
    if (graph.showInPullRequest) {
      this.showFlowInPullRequest = true;
    }
    // releasing keyboard used during automation
    this.view.applyState();
    // Waiting for some time to apply state of clean snapshot
    // aka resetting the map, removing layers...
    await Future.delayed(Duration(milliseconds: 500));
    for (final child in graph.children) {
      final resolvedGraphChild = await recurse(child, parent: resolvedGraph);
      if (resolvedGraphChild == null) continue;
    }
    return resolvedGraph;
  }

  Future<ResolvedGraph?> resolveGraph(StoryboardGraph graph) async {
    driver.testTextInput.unregister();
    print("$logTrace driver.testTextInput.unregister();");

    // delay between graphts
    await Future.delayed(Duration(milliseconds: 500));
    print("$logTrace Staging for Screenshot done");
    final img = await spotLightScreenshotCtrl.takeFlutterScreenShoot();
    // fakeAsyncSingleton.elapse(Duration(seconds: 5));
    print("$logTrace Taking for Screenshot done $img");

    if (img == null) return null;
    return ResolvedGraph(
      graph: graph,
      children: [],
      image: img,
    );
  }

  Future<void> _saveAllGraphScreenshot() async {
    print("Saving all graph");
    final img = await graphAreaScreenshotCtrl.takeFlutterScreenShoot();
    print("Saving all graph $img");
    if (img == null) return;
    final dialog = showDialog(
      context: view.context,
      builder: (contet) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(view.context).size.width * 0.7,
            height: MediaQuery.of(view.context).size.height * 0.7,
            child: InteractiveViewer(
              minScale: 0.1,
              boundaryMargin: EdgeInsets.all(500.0),
              child: UIImage(
                image: img,
              ),
            ),
          ),
        );
      },
    );
  }

  UploadTask uploadData(Uint8List imageFile, String fileName) {
    Reference reference =
        FirebaseStorage.instance.ref().child("PR_Storyboards/$fileName");
    UploadTask uploadTask = reference.putData(
        imageFile, SettableMetadata(contentType: 'image/jpeg'));
    return uploadTask;
  }

  Future<void> _downloadImage(Uint8List byteList) async {
    final uriData = UriData.fromBytes(List.from(byteList)).toString();

    print("$logTrace Saving ${uriData.substring(0, 25)},"
        " ${uriData.length}");
    await GoogleMapsWebScreenshot.instance
        .downloadFile(uriData.toString(), "storyboard.png");
    print("$logTrace Saving ${uriData.substring(0, 25)},"
        " ${uriData.length} saved!!");
  }

  Future<void> _uploadAndDownloadUrlText(Uint8List byteList) async {
    final fileName =
        "PR-Image-Screenshots${DateTime.now().millisecondsSinceEpoch}";
    final UploadTask uploadTask = uploadData(byteList, fileName);
    final answer = await uploadTask;
    final url = await answer.ref.getDownloadURL();
    print("Download URL: $url");
    await Future.delayed(Duration(seconds: 4));
    if (showFlowInPullRequest) {
      print("Download IMAGE PR: $url");
    } else {
      print("No image in PR");
    }
    await GoogleMapsWebScreenshot.instance.downloadFile(
        """<img width="1680" alt="$fileName" src="$url">""", "url.txt");
    await Future.delayed(Duration(seconds: 5));
  }

  Future<void> save() async {
    final img = await graphAreaScreenshotCtrl.takeFlutterScreenShoot();
    if (img == null) return;
    final bytes = await img.toByteData(format: ImageByteFormat.png);
    if (bytes == null) return;
    final byteList = bytes.buffer.asUint8List();
    if (isCI()) {
      String relationDescription =
          view.widget.graphForCiAuto?.relationDescription ??
              "graphForCiAuto is null";
      String? imageNumber = view.widget.graphForCiAuto?.imageNumber == ''
          ? "imageNumber is empty"
          : "${view.widget.graphForCiAuto?.imageNumber} ${view.widget.graphForStoryboard?.children.length.toString()}";
      print("Storyboard: $imageNumber : $relationDescription");
      await _uploadAndDownloadUrlText(byteList);
      // final unawaited = _downloadImage(byteList);
      Navigator.of(view.context).pop();
    }
  }

  Future<void> onStoryScreenTap(ResolvedGraph resolvedGraph) async {
    spotLightVisible = true;
    view.applyState();
    await Future.delayed(Duration(milliseconds: 500));
    await putOnSpotLight(resolvedGraph.graph);
  }

  Future<ResolvedGraph?> putOnSpotLight(StoryboardGraph graph) async {
    currentGraph = graph;
    final story = graph.story;
    print("$logTrace ${story.runtimeType}");
    print("\n========================================== "
        "${story.runtimeType}"
        "========================================== ");
    registerService();
    view.widget.onMockEmAll();
    final clockService = GetIt.instance.get<ClockService>();
    final _dummyNow = DateTime(2021, 12, 07);
    clockService.setMockMode(_dummyNow);
    story.init();
    driver.testTextInput.register();
    story.delegate =
        StoryBoardDelegate(translator: view.widget.translator, driver: driver);

    if (graph.enabled == false) {
      spotLight = _rootWidget(
        key: _getNewKey(story),
        home: Center(
          child: Text(
            "Disabled (${graph.children.length})",
          ),
        ),
      );
      this.view.applyState();
      return resolveGraph(graph);
    } else {
      spotLight = _rootWidget(key: _getNewKey(story), home: story.widget);
    }
    this.view.applyState();
    // In some cases, widget is not built until here
    // and initState has not been called,
    // hence you may get initialization errors for late variables
    // Test Case [CarPageTapNext] in driver enrolment
    await Future.delayed(Duration(milliseconds: 500));
    try {
      print("Before arrange after build");
      await story.arrangeAfterBuild();
      print("After arrange after build");
    } catch (e, trace) {
      driver.testTextInput.unregister();
      rethrow;
    }
    story.printSetupTrace();
    print("Before stage");
    await story.stageForScreenshot();
    print("After stage");

    this.view.applyState();
    final ResolvedGraph? resolvedGraph = await resolveGraph(graph);
    print("After resoved $resolvedGraph");

    if (resolvedGraph == null) return null;

    await story.cleanSnapshotLayer();
    print("After clean");

    return resolvedGraph;
  }

  Widget _rootWidget({Key? key, required Widget home}) {
    Widget child;
    try {
      child = view.widget.widgetParent(key, home);
    } catch (exception, stackTrace) {
      child = _createErrorWidget(exception, stackTrace);
    }
    return child;
  }

  // Return a Widget for the given Exception
  Widget _createErrorWidget(Object exception, StackTrace stackTrace) {
    final FlutterErrorDetails details = FlutterErrorDetails(
      exception: exception,
      stack: stackTrace,
      library: 'widgets library',
      context: ErrorDescription('building'),
    );
    FlutterError.reportError(details);
    return ErrorWidget.builder(details);
  }

  static void registerService() {
    GetIt.instance.allowReassignment = true;
    GetIt.instance.registerLazySingleton<ClockService>(() => ClockService());
  }

  Key _getNewKey(BaseStoryScreen story) {
    return Key("${story.runtimeType.toString()}"
        "-${DateTime.now().microsecondsSinceEpoch}");
  }
}
