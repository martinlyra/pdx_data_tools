const Map<Type, Function(String, Map)> factoryFunctionMap = {};

final objectFactory = PdxDataObjectFactory();

class PdxDataObjectFactory
{
  Map<Type, Function(String, Map)>
  get _factoryFunctionMap => factoryFunctionMap;

  PdxDataObjectFactory();

  T deserialize<T>(String key, Map data) => this._factoryFunctionMap[T](key, data);
}