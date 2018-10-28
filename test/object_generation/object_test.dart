import 'package:test/test.dart';
import 'test_object_a.dart';
import 'test_object_b.dart';

import 'dart:io';

import 'package:pdx_data_tools/pdx_data_tools.dart';

import 'test_object_a.pdt_factory.g.dart';
import 'test_object_b.pdt_factory.g.dart';

const String fileContentA = '''
object_a = {
string_a = "STRINGA"
string_b = "stringB"
integer = 9001
boolean = yes
list_a = {
10 20 30 40
}
}''';
const String fileContentB = '''
@var = "A String Var"
object_b = {
  string_a = @var
}
''';

const String fileContentC = '''
object_c = {
  string_a = "strstr"
  list_a = { }
}
''';

void main () {
  test('General output test', () {
    var datA = PdxDataCodec.parse(fileContentA);
    var datB = PdxDataCodec.parse(fileContentB);
    var datC = PdxDataCodec.parse(fileContentC);

    TestObjectA objA = TestObjectA.deserialize('object_a', datA['object_a']);
    TestObjectB objB = TestObjectB.deserialize('object_b', datB['object_b']);
    TestObjectC objC = TestObjectC.deserialize('object_c', datC['object_c']);

    print(datA);
    print(datB);
    print(datC);

    assert(objC.listA != null);
  }
  );
}