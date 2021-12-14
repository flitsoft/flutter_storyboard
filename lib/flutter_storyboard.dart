library flutter_storyboard;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_storyboard/src/utils/chain_stack_trace.dart';
import 'package:flutter_storyboard/src/utils/screenshotable.dart';
import 'package:flutter_storyboard/src/utils/util.dart';
import 'package:stack_trace/stack_trace.dart';

Future<void> main() async {
  print("Launching Admin ... ");
  if (isCI()) {
    print("running on CI");
    runApp(MaterialApp(home: TestWidget()));
    return;
  }
  if (kIsWeb) {
    runApp(MaterialApp(home: TestWidget()));
    return;
  }
  final _ = runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await myErrorsHandler.initialize();
    FlutterError.onError = (FlutterErrorDetails details) {
      prettyPrintChainTrace(
          details.exception, Chain.forTrace(details.stack ?? Chain.current()));
      FlutterError.dumpErrorToConsole(details);
      // myErrorsHandler.onErro r(details);
      // exit(1);
    };
    runApp(MaterialApp(home: TestWidget()));
  }, (Object error, StackTrace stack) {
    prettyPrintChainTrace(error, Chain.forTrace(stack));
  });
}

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final controller = ScreenshotController();

  @override
  void initState() {
    print("$logTrace InitState _TestWidgetState");

    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((Duration _) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // save();
        },
        label: Text("Save"),
      ),
      body: InteractiveViewer(
        minScale: 0.1,
        boundaryMargin: EdgeInsets.all(500.0),
        constrained: false,
        // scrollDirection: Axis.horizontal,
        child: ScreenShotable(
          screenshotController: controller,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: FlutterLogo(
                      style: FlutterLogoStyle.stacked,
                      size: 400,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: FlutterLogo(
                      style: FlutterLogoStyle.stacked,
                      size: 400,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: FlutterLogo(
                      style: FlutterLogoStyle.stacked,
                      size: 400,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: FlutterLogo(
                      style: FlutterLogoStyle.stacked,
                      size: 400,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: FlutterLogo(
                      style: FlutterLogoStyle.stacked,
                      size: 400,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: FlutterLogo(
                  size: 400,
                ),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: FlutterLogo(
                  style: FlutterLogoStyle.horizontal,
                  size: 400,
                ),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: FlutterLogo(
                  size: 400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
