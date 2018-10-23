# pdx_data_tools
A library for parsing and deserializing game data from Paradox Interactive's games, targeting games using the Clausewitz engine.

## Usage

### Installation

Add to `pubspec.yaml`
```yaml
dependencies:
  # ...
  pdx_data_tools:
    git: git://github.com/martinlyra/pdx_data_tools.git
```

Run
```pub get```
`pdx_data_tools` is now ready for use!

### Classes

* `PdxDataCodec` for parsing JSON-like `.txt` files to `String -> Object` maps
* `PdxYmlCodec` for parsing YML-formatted localisation files to `String -> Object` maps
* `Localisation` for localisation, a YML map (from `PdxYmlCodec`) must be added through `addLocale` with name of language

### Deserialization

Currently, this library supports code generation to create deserializing factory methods for data objects. Using the `@PdxDataObject` and `@DataField(<key>, <default value>)` annotations.

Example, `test_object_a.dart`:
```dart
// in 'test/object_generation/test_object_a.dart'
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
```
After running `pub run build_runner build`, it yields the generated file `test_object_a.pdt_factory.g.dart`. Whose contents include a function for deserializing a map into an instance of given data object. For this example; 
```dart
TestObjectA deserializeTestObjectA(String key, Map map) { // ...
```
Simply include the generated file; 
```dart
import "test_object_a.pdt_factory.g.dart"
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://github.com/martinlyra/pdx_data_tools/issues
