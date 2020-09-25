import 'dart:async';

import 'package:eventbus/eventbus.dart';
import 'package:test/test.dart';

class EventA {
  String text;
  EventA(this.text);
}

class EventB {
  String text;
  EventB(this.text);
}

class EventWithMap {
  Map myMap;
  EventWithMap(this.myMap);
}

main() {
  group('[EventBus]', () {
    test('Fire one event', () {
      // given
      EventBus eventBus = EventBus();
      Future f = eventBus.on<EventA>().toList();

      // when
      eventBus.publish(EventA('a1'));
      eventBus.dispose();

      // then
      return f.then((events) {
        expect(events.length, 1);
      });
    });

    test('Fire two events of same type', () {
      // given
      EventBus eventBus = EventBus();
      Future f = eventBus.on<EventA>().toList();

      // when
      eventBus.publish(EventA('a1'));
      eventBus.publish(EventA('a2'));
      eventBus.dispose();

      // then
      return f.then((events) {
        expect(events.length, 2);
      });
    });

    test('Fire events of different type', () {
      // given
      EventBus eventBus = EventBus();
      Future f1 = eventBus.on<EventA>().toList();
      Future f2 = eventBus.on<EventB>().toList();

      // when
      eventBus.publish(EventA('a1'));
      eventBus.publish(EventB('b1'));
      eventBus.dispose();

      // then
      return Future.wait([
        f1.then((events) {
          expect(events.length, 1);
        }),
        f2.then((events) {
          expect(events.length, 1);
        })
      ]);
    });

    test('Fire events of different type, receive all types', () {
      // given
      EventBus eventBus = EventBus();
      Future f = eventBus.on().toList();

      // when
      eventBus.publish(EventA('a1'));
      eventBus.publish(EventB('b1'));
      eventBus.publish(EventB('b2'));
      eventBus.dispose();

      // then
      return f.then((events) {
        expect(events.length, 3);
      });
    });

    test('Fire event with a map type', () {
      // given
      EventBus eventBus = EventBus();
      Future f = eventBus.on<EventWithMap>().toList();

      // when
      eventBus.publish(EventWithMap({'a': 'test'}));
      eventBus.dispose();

      // then
      return f.then((events) {
        expect(events.length, 1);
      });
    });
  });
}
