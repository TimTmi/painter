import 'dart:ui';

import 'package:paint/application/tool_type.dart';
import 'package:paint/domain/shapes/circle.dart';
import 'package:paint/domain/shapes/ellipse.dart';
import 'package:paint/domain/shapes/line.dart';
import 'package:paint/domain/shapes/point.dart';
import 'package:paint/domain/shapes/rectangle.dart';
import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/domain/shapes/square.dart';

class ShapeFactory {
  const ShapeFactory._();

  static Shape create({
    required ToolType toolType,
    required Offset start,
    required Offset end,
    Color strokeColor = const Color(0xFF000000),
    Color fillColor = const Color(0x00000000),
    double strokeWidth = 1,
  }) {
    return switch (toolType) {
      ToolType.point => PointShape(
        center: start,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      ToolType.line => LineShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      ToolType.rectangle => RectangleShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      ToolType.square => SquareShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      ToolType.circle => CircleShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      ToolType.ellipse => EllipseShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
    };
  }
}
