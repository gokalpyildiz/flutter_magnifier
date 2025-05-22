import 'package:flutter/material.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_view_model.dart';

class MagnifierSizeWidget extends StatelessWidget {
  final MagnifierViewModel viewModel;

  const MagnifierSizeWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final magnifierSize = viewModel.state.magnifierSize;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Magnifier Size: ${magnifierSize.width.toInt()}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Slider(
          value: magnifierSize.width,
          min: 50,
          max: 300,
          divisions: 25,
          label: magnifierSize.width.toInt().toString(),
          onChanged: viewModel.updateMagnifierSize,
        ),
      ],
    );
  }
}
