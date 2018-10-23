import 'package:pdx_data_tools/pdx_data_tools.dart';

import 'test_object_a.pdt_factory.g.dart';

@PdxDataObject()
class TestObjectA
{
  @DataField("string_a", "undefined")
  String stringA;

  @DataField("string_b", "trait_unknown")
  String stringB;

  @DataField("integer", 0)
  int integer;

  @DataField("list_a", [])
  List listA;

  TestObjectA();
}

@PdxDataObject()
class TestObjectB
{
  @DataField("string_a", "undefined")
  String stringA;

  String stringB;

  TestObjectB();
}