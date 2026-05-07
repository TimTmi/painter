import 'package:flutter/material.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/application/tool_type.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({
    super.key,
    this.toolController,
    this.onSave,
    this.onLoad,
    this.onUndo,
    this.onClear,
  });

  final ToolController? toolController;
  final VoidCallback? onSave;
  final VoidCallback? onLoad;
  final VoidCallback? onUndo;
  final VoidCallback? onClear;

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  late final ToolController _ownedToolController;

  ToolController get _toolController =>
      widget.toolController ?? _ownedToolController;

  @override
  void initState() {
    super.initState();
    _ownedToolController = ToolController();
  }

  @override
  void dispose() {
    if (widget.toolController == null) {
      _ownedToolController.dispose();
    }
    super.dispose();
  }

  void _selectTool(ToolType tool) {
    _toolController.setTool(tool);
  }

  void _setStrokeWidth(double value) {
    _toolController.setStrokeWidth(value);
  }

  void _setColor(Color color) {
    _toolController.setStrokeColor(color);
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
    return AnimatedBuilder(
      animation: _toolController,
      builder: (context, child) {
        final selectedTool = _toolController.selectedTool;
        final strokeWidth = _toolController.strokeWidth;
        final strokeColor = _toolController.strokeColor;

        return Material(
          color: Theme.of(context).colorScheme.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
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
                _fileButton(
                  icon: Icons.undo,
                  label: 'Undo',
                  onPressed: widget.onUndo,
                ),
                _fileButton(
                  icon: Icons.delete_outline,
                  label: 'Clear',
                  onPressed: widget.onClear,
                ),
                const VerticalDivider(width: 20),
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
