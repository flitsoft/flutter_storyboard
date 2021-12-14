import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
//
// class GoogleMapsWebScreenshotNoImpl implements GoogleMapsWebScreenshot {
//   @override
//   Future<Uint8List?> takeSnapshot(int mapId) async {
//     throw UnimplementedError("You are not on WEB");
//   }
// }

GoogleMapsWebScreenshot getInstance() =>
    throw UnsupportedError("You are not on WEB");
