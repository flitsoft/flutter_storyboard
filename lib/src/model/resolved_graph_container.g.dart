// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolved_graph_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolvedGraphContainer _$ResolvedGraphContainerFromJson(Map json) {
  return $checkedNew('ResolvedGraphContainer', json, () {
    final val = ResolvedGraphContainer(
      local: $checkedConvert(
          json,
          'local',
          (v) => v == null
              ? null
              : ResolvedGraphFromBuild.fromJson(
                  Map<String, dynamic>.from(v as Map))),
      remote: $checkedConvert(
          json,
          'remote',
          (v) => v == null
              ? null
              : ResolvedGraphFromRemote.fromJson(
                  Map<String, dynamic>.from(v as Map))),
      children: $checkedConvert(
          json,
          'children',
          (v) => (v as List<dynamic>)
              .map((e) => ResolvedGraphContainer.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$ResolvedGraphContainerToJson(
    ResolvedGraphContainer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('local', instance.local?.toJson());
  writeNotNull('remote', instance.remote?.toJson());
  val['children'] = instance.children.map((e) => e.toJson()).toList();
  return val;
}

ResolvedGraphContainerWithLocal _$ResolvedGraphContainerWithLocalFromJson(
    Map json) {
  return $checkedNew('ResolvedGraphContainerWithLocal', json, () {
    final val = ResolvedGraphContainerWithLocal(
      local: $checkedConvert(
          json,
          'local',
          (v) => ResolvedGraphFromBuild.fromJson(
              Map<String, dynamic>.from(v as Map))),
      remote: $checkedConvert(
          json,
          'remote',
          (v) => v == null
              ? null
              : ResolvedGraphFromRemote.fromJson(
                  Map<String, dynamic>.from(v as Map))),
      children: $checkedConvert(
          json,
          'children',
          (v) => (v as List<dynamic>)
              .map((e) => ResolvedGraphContainer.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$ResolvedGraphContainerWithLocalToJson(
    ResolvedGraphContainerWithLocal instance) {
  final val = <String, dynamic>{
    'local': instance.local.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('remote', instance.remote?.toJson());
  val['children'] = instance.children.map((e) => e.toJson()).toList();
  return val;
}

ResolvedGraphContainerWithRemote _$ResolvedGraphContainerWithRemoteFromJson(
    Map json) {
  return $checkedNew('ResolvedGraphContainerWithRemote', json, () {
    final val = ResolvedGraphContainerWithRemote(
      local: $checkedConvert(
          json,
          'local',
          (v) => v == null
              ? null
              : ResolvedGraphFromBuild.fromJson(
                  Map<String, dynamic>.from(v as Map))),
      remote: $checkedConvert(
          json,
          'remote',
          (v) => ResolvedGraphFromRemote.fromJson(
              Map<String, dynamic>.from(v as Map))),
      children: $checkedConvert(
          json,
          'children',
          (v) => (v as List<dynamic>)
              .map((e) => ResolvedGraphContainer.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$ResolvedGraphContainerWithRemoteToJson(
    ResolvedGraphContainerWithRemote instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('local', instance.local?.toJson());
  val['remote'] = instance.remote.toJson();
  val['children'] = instance.children.map((e) => e.toJson()).toList();
  return val;
}

ResolvedGraphContainerWithBoth _$ResolvedGraphContainerWithBothFromJson(
    Map json) {
  return $checkedNew('ResolvedGraphContainerWithBoth', json, () {
    final val = ResolvedGraphContainerWithBoth(
      local: $checkedConvert(
          json,
          'local',
          (v) => v == null
              ? null
              : ResolvedGraphFromBuild.fromJson(
                  Map<String, dynamic>.from(v as Map))),
      remote: $checkedConvert(
          json,
          'remote',
          (v) => ResolvedGraphFromRemote.fromJson(
              Map<String, dynamic>.from(v as Map))),
      children: $checkedConvert(
          json,
          'children',
          (v) => (v as List<dynamic>)
              .map((e) => ResolvedGraphContainer.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()),
    );
    return val;
  });
}

Map<String, dynamic> _$ResolvedGraphContainerWithBothToJson(
    ResolvedGraphContainerWithBoth instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('local', instance.local?.toJson());
  val['remote'] = instance.remote.toJson();
  val['children'] = instance.children.map((e) => e.toJson()).toList();
  return val;
}
