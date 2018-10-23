import 'package:pdx_data_tools/src/object-fectory.dart';
import 'package:test/test.dart';
import 'test_object_a.dart';
import 'test_object_b.dart';

//Function newDataObj = factoryFunctionMap[DataObj] = DataObj.newDataObj;

void main () {
  test('General output test', () {
    var objA = new TestObjectA();
    var objC = new TestObjectC();
  }
  );
  test('Object factory test', () {
    print(factoryFunctionMap);
  });
}