import 'dart:async';

class StateNotifier<T> {
  T _state;
  final _controller = StreamController<T>.broadcast();

  StateNotifier(this._state);

  T get state => _state;

  Stream<T> get stream => _controller.stream;

  void update(T newState) {
    _state = newState;
    _controller.add(_state);
  }

  void dispose() {
    _controller.close();
  }
}
