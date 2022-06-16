import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_page.dart';
import 'package:flutter_storyboard/src/model/resolved_graph.dart';
import 'package:flutter_storyboard/src/model/resolved_graph_container.dart';
import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:flutter_storyboard/src/model/storyboard_graph.dart';
import 'package:flutter_storyboard/src/model/storyboard_model.dart';
import 'package:flutter_storyboard/src/model/view/graph_builder_view_model.dart';
import 'package:flutter_storyboard/src/storyboard_delegate.dart';
import 'package:flutter_storyboard/src/utils/automation_ui.dart';
import 'package:flutter_storyboard/src/utils/internal_utils.dart';
import 'package:flutter_storyboard/src/utils/screenshotable.dart';
import 'package:flutter_storyboard/src/utils/services/clock_service.dart';
import 'package:flutter_storyboard/src/utils/ui_image_widget.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
import 'package:flutter_storyboard/src/view/storyboard_view.dart';
import 'package:get_it/get_it.dart';

class StoryBoardController {
  Widget spotLight = Container();
  ResolvedGraphContainer? resovedGraphRoot;
  final spotLightScreenshotCtrl = ScreenshotController();
  final graphAreaScreenshotCtrl = ScreenshotController();

  StoryboardGraph? currentGraph;
  final driver = UiAutomationDriver();
  late StoryBoardState view;

  bool spotLightVisible = true;
  bool showFlowInPullRequest = false;
  static bool isFlitWeb = kIsWeb;
  static bool isStoryboard = false;
  late StoryboardGraph graphData;

  ///
  /// Method called by FE consumers
  static void registerService() {
    GetIt.instance.allowReassignment = true;
    GetIt.instance.registerLazySingleton<ClockService>(() => ClockService());
  }

  void attach(StoryBoardState storyBoardState) {
    this.view = storyBoardState;
  }

  Future<void> onReady() async {
    final widgetGraphData =
        view.widget.graphForCiAuto ?? view.widget.graphForStoryboard;
    if (widgetGraphData == null) {
      throw Exception("Graph data cannot be null");
    }
    graphData = widgetGraphData;
    print("$logTrace");

    final url =
        "https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b";
    final resolvedGraphUrl = ResolvedGraphDataStore(
      imageUrl: url,
      graphName: 'SplashPageLoading',
      relationDescription: 'root',
      children: [
        ResolvedGraphDataStore(
          imageUrl: url,
          graphName: 'LanguageSignUpPage',
          relationDescription: 'root tap tap',
          children: [
            ResolvedGraphDataStore(
              imageUrl: url,
              graphName: 'ShowMoreLanguageClick',
              relationDescription: 'root tap tap',
              children: [],
              size: Size(411.4, 740.0),
            ),
          ],
          size: Size(411.4, 740.0),
        ),
        ResolvedGraphDataStore(
          imageUrl: url,
          graphName: 'OnBoardingLoading',
          relationDescription: 'root tap tap',
          children: [
            ResolvedGraphDataStore(
              imageUrl: url,
              graphName: 'DragToConfirmYourDriver',
              relationDescription: 'root tap tap',
              children: [
                ResolvedGraphDataStore(
                  imageUrl: url,
                  graphName: 'DragToTrackYourRide',
                  relationDescription: 'root tap tap',
                  children: [],
                  size: Size(411.4, 740.0),
                ),
              ],
              size: Size(411.4, 740.0),
            ),
          ],
          size: Size(411.4, 740.0),
        ),
      ],
      size: Size(411.4, 740.0),
    );

    _flattenStoryboardGraph(graphData);
    _recursePrebuild(resolvedGraphUrl, []);
    this.view.applyState();

    if (isCI()) {
      StoryboardGraph? _graphForCiAuto = view.widget.graphForCiAuto;
      if (_graphForCiAuto == null) return;
      await _recurse(_graphForCiAuto);
    } else {
      StoryboardGraph? _graphForStoryboard = view.widget.graphForStoryboard;
      if (_graphForStoryboard == null) return;
      await _recurse(_graphForStoryboard);
    }
    print("$logTrace All Graph Completed!");
    spotLightVisible = false;
    this.view.applyState();
    await _save();

    // await _saveAllGraphScreenshot();
  }

