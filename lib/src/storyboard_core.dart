import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/model/resolved_graph.dart';
import 'package:flutter_storyboard/src/model/resolved_graph_container.dart';
import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:flutter_storyboard/src/model/storyboard_graph.dart';
import 'package:flutter_storyboard/src/model/storyboard_model.dart';
import 'package:flutter_storyboard/src/storyboard_controller.dart';
import 'package:flutter_storyboard/src/utils/internal_utils.dart';

class StoryboardCore {
  final StoryBoardController parent;

  ResolvedGraphContainer resolvedGraphRoot =
      ResolvedGraphContainer(children: []);

  Map<int, ImageWidgetData> images = {};
  Map<int, UploadTaskWitUrl> uploadTasks = {};
  StoryboardGraph storyboardGraphRoot = StoryboardGraph(
    relationDescription: 'root',
    story: BaseStoryScreen(),
    children: [],
  );
  StoryboardCore(this.parent);
  Future<void> onReady() async {
    print("$logTrace");

    await parent.readDataStore();
    _flattenStoryboardGraph(
      parent.graphData,
      storyboardGraphRoot,
    );

    _resolvePrebuild();
    this.parent.applyState();

    await _recurse(parent.graphData, parent: resolvedGraphRoot);

    print("$logTrace All Graph Completed!");
    parent.spotLightVisible = false;
    this.parent.applyState();
    await this.parent.save();

    // await _saveAllGraphScreenshot();
  }

  StoryboardGraph? _findGraph(List<String> parentPath) {
    StoryboardGraph? lastChildFound;
    for (String parent in parentPath) {
      final childrenToSearch =
          lastChildFound?.children ?? [this.parent.graphData];
      final childFound = childrenToSearch.firstWhereOrNull(
        (element) => element.story.runtimeType.toString() == parent,
      );
      if (childFound == null) return null;
      lastChildFound = childFound;
    }
    return lastChildFound;
  }

  Map<int, StoryboardGraph> graphMap = {};
  Map<int, StoryboardGraph> graphParentMap = {};

  void _flattenStoryboardGraph(
      StoryboardGraph graphData, StoryboardGraph graphDataParent) {
    graphMap[graphData.hashCode] = graphData;
    graphParentMap[graphData.hashCode] = graphDataParent;
    for (final child in graphData.children) {
      _flattenStoryboardGraph(child, graphData);
    }
  }

  void _recursePrebuild(
    GraphDataStore resolvedGraphUrl,
    List<String> parentPath, {
    required ResolvedGraphContainer parent,
  }) {
    if (resolvedGraphUrl.graphName == "LanguageSignUpPage") {
      print("breakpoint");
    }
    final graph = _findGraph(parentPath);
    final size = resolvedGraphUrl.size;
    final image = ImageWidgetData(
      image: Image.network(resolvedGraphUrl.imageUrl),
      size: StoryScreenSize(size.width, size.height),
    );

    final id = image.hashCode;
    images[id] = image;

    final resolved = ResolvedGraphFromRemote(
        hash: resolvedGraphUrl.hash,
        graphName: resolvedGraphUrl.graphName,
        relationDescription: resolvedGraphUrl.relationDescription,
        graph: graph == null ? null : graph.hashCode,
        imageUrl: resolvedGraphUrl.imageUrl,
        image: image.hashCode);
    final resolvedGraph =
        ResolvedGraphContainer(remote: resolved, children: []);
    parent.children.add(resolvedGraph);
    for (final child in resolvedGraphUrl.children) {
      final newParentPath = [...parentPath, child.graphName];
      _recursePrebuild(child, newParentPath, parent: resolvedGraph);
    }
  }

