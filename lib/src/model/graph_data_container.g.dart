// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_data_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GraphDataContainer _$_$_GraphDataContainerFromJson(Map json) {
  return $checkedNew(r'_$_GraphDataContainer', json, () {
    final val = _$_GraphDataContainer(
      storyboardFlow:
          $checkedConvert(json, 'storyboardFlow', (v) => v as String),
      updatedAt: $checkedConvert(json, 'updatedAt', (v) => v as String),
      data: $checkedConvert(json, 'data', (v) => v as String),
    );
    return val;
  });
}

Map<String, dynamic> _$_$_GraphDataContainerToJson(
        _$_GraphDataContainer instance) =>
    <String, dynamic>{
      'storyboardFlow': instance.storyboardFlow,
      'updatedAt': instance.updatedAt,
      'data': instance.data,
    };
