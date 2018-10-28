import 'package:pdx_data_tools/pdx_data_tools.dart';

import 'test_object_a.pdt_factory.g.dart';

@PdxDataObject()
class TestObjectA
{
  @DataField("string_a", "undefined")
  String stringA;

  @DataField("string_b", "trait_unknown")
  String stringB;

  @DataField("boolean", false)
  bool boolean;

  @DataField("integer", 0)
  int integer;

  @DataField("negative", 0)
  int negative;

  @DataField("double", 0.0)
  double $double;

  @DataField("list_a", [])
  List listA;

  TestObjectA();

  factory TestObjectA.deserialize(String key, Map map)
  => deserializeTestObjectA(key, map);
}

@PdxDataObject()
class TestObjectB
{
  @DataField("string_a", "undefined")
  String stringA;

  String stringB;

  TestObjectB();

  factory TestObjectB.deserialize(String key, Map map)
  => deserializeTestObjectB(key, map);
}