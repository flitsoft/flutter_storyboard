import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyboard/flutter_storyboard.dart';
import 'package:flutter_storyboard/src/model/resolved_graph.dart';
import 'package:flutter_storyboard/src/model/resolved_storyboard_data_store.dart';
import 'package:flutter_storyboard/src/storyboard_controller.dart';
import 'package:flutter_storyboard/src/utils/automation_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_data.dart';

class MockUIAutomation extends FlutterDriver {}

class MockStoryboardController extends StoryBoardController {
  @override
  void applyState() {
    print("Mocked applyState");
  }

  @override
  Future<ResolvedGraphFromBuild?> putOnSpotLight(StoryboardGraph graph) async {
    return core.resolveGraph(graph);
  }

  @override
  void deregisterKeyboard() {
    print("Mocked deregisterKeyboard");
  }

  Future<ImageWidgetData?> takeFlutterScreenShoot() async {
    return ImageWidgetData(size: StoryScreenSize(13, 14), image: Container());
  }

  Future<UploadTaskWitUrl?> getUploadTask(ImageWidgetData image) async {
    return null;
  }
}

void main() {
  test(
    "Only root is resolved graph",
    () async {
      final controller = MockStoryboardController();
      controller.graphStoreData = resolvedGraphUrl;
      controller.graphData = StoryboardGraph(
        story: ContainerLoading(),
        relationDescription: "Loading",
        children: [],
      );
      // final core = StoryboardCore(controller);
      await controller.core.afterReadDataStore();
      expect(
        controller.core.resolvedGraphRootToJsonForTest(),
        {
          'children': [
            {
              'remote': {
                'graphName': 'ContainerLoading',
                'relationDescription': 'Root tap tap',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'ContainerLoading',
                  'relationDescription': 'Loading',
                  'children': 0
                },
                'image': {
                  'size': {'width': 411.4, 'height': 740.0}
                },
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
              },
              'children': [
                {
                  'remote': {
                    'graphName': 'SplashPageLoading',
                    'relationDescription': 'root',
                    'image': {
                      'size': {'width': 411.4, 'height': 740.0}
                    },
                    'imageUrl':
                        'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                  },
                  'children': [
                    {
                      'remote': {
                        'graphName': 'LanguageSignUpPage',
                        'relationDescription': 'root tap tap',
                        'image': {
                          'size': {'width': 411.4, 'height': 740.0}
                        },
                        'imageUrl':
                            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                      },
                      'children': [
                        {
                          'remote': {
                            'graphName': 'ShowMoreLanguageClick',
                            'relationDescription': 'root tap tap',
                            'image': {
                              'size': {'width': 411.4, 'height': 740.0}
                            },
                            'imageUrl':
                                'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                          },
                          'children': []
                        }
                      ]
                    },
                    {
                      'remote': {
                        'graphName': 'OnBoardingLoading',
                        'relationDescription': 'root tap tap',
                        'image': {
                          'size': {'width': 411.4, 'height': 740.0}
                        },
                        'imageUrl':
                            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                      },
                      'children': [
                        {
                          'remote': {
                            'graphName': 'DragToConfirmYourDriver',
                            'relationDescription': 'root tap tap',
                            'image': {
                              'size': {'width': 411.4, 'height': 740.0}
                            },
                            'imageUrl':
                                'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                          },
                          'children': [
                            {
                              'remote': {
                                'graphName': 'DragToTrackYourRide',
                                'relationDescription': 'root tap tap',
                                'image': {
                                  'size': {'width': 411.4, 'height': 740.0}
                                },
                                'imageUrl':
                                    'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                              },
                              'children': []
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        },
      );
    },
  );

  test("Test All resolved", () async {
    final controller = MockStoryboardController();
    controller.graphStoreData = resolvedGraphUrl;
    controller.graphData = StoryboardGraph(
      story: ContainerLoading(),
      relationDescription: "Loading",
      children: [
        StoryboardGraph(
            story: SplashPageLoading(),
            relationDescription: "Splash screen",
            children: [
              StoryboardGraph(
                  story: LanguageSignUpPage(),
                  relationDescription: "Language SignUp Page",
                  children: [
                    StoryboardGraph(
                        story: ShowMoreLanguageClick(),
                        relationDescription: "Show more Language",
                        children: []),
                  ]),
              StoryboardGraph(
                  story: OnBoardingLoading(),
                  relationDescription: "OnBoardingPage screen",
                  children: [
                    StoryboardGraph(
                        story: DragToConfirmYourDriver(),
                        relationDescription: "Drag To Confirm Your Driver",
                        children: [
                          StoryboardGraph(
                              story: DragToTrackYourRide(),
                              relationDescription: "Drag To Track Your Ride",
                              children: []),
                        ]),
                  ]),
            ])
      ],
    );
    // final core = StoryboardCore(controller);
    await controller.core.onReady();
    expect(controller.core.resolvedGraphRootToJsonForTest(), {
      'children': [
        {
          'local': {
            'graphName': 'ContainerLoading',
            'relationDescription': 'Loading',
            'graph': {
              'enabled': true,
              'showInPullRequest': false,
              'storyName': 'ContainerLoading',
              'relationDescription': 'Loading',
              'children': 1
            },
            'image': {
              'size': {'width': 13.0, 'height': 14.0}
            }
          },
          'remote': {
            'graphName': 'ContainerLoading',
            'relationDescription': 'Root tap tap',
            'graph': {
              'enabled': true,
              'showInPullRequest': false,
              'storyName': 'ContainerLoading',
              'relationDescription': 'Loading',
              'children': 1
            },
            'image': {
              'size': {'width': 411.4, 'height': 740.0}
            },
            'imageUrl':
                'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
          },
          'children': [
            {
              'local': {
                'graphName': 'SplashPageLoading',
                'relationDescription': 'Splash screen',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'SplashPageLoading',
                  'relationDescription': 'Splash screen',
                  'children': 2
                },
                'image': {
                  'size': {'width': 13.0, 'height': 14.0}
                }
              },
              'remote': {
                'graphName': 'SplashPageLoading',
                'relationDescription': 'root',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'SplashPageLoading',
                  'relationDescription': 'Splash screen',
                  'children': 2
                },
                'image': {
                  'size': {'width': 411.4, 'height': 740.0}
                },
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
              },
              'children': [
                {
                  'local': {
                    'graphName': 'LanguageSignUpPage',
                    'relationDescription': 'Language SignUp Page',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'LanguageSignUpPage',
                      'relationDescription': 'Language SignUp Page',
                      'children': 1
                    },
                    'image': {
                      'size': {'width': 13.0, 'height': 14.0}
                    }
                  },
                  'remote': {
                    'graphName': 'LanguageSignUpPage',
                    'relationDescription': 'root tap tap',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'LanguageSignUpPage',
                      'relationDescription': 'Language SignUp Page',
                      'children': 1
                    },
                    'image': {
                      'size': {'width': 411.4, 'height': 740.0}
                    },
                    'imageUrl':
                        'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                  },
                  'children': [
                    {
                      'local': {
                        'graphName': 'ShowMoreLanguageClick',
                        'relationDescription': 'Show more Language',
                        'graph': {
                          'enabled': true,
                          'showInPullRequest': false,
                          'storyName': 'ShowMoreLanguageClick',
                          'relationDescription': 'Show more Language',
                          'children': 0
                        },
                        'image': {
                          'size': {'width': 13.0, 'height': 14.0}
                        }
                      },
                      'remote': {
                        'graphName': 'ShowMoreLanguageClick',
                        'relationDescription': 'root tap tap',
                        'graph': {
                          'enabled': true,
                          'showInPullRequest': false,
                          'storyName': 'ShowMoreLanguageClick',
                          'relationDescription': 'Show more Language',
                          'children': 0
                        },
                        'image': {
                          'size': {'width': 411.4, 'height': 740.0}
                        },
                        'imageUrl':
                            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                      },
                      'children': []
                    }
                  ]
                },
                {
                  'local': {
                    'graphName': 'OnBoardingLoading',
                    'relationDescription': 'OnBoardingPage screen',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'OnBoardingLoading',
                      'relationDescription': 'OnBoardingPage screen',
                      'children': 1
                    },
                    'image': {
                      'size': {'width': 13.0, 'height': 14.0}
                    }
                  },
                  'remote': {
                    'graphName': 'OnBoardingLoading',
                    'relationDescription': 'root tap tap',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'OnBoardingLoading',
                      'relationDescription': 'OnBoardingPage screen',
                      'children': 1
                    },
                    'image': {
                      'size': {'width': 411.4, 'height': 740.0}
                    },
                    'imageUrl':
                        'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                  },
                  'children': [
                    {
                      'local': {
                        'graphName': 'DragToConfirmYourDriver',
                        'relationDescription': 'Drag To Confirm Your Driver',
                        'graph': {
                          'enabled': true,
                          'showInPullRequest': false,
                          'storyName': 'DragToConfirmYourDriver',
                          'relationDescription': 'Drag To Confirm Your Driver',
                          'children': 1
                        },
                        'image': {
                          'size': {'width': 13.0, 'height': 14.0}
                        }
                      },
                      'remote': {
                        'graphName': 'DragToConfirmYourDriver',
                        'relationDescription': 'root tap tap',
                        'graph': {
                          'enabled': true,
                          'showInPullRequest': false,
                          'storyName': 'DragToConfirmYourDriver',
                          'relationDescription': 'Drag To Confirm Your Driver',
                          'children': 1
                        },
                        'image': {
                          'size': {'width': 411.4, 'height': 740.0}
                        },
                        'imageUrl':
                            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                      },
                      'children': [
                        {
                          'local': {
                            'graphName': 'DragToTrackYourRide',
                            'relationDescription': 'Drag To Track Your Ride',
                            'graph': {
                              'enabled': true,
                              'showInPullRequest': false,
                              'storyName': 'DragToTrackYourRide',
                              'relationDescription': 'Drag To Track Your Ride',
                              'children': 0
                            },
                            'image': {
                              'size': {'width': 13.0, 'height': 14.0}
                            }
                          },
                          'remote': {
                            'graphName': 'DragToTrackYourRide',
                            'relationDescription': 'root tap tap',
                            'graph': {
                              'enabled': true,
                              'showInPullRequest': false,
                              'storyName': 'DragToTrackYourRide',
                              'relationDescription': 'Drag To Track Your Ride',
                              'children': 0
                            },
                            'image': {
                              'size': {'width': 411.4, 'height': 740.0}
                            },
                            'imageUrl':
                                'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                          },
                          'children': []
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    });
  });

  test("Test Some not resolved ", () async {
    // expect('{"foo":123}', '{"foo":124}');
    final controller = MockStoryboardController();
    controller.graphStoreData = resolvedGraphUrl;
    controller.graphData = StoryboardGraph(
      story: ContainerLoading(),
      relationDescription: "Loading",
      children: [
        StoryboardGraph(
            story: SplashPageLoading(),
            relationDescription:
                "First child is in local, but local also has a second child that is not here",
            children: [
              StoryboardGraph(
                  story: LanguageSignUpPage(),
                  relationDescription: "Language SignUp Page",
                  children: [
                    StoryboardGraph(
                        story: ShowMoreLanguageClick(),
                        relationDescription: "Show more Language",
                        children: []),
                    StoryboardGraph(
                        story: DragToConfirmYourDriver(),
                        relationDescription:
                            "This is from remote but not in local",
                        children: []),
                  ]),
            ]),
      ],
    );
    // final core = StoryboardCore(controller);
    await controller.core.onReady();
    expect(
        (controller.core.resolvedGraphRootToJsonForTest()),
        ({
          'children': [
            {
              'local': {
                'graphName': 'ContainerLoading',
                'relationDescription': 'Loading',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'ContainerLoading',
                  'relationDescription': 'Loading',
                  'children': 1
                },
                'image': {
                  'size': {'width': 13.0, 'height': 14.0}
                }
              },
              'remote': {
                'graphName': 'ContainerLoading',
                'relationDescription': 'Root tap tap',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'ContainerLoading',
                  'relationDescription': 'Loading',
                  'children': 1
                },
                'image': {
                  'size': {'width': 411.4, 'height': 740.0}
                },
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
              },
              'children': [
                {
                  'local': {
                    'graphName': 'SplashPageLoading',
                    'relationDescription':
                        'First child is in local, but local also has a second child that is not here',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'SplashPageLoading',
                      'relationDescription':
                          'First child is in local, but local also has a second child that is not here',
                      'children': 1
                    },
                    'image': {
                      'size': {'width': 13.0, 'height': 14.0}
                    }
                  },
                  'remote': {
                    'graphName': 'SplashPageLoading',
                    'relationDescription': 'root',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'SplashPageLoading',
                      'relationDescription':
                          'First child is in local, but local also has a second child that is not here',
                      'children': 1
                    },
                    'image': {
                      'size': {'width': 411.4, 'height': 740.0}
                    },
                    'imageUrl':
                        'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                  },
                  'children': [
                    {
                      'local': {
                        'graphName': 'LanguageSignUpPage',
                        'relationDescription': 'Language SignUp Page',
                        'graph': {
                          'enabled': true,
                          'showInPullRequest': false,
                          'storyName': 'LanguageSignUpPage',
                          'relationDescription': 'Language SignUp Page',
                          'children': 2
                        },
                        'image': {
                          'size': {'width': 13.0, 'height': 14.0}
                        }
                      },
                      'remote': {
                        'graphName': 'LanguageSignUpPage',
                        'relationDescription': 'root tap tap',
                        'graph': {
                          'enabled': true,
                          'showInPullRequest': false,
                          'storyName': 'LanguageSignUpPage',
                          'relationDescription': 'Language SignUp Page',
                          'children': 2
                        },
                        'image': {
                          'size': {'width': 411.4, 'height': 740.0}
                        },
                        'imageUrl':
                            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                      },
                      'children': [
                        {
                          'local': {
                            'graphName': 'ShowMoreLanguageClick',
                            'relationDescription': 'Show more Language',
                            'graph': {
                              'enabled': true,
                              'showInPullRequest': false,
                              'storyName': 'ShowMoreLanguageClick',
                              'relationDescription': 'Show more Language',
                              'children': 0
                            },
                            'image': {
                              'size': {'width': 13.0, 'height': 14.0}
                            }
                          },
                          'remote': {
                            'graphName': 'ShowMoreLanguageClick',
                            'relationDescription': 'root tap tap',
                            'graph': {
                              'enabled': true,
                              'showInPullRequest': false,
                              'storyName': 'ShowMoreLanguageClick',
                              'relationDescription': 'Show more Language',
                              'children': 0
                            },
                            'image': {
                              'size': {'width': 411.4, 'height': 740.0}
                            },
                            'imageUrl':
                                'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                          },
                          'children': []
                        },
                        {
                          'local': {
                            'graphName': 'DragToConfirmYourDriver',
                            'relationDescription':
                                'This is from remote but not in local',
                            'graph': {
                              'enabled': true,
                              'showInPullRequest': false,
                              'storyName': 'DragToConfirmYourDriver',
                              'relationDescription':
                                  'This is from remote but not in local',
                              'children': 0
                            },
                            'image': {
                              'size': {'width': 13.0, 'height': 14.0}
                            },
                          },
                          'children': []
                        }
                      ]
                    },
                    {
                      'remote': {
                        'graphName': 'OnBoardingLoading',
                        'relationDescription': 'root tap tap',
                        'image': {
                          'size': {'width': 411.4, 'height': 740.0}
                        },
                        'imageUrl':
                            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                      },
                      'children': [
                        {
                          'remote': {
                            'graphName': 'DragToConfirmYourDriver',
                            'relationDescription': 'root tap tap',
                            'image': {
                              'size': {'width': 411.4, 'height': 740.0}
                            },
                            'imageUrl':
                                'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                          },
                          'children': [
                            {
                              'remote': {
                                'graphName': 'DragToTrackYourRide',
                                'relationDescription': 'root tap tap',
                                'image': {
                                  'size': {'width': 411.4, 'height': 740.0}
                                },
                                'imageUrl':
                                    'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                              },
                              'children': []
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }));
  });

  test("Test no remote", () async {
    // expect('{"foo":123}', '{"foo":124}');
    final controller = MockStoryboardController();
    controller.graphData = StoryboardGraph(
      story: ContainerLoading(),
      relationDescription: "Loading",
      children: [
        StoryboardGraph(
            story: SplashPageLoading(),
            relationDescription:
                "First child is in local, but local also has a second child that is not here",
            children: [
              StoryboardGraph(
                  story: LanguageSignUpPage(),
                  relationDescription: "Language SignUp Page",
                  children: [
                    StoryboardGraph(
                        story: ShowMoreLanguageClick(),
                        relationDescription: "Show more Language",
                        children: []),
                    StoryboardGraph(
                        story: DragToConfirmYourDriver(),
                        relationDescription:
                            "This is from remote but not in local",
                        children: []),
                  ]),
            ]),
      ],
    );
    // final core = StoryboardCore(controller);
    await controller.core.onReady();
    expect(
        (controller.core.resolvedGraphRootToJsonForTest()),
        ({
          'children': [
            {
              'local': {
                'graphName': 'ContainerLoading',
                'relationDescription': 'Loading',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'ContainerLoading',
                  'relationDescription': 'Loading',
                  'children': 1
                },
                'image': {
                  'size': {'width': 13.0, 'height': 14.0}
                }
              },
              'children': [
                {
                  'local': {
                    'graphName': 'SplashPageLoading',
                    'relationDescription':
                        'First child is in local, but local also has a second child that is not here',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'SplashPageLoading',
                      'relationDescription':
                          'First child is in local, but local also has a second child that is not here',
                      'children': 1
                    },
                    'image': {
                      'size': {'width': 13.0, 'height': 14.0}
                    }
                  },
                  'children': [
                    {
                      'local': {
                        'graphName': 'LanguageSignUpPage',
                        'relationDescription': 'Language SignUp Page',
                        'graph': {
                          'enabled': true,
                          'showInPullRequest': false,
                          'storyName': 'LanguageSignUpPage',
                          'relationDescription': 'Language SignUp Page',
                          'children': 2
                        },
                        'image': {
                          'size': {'width': 13.0, 'height': 14.0}
                        }
                      },
                      'children': [
                        {
                          'local': {
                            'graphName': 'ShowMoreLanguageClick',
                            'relationDescription': 'Show more Language',
                            'graph': {
                              'enabled': true,
                              'showInPullRequest': false,
                              'storyName': 'ShowMoreLanguageClick',
                              'relationDescription': 'Show more Language',
                              'children': 0
                            },
                            'image': {
                              'size': {'width': 13.0, 'height': 14.0}
                            }
                          },
                          'children': []
                        },
                        {
                          'local': {
                            'graphName': 'DragToConfirmYourDriver',
                            'relationDescription':
                                'This is from remote but not in local',
                            'graph': {
                              'enabled': true,
                              'showInPullRequest': false,
                              'storyName': 'DragToConfirmYourDriver',
                              'relationDescription':
                                  'This is from remote but not in local',
                              'children': 0
                            },
                            'image': {
                              'size': {'width': 13.0, 'height': 14.0}
                            },
                          },
                          'children': []
                        }
                      ]
                    },
                  ]
                }
              ]
            }
          ]
        }));
  });
}

final d = {
  'children': [
    {
      'local': {
        'graphName': 'ContainerLoading',
        'relationDescription': 'Loading',
        'graph': {
          'enabled': true,
          'showInPullRequest': false,
          'storyName': 'ContainerLoading',
          'relationDescription': 'Loading',
          'children': 1
        },
        'image': {
          'size': {'width': 13.0, 'height': 14.0}
        }
      },
      'remote': {
        'graphName': 'ContainerLoading',
        'relationDescription': 'Root tap tap',
        'graph': {
          'enabled': true,
          'showInPullRequest': false,
          'storyName': 'ContainerLoading',
          'relationDescription': 'Loading',
          'children': 1
        },
        'image': {
          'size': {'width': 411.4, 'height': 740.0}
        },
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
      },
      'children': [
        {
          'local': {
            'graphName': 'SplashPageLoading',
            'relationDescription':
                'First child is in local, but local also has a second child that is not here',
            'graph': {
              'enabled': true,
              'showInPullRequest': false,
              'storyName': 'SplashPageLoading',
              'relationDescription':
                  'First child is in local, but local also has a second child that is not here',
              'children': 1
            },
            'image': {
              'size': {'width': 13.0, 'height': 14.0}
            }
          },
          'remote': {
            'graphName': 'SplashPageLoading',
            'relationDescription': 'root',
            'graph': {
              'enabled': true,
              'showInPullRequest': false,
              'storyName': 'SplashPageLoading',
              'relationDescription':
                  'First child is in local, but local also has a second child that is not here',
              'children': 1
            },
            'image': {
              'size': {'width': 411.4, 'height': 740.0}
            },
            'imageUrl':
                'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
          },
          'children': [
            {
              'local': {
                'graphName': 'LanguageSignUpPage',
                'relationDescription': 'Language SignUp Page',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'LanguageSignUpPage',
                  'relationDescription': 'Language SignUp Page',
                  'children': 2
                },
                'image': {
                  'size': {'width': 13.0, 'height': 14.0}
                }
              },
              'remote': {
                'graphName': 'LanguageSignUpPage',
                'relationDescription': 'root tap tap',
                'graph': {
                  'enabled': true,
                  'showInPullRequest': false,
                  'storyName': 'LanguageSignUpPage',
                  'relationDescription': 'Language SignUp Page',
                  'children': 2
                },
                'image': {
                  'size': {'width': 411.4, 'height': 740.0}
                },
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
              },
              'children': [
                {
                  'local': {
                    'graphName': 'ShowMoreLanguageClick',
                    'relationDescription': 'Show more Language',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'ShowMoreLanguageClick',
                      'relationDescription': 'Show more Language',
                      'children': 0
                    },
                    'image': {
                      'size': {'width': 13.0, 'height': 14.0}
                    }
                  },
                  'remote': {
                    'graphName': 'ShowMoreLanguageClick',
                    'relationDescription': 'root tap tap',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'ShowMoreLanguageClick',
                      'relationDescription': 'Show more Language',
                      'children': 0
                    },
                    'image': {
                      'size': {'width': 411.4, 'height': 740.0}
                    },
                    'imageUrl':
                        'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                  },
                  'children': []
                },
                {
                  'local': {
                    'graphName': 'DragToConfirmYourDriver',
                    'relationDescription':
                        'This is from remote but not in local',
                    'graph': {
                      'enabled': true,
                      'showInPullRequest': false,
                      'storyName': 'DragToConfirmYourDriver',
                      'relationDescription':
                          'This is from remote but not in local',
                      'children': 0
                    },
                    'image': {
                      'size': {'width': 13.0, 'height': 14.0}
                    }
                  },
                  'children': []
                }
              ]
            },
            {
              'remote': {
                'graphName': 'OnBoardingLoading',
                'relationDescription': 'root tap tap',
                'image': {
                  'size': {'width': 411.4, 'height': 740.0}
                },
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
              },
              'children': [
                {
                  'remote': {
                    'graphName': 'DragToConfirmYourDriver',
                    'relationDescription': 'root tap tap',
                    'image': {
                      'size': {'width': 411.4, 'height': 740.0}
                    },
                    'imageUrl':
                        'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                  },
                  'children': [
                    {
                      'remote': {
                        'graphName': 'DragToTrackYourRide',
                        'relationDescription': 'root tap tap',
                        'image': {
                          'size': {'width': 411.4, 'height': 740.0}
                        },
                        'imageUrl':
                            'https://firebasestorage.googleapis.com/v0/b/rideapplication-3aa62.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-06-15%20at%2017.49.30.png?alt=media&token=81563eb3-d5f5-4443-bd6d-88847ffb3e9b'
                      },
                      'children': []
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
};
