import 'package:flutter/material.dart';
import 'package:paint/application/tool_type.dart';

class ToolController extends ChangeNotifier {
  ToolType _selectedTool = ToolType.line;
  Color _strokeColor = Colors.black;
  double _strokeWidth = 4;

  Color _fillColor = const Color(0x00000000);

  ToolType get selectedTool => _selectedTool;
  Color get strokeColor => _strokeColor;
  double get strokeWidth => _strokeWidth;
  Color get fillColor => _fillColor;

  void setTool(ToolType tool) {
    if (_selectedTool != tool) {
      _selectedTool = tool;
      notifyListeners();
    }
  }

  void setStrokeColor(Color color) {
    if (_strokeColor != color) {
      _strokeColor = color;
      notifyListeners();
    }
  }

  void setStrokeWidth(double width) {
    if (_strokeWidth != width) {
      _strokeWidth = width;
      notifyListeners();
    }
  }

  void setFillColor(Color color) {
    if (_fillColor != color) {
      _fillColor = color;
      notifyListeners();
    }
  }
}
