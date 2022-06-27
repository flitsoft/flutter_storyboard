// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryScreenDetail _$StoryScreenDetailFromJson(Map json) {
  return $checkedNew('StoryScreenDetail', json, () {
    final val = StoryScreenDetail(
      graphName: $checkedConvert(json, 'graphName', (v) => v as String),
      relationDescription:
          $checkedConvert(json, 'relationDescription', (v) => v as String),
    );
    return val;
  });
}

Map<String, dynamic> _$StoryScreenDetailToJson(StoryScreenDetail instance) =>
    <String, dynamic>{
      'graphName': instance.graphName,
      'relationDescription': instance.relationDescription,
    };

StoryboardScreenDifference _$StoryboardScreenDifferenceFromJson(Map json) {
  return $checkedNew('StoryboardScreenDifference', json, () {
    final val = StoryboardScreenDifference(
      urlBefore: $checkedConvert(json, 'urlBefore', (v) => v as String),
      urlAfter: $checkedConvert(json, 'urlAfter', (v) => v as String),
      steps: $checkedConvert(
          json,
          'steps',
          (v) => (v as List<dynamic>)
              .map((e) => StoryScreenDetail.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$StoryboardScreenDifferenceToJson(
        StoryboardScreenDifference instance) =>
    <String, dynamic>{
      'urlBefore': instance.urlBefore,
      'urlAfter': instance.urlAfter,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

StoryboardComplete _$StoryboardCompleteFromJson(Map json) {
  return $checkedNew('StoryboardComplete', json, () {
    final val = StoryboardComplete(
      screenCount: $checkedConvert(json, 'screenCount', (v) => v as int),
      addedCount: $checkedConvert(json, 'addedCount', (v) => v as int),
      deletedCount: $checkedConvert(json, 'deletedCount', (v) => v as int),
      modifiedCount: $checkedConvert(json, 'modifiedCount', (v) => v as int),
      imageUrl: $checkedConvert(json, 'imageUrl', (v) => v as String),
      title: $checkedConvert(json, 'title', (v) => v as String),
      showFlowInPullRequest:
          $checkedConvert(json, 'showFlowInPullRequest', (v) => v as bool),
      screenDiff: $checkedConvert(
          json,
          'screenDiff',
          (v) => (v as List<dynamic>)
              .map((e) => StoryboardScreenDifference.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$StoryboardCompleteToJson(StoryboardComplete instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'showFlowInPullRequest': instance.showFlowInPullRequest,
      'addedCount': instance.addedCount,
      'deletedCount': instance.deletedCount,
      'modifiedCount': instance.modifiedCount,
      'screenCount': instance.screenCount,
      'screenDiff': instance.screenDiff.map((e) => e.toJson()).toList(),
    };