  Future<ResolvedGraphContainer?> _recurse(
    StoryboardGraph graph, {
    ResolvedGraphContainer? parent,
  }) async {
    // parent ??= resovedGraphRoot;
    final siblings = parent == null ? [] : parent.children;

    final _resolvedGraph = await _putOnSpotLight(graph);

    if (_resolvedGraph == null) return null;
    // if (parent == null) {
    //   resovedGraphRoot = _resolvedGraph;
    // }

    final preBuiltResolvedGraph = siblings.firstWhereOrNull((element) {
      final remote = element.remote;
      if (remote == null) return false;
      return remote.graph == _resolvedGraph.graph;
    });
    final resolvedGraph = preBuiltResolvedGraph ?? ResolvedGraphContainer();

    resolvedGraph.locale = _resolvedGraph;

    if (!graph.enabled) return resolvedGraph;

    resovedGraphRoot ??= resolvedGraph;
    if (parent != null) {
      parent.children.add(resolvedGraph);
    }

    if (graph.showInPullRequest) {
      this.showFlowInPullRequest = true;
    }
    // releasing keyboard used during automation
    this.view.applyState();
    // Waiting for some time to apply state of clean snapshot
    // aka resetting the map, removing layers...
    await Future.delayed(Duration(milliseconds: 500));
    for (final child in graph.children) {
      final resolvedGraphChild = await _recurse(child, parent: resolvedGraph);
      if (resolvedGraphChild == null) continue;
    }
    return resolvedGraph;
  }

  Map<int, ImageWidgetData> images = {};

  void _recursePrebuild(
    ResolvedGraphDataStore resolvedGraphUrl,
    List<String> parentPath, {
    ResolvedGraphContainer? parent,
  }) {
    final graph = _findGraph(parentPath);
    final image = ImageWidgetData(
      image: Image.network(resolvedGraphUrl.imageUrl),
      size: resolvedGraphUrl.size,
    );

    final id = image.hashCode;
    images[id] = image;

    final resolved = ResolvedGraphFromRemote(
        graphName: resolvedGraphUrl.graphName,
        relationDescription: resolvedGraphUrl.relationDescription,
        graph: graph == null ? null : graph.hashCode,
        imageUrl: resolvedGraphUrl.imageUrl,
        image: image.hashCode);
    final resolvedGraph = ResolvedGraphContainer(remote: resolved);
    resovedGraphRoot ??= resolvedGraph;
    parent?.children.add(ResolvedGraphContainer(remote: resolved));
    final newParentPath = [...parentPath, resolvedGraphUrl.graphName];
    for (final child in resolvedGraphUrl.children) {
      _recursePrebuild(child, newParentPath, parent: resolvedGraph);
    }
  }

