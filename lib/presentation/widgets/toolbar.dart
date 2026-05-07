import 'package:flutter/material.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/application/tool_type.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key, required this.toolController});

  final ToolController toolController;

  void _selectTool(ToolType tool) {
    toolController.setTool(tool);
  }

  void _setStrokeWidth(double value) {
    toolController.setStrokeWidth(value);
  }

  void _setColor(Color color) {
    toolController.setStrokeColor(color);
  }

  Widget _toolButton(
    BuildContext context,
    ToolType selectedTool,
    ToolType tool,
    IconData icon,
    String label,
  ) {
    final selected = selectedTool == tool;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _selectTool(tool),
            icon: Icon(icon),
            color: selected ? Theme.of(context).colorScheme.primary : null,
            tooltip: label,
          ),
          if (selected)
            SizedBox(
              height: 4,
              width: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: toolController,
      builder: (context, child) {
        final selectedTool = toolController.selectedTool;
        final strokeWidth = toolController.strokeWidth;
        final strokeColor = toolController.strokeColor;

        return Material(
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                _toolButton(
                  context,
                  selectedTool,
                  ToolType.point,
                  Icons.radio_button_checked,
                  'Point',
                ),
                _toolButton(
                  context,
                  selectedTool,
                  ToolType.line,
                  Icons.show_chart,
                  'Line',
                ),
                _toolButton(
                  context,
                  selectedTool,
                  ToolType.rectangle,
                  Icons.crop_square,
                  'Rect',
                ),
                _toolButton(
                  context,
                  selectedTool,
                  ToolType.square,
                  Icons.check_box_outline_blank,
                  'Square',
                ),
                _toolButton(
                  context,
                  selectedTool,
                  ToolType.circle,
                  Icons.circle_outlined,
                  'Circle',
                ),
                _toolButton(
                  context,
                  selectedTool,
                  ToolType.ellipse,
                  Icons.panorama_fish_eye,
                  'Ellipse',
                ),
                const VerticalDivider(width: 20),
                SizedBox(
                  width: 180,
                  child: Row(
                    children: [
                      const Text('Width'),
                      Expanded(
                        child: Slider(
                          value: strokeWidth,
                          min: 1,
                          max: 20,
                          divisions: 19,
                          label: strokeWidth.toStringAsFixed(0),
                          onChanged: _setStrokeWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 20),
                Row(
                  children: [
                    _colorSwatch(Colors.black, strokeColor),
                    _colorSwatch(Colors.red, strokeColor),
                    _colorSwatch(Colors.green, strokeColor),
                    _colorSwatch(Colors.blue, strokeColor),
                    _colorSwatch(Colors.yellow, strokeColor),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(selectedTool.name.toUpperCase()),
                      const SizedBox(width: 8),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: strokeColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _colorSwatch(Color color, Color selectedColor) {
    final selected = selectedColor.toARGB32() == color.toARGB32();

    return GestureDetector(
      onTap: () => _setColor(color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          border: Border.all(
            color: selected ? Colors.black : Colors.black26,
            width: selected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}
