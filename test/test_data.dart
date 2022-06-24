import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/flutter_storyboard.dart';
import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:flutter_test/flutter_test.dart';

class ContainerStoryScreen extends BaseStoryScreen implements StoryScreen {
  late Widget widget;

  @override
  void init() {
    widget = CounterApp();
  }

  @override
  Future<void> stageForScreenshot() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class ContainerLoading extends ContainerStoryScreen {
  @override
  Future<void> arrangeAfterBuild() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class SplashPageLoading extends ContainerStoryScreen {
  @override
  Future<void> arrangeAfterBuild() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class LanguageSignUpPage extends ContainerStoryScreen {
  @override
  Future<void> arrangeAfterBuild() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class ShowMoreLanguageClick extends ContainerStoryScreen {
  @override
  Future<void> arrangeAfterBuild() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class OnBoardingLoading extends ContainerStoryScreen {
  @override
  Future<void> arrangeAfterBuild() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class DragToConfirmYourDriver extends ContainerStoryScreen {
  @override
  Future<void> arrangeAfterBuild() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class DragToTrackYourRide extends ContainerStoryScreen {
  @override
  Future<void> arrangeAfterBuild() async {
    await pumpAndSettle(Duration(milliseconds: 500));
  }
}

class CounterApp extends StatefulWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App - Compact',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Page Title"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${counter}',
                style: Theme.of(context).textTheme.display1,
              ),
              RaisedButton(
                onPressed: () => counter++,
                child: Text("Increment"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final url =
    "https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b";
final resolvedGraphUrl = GraphDataStore(
  imageUrl: url,
  graphName: 'ContainerLoading',
  relationDescription: 'Root tap tap',
  children: [
    GraphDataStore(
      imageUrl: url,
      graphName: 'SplashPageLoading',
      relationDescription: 'root',
      children: [
        GraphDataStore(
          imageUrl: url,
          graphName: 'LanguageSignUpPage',
          relationDescription: 'root tap tap',
          children: [
            GraphDataStore(
              imageUrl: url,
              graphName: 'ShowMoreLanguageClick',
              relationDescription: 'root tap tap',
              children: [],
              size: StoryScreenSize(411.4, 740.0),
            ),
          ],
          size: StoryScreenSize(411.4, 740.0),
        ),
        GraphDataStore(
          imageUrl: url,
          graphName: 'OnBoardingLoading',
          relationDescription: 'root tap tap',
          children: [
            GraphDataStore(
              imageUrl: url,
              graphName: 'DragToConfirmYourDriver',
              relationDescription: 'root tap tap',
              children: [
                GraphDataStore(
                  imageUrl: url,
                  graphName: 'DragToTrackYourRide',
                  relationDescription: 'root tap tap',
                  children: [],
                  size: StoryScreenSize(411.4, 740.0),
                ),
              ],
              size: StoryScreenSize(411.4, 740.0),
            ),
          ],
          size: StoryScreenSize(411.4, 740.0),
        ),
      ],
      size: StoryScreenSize(411.4, 740.0),
    ),
  ],
  size: StoryScreenSize(411.4, 740.0),
);
