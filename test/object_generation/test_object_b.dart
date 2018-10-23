import 'package:pdx_data_tools/pdx_data_tools.dart';

@PdxDataObject()
class TestObjectC
{
  @DataField("string_a", "undefined")
  String stringA;

  String stringB;

  TestObjectC();
}