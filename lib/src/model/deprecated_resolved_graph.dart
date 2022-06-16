import 'package:flutter_storyboard/src/model/storyboard_graph.dart';
import 'package:flutter_storyboard/src/model/storyboard_model.dart';

class ResolvedGraph {
  ResolvedGraphFromBuild? locale;
  ResolvedGraphFromRemote? remote;
  List<ResolvedGraph> children;

  ResolvedGraph({
    this.locale,
    this.remote,
    this.children = const [],
  });

  ImageWidgetData get image {
    final image = this.locale?.image ?? this.remote?.image;
    if (image != null) return image;
    throw Exception("Local and remote cannot be null at the same time");
  }

  StoryboardGraph get graph {
    final graph = this.remote?.graph ?? this.locale?.graph;
    if (graph != null) return graph;
    throw Exception("Local and remote cannot be null at the same time");
  }
}

class ResolvedGraphWithLocaleOnly {
  ResolvedGraphFromBuild locale;
  ResolvedGraphFromRemote? remote;
  List<ResolvedGraphWithLocaleOnly> children;
  ResolvedGraphWithLocaleOnly({
    required this.locale,
    this.remote,
    this.children = const [],
  });
}

class ResolvedGraphWithLocale {
  ResolvedGraphFromBuild locale;
  ResolvedGraphFromRemote remote;
  List<ResolvedGraph> children;
  ResolvedGraphWithLocale({
    required this.locale,
    required this.remote,
    this.children = const [],
  });
}

class ResolvedGraphFromBuild {
  final String graphName;
  final String relationDescription;
  final StoryboardGraph graph;
  final ImageWidgetData image;
  final String? imageUrl;

  ResolvedGraphFromBuild({
    this.imageUrl,
    required this.graphName,
    required this.relationDescription,
    required this.graph,
    required this.image,
  });
}

class ResolvedGraphFromRemote {
  final String graphName;
  final String relationDescription;
  final StoryboardGraph? graph;
  final ImageWidgetData image;
  final String? imageUrl;

  ResolvedGraphFromRemote({
    this.imageUrl,
    required this.graphName,
    required this.relationDescription,
    required this.graph,
    required this.image,
  });
}
