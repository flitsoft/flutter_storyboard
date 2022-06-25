// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolved_graph.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolvedGraphFromBuildWithUploadTask
    _$ResolvedGraphFromBuildWithUploadTaskFromJson(Map json) {
  return $checkedNew('ResolvedGraphFromBuildWithUploadTask', json, () {
    final val = ResolvedGraphFromBuildWithUploadTask(
      imageUrl: $checkedConvert(json, 'imageUrl', (v) => v as String?),
      uploadTask: $checkedConvert(json, 'uploadTask', (v) => v as int),
      graphName: $checkedConvert(json, 'graphName', (v) => v as String),
      relationDescription:
          $checkedConvert(json, 'relationDescription', (v) => v as String),
      graph: $checkedConvert(json, 'graph', (v) => v as int),
      image: $checkedConvert(json, 'image', (v) => v as int),
    );
    return val;
  });
}

Map<String, dynamic> _$ResolvedGraphFromBuildWithUploadTaskToJson(
    ResolvedGraphFromBuildWithUploadTask instance) {
  final val = <String, dynamic>{
    'graphName': instance.graphName,
    'relationDescription': instance.relationDescription,
    'graph': instance.graph,
    'image': instance.image,
    'uploadTask': instance.uploadTask,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imageUrl', instance.imageUrl);
  return val;
}

ResolvedGraphFromBuild _$ResolvedGraphFromBuildFromJson(Map json) {
  return $checkedNew('ResolvedGraphFromBuild', json, () {
    final val = ResolvedGraphFromBuild(
      hash: $checkedConvert(json, 'hash', (v) => v as String),
      uploadTask: $checkedConvert(json, 'uploadTask', (v) => v as int),
      graphName: $checkedConvert(json, 'graphName', (v) => v as String),
      relationDescription:
          $checkedConvert(json, 'relationDescription', (v) => v as String),
      graph: $checkedConvert(json, 'graph', (v) => v as int),
      image: $checkedConvert(json, 'image', (v) => v as int),
    );
    return val;
  });
}

Map<String, dynamic> _$ResolvedGraphFromBuildToJson(
        ResolvedGraphFromBuild instance) =>
    <String, dynamic>{
      'graphName': instance.graphName,
      'relationDescription': instance.relationDescription,
      'graph': instance.graph,
      'image': instance.image,
      'uploadTask': instance.uploadTask,
      'hash': instance.hash,
    };

ResolvedGraphFromRemote _$ResolvedGraphFromRemoteFromJson(Map json) {
  return $checkedNew('ResolvedGraphFromRemote', json, () {
    final val = ResolvedGraphFromRemote(
      hash: $checkedConvert(json, 'hash', (v) => v as String),
      imageUrl: $checkedConvert(json, 'imageUrl', (v) => v as String),
      graphName: $checkedConvert(json, 'graphName', (v) => v as String),
      relationDescription:
          $checkedConvert(json, 'relationDescription', (v) => v as String),
      graph: $checkedConvert(json, 'graph', (v) => v as int?),
      image: $checkedConvert(json, 'image', (v) => v as int),
    );
    return val;
  });
}

Map<String, dynamic> _$ResolvedGraphFromRemoteToJson(
    ResolvedGraphFromRemote instance) {
  final val = <String, dynamic>{
    'graphName': instance.graphName,
    'relationDescription': instance.relationDescription,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('graph', instance.graph);
  val['image'] = instance.image;
  val['imageUrl'] = instance.imageUrl;
  val['hash'] = instance.hash;
  return val;
}
