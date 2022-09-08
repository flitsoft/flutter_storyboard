import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_page.dart';
import 'package:flutter_storyboard/src/constants/git_runner_key.dart';
import 'package:flutter_storyboard/src/model/graph_shallow_reference.dart';
import 'package:flutter_storyboard/src/model/resolved_graph.dart';
import 'package:flutter_storyboard/src/model/resolved_graph_container.dart';
import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:flutter_storyboard/src/model/runner_model.dart';
import 'package:flutter_storyboard/src/model/storyboard_graph.dart';
import 'package:flutter_storyboard/src/model/storyboard_model.dart';
import 'package:flutter_storyboard/src/model/view/graph_builder_view_model.dart';
import 'package:flutter_storyboard/src/services/storyboard_repository.dart';
import 'package:flutter_storyboard/src/storyboard_delegate.dart';
import 'package:flutter_storyboard/src/utils/automation_ui.dart';
import 'package:flutter_storyboard/src/utils/internal_utils.dart';
import 'package:flutter_storyboard/src/utils/runner_messenger.dart';
import 'package:flutter_storyboard/src/utils/screenshotable.dart';
import 'package:flutter_storyboard/src/utils/services/clock_service.dart';
import 'package:flutter_storyboard/src/utils/ui_image_widget.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
import 'package:flutter_storyboard/src/view/storyboard_view.dart';
import 'package:get_it/get_it.dart';

import 'storyboard_core.dart';

class StoryBoardController {
  GraphDataStore? graphStoreData;
  late StoryboardCore core = StoryboardCore(this);
  Widget spotLight = Container();
  ResolvedGraphContainer get resolvedGraphRoot => core.resolvedGraphRoot;
  final spotLightScreenshotCtrl = ScreenshotController();
  final graphAreaScreenshotCtrl = ScreenshotController();

  final storyboardRepo = StoryboardRepository();
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
    final _ = showDialog(
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

  Future<String> _uploadAndDownloadUrlText(Uint8List byteList) async {
    final fileName =
        "PR-Image-Screenshots${DateTime.now().millisecondsSinceEpoch}";
    final UploadTask uploadTask = _uploadData(byteList, fileName);
    final answer = await uploadTask;
    final url = await answer.ref.getDownloadURL();
    await GoogleMapsWebScreenshot.instance.downloadFile(
      """<img width="1680" alt="$fileName" src="$url">""",
      "url.txt",
    );
    await Future.delayed(Duration(seconds: 5));
    return url;
  }

  Future<Uint8List?> _convertImageToBytes(ui.Image img) async {
    final bytes = await img.toByteData(format: ImageByteFormat.png);
    if (bytes == null) return null;
    return bytes.buffer.asUint8List();
  }

  Future<void> save() async {
    await _trySaveDataStore();
    if (!isCI()) return;
    final img = await graphAreaScreenshotCtrl.takeFlutterScreenShoot();
    if (img == null) return null;
    final byteList = await _convertImageToBytes(img);
    if (byteList == null) return;
    await _saveGiantScreenshot(byteList);
  }

  Widget _getSpotLight(StoryboardGraph graph, BaseStoryScreen<dynamic> story) {
    if (graph.enabled == false) {
      return _rootWidget(
        key: _getNewKey(story),
        home: Center(
          child: Text(
            "Disabled (${graph.children.length})",
          ),
        ),
      );
    }
    return _rootWidget(key: _getNewKey(story), home: story.widget);
  }

  Future<void> _arrangeAfterBuild(
      StoryboardGraph graph, BaseStoryScreen<dynamic> story) async {
    if (!graph.enabled) return;
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
    } catch (e, _) {
      this.deregisterKeyboard();
      rethrow;
    }
    story.printSetupTrace();
    print("Before stage");
    await story.stageForScreenshot();
    print("After stage");
  }

