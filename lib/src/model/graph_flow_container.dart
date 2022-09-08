import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'graph_flow_container.g.dart';
part 'graph_flow_container.freezed.dart';

@freezed
class GraphFlowContainer with _$GraphFlowContainer {
  const factory GraphFlowContainer({
    @JsonKey() required String id,
    @JsonKey() required String branchName,
    @JsonKey() required Map<String, dynamic> storyboardFlows,
    @JsonKey() required String updatedAt,
  }) = _GraphFlowContainer;

  factory GraphFlowContainer.fromJson(Map<String, dynamic> json) =>
      _$GraphFlowContainerFromJson(json);

  static GraphFlowContainer? fromJsonOrNull(Map<String, dynamic> json) {
    try {
      return _$GraphFlowContainerFromJson(json);
    } catch (e, trace) {
      print(e);
      print(trace);
      return null;
    }
  }
}
