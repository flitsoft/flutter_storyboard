import 'package:json_annotation/json_annotation.dart';

part 'resolved_graph.g.dart';

@JsonSerializable()
class ResolvedGraphFromBuild {
  @JsonKey()
  final String graphName;
  @JsonKey()
  final String relationDescription;
  @JsonKey()
  final int graph;
  @JsonKey()
  final int image;
  @JsonKey()
  final String? imageUrl;

  ResolvedGraphFromBuild({
    this.imageUrl,
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
