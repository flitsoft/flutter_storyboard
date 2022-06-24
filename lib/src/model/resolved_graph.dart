import 'package:flutter_storyboard/src/model/resolved_graph_container.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resolved_graph.g.dart';

@JsonSerializable()
class ResolvedGraphFromBuildWithUploadTask {
  @JsonKey()
  final String graphName;
  @JsonKey()
  final String relationDescription;
  @JsonKey()
  final int graph;
  @JsonKey()
  final int image;
  @JsonKey()
  final int uploadTask;
  @JsonKey()
  final String? imageUrl;

  ResolvedGraphFromBuildWithUploadTask({
    this.imageUrl,
    required this.uploadTask,
    required this.graphName,
    required this.relationDescription,
    required this.graph,
    required this.image,
  });

  factory ResolvedGraphFromBuildWithUploadTask.fromJson(
          Map<String, dynamic> json) =>
      _$ResolvedGraphFromBuildWithUploadTaskFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResolvedGraphFromBuildWithUploadTaskToJson(this);

  static ResolvedGraphFromBuildWithUploadTask?
      castFrom<T extends SerializableProtocol>(T map) {
    try {
      return ResolvedGraphFromBuildWithUploadTask.fromJson(map.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }
}

@JsonSerializable()
class ResolvedGraphFromBuild implements SerializableProtocol {
  @JsonKey()
  final String graphName;
  @JsonKey()
  final String relationDescription;
  @JsonKey()
  final int graph;
  @JsonKey()
  final int image;
  @JsonKey()
  final int? uploadTask;
  @JsonKey()
  final String? imageUrl;

  ResolvedGraphFromBuild({
    this.imageUrl,
    this.uploadTask,
    required this.graphName,
    required this.relationDescription,
    required this.graph,
    required this.image,
  });

  factory ResolvedGraphFromBuild.fromJson(Map<String, dynamic> json) =>
      _$ResolvedGraphFromBuildFromJson(json);

  Map<String, dynamic> toJson() => _$ResolvedGraphFromBuildToJson(this);
}

@JsonSerializable()
class ResolvedGraphFromRemote {
  @JsonKey()
  final String graphName;
  @JsonKey()
  final String relationDescription;
  @JsonKey()
  final int? graph;
  @JsonKey()
  final int image;
  @JsonKey()
  final String? imageUrl;

  ResolvedGraphFromRemote({
    this.imageUrl,
    required this.graphName,
    required this.relationDescription,
    required this.graph,
    required this.image,
  });

  factory ResolvedGraphFromRemote.fromJson(Map<String, dynamic> json) =>
      _$ResolvedGraphFromRemoteFromJson(json);

  Map<String, dynamic> toJson() => _$ResolvedGraphFromRemoteToJson(this);
}
