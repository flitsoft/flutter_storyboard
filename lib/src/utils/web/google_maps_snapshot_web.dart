import 'dart:html';
import 'dart:js_util';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot.dart';
import 'package:flutter_storyboard/src/utils/web/google_maps_snapshot_interop.dart';

class GoogleMapsWebScreenshotImpl implements GoogleMapsWebScreenshot {
  @override
  Future<Uint8List?> takeSnapshot(int mapId) async {
    final id = "plugins.flutter.io/google_maps_${mapId}";
    print("$logTrace calling web function with $id");
    final result = await promiseToFuture(takeGoogleMapSnapshot(id));
    if (result == null) return null;
    final String base64Result = result.toString();
    print("$logTrace calling web function done ${base64Result.length}");
    // https://stackoverflow.com/questions/68287121/how-to-decode-or-convert-base64-string-url-to-uintlist-in-dart/68290298#68290298
    // You could also do
    final bytes = UriData.parse(base64Result).contentAsBytes();
    // But not sure in terms of performance
    // final bytes = base64Url.decode(base64Result.split(';base64,')[1]);
    return bytes;
  }

  @override
  Future<void> downloadFile(String base64DataUrl, String fileName) async {
    await promiseToFuture(downloadDataUrlString(base64DataUrl, fileName));
  }

  @override
  Future<void> downloadImage(String base64DataUrl, String fileName) async {
    await promiseToFuture(downloadImageUrlString(base64DataUrl, fileName));
  }

  @override
  void exit() {
    print("Window.closing");
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    window.close();
    close();
  }
}

GoogleMapsWebScreenshot getInstance() => GoogleMapsWebScreenshotImpl();
