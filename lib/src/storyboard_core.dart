import 'dart:async';
import 'dart:ui';

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
  StoryboardCore(this.parent);
  Future<void> onReady() async {
    print("$logTrace");

    final url =
        "https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b";
    final resolvedGraphUrl = ResolvedGraphDataStore(
      imageUrl: url,
      graphName: 'ContainerLoading',
      relationDescription: 'Root tap tap',
      children: [
        ResolvedGraphDataStore(
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
        ),
      ],
      size: Size(411.4, 740.0),
    );

    _flattenStoryboardGraph(parent.graphData);

    _recursePrebuild(resolvedGraphUrl, [resolvedGraphUrl.graphName],
        parent: resolvedGraphRoot);

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

  void _flattenStoryboardGraph(StoryboardGraph graphData) {
    graphMap[graphData.hashCode] = graphData;
    for (final child in graphData.children) {
      _flattenStoryboardGraph(child);
    }
  }

  void _recursePrebuild(
    ResolvedGraphDataStore resolvedGraphUrl,
    List<String> parentPath, {
    required ResolvedGraphContainer parent,
  }) {
    if (resolvedGraphUrl.graphName == "LanguageSignUpPage") {
      print("breakpoint");
    }
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
    images[img.hashCode] = img;
    return ResolvedGraphFromBuild(
      graph: graph.hashCode,
      image: img.hashCode,
      relationDescription: graph.relationDescription,
      graphName: graph.story.runtimeType.toString(),
    );
  }

  void reload() {
    resolvedGraphRoot = ResolvedGraphContainer(children: []);
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
}
