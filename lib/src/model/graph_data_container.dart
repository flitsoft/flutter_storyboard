import 'dart:convert';

import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'graph_data_container.g.dart';
part 'graph_data_container.freezed.dart';

@freezed
class GraphDataContainer with _$GraphDataContainer {
  const GraphDataContainer._();
  const factory GraphDataContainer({
    @JsonKey() required String id,
    @JsonKey() required String branchName,
    @JsonKey() required String updatedAt,
    @JsonKey() required String data,
  }) = _GraphDataContainer;

  GraphDataStore? dataStore() =>
      GraphDataStore.fromJsonOrNull(jsonDecode(data));

  factory GraphDataContainer.fromJson(Map<String, dynamic> json) =>
      _$GraphDataContainerFromJson(json);

  static fromJsonOrNull(Map<String, dynamic> json) {
    try {
      return _$GraphDataContainerFromJson(json);
    } catch (e, trace) {
      print(e);
      print(trace);
      return null;
    }
  }
}
