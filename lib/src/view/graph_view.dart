import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_storyboard/src/model/resolved_graph_container.dart';
import 'package:flutter_storyboard/src/model/view/graph_builder_view_model.dart';
import 'package:flutter_storyboard/src/storyboard_controller.dart';
import 'package:flutter_storyboard/src/utils/static_utils.dart';

class GraphImageView extends StatelessWidget {
  const GraphImageView({
    Key? key,
    required this.resolvedGraph,
    required this.controller,
    required this.model,
  }) : super(key: key);

  final GraphBuilderViewModel? model;
  final ResolvedGraphContainer resolvedGraph;
  final StoryBoardController controller;
  @override
  Widget build(BuildContext context) {
    final viewModel = model;
    if (viewModel == null) return Container();
    final image = viewModel.image;
    final graphName = viewModel.title;
    final relationDescription = viewModel.description;
    return Container(
      width: image.size.width.toDouble(),
      child: Column(
        children: [
          Container(
            height: image.size.height.toDouble(),
            width: image.size.width.toDouble(),
            child: InkWell(
              onTap: () => controller.onStoryScreenTap(resolvedGraph),
              child: image.image,
            ),
          ),
          if (viewModel.overriding == true)
            Container(
              width: image.size.width.toDouble(),
              // color: resolvedGraph.graph.showInPullRequest
              color: viewModel.hasChanged ? Colors.red : Colors.blue,
              child: Column(
                children: [
                  Text(
                    viewModel.hasChanged ? "Has Changed" : "No Change",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(relationDescription),
                ],
              ),
            ),
          Container(
            width: image.size.width.toDouble(),
            // color: resolvedGraph.graph.showInPullRequest
            color: true ? Colors.yellow : Colors.transparent,
            child: Column(
              children: [
                Text(
                  "${StaticUtils.camelToSentence(graphName)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(relationDescription),
              ],
            ),
          )
        ],
      ),
    );
  }
}
