import 'package:json_annotation/json_annotation.dart';

part 'runner_model.g.dart';

@JsonSerializable()
class StoryScreenDetail {
  @JsonKey()
  final String graphName;
  @JsonKey()
  final String relationDescription;

  StoryScreenDetail({
    required this.graphName,
    required this.relationDescription,
  });

  factory StoryScreenDetail.fromJson(Map<String, dynamic> json) =>
      _$StoryScreenDetailFromJson(json);

  Map<String, dynamic> toJson() => _$StoryScreenDetailToJson(this);
}

@JsonSerializable()
class StoryboardScreenDifference {
  @JsonKey()
  final String urlBefore;
  @JsonKey()
  final String urlAfter;
  @JsonKey()
  final List<StoryScreenDetail> steps;

  StoryboardScreenDifference({
    required this.urlBefore,
    required this.urlAfter,
    required this.steps,
  });

  factory StoryboardScreenDifference.fromJson(Map<String, dynamic> json) =>
      _$StoryboardScreenDifferenceFromJson(json);

  Map<String, dynamic> toJson() => _$StoryboardScreenDifferenceToJson(this);
}

class ScreenDiffReport {
  int screenCount;
  int addedCount;
  int deletedCount;
  int modifiedCount;

  final List<StoryboardScreenDifference> screenDiff;

  ScreenDiffReport({
    required this.screenCount,
    required this.addedCount,
    required this.deletedCount,
    required this.modifiedCount,
    required this.screenDiff,
  });
}

@JsonSerializable()
class StoryboardComplete {
  @JsonKey()
  final String imageUrl;
  @JsonKey()
  final String title;
  @JsonKey()
  final bool showFlowInPullRequest;

  @JsonKey()
  final int addedCount;
  @JsonKey()
  final int deletedCount;
  @JsonKey()
  final int modifiedCount;

  @JsonKey()
  final int screenCount;

  @JsonKey()
  final List<StoryboardScreenDifference> screenDiff;

  StoryboardComplete({
    required this.screenCount,
    required this.addedCount,
    required this.deletedCount,
    required this.modifiedCount,
    required this.imageUrl,
    required this.title,
    required this.showFlowInPullRequest,
    required this.screenDiff,
  });

  factory StoryboardComplete.fromJson(Map<String, dynamic> json) =>
      _$StoryboardCompleteFromJson(json);

  Map<String, dynamic> toJson() => _$StoryboardCompleteToJson(this);
}
