import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_storyboard/src/model/graph_data_container.dart';
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

  Future<GraphDataContainer?> read(String branchName) async {
    final documentData = await _docRoot()
        .where("branchName", isEqualTo: branchName)
        .limit(1)
        .get();
    final json = documentData.docs.firstOrNull;
    // if(json == null) return;

    if (json == null) return null;
    return GraphDataContainer.fromJsonOrNull(json.data());
  }

  Future<void> updateDatastore(GraphDataContainer data) async {
    print('$logTrace Updating Data Store ${data.toJson()}');
    final newData = data.copyWith(updatedAt: DateTime.now().toIso8601String());
    await _docRoot().doc(data.id).update(newData.toJson());
  }

  Future<void> saveDatastore(
    GraphDataStore dataStore,
    String branchName,
  ) async {
    final existingData = await read(branchName);
    if (existingData == null) {
      await this.addDataStore(dataStore, branchName);
    } else {
      final newData = existingData.copyWith(
        data: dataStore,
        updatedAt: DateTime.now().toIso8601String(),
      );
      await this.updateDatastore(newData);
    }
  }

  Future<void> addDataStore(
    GraphDataStore dataStore,
    String branchName,
  ) async {
    final id = _generateId(branchName);
    final data = GraphDataContainer(
      id: id,
      data: dataStore,
      branchName: branchName,
      updatedAt: DateTime.now().toIso8601String(),
    );
    print('$logTrace Saving Data Store ${data.toJson()}');
    await _docRoot().doc(data.id).set(data.toJson());
  }

  // firebase id sanitizer
  String _generateId(String branchName) {
    final id = branchName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final now = DateTime.now();
    return '${id}_${now.toIso8601String()}';
  }
}
