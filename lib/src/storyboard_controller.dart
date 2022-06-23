import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_page.dart';
import 'package:flutter_storyboard/src/model/graph_shallow_reference.dart';
import 'package:flutter_storyboard/src/model/resolved_graph.dart';
import 'package:flutter_storyboard/src/model/resolved_graph_container.dart';
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

import 'storyboard_core.dart';

class StoryBoardController {
  late StoryboardCore core = StoryboardCore(this);
  Widget spotLight = Container();
  ResolvedGraphContainer get resolvedGraphRoot => core.resolvedGraphRoot;
  final spotLightScreenshotCtrl = ScreenshotController();
  final graphAreaScreenshotCtrl = ScreenshotController();

  Map<int, ImageWidgetData> get images => core.images;
  Map<int, StoryboardGraph> get graphMap => core.graphMap;
  StoryboardGraph? currentGraph;
  late final driver = UiAutomationDriver();
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

  void applyState() {
    this.view.applyState();
  }

  void attach(StoryBoardState storyBoardState) {
    this.view = storyBoardState;
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

  Future<void> save() async {
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

  Future<ResolvedGraphFromBuild?> putOnSpotLight(StoryboardGraph graph) async {
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
    this.registerKeyboard();
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
      return core.resolveGraph(graph);
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
      this.deregisterKeyboard();
      rethrow;
    }
    story.printSetupTrace();
    print("Before stage");
    await story.stageForScreenshot();
    print("After stage");

    this.view.applyState();
    final ResolvedGraphFromBuild? resolvedGraph =
        await core.resolveGraph(graph);
    print("$logTrace After resoved");

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

  GraphBuilderViewModel? viewModel(ResolvedGraphContainer resolvedGraph) {
    int? imageId;
    final isOverriding =
        ResolvedGraphContainerWithBoth.castFrom(resolvedGraph) != null;
    final resolvedGraphLocal =
        ResolvedGraphContainerWithLocal.castFrom(resolvedGraph);
    if (resolvedGraphLocal != null) {
      final locale = resolvedGraphLocal.local;
      imageId = locale.image;
      final image = images[imageId];
      if (image == null) return null;
      return GraphBuilderViewModel(
        image: image,
        description: locale.relationDescription,
        title: locale.graphName,
        overriding: isOverriding,
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
        overriding: isOverriding,
      );
    }
    return null;
  }

  List<ResolvedGraphContainer> _getSiblings(ResolvedGraphContainer? parent) {
    final resolvedGraphRootLocal = resolvedGraphRoot;

    final List<ResolvedGraphContainer> siblings = [];
    if (parent == null && resolvedGraphRootLocal != null) {
      siblings.add(resolvedGraphRootLocal);
      return siblings;
    }
    if (parent == null) {
      return siblings;
    }
    siblings.addAll(parent.children);
    return siblings;
  }

  void deregisterKeyboard() {
    this.driver.testTextInput.unregister();
  }

  void registerKeyboard() {
    driver.testTextInput.register();
  }

  Future<ImageWidgetData?> takeFlutterScreenShoot() async {
    final img = await spotLightScreenshotCtrl.takeFlutterScreenShoot();
    if (img == null) return null;

    final image = ImageWidgetData(
      image: UIImage(image: img),
      size: Size(
        img.width.toDouble(),
        img.height.toDouble(),
      ),
    );
    return image;
  }
}

extension StoryBoardControllerAction on StoryBoardController {
  void toggle() {
    spotLightVisible = !spotLightVisible;
    this.view.applyState();
  }

  void reload() {
    core.reload();
    core.onReady();
  }

  void startUp() {
    final widgetGraphData =
        view.widget.graphForCiAuto ?? view.widget.graphForStoryboard;
    if (widgetGraphData == null) {
      throw Exception("Graph data cannot be null");
    }
    graphData = widgetGraphData;
    core.onReady();
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
    final graph = lookupGraph(resolvedGraph)?.graph;
    if (graph == null) {
      print("Graph code could not be found");
      return;
    }
    spotLightVisible = true;
    view.applyState();
    await Future.delayed(Duration(milliseconds: 500));
    await putOnSpotLight(graph);
  }

  GraphShallowReference? lookupGraphLocale(
      ResolvedGraphContainer resolvedGraph) {
    final resolvedGraphLocal =
        ResolvedGraphContainerWithLocal.castFrom(resolvedGraph);
    if (resolvedGraphLocal == null) return null;
    final graph = graphMap[resolvedGraphLocal.local.graph];
    final image = images[resolvedGraphLocal.local.image];
    return GraphShallowReference(graph: graph, image: image);
  }

  GraphShallowReference? lookupGraphRemote(
      ResolvedGraphContainer resolvedGraph) {
    final resolvedGraphLocal =
        ResolvedGraphContainerWithRemote.castFrom(resolvedGraph);
    if (resolvedGraphLocal == null) return null;
    final graphId = resolvedGraphLocal.remote.graph;
    final graph = graphId == null ? null : graphMap[graphId];
    final image = images[resolvedGraphLocal.remote.image];
    return GraphShallowReference(graph: graph, image: image);
  }

  GraphShallowReference? lookupGraph(ResolvedGraphContainer resolvedGraph) {
    final graphLocale = lookupGraphLocale(resolvedGraph);
    if (graphLocale != null) return graphLocale;
    final graphRemote = lookupGraphRemote(resolvedGraph);
    return graphRemote;
  }
}
