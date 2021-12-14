@JS()
library coolLib;

import 'dart:async';

import 'package:js/js.dart';

@JS()
external Future<String> takeGoogleMapSnapshot(String mapId);
external Future<String> testStringOnly(String mapId);
external Future<void> downloadDataUrlString(String base64, String filename);
external Future<void> downloadImageUrlString(String base64, String filename);
external void close();
