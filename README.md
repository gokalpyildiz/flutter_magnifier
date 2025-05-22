
# Flutter Magnifier

A Flutter package that provides a magnifying glass effect for any widget. This package allows you to add a magnifying glass functionality to your Flutter applications with various customization options.

## Features

- 🔍 Magnify any widget with a circular magnifying glass
- 🎯 Multiple positioning modes (bouncing, fingertips, custom)
- 🎨 Customizable magnifier size, zoom scale, and border
- 🖼️ Smooth performance with optimized rendering

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_magnifier: ^0.0.1
```

## Usage

### Basic Usage

```dart
import 'package:flutter_magnifier/flutter_magnifier.dart';

// Wrap any widget with MagnifierTool
MagnifierTool(
  widget: YourWidget(),
)
```

### Advanced Usage

```dart
MagnifierTool(
  widget: YourWidget(),
  zoomPosition: BouncingZoomPosition(MagnifierPosition.bouncing),
  magnifierSize: const Size(50, 50),
  zoomScale: 2.5,
  borderColor: Colors.blue,
  showBorder: true,
)
```

### Available Position Types

- `MagnifierPosition.bouncing`: Magnifier bounces between all four corners
- `MagnifierPosition.bouncingTopRightTopLeft`: Bounces between top-right and top-left
- `MagnifierPosition.bouncingBottomRightBottomLeft`: Bounces between bottom-right and bottom-left
- `MagnifierPosition.bouncingTopLeftBottomLeft`: Bounces between top-left and bottom-left
- `MagnifierPosition.bouncingTopRightBottomRight`: Bounces between top-right and bottom-right
- `MagnifierPosition.fingertips`: Follows the touch point with an offset

### Custom Position

You can create a custom position using `CustomZoomPosition`:

```dart
MagnifierTool(
  widget: YourWidget(),
  zoomPosition: CustomZoomPosition(
    top: 0,
    left: 0,
  ),
)
```

### Custom Function Position

You can also use a custom function to calculate the position:

```dart
MagnifierTool(
  widget: YourWidget(),
  zoomPosition: CustomFunctionZoomPosition(
    (top, bottom, left, right) => PositionedPoints(
      top: top + 20,
      left: left + 20,
    ),
  ),
)
```

## Example

Check out the [example](lib/example) directory for a complete example app that demonstrates all features.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
