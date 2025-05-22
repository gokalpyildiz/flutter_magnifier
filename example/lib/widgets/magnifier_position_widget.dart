import 'package:flutter/material.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_view_model.dart';

class MagnifierPositionWidget extends StatelessWidget {
  final MagnifierViewModel viewModel;

  const MagnifierPositionWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Magnifier Position:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: viewModel.state.currentPositionValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: const [
            DropdownMenuItem(
              value: 'Bouncing',
              child: Text('Bouncing'),
            ),
            DropdownMenuItem(
              value: 'Custom',
              child: Text('Custom'),
            ),
            DropdownMenuItem(
              value: 'Custom Function',
              child: Text('Custom Function'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              viewModel.updatePosition(value);
              _updateZoomPosition(value);
            }
          },
        ),
        const SizedBox(height: 16),
        if (viewModel.state.currentPositionValue == 'Bouncing') ...[
          const Text(
            'Bouncing Position:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBouncingChip('Fingertips', MagnifierPositionEnum.fingertips),
              _buildBouncingChip('Top Left - Bottom Left', MagnifierPositionEnum.bouncingTopLeftBottomLeft),
              _buildBouncingChip('Top Right - Bottom Right', MagnifierPositionEnum.bouncingTopRightBottomRight),
              _buildBouncingChip('Top Right - Top Left', MagnifierPositionEnum.bouncingTopRightTopLeft),
              _buildBouncingChip('Bottom Right - Bottom Left', MagnifierPositionEnum.bouncingBottomRightBottomLeft),
              _buildBouncingChip('Top Left - Top Right', MagnifierPositionEnum.bouncingTopLeftBottomLeft),
            ],
          ),
        ] else if (viewModel.state.currentPositionValue == 'Custom') ...[
          const Text(
            'Custom Position:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Top',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final top = double.tryParse(value);
                    if (top != null) {
                      viewModel.updateZoomPosition(CustomZoomPosition(top: top));
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Left',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final left = double.tryParse(value);
                    if (left != null) {
                      viewModel.updateZoomPosition(CustomZoomPosition(left: left));
                    }
                  },
                ),
              ),
            ],
          ),
        ] else if (viewModel.state.currentPositionValue == 'Custom Function') ...[
          const Text(
            'Custom Function Position:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              viewModel.updateZoomPosition(
                CustomFunctionZoomPosition(({required bottom, required left, required right, required top}) {
                  return PositionedPoints(top: top + 50, right: right + 50);
                }),
              );
            },
            child: const Text('Apply Custom Function'),
          ),
        ],
      ],
    );
  }

  Widget _buildBouncingChip(String label, MagnifierPositionEnum position) {
    return ChoiceChip(
      label: Text(label),
      selected: false,
      onSelected: (selected) {
        if (selected) {
          viewModel.updateZoomPosition(BouncingZoomPosition(position));
        }
      },
    );
  }

  void _updateZoomPosition(String position) {
    switch (position) {
      case 'Bouncing':
        viewModel.updateZoomPosition(const BouncingZoomPosition(MagnifierPositionEnum.bouncing));
        break;
      case 'Custom':
        viewModel.updateZoomPosition(const CustomZoomPosition(top: 0, left: 0));
        break;
      case 'Custom Function':
        viewModel.updateZoomPosition(
          CustomFunctionZoomPosition(
            ({required bottom, required left, required right, required top}) {
              return PositionedPoints(top: top + 50, right: right + 50);
            },
          ),
        );
        break;
    }
  }
}
