import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paint/application/tool_type.dart';

class ToolController extends ChangeNotifier {
  ToolType _selectedTool = ToolType.line;
  Color _strokeColor = Colors.black;
  double _strokeWidth = 4;

  ToolType get selectedTool => _selectedTool;
  Color get strokeColor => _strokeColor;
  double get strokeWidth => _strokeWidth;

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
}
