import 'package:test/test.dart';
import 'test_object_a.dart';
import 'test_object_b.dart';

import 'test_object_a.pdt_factory.g.dart';
import 'test_object_b.pdt_factory.g.dart';

void main () {
  test('General output test', () {
    // Dry running
    TestObjectA objA = deserializeTestObjectA("", new Map());
    TestObjectB objB = deserializeTestObjectB("", new Map());
    TestObjectC objC = deserializeTestObjectC("", new Map());
  }
  );
}