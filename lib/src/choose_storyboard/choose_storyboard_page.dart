import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_storyboard/src/choose_storyboard/choose_storyboard_controller.dart';
import 'package:flutter_storyboard/src/storyboard_model.dart';
import 'package:flutter_storyboard/src/utils/bottom_action_button.dart';

class ChooseStoryBoardPage extends StatefulWidget {
  final StoryboardGraph graphForStoryboard;
  final Function onMockEmAll;
  final String Function(dynamic stringCode) translator;
  final Widget Function(Key? key, Widget home) widgetParent;

  ChooseStoryBoardPage({
    required this.graphForStoryboard,
    Key? key,
    required this.onMockEmAll,
    required this.translator,
    required this.widgetParent,
  }) : super(key: key);
  @override
  ChooseStoryBoardPageState createState() => ChooseStoryBoardPageState();
}

class ChooseStoryBoardPageState extends State<ChooseStoryBoardPage> {
  ChooseStoryBoardController controller = ChooseStoryBoardController();
  static const Key runKey = Key("runKey");
  List<StoryboardGraph>? listStoryboardGraph;

  ChooseStoryBoardPageState() {
    controller.attach(this);
  }

  @override
  void initState() {
    listStoryboardGraph = widget.graphForStoryboard.children;
    super.initState();
    SchedulerBinding.instance
        ?.addPostFrameCallback((_) => controller.initState());
  }

  void applyState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<StoryboardGraph>? _listStoryboardGraph = listStoryboardGraph;
    if (_listStoryboardGraph == null) {
      return Container(
        child: Text("StoryboardGraph is empty"),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose storyBoard"),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _listStoryboardGraph.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == _listStoryboardGraph.length) {
            return BottomActionButton(
              key: runKey,
              padding: MediaQuery.of(context).size.width * .025,
              text: "Run storyboard",
              backgroundColor: Colors.deepOrangeAccent,
              // width: 280.0,
              onPressed: () {
                controller.gotoStoryboard();
              },
            );
          }
          return CheckboxListTile(
            value: _listStoryboardGraph.elementAt(index).enabled,
            onChanged: (bool? value) {
              setState(() {
                _listStoryboardGraph.elementAt(index).enabled = value!;
              });
            },
            title:
                Text(_listStoryboardGraph.elementAt(index).relationDescription),
          );
        },
      ),
    );
  }
}
