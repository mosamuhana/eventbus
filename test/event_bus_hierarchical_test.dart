import 'dart:async';

import 'package:eventbus/eventbus.dart';
import 'package:test/test.dart';

class SuperEvent {}

class EventA extends SuperEvent {
  String text;

  EventA(this.text);
}

class EventB extends SuperEvent {
  String text;

  EventB(this.text);
}

main() {
  group('[EventBus] (hierarchical)', () {
    test('Listen on same class', () {
      // given
      EventBus eventBus = EventBus();
      Future f = eventBus.on<EventA>().toList();

      // when
      eventBus.publish(EventA('a1'));
      eventBus.publish(EventB('b1'));
      eventBus.dispose();

      // then
      return f.then((events) {
        expect(events.length, 1);
      });
    });

    test('Listen on superclass', () {
      // given
      EventBus eventBus = EventBus();
      Future f = eventBus.on<SuperEvent>().toList();

      // when
      eventBus.publish(EventA('a1'));
      eventBus.publish(EventB('b1'));
      eventBus.dispose();

      // then
      return f.then((events) {
        expect(events.length, 2);
      });
    });
  });
}
