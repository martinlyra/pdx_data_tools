import 'dart:async';

import 'package:pdx_data_tools/src/yml-parser.dart';

final localization = new Localization();

class Localization {

  final Map<String, Map<String, Object>> _localization = Map();

  bool _isLoading = true;

  Localization();

  void addLocalization(String language, String yamlContent)
  {
    var locale = PdxYmlCodec.parse(yamlContent)["l_${language}"];

    Map<String, Object> map = null;
    if (_localization.containsKey(language)) {
      var map = _localization[language];
      if (map == null)
        map = locale;
      else
        map.addAll(locale);
    } else
      map = locale;

    _localization[language] = map;

    _isLoading = false;
  }

  Future<bool> whenLoaded() async {
    while (_isLoading);
    return true;
  }

  String getLocalizedString(String lang, String name)
  {
    var locale = _localization["${lang}"];

    if (locale.containsKey(name)) {
      var string = locale[name] as String;
      return string.substring(string.indexOf(" "));
    }
    return name;
  }
}