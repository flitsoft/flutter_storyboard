import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_page.dart';
import 'package:flutter_storyboard/src/model/storyboard_graph.dart';
import 'package:flutter_storyboard/src/model/storyboard_model.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
import 'package:flutter_storyboard/src/view/storyboard_view.dart';
// first or null
import 'package:collection/collection.dart';

class ContainerStoryScreen extends BaseStoryScreen implements StoryScreen {
  late Widget widget;

  @override
  void init() {
    widget = Scaffold(
      body: Center(
        child: Text("ROOT"),
      ),
    );
  }
}

class ChooseStoryBoardController {
  late ChooseStoryBoardPageState view;
  bool canInstanciate = true;

  bool saveRun = false;
  void attach(ChooseStoryBoardPageState _state) {
    view = _state;
  }

  StoryboardGraph wrap(List<StoryboardGraph> children) {
    return StoryboardGraph(
      relationDescription: 'root',
      story: ContainerStoryScreen(),
      children: children,
    );
  }

  void onStoryboardRunTapped() {
    final graph = view.widget.graphForStoryboard.children
        .where((element) => element.enabled)
        .firstOrNull;
    if (graph == null) {
      print("No storyboard selected");
      return;
    }
    this.runGraph(graph, saveRun);
  }

  // Init state for CI
  // Manual run require to hit button
  Future<void> initState() async {
    final storyboardFlow = getCiStoryboardFlow();
    if (!isCI()) return;
    StoryboardGraph? graph = view.widget.graphForStoryboard.children
        .where((element) =>
            (element.story.runtimeType.toString() == storyboardFlow))
        .firstOrNull;

    if (graph == null) {
      print("Could not find storyboard flow $storyboardFlow");
      return;
    }
    await this.runGraph(graph, true);
  }

  Future<void> runGraph(StoryboardGraph graph, bool saveRun) async {
    print("[CI] running $graph storyboard flows "
        "with ${graph.story.runtimeType}");

    await Navigator.push(
      view.context,
      MaterialPageRoute(
        builder: (context) => StoryBoard(
          saveRun: saveRun,
          storyboardFlow: graph.story.runtimeType.toString(),
          translator: view.widget.translator,
          graphForStoryboard: wrap([graph]),
          onMockEmAll: view.widget.onMockEmAll,
          widgetParent: view.widget.widgetParent,
        ),
      ),
    );
    GoogleMapsWebScreenshot.instance.exit();
  }

  void onChanged(bool? value, int index) {
    if (value == null) return;
    List<StoryboardGraph> listStoryboardGraph =
        view.widget.graphForStoryboard.children;
    // forEach loop with index
    listStoryboardGraph.asMap().forEach((i, e) {
      if (i == index) {
        e.enabled = value;
      } else {
        e.enabled = false;
      }
    });
    view.applyState();
  }

  void onSaveRunToggle(bool? value) {
    if (value == null) return;
    this.saveRun = value;
    view.applyState();
  }
}
