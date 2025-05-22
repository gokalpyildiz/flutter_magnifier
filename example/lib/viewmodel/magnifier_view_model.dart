import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_magnifier/flutter_magnifier.dart';
import 'package:flutter_magnifier_example/viewmodel/magnifier_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/state_notifier.dart';

class MagnifierViewModel {
  final _stateNotifier = StateNotifier<MagnifierState>(const MagnifierState());

  MagnifierState get state => _stateNotifier.state;
  Stream<MagnifierState> get stream => _stateNotifier.stream;

  // Permission handling
  Future<void> requestPermissions() async {
    await Permission.photos.request();
    await Permission.camera.request();
  }

  // Image handling
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        _stateNotifier.update(state.copyWith(image: File(pickedFile.path)));
      }
    } catch (e) {
      rethrow;
    }
  }

  // Position handling
  void updatePosition(String position) {
    _stateNotifier.update(state.copyWith(currentPositionValue: position));
  }

  void updateZoomPosition(ZoomPosition position,
      {required String selectedPosition}) {
    _stateNotifier.update(state.copyWith(
        currentPosition: position, selectedBouncePosition: selectedPosition));
  }

  // Zoom scale handling
  void updateZoomScale(double value) {
    _stateNotifier.update(state.copyWith(zoomScale: value));
  }

  // Magnifier size handling
  void updateMagnifierSize(double value) {
    _stateNotifier.update(state.copyWith(magnifierSize: Size(value, value)));
  }

  // Border settings handling
  void updateShowBorder(bool value) {
    _stateNotifier.update(state.copyWith(showBorder: value));
  }

  void updateBorderColor(Color color) {
    _stateNotifier.update(state.copyWith(borderColor: color));
  }

  void dispose() {
    _stateNotifier.dispose();
  }
}
