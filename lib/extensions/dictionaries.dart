import 'dart:convert';
import 'package:literaturamo/models/dictionary.dart';
import 'package:literaturamo/constants.dart';
import 'package:literaturamo/api.dart';
import 'package:http/http.dart' as http;

void main() {
  ContributionPoint.registerLanguageDictionary(EnglishLanguageDictionary());
}

const api = "https://api.dictionaryapi.dev/api/v2/entries";

class EnglishLanguageDictionary implements LanguageDictionary {
  @override
  Language language = Language.english;

  @override
  Future<DictionaryEntry?> getDictionaryEntry(String word) async {
    final endpoint = Uri.parse("$api/${language.code}/$word");
    late final http.Response res;
    try {
      res = await http.get(endpoint);
    } catch (e) {
      return null;
    }
    if (res.statusCode != 200) {
      return null;
    }
    final resp = jsonDecode(res.body);
    return DictionaryEntry.fromJson(word, language, resp[0]);
  }
}