  Future<ResolvedGraphContainer?> _recurse(
    StoryboardGraph graph, {
    required ResolvedGraphContainer parent,
  }) async {
    if (graph.story.runtimeType.toString() == "ContainerLoading") {
      print("breakpoint");
    }
    print("$logTrace Before putOnSpotLight");

    final _resolvedGraph = await this.parent.putOnSpotLight(graph);
    print("$logTrace After putOnSpotLight");

    if (_resolvedGraph == null) return null;
    print("$logTrace Before _getSiblings");

    final List<ResolvedGraphContainer> siblings = parent.children;
    print("$logTrace After _getSiblings");

    final preBuiltResolvedGraph = siblings.firstWhereOrNull(
      (ResolvedGraphContainer element) {
        print("$logTrace 00 ");

        final resolvedGraphWithRemote =
            ResolvedGraphContainerWithRemote.castFrom(element);
        print("$logTrace 01 ");

        if (resolvedGraphWithRemote == null) return false;
        return resolvedGraphWithRemote.remote.graph == _resolvedGraph.graph;
      },
    );

    print("$logTrace 1 ");
    final resolvedGraph = preBuiltResolvedGraph ??
        ResolvedGraphContainer(
          children: [],
        );

    resolvedGraph.local = _resolvedGraph;

    // if (!graph.enabled) return resolvedGraph;

    if (preBuiltResolvedGraph == null) {
      siblings.add(resolvedGraph);
    }

    if (preBuiltResolvedGraph != null) {
      this.parent.compareImageChange(preBuiltResolvedGraph);
    }
    // resolvedGraph.children.clear();
    // resolvedGraph.children.addAll(siblings);

    if (graph.showInPullRequest) {
      this.parent.showFlowInPullRequest = true;
    }
    // releasing keyboard used during automation
    print("$logTrace Before apply state ");

    this.parent.applyState();
    print("$logTrace After apply state ");

    // Waiting for some time to apply state of clean snapshot
    // aka resetting the map, removing layers...
    await Future.delayed(Duration(milliseconds: 500));
    print("$logTrace Before _recurse children");

    for (final child in graph.children) {
      final resolvedGraphChild = await _recurse(child, parent: resolvedGraph);
      if (resolvedGraphChild == null) continue;
    }
    return resolvedGraph;
  }

  Future<ResolvedGraphFromBuild?> resolveGraph(StoryboardGraph graph) async {
    parent.deregisterKeyboard();
    print("$logTrace driver.testTextInput.unregister();");

    // delay between graphts
    await Future.delayed(Duration(milliseconds: 500));
    print("$logTrace Staging for Screenshot done");
    final img = await parent.takeFlutterScreenShoot();
    // fakeAsyncSingleton.elapse(Duration(seconds: 5));
    print("$logTrace Taking for Screenshot done $img");

    if (img == null) return null;
    final uploadTask = await parent.getUploadTask(img);
    print("$logTrace UploadTask before save is $uploadTask");

    final hash = await this.parent.computeImageHash(img);
    if (hash == null) return null;
    _saveUploadTaskIfNotNull(uploadTask);
    images[img.hashCode] = img;

    return ResolvedGraphFromBuild(
      hash: hash,
      uploadTask: uploadTask.hashCode,
      graph: graph.hashCode,
      image: img.hashCode,
      relationDescription: graph.relationDescription,
      graphName: graph.story.runtimeType.toString(),
    );
  }

  void reload() {
    resolvedGraphRoot = ResolvedGraphContainer(children: []);
  }

  Map<String, dynamic> resolvedGraphRootToJsonForTest() {
    final json = resolvedGraphRoot.toJson();
    return resolvedGraphRootToJsonRecursive(this.resolvedGraphRoot, json);
  }

  Map<String, dynamic> resolvedGraphRootToJsonRecursive(
      ResolvedGraphContainer resolvedGraph, Map<String, dynamic> json) {
    final locale = parent.lookupGraphLocale(resolvedGraph);

    if (resolvedGraph.remote?.graphName == "LanguageSignUpPage") {
      print("breakpoint");
    }
    final localeGraph = locale?.graph;
    final localeImage = locale?.image;
    if (localeGraph != null) {
      json['local']['graph'] = localeGraph.toJson();
    }
    if (localeImage != null) {
      json['local']['image'] = localeImage.toJson();
    }

    final remote = parent.lookupGraphRemote(resolvedGraph);
    final remoteGraph = remote?.graph;
    final remoteImage = remote?.image;

    if (remoteGraph != null) {
      json['remote']['graph'] = remoteGraph.toJson();
    }
    if (remoteImage != null) {
      json['remote']['image'] = remoteImage.toJson();
    }

    resolvedGraph.children.forEachIndexed((index, element) {
      final child = resolvedGraph.children[index];
      final jsonChild = json['children'][index];
      resolvedGraphRootToJsonRecursive(child, jsonChild);
    });

    return json;
  }

  void _resolvePrebuild() {
    final resolvedGraphUrl = parent.graphStoreData;
    if (resolvedGraphUrl == null) return;
    _recursePrebuild(resolvedGraphUrl, [resolvedGraphUrl.graphName],
        parent: resolvedGraphRoot);
  }

  void _saveUploadTaskIfNotNull(UploadTaskWitUrl? uploadTask) {
    if (uploadTask == null) return;
    uploadTasks[uploadTask.hashCode] = uploadTask;
  }
}
