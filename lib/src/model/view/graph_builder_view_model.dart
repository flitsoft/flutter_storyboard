import 'package:flutter_storyboard/src/model/storyboard_model.dart';

class GraphBuilderViewModel {
  final String title;
  final String description;
  final ImageWidgetData image;
  final bool overriding;
  final bool hasChanged;

  GraphBuilderViewModel({
    required this.title,
    required this.description,
    required this.image,
    this.overriding = false,
    this.hasChanged = false,
  });
}
