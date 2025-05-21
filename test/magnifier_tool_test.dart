import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';

void main() {
  group('MagnifierTool Widget Tests', () {
    testWidgets('renders correctly with default values', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: MagnifierTool(widget: Text('Test')))));

      expect(find.byType(MagnifierTool), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('renders correctly with custom values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MagnifierTool(
              widget: Text('Test'),
              magnifierSize: Size(150, 150),
              zoomScale: 3.0,
              borderColor: Colors.red,
              showBorder: false,
            ),
          ),
        ),
      );

      expect(find.byType(MagnifierTool), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
