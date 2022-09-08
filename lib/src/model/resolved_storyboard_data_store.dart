import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'resolved_storyboard_data_store.g.dart';

@JsonSerializable()
class StoryScreenSize {
  @JsonKey()
  final double width;
  @JsonKey()
  final double height;

  StoryScreenSize(this.width, this.height);

  factory StoryScreenSize.fromJson(Map<String, dynamic> json) =>
      _$StoryScreenSizeFromJson(json);

  Map<String, dynamic> toJson() => _$StoryScreenSizeToJson(this);
}

@JsonSerializable()
class GraphDataStore {
  @JsonKey()
  final List<GraphDataStore> children;
  @JsonKey()
  final String imageUrl;
  @JsonKey()
  final StoryScreenSize size;
  @JsonKey()
  final String graphName;
  @JsonKey()
  final String relationDescription;
  @JsonKey()
  final String hash;

  GraphDataStore({
    required this.hash,
    required this.imageUrl,
    required this.size,
    required this.graphName,
    required this.relationDescription,
    required this.children,
  });

  static GraphDataStore? fromJsonOrNull(Map<String, dynamic> json) {
    try {
      return _$GraphDataStoreFromJson(json);
    } catch (e, trace) {
      print(e);
      print(trace);
      return null;
    }
  }

  factory GraphDataStore.fromJson(Map<String, dynamic> json) =>
      _$GraphDataStoreFromJson(json);

  Map<String, dynamic> toJson() => _$GraphDataStoreToJson(this);

  String serialize() => jsonEncode(toJson());
}
