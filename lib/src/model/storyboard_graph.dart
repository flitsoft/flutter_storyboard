import 'package:flutter_storyboard/src/model/storyboard_model.dart';

class StoryboardGraph {
  bool enabled;
  bool showInPullRequest;

  final String relationDescription;
  final List<StoryboardGraph> children;

  final BaseStoryScreen story;
  String get storyName {
    return this.story.runtimeType.toString();
  }

  StoryboardGraph({
    this.enabled = true,
    this.showInPullRequest = false,
    required this.story,
    required this.relationDescription,
    required this.children,
  });

  Map<String, dynamic> toJson() {
    final instance = this;
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('enabled', instance.enabled);
    writeNotNull('showInPullRequest', instance.showInPullRequest);
    writeNotNull('storyName', instance.storyName);
    writeNotNull('relationDescription', instance.relationDescription);
    val['children'] = instance.children.length;
    return val;
  }
}
