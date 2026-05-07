import 'package:flutter/material.dart';
import 'package:paint/application/tool_type.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({super.key, this.onSave, this.onLoad});

  final VoidCallback? onSave;
  final VoidCallback? onLoad;

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  ToolType _selected = ToolType.point;
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

  Widget _fileButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(onPressed: onPressed, icon: Icon(icon), tooltip: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            _toolButton(ToolType.point, Icons.radio_button_checked, 'Point'),
            _toolButton(ToolType.line, Icons.show_chart, 'Line'),
            _toolButton(ToolType.rectangle, Icons.crop_square, 'Rect'),
            _toolButton(
              ToolType.square,
              Icons.check_box_outline_blank,
              'Square',
            ),
            _toolButton(ToolType.circle, Icons.circle_outlined, 'Circle'),
            _toolButton(ToolType.ellipse, Icons.panorama_fish_eye, 'Ellipse'),
            const VerticalDivider(width: 20),

            _fileButton(
              icon: Icons.save_outlined,
              label: 'Save',
              onPressed: widget.onSave,
            ),
            _fileButton(
              icon: Icons.folder_open_outlined,
              label: 'Load',
              onPressed: widget.onLoad,
            ),
            const VerticalDivider(width: 20),

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

            Row(
              children: [
                _colorSwatch(Colors.black),
                _colorSwatch(Colors.red),
                _colorSwatch(Colors.green),
                _colorSwatch(Colors.blue),
                _colorSwatch(Colors.yellow),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
