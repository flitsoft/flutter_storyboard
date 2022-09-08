// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_flow_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GraphFlowContainer _$_$_GraphFlowContainerFromJson(Map json) {
  return $checkedNew(r'_$_GraphFlowContainer', json, () {
    final val = _$_GraphFlowContainer(
      id: $checkedConvert(json, 'id', (v) => v as String),
      branchName: $checkedConvert(json, 'branchName', (v) => v as String),
      storyboardFlows: $checkedConvert(
          json, 'storyboardFlows', (v) => Map<String, dynamic>.from(v as Map)),
      updatedAt: $checkedConvert(json, 'updatedAt', (v) => v as String),
    );
    return val;
  });
}

Map<String, dynamic> _$_$_GraphFlowContainerToJson(
        _$_GraphFlowContainer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchName': instance.branchName,
      'storyboardFlows': instance.storyboardFlows,
      'updatedAt': instance.updatedAt,
    };
