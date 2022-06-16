import 'package:flutter/material.dart';
import 'package:flutter_storyboard/src/model/storyboard_model.dart';
import 'package:flutter_storyboard/src/utils/util.dart';

class StoryboardGraph {
  bool enabled;
  bool showInPullRequest;
  final BaseStoryScreen story;
  final String relationDescription;
  final List<StoryboardGraph> children;

  StoryboardGraph({
    this.enabled = true,
    this.showInPullRequest = false,
    required this.story,
    required this.relationDescription,
    required this.children,
  });
}
