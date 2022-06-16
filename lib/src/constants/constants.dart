import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Size logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
final screenwidth = min(411.4, logicalSize.width * 0.8);
final screenheight = min(740.0, logicalSize.height * 0.8);
