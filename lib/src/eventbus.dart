import 'dart:async';

class EventBus {
  StreamController _controller;

  EventBus({bool sync = false}) : _controller = StreamController.broadcast(sync: sync);

  Stream<dynamic> get _stream => _controller.stream;

  Stream<_Event> get _namedEvents => _stream.where((e) => e is _Event).cast<_Event>();

  Stream<T> on<T>([String name]) {
    if (name == null) {
      if (T == dynamic) {
        return _stream;
      } else {
        return _stream.where((e) => e is T).cast<T>();
      }
    } else {
      return _namedEvents.where((e) => e.name == name).map((e) => e.data as T);
    }
  }

  StreamSubscription<T> subscribe<T>(void Function(T) callback, {String name}) {
    return on<T>(name).listen((e) => callback(e));
  }

  void publish<T>(T event, {String name}) {
    if (name == null) {
      _controller.add(event);
    } else {
      _controller.add(_Event<T>(name, event));
    }
  }

  void dispose() => _controller.close();
}

class _Event<T> {
  final String name;
  final T data;
  _Event(this.name, this.data);
}
