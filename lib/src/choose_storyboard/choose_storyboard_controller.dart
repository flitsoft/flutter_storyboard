import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_page.dart';
import 'package:flutter_storyboard/src/model/storyboard_graph.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
import 'package:flutter_storyboard/src/view/storyboard_view.dart';

class ChooseStoryBoardController {
  late ChooseStoryBoardPageState view;
  bool canInstanciate = true;
  void attach(ChooseStoryBoardPageState _state) {
    view = _state;
  }

  void gotoStoryboard() {
    if (canInstanciate) {
      print("First instance!");
      canInstanciate = !canInstanciate;
      Navigator.push(
        view.context,
        MaterialPageRoute(
          builder: (BuildContext context) => StoryBoard(
            translator: view.widget.translator,
            onMockEmAll: view.widget.onMockEmAll,
            graphForStoryboard: view.widget.graphForStoryboard,
            widgetParent: view.widget.widgetParent,
          ),
        ),
      );
    } else {
      print("!!!!!!!!!!!New instance detected!!!!!!!!!!!");
    }
  }

  Future<void> initState() async {
    final storyboardFlow = getCiStoryboardFlow();
    if (isCI()) {
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
  }
}
