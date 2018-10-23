import 'package:pdx_data_tools/pdx_data_tools.dart';

@PdxDataObject()
class TestObjectC
{
  @DataField("string_a", "undefined")
  String stringA;

  String stringB;

  TestObjectC();
}

@PdxDataObject()
class TestObjectD
{
  @DataField("redundant_object", null)
  DataA dataObjectA;

  TestObjectD();
}

class DataA { DataA(); }
