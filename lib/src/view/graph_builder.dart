import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_storyboard/src/model/resolved_graph_container.dart';
import 'package:flutter_storyboard/src/storyboard_controller.dart';
import 'package:flutter_storyboard/src/view/graph_view.dart';

class GraphBuilder extends StatelessWidget {
  final ResolvedGraphContainer resolvedGraph;
  final StoryBoardController controller;
  const GraphBuilder({
    Key? key,
    required this.resolvedGraph,
    required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GraphImageView(
          resolvedGraph: resolvedGraph,
          controller: controller,
          model: controller.viewModel(resolvedGraph),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: resolvedGraph.children
                .map((e) => GraphBuilder(
                      controller: controller,
                      resolvedGraph: e,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
