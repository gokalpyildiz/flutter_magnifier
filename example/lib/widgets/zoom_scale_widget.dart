import 'package:flutter/material.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_view_model.dart';

class ZoomScaleWidget extends StatelessWidget {
  final MagnifierViewModel viewModel;

  const ZoomScaleWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final zoomScale = viewModel.state.zoomScale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Zoom Scale:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Slider(
              value: zoomScale,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              label: zoomScale.toStringAsFixed(1),
              onChanged: viewModel.updateZoomScale,
            ),
            Text(
              zoomScale.toStringAsFixed(1),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
