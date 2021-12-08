import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart' hide find;

export 'package:flutter_driver/flutter_driver.dart';

class MyCreateFinderFactory with CreateFinderFactory {}

class MyHandler with CommandHandlerFactory {}

class UiAutomationDriver extends FlutterDriver {
  final TestTextInput testTextInput = TestTextInput();

  final WidgetController _prober =
      LiveWidgetController(WidgetsBinding.instance!);
  final myHandler = MyHandler();
  final finderFactory = MyCreateFinderFactory();

  @override
  Future<void> tap(SerializableFinder finder, {Duration? timeout}) {
    return _prober.tap(finderFactory.createFinder(finder));
  }

  @override
  Future<Map<String, dynamic>> sendCommand(Command command) async {
    final result =
        await myHandler.handleCommand(command, _prober, finderFactory);
    return result.toJson();
  }
}
