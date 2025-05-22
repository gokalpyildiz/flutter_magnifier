import 'package:flutter/material.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_view_model.dart';

class MagnifierPositionWidget extends StatefulWidget {
  final MagnifierViewModel viewModel;

  const MagnifierPositionWidget({
    super.key,
    required this.viewModel,
  });

  @override
  State<MagnifierPositionWidget> createState() => _MagnifierPositionWidgetState();
}

class _MagnifierPositionWidgetState extends State<MagnifierPositionWidget> {
  late final TextEditingController _topTextEditingController;
  late final TextEditingController _leftTextEditingController;
  @override
  void initState() {
    super.initState();
    _topTextEditingController = TextEditingController();
    _leftTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _topTextEditingController.dispose();
    _leftTextEditingController.dispose();
    super.dispose();
  }

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
          value: widget.viewModel.state.currentPositionValue,
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
              widget.viewModel.updatePosition(value);
              _updateZoomPosition(value);
            }
          },
        ),
        const SizedBox(height: 16),
        if (widget.viewModel.state.currentPositionValue == 'Bouncing') ...[
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
              _buildBouncingChip('Bouncing', MagnifierPositionEnum.bouncing),
              _buildBouncingChip('Top Left - Bottom Left', MagnifierPositionEnum.bouncingTopLeftBottomLeft),
              _buildBouncingChip('Top Right - Bottom Right', MagnifierPositionEnum.bouncingTopRightBottomRight),
              _buildBouncingChip('Top Right - Top Left', MagnifierPositionEnum.bouncingTopRightTopLeft),
              _buildBouncingChip('Bottom Right - Bottom Left', MagnifierPositionEnum.bouncingBottomRightBottomLeft),
            ],
          ),
        ] else if (widget.viewModel.state.currentPositionValue == 'Custom') ...[
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
                  controller: _topTextEditingController,
                  onChanged: (value) {
                    final top = double.tryParse(value);
                    final left = double.tryParse(_leftTextEditingController.text);
                    if (top != null) {
                      widget.viewModel.updateZoomPosition(CustomZoomPosition(top: top, left: left), selectedPosition: 'Custom');
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
                  controller: _leftTextEditingController,
                  onChanged: (value) {
                    final top = double.tryParse(_topTextEditingController.text);
                    final left = double.tryParse(value);
                    if (left != null) {
                      widget.viewModel.updateZoomPosition(CustomZoomPosition(left: left, top: top), selectedPosition: 'Custom');
                    }
                  },
                ),
              ),
            ],
          ),
        ] else if (widget.viewModel.state.currentPositionValue == 'Custom Function') ...[
          const Text(
            'Custom Function Position:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              widget.viewModel.updateZoomPosition(
                CustomFunctionZoomPosition(({required bottom, required left, required right, required top}) {
                  return PositionedPoints(top: top + 50, right: right + 50);
                }),
                selectedPosition: 'Custom Function',
              );
            },
            child: const Text('Apply Custom Function'),
          ),
        ],
      ],
    );
  }

  Widget _buildBouncingChip(String label, MagnifierPositionEnum position) {
    final isSelected = widget.viewModel.state.selectedBouncePosition == label;
    return ChoiceChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 13),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          widget.viewModel.updateZoomPosition(BouncingZoomPosition(position), selectedPosition: label);
        }
      },
    );
  }

  void _updateZoomPosition(String position) {
    switch (position) {
      case 'Bouncing':
        widget.viewModel.updateZoomPosition(const BouncingZoomPosition(MagnifierPositionEnum.bouncing), selectedPosition: 'Bouncing');
        break;
      case 'Custom':
        widget.viewModel.updateZoomPosition(const CustomZoomPosition(top: 0, left: 0), selectedPosition: 'Custom');
        break;
      case 'Custom Function':
        widget.viewModel.updateZoomPosition(CustomFunctionZoomPosition(
          ({required bottom, required left, required right, required top}) {
            return PositionedPoints(top: top + 50, right: right + 50);
          },
        ), selectedPosition: 'Custom Function');
        break;
    }
  }
}
