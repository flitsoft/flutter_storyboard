import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_storyboard/src/model/graph_data_container.dart';
import 'package:flutter_storyboard/src/model/graph_flow_container.dart';
import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:flutter_storyboard/src/utils/internal_utils.dart';
// import first or null
import 'package:collection/collection.dart';

class StoryboardRepository {
  CollectionReference<Map<String, dynamic>> _docRoot() {
    return FirebaseFirestore.instance
        .collection('databases')
        .doc('storyboard')
        .collection('datastore');
  }

  Future<GraphFlowContainer?> readGraphFlow(
    String branchName,
  ) async {
    final documentData = await _docRoot()
        .where("branchName", isEqualTo: branchName)
        .limit(1)
        .get();

    return await this.parseGraphFlowReading(documentData);
  }

  Future<GraphFlowContainer?> parseGraphFlowReading(
      QuerySnapshot<Map<String, dynamic>> documentData) async {
    final json = documentData.docs.firstOrNull;

    if (json == null) return null;
    final graphFlowContainer = GraphFlowContainer.fromJsonOrNull(json.data());
    if (graphFlowContainer == null) {
      await json.reference.delete();
      return null;
    }
    return graphFlowContainer;
  }

  Future<GraphDataContainer?> readDataContainer(
    String branchName,
    String storyboardFlow, {
    bool deleteIfCorrupted = false,
  }) async {
    final graphFlowContainer = await this.readGraphFlow(branchName);
    if (graphFlowContainer == null) {
      return null;
    }
    final graphDataContainer =
        extractStoryboardFlow(graphFlowContainer, storyboardFlow);
    return graphDataContainer;
  }

  GraphDataContainer? extractStoryboardFlow(
      GraphFlowContainer graphFlowContainer, String storyboardFlow) {
    final graphDataContainerData =
        graphFlowContainer.storyboardFlows[storyboardFlow];
    if (graphDataContainerData == null) {
      return null;
    }
    final graphDataContainer =
        GraphDataContainer.fromJsonOrNull(graphDataContainerData);
    if (graphDataContainer == null) {
      return null;
    }
    return graphDataContainer;
  }

  Future<void> updateDatastore(
      GraphFlowContainer flow, GraphDataContainer data) async {
    print('$logTrace Updating Data Store ${jsonEncode(data.toJson())}');
    final newData = data.copyWith(updatedAt: DateTime.now().toIso8601String());
    await _docRoot()
        .doc(flow.id)
        .update({"storyboardFlows.${data.storyboardFlow}": newData.toJson()});
  }

  // Save if not exist
  // Otherwise update the existing one
  Future<void> saveDatastore(
    GraphDataStore dataStore,
    String branchName,
    String storyboardFlow,
  ) async {
    final existingDataFlowContainer = await readGraphFlow(branchName);
    if (existingDataFlowContainer == null) {
      await this.addDataStore(dataStore, branchName, storyboardFlow);
    } else {
      final existingDataContainer =
          extractStoryboardFlow(existingDataFlowContainer, storyboardFlow);
      final newData = existingDataContainer?.copyWith(
            data: dataStore.serialize(),
            updatedAt: DateTime.now().toIso8601String(),
          ) ??
          createNewData(storyboardFlow, dataStore);
      await this.updateDatastore(existingDataFlowContainer, newData);
    }
  }

  Future<void> addDataStore(
    GraphDataStore dataStore,
    String branchName,
    String storyboardFlow,
  ) async {
    final data = createNewData(storyboardFlow, dataStore);
    final id = _generateId(branchName);
    final graphDataFlow = GraphFlowContainer(
      id: id,
      branchName: branchName,
      storyboardFlows: {
        storyboardFlow: data.toJson(),
      },
      updatedAt: DateTime.now().toIso8601String(),
    );
    print('$logTrace Saving Data Store ${graphDataFlow.toJson()}');
    await this.saveGraphFlow(graphDataFlow);
  }

  GraphDataContainer createNewData(
    String storyboardFlow,
    GraphDataStore dataStore,
  ) {
    final data = GraphDataContainer(
      storyboardFlow: storyboardFlow,
      data: dataStore.serialize(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    return data;
  }

  // firebase id sanitizer
  String _generateId(String branchName) {
    final id = branchName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final now = DateTime.now();
    return '${id}_${now.toIso8601String()}';
  }

  Future<void> saveGraphFlow(GraphFlowContainer graphDataFlow) async {
    await _docRoot().doc(graphDataFlow.id).set(graphDataFlow.toJson());
  }

  Future<void> saveGraphFlowAtBranch(
    GraphFlowContainer newData,
    String branchName,
  ) async {
    final existingDataFlowContainer = await readGraphFlow(branchName);
    String id = _generateId(branchName);
    if (existingDataFlowContainer != null) {
      id = existingDataFlowContainer.id;
    }
    await this.saveGraphFlow(
      newData.copyWith(id: id, updatedAt: DateTime.now().toIso8601String()),
    );
  }
}
