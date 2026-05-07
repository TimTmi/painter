# Flow

## Presentation

- `canvas_widget` → input capture
- `canvas_painter` → render only
- `toolbar` → tool selection

## Application

- `canvas_state` → single truth
- `canvas_controller` → gesture → shape lifecycle
- `tool_controller` → tool switching logic

## Domain

- Shape hierarchy
- Geometry (`Rect`, `Path` logic)
- Stroke/color value objects

## Infrastructure

- Binary serialize shapes
- Image export via `RenderRepaintBoundary`
