library parser;

import 'dart:core';

class StringIterator extends Iterator<String>{

  final String _string;

  int position = -1;

  StringIterator(this._string);

  @override
  String get current => _string.substring(position, position + 1);

  @override
  bool moveNext() {
    return (position += 1) < _string.length;
  }
}

class PdxDataCodec
{
  static const String _whitespace = "\t\r\n ";
  static const String _linebreak = "\r\n";

  String _content;

  PdxDataCodec(String content)
  {
    this._content = content;
  }

  static dynamic parse (String content)
  {
    var codec = new PdxDataCodec(content);

    return codec._parse();
  }

  dynamic _parse()
  {
    var res = Map();
    var iterator = new StringIterator(_content);
    var previousTokens = List();
    while(iterator.moveNext()) {
      var char = iterator.current;

      if (_whitespace.contains(char))
        continue;
      else if (char == '#')
        _escapeComment(iterator);
      else if (char == '=') {
        res[previousTokens.last] = _parseValue(iterator);
        previousTokens.clear();
      }
      else
        previousTokens.add(_parseText(iterator));
    }

    if (previousTokens.length > 0)
      return previousTokens;
    return res;
  }

  void _escapeComment(StringIterator iterator)
  {
    while (iterator.moveNext())
      if (_linebreak.contains(iterator.current))
        return;
  }

  String _parseText(StringIterator iterator)
  {
    var currentToken = iterator.current;
    while (iterator.moveNext()) {
      var char = iterator.current;

      if (_whitespace.contains(char))
        break;
      else if (char == "=")
           break;

      currentToken += char;
    }

    return currentToken;
  }

  dynamic _parseValue(StringIterator iterator)
  {
    String stringValue = null;
    while (iterator.moveNext()) {
      var char = iterator.current;

      if (stringValue == null) {
        if (_whitespace.contains(char))
          continue;
        else if (char == '"')
          stringValue = "";
        else if (char == '{')
          return _parseObject(iterator);
        else
          return _parseText(iterator);
      }
      else {
        if (char == '"') {
          stringValue += char;
          break;
        }
      }
      stringValue += char;
    }
    return stringValue;
  }

  dynamic _parseObject(StringIterator iterator)
  {
    var currentDepth = 0;
    var innerContent = "";
    while (iterator.moveNext()) {
      var char = iterator.current;

      if (char == "{")
        currentDepth++;
      if (char == "}") {
        if (currentDepth > 0)
          currentDepth--;
        else
          break;
      }

      innerContent += char;
    }
    return PdxDataCodec.parse(innerContent);
  }
}