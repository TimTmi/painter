import 'package:flutter/foundation.dart';
import 'package:paint/application/tool_type.dart';

class ToolController extends ChangeNotifier {
  ToolType _selectedTool = ToolType.line;

  ToolType get selectedTool => _selectedTool;

  void setTool(ToolType tool) {
    if (_selectedTool != tool) {
      _selectedTool = tool;
      notifyListeners();
    }
  }
}
