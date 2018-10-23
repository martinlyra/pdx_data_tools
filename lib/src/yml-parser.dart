import 'package:pdx_data_tools/src/parser.dart';

class BidirectionalArrayIterator<E> implements BidirectionalIterator<E> {

  final Iterable _iterable;

  int position = -1;

  BidirectionalArrayIterator(this._iterable);

  @override
  E get current => _iterable.elementAt(position);

  @override
  bool moveNext() {
    return (position += 1) < _iterable.length;
  }

  @override
  bool movePrevious() {
    return  (position -= 1) > 0;
  }

}

class PdxYmlCodec
{
  static const _YML_DEPTH_COUNTING = 0;
  static const _YML_KEY_PARSING = 1;
  static const _YML_VALUE_PARSING = 2;
  static const _YML_VALUE_STRING_PARSING = 3;

  final String _content;

  PdxYmlCodec(this._content);

  static Map<String, Object> parse(String ymlContent)
  {
    var codec = new PdxYmlCodec(ymlContent);
    return codec._parse();
  }

  Map<String, Object> _parse()
  {
    var lines = _content.split("\n");

    var info = new List<Map>();
    for (var line in lines) {
      info.add(_parseLine(line));
    }

    return _buildTree(new BidirectionalArrayIterator(info), 0);
  }

  Map<String, Object> _parseLine(String line) {
    var iterator = new StringIterator(line);

    int mode = _YML_DEPTH_COUNTING;
    int lineDepth = 0;

    String key = "";
    String value = "";

    while (iterator.moveNext()) {
      var char = iterator.current;

      if (mode != _YML_VALUE_STRING_PARSING && char == "#")
        break;

      switch (mode) {
        case _YML_DEPTH_COUNTING: {
          if (char == " ")
            lineDepth++;
          else {
            mode = _YML_KEY_PARSING;
            key += char;
          }
          break;
        }
        case _YML_KEY_PARSING: {
          if (char == ":")
            mode = _YML_VALUE_PARSING;
          else
            key += char;
          break;
        }
        case _YML_VALUE_PARSING:
        case _YML_VALUE_STRING_PARSING:
        {
          if (char == '"')
            mode = _YML_VALUE_STRING_PARSING;
          else if (char == " " && value.isEmpty)
            continue;
          else
            value += char;
          break;
        }
      }
    }

    if (key.isEmpty)
      return null;

    var map = new Map<String, Object>();
    map["depth"] = lineDepth;
    map["key"] = key;
    map["value"] = value;

    return map;
  }

  Map<String, Object> _buildTree(BidirectionalIterator<Map> iterator, depth) {
    var subTree = new Map<String, Object>();

    while (iterator.moveNext()) {
      var item = iterator.current;
      if (item == null)
        continue;

      if (item['depth'] < depth) {
        iterator.movePrevious();
        break;
      }

      String key = item['key'];
      String val = item['value'];

      if (val.isEmpty)
        subTree[key] = _buildTree(iterator, depth + 1);
      else
        subTree[key] = val;
    }

    return subTree;
  }
}