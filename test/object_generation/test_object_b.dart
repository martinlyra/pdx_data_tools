import 'package:pdx_data_tools/pdx_data_tools.dart';

import 'test_object_b.pdt_factory.g.dart';

@PdxDataObject()
class TestObjectC
{
  @DataField("string_a", "undefined")
  String stringA;

  String stringB;

  @DataField("list_a", [])
  List listA;

  TestObjectC();

  factory TestObjectC.deserialize(String key, Map map)
  => deserializeTestObjectC(key, map);
}

@PdxDataObject()
class TestObjectD
{
  @DataField("redundant_object", null)
  DataA dataObjectA;

  TestObjectD();
}

class DataA { DataA(); }
