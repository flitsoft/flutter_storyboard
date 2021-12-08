import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_storyboard/src/utils/util.dart';

class ScreenshotController {
  ScreenShotableState? view;

  attach(ScreenShotableState screenShotableState) {
    this.view = screenShotableState;
  }

  Future<ui.Image?> takeFlutterScreenShoot([double pxRatio = 1]) async {
    // it is possible that view is null when ScreenShotable Widget is not used
    print("$logTrace taking flutter screenshot using RenderRepaintBoundary");
    if (!this.canTakeScreenshot()) return null;
    RenderRepaintBoundary boundary =
        this.view!.context.findRenderObject() as RenderRepaintBoundary;

    print(
        "$logTrace Screenshot boundary obtained $boundary, now converting into image");
    ui.Image image = await boundary.toImage(pixelRatio: pxRatio);
    print(
        "$logTrace taking flutter screenshot using RenderRepaintBoundary done");
    return image;
  }

  static Future<ui.Image> captureFromWidget(
    Widget widget, {
    Duration delay: const Duration(milliseconds: 20),
  }) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    Size logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
    Size imageSize = ui.window.physicalSize;

    assert(logicalSize.aspectRatio == imageSize.aspectRatio);

    final RenderView renderView = RenderView(
      window: ui.window,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    await Future.delayed(delay);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await repaintBoundary.toImage(
        pixelRatio: imageSize.width / logicalSize.width);
    // final ByteData? byteData =
    //     await image.toByteData(format: ui.ImageByteFormat.png);
    //
    // return byteData!.buffer.asUint8List();
    return image;
  }

  bool canTakeScreenshot() {
    return this.view != null;
  }
}

class ScreenShotable extends StatefulWidget {
  final ScreenshotController? screenshotController;
  final Widget child;

  const ScreenShotable({
    Key? key,
    this.screenshotController,
    required this.child,
  }) : super(key: key);

  @override
  ScreenShotableState createState() => ScreenShotableState();
}

class ScreenShotableState extends State<ScreenShotable> {
  @override
  void initState() {
    widget.screenshotController?.attach(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.child,
    );
  }
}
