

import 'package:flutter/painting.dart';
import 'package:flutter_storyboard/src/model/storyboard_graph.dart';

class ResolvedGraphDataStore {
  final StoryboardGraph? graph;
  final List<ResolvedGraphDataStore> children;
  final String imageUrl;
  final Size size;
  final String graphName;
  final String relationDescription;

  ResolvedGraphDataStore({
    required this.imageUrl,
    required this.size,
    required this.graphName,
    required this.relationDescription,
    this.graph,
    required this.children,
  });
}