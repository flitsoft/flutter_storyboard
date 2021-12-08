import 'dart:typed_data';

import 'google_maps_snashot_deferred.dart'
    if (dart.library.io) 'google_maps_snapshot_not_web.dart'
    if (dart.library.js) 'google_maps_snapshot_web.dart';

///
/// This is an implementation of http://jsfiddle.net/zyn10sf5/22/
abstract class GoogleMapsWebScreenshot {
  static GoogleMapsWebScreenshot? _instance;

  static GoogleMapsWebScreenshot get instance {
    _instance ??= getInstance();
    return _instance!;
  }

  Future<Uint8List?> takeSnapshot(int mapId);
  Future<void> downloadFile(String base64DataUrl, String fileName);
  Future<void> downloadImage(String base64DataUrl, String fileName);
  void exit();
}