  Future<ResolvedGraphFromBuild?> _resolveGraph(StoryboardGraph graph) async {
    driver.testTextInput.unregister();
    print("$logTrace driver.testTextInput.unregister();");

    // delay between graphts
    await Future.delayed(Duration(milliseconds: 500));
    print("$logTrace Staging for Screenshot done");
    final img = await spotLightScreenshotCtrl.takeFlutterScreenShoot();
    // fakeAsyncSingleton.elapse(Duration(seconds: 5));
    print("$logTrace Taking for Screenshot done $img");

    if (img == null) return null;
    final image = ImageWidgetData(
      image: UIImage(image: img),
      size: Size(
        img.width.toDouble(),
        img.height.toDouble(),
      ),
    );
    images[image.hashCode] = image;
    return ResolvedGraphFromBuild(
      graph: graph.hashCode,
      image: image.hashCode,
      relationDescription: graph.relationDescription,
      graphName: graph.story.runtimeType.toString(),
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

  UploadTask _uploadData(Uint8List imageFile, String fileName) {
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
    String urlWithIsShowInPrKey = 'urlWithIsShowInPrKey';
    final UploadTask uploadTask = _uploadData(byteList, fileName);
    final answer = await uploadTask;
    final url = await answer.ref.getDownloadURL();
    print("$urlWithIsShowInPrKey=>$url=>${showFlowInPullRequest.toString()}");
    await GoogleMapsWebScreenshot.instance.downloadFile(
        """<img width="1680" alt="$fileName" src="$url">""", "url.txt");
    await Future.delayed(Duration(seconds: 5));
  }

  Future<void> _save() async {
    String storyboardKey = "storyboardKey";
    final img = await graphAreaScreenshotCtrl.takeFlutterScreenShoot();
    if (img == null) return;
    final bytes = await img.toByteData(format: ImageByteFormat.png);
    if (bytes == null) return;
    final byteList = bytes.buffer.asUint8List();
    if (isCI()) {
      String relationDescription =
          view.widget.graphForCiAuto?.relationDescription ??
              "graphForCiAuto is null";
      print("$storyboardKey $relationDescription");
      await _uploadAndDownloadUrlText(byteList);
      // final unawaited = _downloadImage(byteList);
      Navigator.of(view.context).pop();
    }
  }

  Future<ResolvedGraphFromBuild?> _putOnSpotLight(StoryboardGraph graph) async {
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
      return _resolveGraph(graph);
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
    final ResolvedGraphFromBuild? resolvedGraph = await _resolveGraph(graph);
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

  Key _getNewKey(BaseStoryScreen story) {
    return Key("${story.runtimeType.toString()}"
        "-${DateTime.now().microsecondsSinceEpoch}");
  }

  StoryboardGraph? _findGraph(List<String> parentPath) {
    StoryboardGraph graph = graphData;
    for (String parent in parentPath) {
      final childFound = graph.children.firstWhereOrNull(
          (element) => element.story.runtimeType.toString() == parent);
      if (childFound == null) return null;
      graph = childFound;
    }
    return graph;
  }

  Map<int, StoryboardGraph> graphMap = {};

  void _flattenStoryboardGraph(StoryboardGraph graphData) {
    graphMap[graphData.hashCode] = graphData;
    for (final child in graphData.children) {
      _flattenStoryboardGraph(child);
    }
  }

  GraphBuilderViewModel? viewModel(ResolvedGraphContainer resolvedGraph) {
    int? imageId;
    final isOveriding =
        ResolvedGraphContainerWithBoth.castFrom(resolvedGraph) != null;
    final resolvedGraphLocal =
        ResolvedGraphContainerWithLocal.castFrom(resolvedGraph);
    if (resolvedGraphLocal != null) {
      final locale = resolvedGraphLocal.locale;
      imageId = locale.image;
      final image = images[imageId];
      if (image == null) return null;
      return GraphBuilderViewModel(
        image: image,
        description: locale.relationDescription,
        title: locale.graphName,
        overriding: isOveriding,
      );
    }
    final resolvedGraphWithRemote =
        ResolvedGraphContainerWithRemote.castFrom(resolvedGraph);
    if (resolvedGraphWithRemote != null) {
      final remote = resolvedGraphWithRemote.remote;
      imageId = remote.image;
      final image = images[imageId];
      if (image == null) return null;
      return GraphBuilderViewModel(
        image: image,
        description: remote.relationDescription,
        title: remote.graphName,
        overriding: isOveriding,
      );
    }
    return null;
  }
}

extension StoryBoardControllerAction on StoryBoardController {
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

  Future<void> onStoryScreenTap(ResolvedGraphContainer resolvedGraph) async {
    int? graphId;
    final resolvedGraphLocal =
        ResolvedGraphContainerWithLocal.castFrom(resolvedGraph);
    if (resolvedGraphLocal != null) {
      graphId = resolvedGraphLocal.locale.graph;
    }
    final resolvedGraphWithRemote =
        ResolvedGraphContainerWithRemote.castFrom(resolvedGraph);
    if (resolvedGraphWithRemote != null) {
      graphId = resolvedGraphWithRemote.remote.graph;
    }
    if (graphId == null) {
      print("Graph code could not be found");
      return;
    }
    final graph = graphMap[graphId];
    if (graph == null) {
      print("Graph code could not be found");
      return;
    }
    spotLightVisible = true;
    view.applyState();
    await Future.delayed(Duration(milliseconds: 500));
    await _putOnSpotLight(graph);
  }
}
