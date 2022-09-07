// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_data_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GraphDataContainer _$_$_GraphDataContainerFromJson(Map json) {
  return $checkedNew(r'_$_GraphDataContainer', json, () {
    final val = _$_GraphDataContainer(
      id: $checkedConvert(json, 'id', (v) => v as String),
      branchName: $checkedConvert(json, 'branchName', (v) => v as String),
      updatedAt: $checkedConvert(json, 'updatedAt', (v) => v as String),
      data: $checkedConvert(json, 'data',
          (v) => GraphDataStore.fromJson(Map<String, dynamic>.from(v as Map))),
    );
    return val;
  });
}

Map<String, dynamic> _$_$_GraphDataContainerToJson(
        _$_GraphDataContainer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchName': instance.branchName,
      'updatedAt': instance.updatedAt,
      'data': instance.data.toJson(),
    };
