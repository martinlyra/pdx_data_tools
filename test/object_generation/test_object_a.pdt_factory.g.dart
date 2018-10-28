// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: Instance of 'PdxDataObjectFactoryGenerator'
// **************************************************************************

import 'test_object_a.dart';

TestObjectA deserializeTestObjectA(String key, Map map) {
  final inst = new TestObjectA();
  inst.stringA =
      map.containsKey('string_a') ? map['string_a'] as String : 'undefined';
  inst.stringB =
      map.containsKey('string_b') ? map['string_b'] as String : 'trait_unknown';
  inst.boolean = map.containsKey('boolean') ? map['boolean'] as bool : false;
  inst.integer = map.containsKey('integer') ? map['integer'] as int : 0;
  inst.$double = map.containsKey('double') ? map['double'] as double : null;
  inst.listA = map.containsKey('list_a') ? map['list_a'] as List<dynamic> : [];
  return inst;
}

TestObjectB deserializeTestObjectB(String key, Map map) {
  final inst = new TestObjectB();
  inst.stringA =
      map.containsKey('string_a') ? map['string_a'] as String : 'undefined';
  return inst;
}
