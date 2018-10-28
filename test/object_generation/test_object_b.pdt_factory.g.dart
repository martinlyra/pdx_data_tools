// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: Instance of 'PdxDataObjectFactoryGenerator'
// **************************************************************************

import 'test_object_b.dart';

TestObjectC deserializeTestObjectC(String key, Map map) {
  final inst = new TestObjectC();
  inst.stringA =
      map.containsKey('string_a') ? map['string_a'] as String : 'undefined';
  return inst;
}

TestObjectD deserializeTestObjectD(String key, Map map) {
  final inst = new TestObjectD();
  inst.dataObjectA = map.containsKey('redundant_object')
      ? map['redundant_object'] as DataA
      : null;
  return inst;
}
