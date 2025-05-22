import 'package:flutter/material.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_state.dart';
import 'package:flutter_magnifier_example/widgets/border_settings_widget.dart';
import 'viewmodel/magnifier_view_model.dart';
import 'widgets/image_widget.dart';
import 'widgets/magnifier_position_widget.dart';
import 'widgets/zoom_scale_widget.dart';
import 'widgets/magnifier_size_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Magnifier Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MagnifierExample(),
    );
  }
}

class MagnifierExample extends StatefulWidget {
  const MagnifierExample({super.key});

  @override
  State<MagnifierExample> createState() => _MagnifierExampleState();
}

class _MagnifierExampleState extends State<MagnifierExample> {
  final _viewModel = MagnifierViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.requestPermissions();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Widget _buildControls() {
    return StreamBuilder<MagnifierState>(
      stream: _viewModel.stream,
      builder: (context, snapshot) {
        return ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16),
            MagnifierPositionWidget(
              viewModel: _viewModel,
            ),
            const SizedBox(height: 16),
            ZoomScaleWidget(
              viewModel: _viewModel,
            ),
            const SizedBox(height: 16),
            MagnifierSizeWidget(
              viewModel: _viewModel,
            ),
            const SizedBox(height: 16),
            BorderSettingsWidget(
              viewModel: _viewModel,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Magnifier Example'),
      ),
      body: StreamBuilder<MagnifierState>(
        stream: _viewModel.stream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? _viewModel.state;
          return Column(
            children: [
              Expanded(
                  flex: 1,
                  child: MagnifierTool(
                    widget: Center(
                      child: ImageWidget(
                        viewModel: _viewModel,
                      ),
                    ),
                    zoomPosition: state.currentPosition,
                    zoomScale: state.zoomScale,
                    showBorder: state.showBorder,
                    borderColor: state.borderColor,
                    magnifierSize: state.magnifierSize,
                  )),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildControls(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
