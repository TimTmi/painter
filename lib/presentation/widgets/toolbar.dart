import 'package:flutter/material.dart';

enum ToolType { pen, line, rectangle, circle, eraser }

class Toolbar extends StatefulWidget {
  const Toolbar({super.key});

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  ToolType _selected = ToolType.pen;
  double _strokeWidth = 4;
  Color _color = Colors.black;

  void _selectTool(ToolType tool) {
    setState(() => _selected = tool);
  }

  void _setStrokeWidth(double v) {
    setState(() => _strokeWidth = v);
  }

  void _setColor(Color c) {
    setState(() => _color = c);
  }

  Widget _toolButton(ToolType tool, IconData icon, String label) {
    final selected = _selected == tool;
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
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            // Tools
            _toolButton(ToolType.pen, Icons.edit, 'Pen'),
            _toolButton(ToolType.line, Icons.show_chart, 'Line'),
            _toolButton(ToolType.rectangle, Icons.crop_square, 'Rect'),
            _toolButton(ToolType.circle, Icons.circle, 'Circle'),
            _toolButton(ToolType.eraser, Icons.cleaning_services, 'Eraser'),
            const VerticalDivider(width: 20),

            // Stroke width (mock)
            SizedBox(
              width: 180,
              child: Row(
                children: [
                  const Text('Width'),
                  Expanded(
                    child: Slider(
                      value: _strokeWidth,
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: _strokeWidth.toStringAsFixed(0),
                      onChanged: _setStrokeWidth,
                    ),
                  ),
                ],
              ),
            ),

            const VerticalDivider(width: 20),

            // Color swatches (mock)
            Row(
              children: [
                _colorSwatch(Colors.black),
                _colorSwatch(Colors.red),
                _colorSwatch(Colors.green),
                _colorSwatch(Colors.blue),
                _colorSwatch(Colors.yellow),
              ],
            ),

            const Spacer(),

            // Status summary (small)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Text(_selected.name.toUpperCase()),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _color,
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
  }

  Widget _colorSwatch(Color c) {
    final selected = _color.toARGB32() == c.toARGB32();
    return GestureDetector(
      onTap: () => _setColor(c),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: c,
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
