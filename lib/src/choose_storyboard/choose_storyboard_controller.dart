import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_page.dart';
import 'package:flutter_storyboard/src/model/storyboard_graph.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
import 'package:flutter_storyboard/src/view/storyboard_view.dart';

class ChooseStoryBoardController {
  late ChooseStoryBoardPageState view;
  bool canInstanciate = true;

  bool saveRun = false;
  void attach(ChooseStoryBoardPageState _state) {
    view = _state;
  }

  void onStoryboardRunTapped() {
    Navigator.push(
      view.context,
      MaterialPageRoute(
        builder: (BuildContext context) => StoryBoard(
          saveRun: saveRun,
          translator: view.widget.translator,
          onMockEmAll: view.widget.onMockEmAll,
          graphForStoryboard: view.widget.graphForStoryboard,
          widgetParent: view.widget.widgetParent,
        ),
      ),
    );
  }

  Future<void> initState() async {
    final storyboardFlow = getCiStoryboardFlow();
    if (!isCI()) return;
    List<StoryboardGraph> storyBoardGraphFlow = view
        .widget.graphForStoryboard.children
        .where((element) =>
            (element.story.runtimeType.toString() == storyboardFlow) ||
            storyboardFlow == "all")
        .toList();

    print("[CI] running ${storyBoardGraphFlow.length} storyboard flows "
        "with ${storyBoardGraphFlow.map((e) => e.story.runtimeType)}");

    for (final StoryboardGraph graph in storyBoardGraphFlow) {
      await Navigator.push(
        view.context,
        MaterialPageRoute(
          builder: (context) => StoryBoard(
            saveRun: true,
            translator: view.widget.translator,
            graphForCiAuto: graph,
            onMockEmAll: view.widget.onMockEmAll,
            widgetParent: view.widget.widgetParent,
          ),
        ),
      );
    }
    GoogleMapsWebScreenshot.instance.exit();
  }

  void onChanged(bool? value, int index) {
    if (value == null) return;
    List<StoryboardGraph> listStoryboardGraph =
        view.widget.graphForStoryboard.children;
    listStoryboardGraph.elementAt(index).enabled = value;
    view.applyState();
  }

  void onSaveRunToggle(bool? value) {
    if (value == null) return;
    this.saveRun = value;
    view.applyState();
  }
}
