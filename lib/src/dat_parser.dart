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
  static const String _numerals = "0123456789";
  static const String _whitespace = "\t\r\n ";
  static const String _linebreak = "\r\n";

  final bool _preserveVariables;

  Map<String, dynamic> _variables;

  String _content;

  PdxDataCodec(String content,
      [
        this._preserveVariables = false,
        this._variables = null
      ]) {
    this._content = content;

    if (this._variables == null)
      _variables = new Map();
  }

  static dynamic parse (String content,
      [
        preserveVariables = false,
        variables = null
      ])
  {
    var codec = new PdxDataCodec(content, preserveVariables, variables);

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
        var key = previousTokens.last as String;
        var value = _parseValue(iterator);

        if (key.startsWith('@')) {
          _variables[key] = value;
          if (_preserveVariables)
            res[key] = value;
        }
        else
          res[key] = value;

        previousTokens.clear();
      }
      else
        previousTokens.add(_parseText(iterator));
    }

    if (previousTokens.isNotEmpty)
      return previousTokens;
    if (res.isNotEmpty)
      return res;
    return null;
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
    while (iterator.moveNext()) {
      var char = iterator.current;

      if (_whitespace.contains(char))
        continue;

      // If any of these below is true, it is run only once in this loop
      else if (char == '"')
        return _parseStringLiteral(iterator);
      else if (_numerals.contains(char))
        return _parseNumberLiteral(iterator);
      else if (char == '{')
        return _parseObject(iterator);
      else {
        var token = _parseText(iterator);

        if (token == "yes" || token == "true")
          return true;
        else if (token == "no" || token == "false")
          return false;
        else if (token.startsWith('@') && !_preserveVariables)
          return _variables[token];
        else
          return token;
      }
    }
  }

  dynamic _parseNumberLiteral(StringIterator iterator)
  {
    var token = _parseText(iterator);

    if (token.contains('.'))
      return double.tryParse(token);
    else
      return int.tryParse(token);
  }

  //TODO: Handle escape sequences properly
  String _parseStringLiteral(StringIterator iterator)
  {
    var out = "";

    bool escapeSequence = false;
    while (iterator.moveNext()) {
      var char = iterator.current;

      if (char == '"')
        break;

      out += char;
    }
    return out;
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
    return PdxDataCodec.parse(innerContent, _preserveVariables, _variables);
  }
}