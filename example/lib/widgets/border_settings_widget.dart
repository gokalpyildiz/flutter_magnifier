import 'package:flutter/material.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_view_model.dart';

class BorderSettingsWidget extends StatelessWidget {
  const BorderSettingsWidget({super.key, required this.viewModel});
  final MagnifierViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Border Settings:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                title: const Text('Show Border'),
                value: viewModel.state.showBorder,
                onChanged: viewModel.updateShowBorder,
              ),
            ),
            DropdownButton<Color>(
              value: viewModel.state.borderColor,
              items: [
                Colors.black,
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.purple,
                Colors.orange,
              ].map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (color) {
                if (color != null) {
                  viewModel.updateBorderColor(color);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
