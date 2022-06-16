import 'package:flutter_storyboard/src/model/resolved_graph.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resolved_graph_container.g.dart';

abstract class SerializableProtocol {
  Map<String, dynamic> toJson();
}

@JsonSerializable()
class ResolvedGraphContainer implements SerializableProtocol {
  @JsonKey()
  ResolvedGraphFromBuild? locale;
  @JsonKey()
  ResolvedGraphFromRemote? remote;
  @JsonKey()
  List<ResolvedGraphContainer> children;

  ResolvedGraphContainer({
    this.locale,
    this.remote,
    this.children = const [],
  });

  ResolvedGraphContainer fromJson(Map<String, dynamic> json) {
    return ResolvedGraphContainer.fromJson(json);
  }

  factory ResolvedGraphContainer.fromJson(Map<String, dynamic> json) =>
      _$ResolvedGraphContainerFromJson(json);

  Map<String, dynamic> toJson() => _$ResolvedGraphContainerToJson(this);
  static ResolvedGraphContainer? castFrom<T extends SerializableProtocol>(
      T map) {
    try {
      return ResolvedGraphContainer.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }
}

@JsonSerializable()
class ResolvedGraphContainerWithLocal implements SerializableProtocol {
  @JsonKey()
  ResolvedGraphFromBuild locale;
  @JsonKey()
  ResolvedGraphFromRemote? remote;
  @JsonKey()
  List<ResolvedGraphContainer> children;

  ResolvedGraphContainerWithLocal({
    required this.locale,
    this.remote,
    this.children = const [],
  });

  factory ResolvedGraphContainerWithLocal.fromJson(Map<String, dynamic> json) =>
      _$ResolvedGraphContainerWithLocalFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResolvedGraphContainerWithLocalToJson(this);

  static ResolvedGraphContainerWithLocal?
      castFrom<T extends SerializableProtocol>(T map) {
    try {
      return ResolvedGraphContainerWithLocal.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }
}

@JsonSerializable()
class ResolvedGraphContainerWithRemote {
  @JsonKey()
  ResolvedGraphFromBuild? locale;
  @JsonKey()
  ResolvedGraphFromRemote remote;
  @JsonKey()
  List<ResolvedGraphContainer> children;

  ResolvedGraphContainerWithRemote({
    this.locale,
    required this.remote,
    this.children = const [],
  });

  factory ResolvedGraphContainerWithRemote.fromJson(
          Map<String, dynamic> json) =>
      _$ResolvedGraphContainerWithRemoteFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResolvedGraphContainerWithRemoteToJson(this);

  static ResolvedGraphContainerWithRemote?
      castFrom<T extends SerializableProtocol>(T map) {
    try {
      return ResolvedGraphContainerWithRemote.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }
}

@JsonSerializable()
class ResolvedGraphContainerWithBoth {
  @JsonKey()
  ResolvedGraphFromBuild? locale;
  @JsonKey()
  ResolvedGraphFromRemote remote;
  @JsonKey()
  List<ResolvedGraphContainer> children;

  ResolvedGraphContainerWithBoth({
    this.locale,
    required this.remote,
    this.children = const [],
  });

  factory ResolvedGraphContainerWithBoth.fromJson(Map<String, dynamic> json) =>
      _$ResolvedGraphContainerWithBothFromJson(json);

  Map<String, dynamic> toJson() => _$ResolvedGraphContainerWithBothToJson(this);

  static ResolvedGraphContainerWithBoth?
      castFrom<T extends SerializableProtocol>(T map) {
    try {
      return ResolvedGraphContainerWithBoth.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }
}