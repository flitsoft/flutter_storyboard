import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:flutter_storyboard/src/utils/internal_utils.dart';

class StoryboardRepository {
  DocumentReference<Map<String, dynamic>> _docRoot() {
    return FirebaseFirestore.instance
        .collection('databases')
        .doc('storyboard')
        .collection('datastore')
        .doc('tolotra');
  }

  Future<GraphDataStore?> read() async {
    final documentData = await _docRoot().get();
    final json = documentData.data();
    if (json == null) return null;
    return GraphDataStore.fromJsonOrNull(json);
  }

  Future<void> saveDatastore(GraphDataStore data) async {
    print('$logTrace Saving Ride ${data.toJson()}');
    await _docRoot().set(data.toJson());
  }
}
