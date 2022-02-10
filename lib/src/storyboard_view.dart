import 'dart:math';
import 'dart:ui' as ui;

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_storyboard/src/storyboard_controller.dart';
import 'package:flutter_storyboard/src/storyboard_model.dart';
import 'package:flutter_storyboard/src/utils/device_preview/device_preview.dart';
import 'package:flutter_storyboard/src/utils/gesture_visualizer.dart';
import 'package:flutter_storyboard/src/utils/screenshotable.dart';
import 'package:flutter_storyboard/src/utils/static_utils.dart';
import 'package:flutter_storyboard/src/utils/ui_image_widget.dart';

Size logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
final screenwidth = min(411.4, logicalSize.width * 0.8);
final screenheight = min(740.0, logicalSize.height * 0.8);

class GraphBuilder extends StatelessWidget {
  final ResolvedGraph resolvedGraph;
  final StoryBoardController controller;
  const GraphBuilder({
    Key? key,
    required this.resolvedGraph,
    required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: resolvedGraph.image.width.toDouble(),
          child: Column(
            children: [
              Container(
                height: resolvedGraph.image.height.toDouble(),
                width: resolvedGraph.image.width.toDouble(),
                child: InkWell(
                  onTap: () => controller.onStoryScreenTap(resolvedGraph),
                  child: UIImage(image: resolvedGraph.image),
                ),
              ),
              Container(
                width: resolvedGraph.image.width.toDouble(),
                color: resolvedGraph.graph.showInPullRequest
                    ? Colors.yellow
                    : Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      "${StaticUtils.camelToSentence(resolvedGraph.graph.story.runtimeType.toString())}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(resolvedGraph.graph.relationDescription),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: resolvedGraph.children
                .map((e) => GraphBuilder(
                      controller: controller,
                      resolvedGraph: e,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class StoryBoard extends StatefulWidget {
  final StoryboardGraph? graphForCiAuto;
  final StoryboardGraph? graphForStoryboard;
  final Function onMockEmAll;
  final String Function(dynamic stringCode) translator;
  final Widget Function(Key? key, Widget home) widgetParent;
  final int storyboardGraphLength;
  final int storyboardGraphNumber;

  const StoryBoard({
    Key? key,
    this.graphForCiAuto,
    this.storyboardGraphLength = 0,
    this.storyboardGraphNumber = 0,
    required this.translator,
    required this.onMockEmAll,
    this.graphForStoryboard,
    required this.widgetParent,
  }) : super(key: key);
  @override
  StoryBoardState createState() => StoryBoardState();
}

class StoryBoardState extends State<StoryBoard> {
  final controller = StoryBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "buttonReload",
            onPressed: controller.toggle,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(),
              ),
              child: Center(
                child: Text("RELOAD"),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          FloatingActionButton(
            heroTag: "buttonAnnuler",
            onPressed: controller.chooseStoryBoard,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(),
              ),
              child: Center(
                child: Text("Annuler"),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        // color: Colors.red,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.1,
              boundaryMargin: EdgeInsets.all(500.0),
              constrained: false,
              child: ScreenShotable(
                screenshotController: controller.graphAreaScreenshotCtrl,
                child: Container(
                  // height: screenheight,
                  color: Colors.red,
                  child: controller.resovedGraphRoot == null
                      ? Container()
                      : GraphBuilder(
                          controller: controller,
                          resolvedGraph: controller.resovedGraphRoot!,
                        ),
                ),
              ),
            ),
            _getSpotLight(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // resetContainerForTest();
    super.initState();
    this.controller.attach(this);
    this.controller.numberStoryboardGraph(
        widget.storyboardGraphLength, widget.storyboardGraphNumber);
    SchedulerBinding.instance
        ?.addPostFrameCallback((_) => controller.onReady());
  }

  void applyState() {
    setState(() {});
  }

  //PROBLEM
  /**
      To have an interactive map, it needs to be 100% scaled.
      DevicePreview is using css transform for scaling everything up or down,
      including the map. However,  the map is showing weird bugs if transformed
      ( map edges loading late, map gestures not correctly recognised)
      There is a git issue about that (link to add here) and the solution was
      to suggest that no one scale transform map, people just resize the map.
      As a result,  we have to use full scale map, but DevicePreview adds a
      margin (grey background) to the Device frame and scale down the map.
      We could play around with the size to compensate for this margin to
      make the map 100%, but the best solution is to use DeviceFrame,
      which is used by DevicePreview. DeviceFrame does not have this margin,
      hence, map is at 100%
   ***/

  //SOLUTION
  /// Change device preview and delete padding to display map 100%
  Widget _getSpotLight() {
    final device = Devices.android.samsungS8;

    final bounds = device.screenPath.getBounds();

    final scale = bounds.width / device.screenSize.width;
    final height = StoryBoardController.isFlitWeb
        ? device.frameSize.height / scale
        : screenheight;
    final width = StoryBoardController.isFlitWeb
        ? device.frameSize.width / scale
        : screenwidth;
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: controller.spotLightVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
              ),
              height: height,
              width: width,
              child: false
                  ? ScreenShotable(
                      screenshotController: controller.spotLightScreenshotCtrl,
                      child: GestureVisualizer(
                        child: DeviceFrame(
                          device: device,
                          isFrameVisible: true,
                          screen: Container(
                            height: device.screenSize.height,
                            width: device.screenSize.width,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(),
                            ),
                            child: controller.spotLight,
                          ),
                        ),
                      ),
                    )
                  : ScreenShotable(
                      screenshotController: controller.spotLightScreenshotCtrl,
                      child: GestureVisualizer(
                        child: MyDevicePreview(
                          enabled: true,
                          isToolbarVisible: false,
                          defaultDevice: device,
                          builder: (context) {
                            final ctxDevicePixelRatio =
                                MediaQuery.of(context).devicePixelRatio;
                            final windowDevicePixelRation =
                                ui.window.devicePixelRatio;
                            final ctxSize = MediaQuery.of(context).size;
                            final uiSize = ui.window.physicalSize;
                            final ctxTextScale =
                                MediaQuery.of(context).textScaleFactor;
                            final uiCtxTextScale = ui.window.textScaleFactor;
                            final uiPadding = ui.window.padding;
                            final ctxPadding = MediaQuery.of(context).padding;
                            final ctxViewPadding =
                                MediaQuery.of(context).viewPadding;
                            final ctxViewInsets =
                                MediaQuery.of(context).viewInsets;
                            final uiViewPadding = ui.window.viewPadding;
                            final uiViewInsets = ui.window.viewInsets;

                            final config = {
                              'ctxDevicePixelRatio': ctxDevicePixelRatio,
                              'windowDevicePixelRation':
                                  windowDevicePixelRation,
                              'ctxSize': ctxSize,
                              'uiSize': uiSize,
                              'ctxTextScale': ctxTextScale,
                              'uiCtxTextScale': uiCtxTextScale,
                              'uiPadding': uiPadding,
                              'ctxPadding': ctxPadding,
                              'ctxViewPadding': ctxViewPadding,
                              'ctxViewInsets': ctxViewInsets,
                              'uiViewPadding': uiViewPadding,
                              'uiViewInsets': uiViewInsets,
                            };
                            print(config);
                            return DeviceFrame(
                              device: device,
                              isFrameVisible: false,
                              screen: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(),
                                ),
                                child: controller.spotLight,
                              ),
                            );
                          },
                        ),
                      ),
                    )),
          Container(
            width: width,
            color: Colors.green,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(),
                if (controller.currentGraph != null) ...[
                  Text(
                    "${StaticUtils.camelToSentence(controller.currentGraph!.story.runtimeType.toString())}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(controller.currentGraph!.relationDescription)
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/PR_Storyboards'%'2FPR-Image-Screenshots1625714936054?alt=media&token=36cc34c8-e372-4833-acdd-a1a9f75b941a
// https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/PR_Storyboards%2FPR-Image-Screenshots1625714936054?alt=media&token=36cc34c8-e372-4833-acdd-a1a9f75b941a