  Future<void> _cleanUpScrenshoot(
      StoryboardGraph graph, BaseStoryScreen<dynamic> story) async {
    if (!graph.enabled) return;

    await story.cleanSnapshotLayer();
    print("After clean");
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

    spotLight = _getSpotLight(graph, story);

    await _arrangeAfterBuild(graph, story);

    this.view.applyState();
    final ResolvedGraphFromBuild? resolvedGraph =
        await core.resolveGraph(graph);
    print("$logTrace After resoved");

    if (resolvedGraph == null) return null;
    await _cleanUpScrenshoot(graph, story);

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
    final graphWithBoth =
        ResolvedGraphContainerWithBoth.castFrom(resolvedGraph);
    final isOverriding = graphWithBoth != null;

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
        hasChanged: graphWithBoth?.hasChanged ?? false,
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
        hasChanged: graphWithBoth?.hasChanged ?? false,
      );
    }
    return null;
  }

  void deregisterKeyboard() {
    this.driver.testTextInput.unregister();
  }

  void registerKeyboard() {
    driver.testTextInput.register();
  }

  Future<UploadTaskWitUrl?> getUploadTask(ImageWidgetData image) async {
    if (view.widget.saveRun != true) return null;
    final img = (image.image as UIImage).image;
    final bytes = await _convertImageToBytes(img);
    if (bytes == null) return null;
    final uploadTask = _saveInvidivualScreenCaptureAsync(bytes);
    print("$logTrace UploadTask should be this $uploadTask");
    // https://stackoverflow.com/questions/64574430/flutter-returning-uploadtask-returns-tasksnapshot-instead
    return Future.value(uploadTask);
  }

  UploadTaskWitUrl _saveInvidivualScreenCaptureAsync(Uint8List byteList) {
    final fileName =
        "Story-Image-Screenshots${DateTime.now().millisecondsSinceEpoch}";
    final UploadTask uploadTask = _uploadData(byteList, fileName);
    final task = UploadTaskWitUrl(uploadTask);
    task.start();
    return task;
  }

  Future<ImageWidgetData?> takeFlutterScreenShoot() async {
    final img = await spotLightScreenshotCtrl.takeFlutterScreenShoot();
    if (img == null) return null;

    final image = ImageWidgetData(
      image: UIImage(image: img),
      size: StoryScreenSize(
        img.width.toDouble(),
        img.height.toDouble(),
      ),
    );
    // image.image
    return image;
  }

  Future<void> _saveGiantScreenshot(Uint8List byteList) async {
    if (!isCI()) return;

    final url = await _uploadAndDownloadUrlText(byteList);
    await _printReportToCi(url);
    _tryPop();
  }

  void _tryPop() {
    print("$logTrace Trying to close");
    if (!isCI()) return;
    // final unawaited = _downloadImage(byteList);
    Navigator.of(view.context).pop();
  }

  Future<void> _trySaveDataStore() async {
    print('$logTrace _trySaveDataStore');
    if (!isCI() && view.widget.saveRun == false) return null;
    await Future.wait(
        core.uploadTasksWithUrls.values.map((e) => e.completer.future));
    print('$logTrace all images screen uploaded');

    final rootLocal = core.resolvedGraphRoot.children
        .firstWhereOrNull((element) => element.local != null);
    if (rootLocal == null) return;
    final data = await _recurseGraphRootLocalToDataStore(rootLocal);
    if (data == null) return;
    String featureBranch = "feature/debug-proxy-charles";
    if (isCI()) {
      featureBranch =
          const String.fromEnvironment(STORYBOARD_FEATURE_BRANCH_NAME);
    }
    await storyboardRepo.saveDatastore(
      data,
      featureBranch,
      this.view.widget.storyboardFlow,
    );
  }

  Future<GraphDataStore?> _recurseGraphRootLocalToDataStore(
      ResolvedGraphContainer resolvedGraph) async {
    final resolvedGraphWithLocal =
        ResolvedGraphContainerWithLocal.castFrom(resolvedGraph);
    if (resolvedGraphWithLocal == null) return null;
    final url = this.getLocalImageUploadUrl(resolvedGraphWithLocal.local);
    if (url == null) {
      print("Image URL is not found");
      return null;
    }
    final image = this.lookupGraphLocale(resolvedGraph)?.image;
    if (image == null) return null;
    final data = GraphDataStore(
      hash: resolvedGraphWithLocal.local.hash,
      imageUrl: url,
      size: image.size,
      graphName: resolvedGraphWithLocal.local.graphName,
      relationDescription: resolvedGraphWithLocal.local.relationDescription,
      children: [],
    );

    for (final child in resolvedGraph.children) {
      final dataStoreChild = await _recurseGraphRootLocalToDataStore(child);
      if (dataStoreChild == null) continue;
      data.children.add(dataStoreChild);
    }

    return data;
  }

  String? getLocalImageUploadUrl(ResolvedGraphFromBuild resolvedGraphLocal) {
    final resolvedGraphFromLocalWithUploadTask =
        ResolvedGraphFromBuildWithUploadTask.castFrom(resolvedGraphLocal);
    if (resolvedGraphFromLocalWithUploadTask == null) return null;

    final uploadTask = core
        .uploadTasksWithUrls[resolvedGraphFromLocalWithUploadTask.uploadTask];
    if (uploadTask == null) return null;
    // This is actually not waiting for the upload task to complete
    // but the url should already be available
    // it is the same as uploadTask.url
    // final url = await uploadTask.completer.future;
    final url = uploadTask.url;
    return url;
  }

  Future<void> readDataStore() async {
    String branch = "master";
    if (isCI()) {
      branch = const String.fromEnvironment(STORYBOARD_BASE_BRANCH_NAME,
          defaultValue: "master");
    }
    final datastore = await storyboardRepo.readDataContainer(
        branch, this.view.widget.storyboardFlow);
    print("$logTrace reading datastore ${datastore?.toJson()}");
    this.graphStoreData = datastore?.dataStore();
  }

  Future<String> generateImageHash(List<int> bytes) async {
    String digest = sha256.convert(bytes).toString();
    return digest;
  }

  Future<String?> computeImageHash(ImageWidgetData imageLocal) async {
    final image = (imageLocal.image as UIImage).image;
    final imageBytes = await _convertImageToBytes(image);
    if (imageBytes == null) return null;
    final start = DateTime.now();
    // final url = graphWithBoth.remote.imageUrl;
    // final networkResult = await compareImages(
    //     src1: imageBytes.toList(),
    //     src2: imageBytes.toList(),
    //     algorithm: PixelMatching(ignoreAlpha: true));

    var result = await compute(generateImageHash, imageBytes.toList());
    final end = DateTime.now();
    print(
        "Difference is $result. Took ${end.millisecondsSinceEpoch - start.millisecondsSinceEpoch}");
    return result;
  }

  Future<void> compareImageChange(ResolvedGraphContainer resolvedGraph) async {
    final graphWithBoth =
        ResolvedGraphContainerWithBoth.castFrom(resolvedGraph);
    if (graphWithBoth == null) return;

    print(
        "Difference ${graphWithBoth.local.hash == graphWithBoth.remote.hash}");
    return;

    final imageLocal = this.lookupGraphLocale(resolvedGraph)?.image;
    if (imageLocal == null) return null;
    final imageRemote = this.lookupGraphRemote(resolvedGraph)?.image;
    if (imageRemote == null) return null;
    final image = (imageLocal.image as UIImage).image;
    final imageBytes = await _convertImageToBytes(image);
    if (imageBytes == null) return;
    final start = DateTime.now();
    // final url = graphWithBoth.remote.imageUrl;
    // final networkResult = await compareImages(
    //     src1: imageBytes.toList(),
    //     src2: imageBytes.toList(),
    //     algorithm: PixelMatching(ignoreAlpha: true));

    var result = await compute(generateImageHash, imageBytes.toList());
    var result1 = await compute(generateImageHash, imageBytes.toList());
    final end = DateTime.now();
    print(
        "Difference is $result $result1. Took ${end.millisecondsSinceEpoch - start.millisecondsSinceEpoch}");
  }

  Future<void> _printReportToCi(String url) async {
    final storyboardGraphFlow = graphData.children.firstOrNull;
    String relationDescription = storyboardGraphFlow?.relationDescription ?? "";
    String flowName = storyboardGraphFlow?.storyName ?? "";
    ScreenDiffReport diffReport = _generateScreenDiffReport();
    final storyboardComplete = StoryboardComplete(
      imageUrl: url,
      title: "[$flowName] $relationDescription",
      showFlowInPullRequest: showFlowInPullRequest,
      screenDiff: diffReport.screenDiff,
      addedCount: diffReport.addedCount,
      screenCount: diffReport.screenCount,
      deletedCount: diffReport.deletedCount,
      modifiedCount: diffReport.modifiedCount,
    );
    final payload = storyboardComplete.toJson();
    final payloadString = jsonEncode(payload);
    await RunnerMessenger.sendMessage(
        STORYBOARD_RUNNER_COMPLETE, payloadString);
  }

  ScreenDiffReport _generateScreenDiffReport() {
    final report = ScreenDiffReport(
      addedCount: 0,
      deletedCount: 0,
      modifiedCount: 0,
      screenCount: 0,
      screenDiff: [],
    );
    _recurseForReport(resolvedGraphRoot, report);
    return report;
  }

  void _recurseForReport(
    ResolvedGraphContainer resolvedGraph,
    ScreenDiffReport report,
  ) {
    report.screenCount++;
    final graphWithBoth =
        ResolvedGraphContainerWithBoth.castFrom(resolvedGraph);
    if (graphWithBoth != null && graphWithBoth.hasChanged) {
      final urlAfter = this.getLocalImageUploadUrl(graphWithBoth.local);
      if (urlAfter == null) {
        print("No url after. Please check if image is actually uploaded.");
        return;
      }
      final diff = StoryboardScreenDifference(
        urlBefore: graphWithBoth.remote.imageUrl,
        urlAfter: urlAfter,
        steps: _traceParents(graphWithBoth).map((e) {
          return StoryScreenDetail(
            graphName: e.storyName,
            relationDescription: e.relationDescription,
          );
        }).toList(),
      );
      report.screenDiff.add(diff);
      report.modifiedCount++;
    }
    if (resolvedGraph.local != null && resolvedGraph.remote == null) {
      report.addedCount++;
    }
    if (resolvedGraph.local == null && resolvedGraph.remote != null) {
      report.deletedCount++;
    }

    for (final child in resolvedGraph.children) {
      _recurseForReport(child, report);
    }
  }

  List<StoryboardGraph> _traceParents(ResolvedGraphContainerWithBoth local) {
    int graphHash = local.local.graph;
    List<StoryboardGraph> parent = [];
    final current = this.core.graphMap[graphHash];
    if (current != null) parent.add(current);

    StoryboardGraph? storyboardGraphParent;
    while (storyboardGraphParent == null ||
        storyboardGraphParent != this.core.storyboardGraphRoot) {
      storyboardGraphParent = this.core.graphParentMap[graphHash];
      if (storyboardGraphParent == null) break;
      parent.add(storyboardGraphParent);
      graphHash = storyboardGraphParent.hashCode;
    }

    return parent.reversed.toList();
  }

  // void compareImageWithDiff(ResolvedGraphContainer preBuiltResolvedGraph) {
  //   try {
  //     var diff = await DiffImage.compareFromUrl(
  //       FIRST_IMAGE,
  //       SECOND_IMAGE,
  //     );
  //     print('The difference between images is: ${diff.value} %');
  //   } catch(e) {
  //     print(e);
  //   }
  // }
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
    final widgetGraphData = view.widget.graphForStoryboard;
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

void priasd() {}

///
/// 6681-7110 ChiSquareDistanceHistogram
/// 6496-7249 IntersectionHistogram
/// 5609-7249 PixelMatching
