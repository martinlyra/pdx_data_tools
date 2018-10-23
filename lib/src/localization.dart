import 'dart:async';

import 'package:pdx_data_tools/src/yml-parser.dart';

final localization = new Localization();

class Localization {

  final Map<String, Map<String, Object>> _localization = Map();

  bool _isLoading = true;

  Localization();

  void addLocaleFromYaml(String language, String yamlContent) {
    addLocale(language, PdxYmlCodec.parse(yamlContent));
  }

  void addLocale(String language, Map localeMap) {
    _addLocale(language, localeMap["l_${language}"]);
  }
  
  void _addLocale(String language, Map localeMap) {
    Map<String, Object> map = null;
    if (_localization.containsKey(language)) {
      var map = _localization[language];
      if (map == null)
        map = localeMap;
      else
        map.addAll(localeMap);
    } else
      map = localeMap;

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