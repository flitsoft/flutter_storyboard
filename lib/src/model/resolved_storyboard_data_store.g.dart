// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolved_storyboard_data_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryScreenSize _$StoryScreenSizeFromJson(Map json) {
  return $checkedNew('StoryScreenSize', json, () {
    final val = StoryScreenSize(
      $checkedConvert(json, 'width', (v) => (v as num).toDouble()),
      $checkedConvert(json, 'height', (v) => (v as num).toDouble()),
    );
    return val;
  });
}

Map<String, dynamic> _$StoryScreenSizeToJson(StoryScreenSize instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };

GraphDataStore _$GraphDataStoreFromJson(Map json) {
  return $checkedNew('GraphDataStore', json, () {
    final val = GraphDataStore(
      hash: $checkedConvert(json, 'hash', (v) => v as String),
      imageUrl: $checkedConvert(json, 'imageUrl', (v) => v as String),
      size: $checkedConvert(json, 'size',
          (v) => StoryScreenSize.fromJson(Map<String, dynamic>.from(v as Map))),
      graphName: $checkedConvert(json, 'graphName', (v) => v as String),
      relationDescription:
          $checkedConvert(json, 'relationDescription', (v) => v as String),
      children: $checkedConvert(
          json,
          'children',
          (v) => (v as List<dynamic>)
              .map((e) =>
                  GraphDataStore.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$GraphDataStoreToJson(GraphDataStore instance) =>
    <String, dynamic>{
      'children': instance.children.map((e) => e.toJson()).toList(),
      'imageUrl': instance.imageUrl,
      'size': instance.size.toJson(),
      'graphName': instance.graphName,
      'relationDescription': instance.relationDescription,
      'hash': instance.hash,
    };
