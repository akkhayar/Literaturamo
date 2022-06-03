import 'dart:convert';
import 'package:literaturamo/models/dictionary.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:http/http.dart' as http;

void main() {
  ContributionPoints.registerLanguageDictionary(EnglishLanguageDictionary());
}

const api = "https://api.dictionaryapi.dev/api/v2/entries";

class EnglishLanguageDictionary implements LanguageDictionary {
  @override
  Language language = Language.english;

  @override
  Future<DictionaryEntry?> getDictionaryEntry(String word) async {
    if (word.length < 3 || word.contains(" ")) return null;
    word = word.toLowerCase().trim();
    final endpoint = Uri.parse("$api/${language.code}/$word");
    final res = await http.get(endpoint);
    if (res.statusCode != 200) {
      return null;
    }
    final resp = jsonDecode(res.body);
    return DictionaryEntry.fromJson(word, language, resp[0]);
  }
}
