import 'dart:convert';
import 'package:fable/models/dictionary.dart';
import 'package:fable/utils/constants.dart';
import 'package:fable/utils/api.dart';
import 'package:http/http.dart' as http;

void main() {
  ContributionPoints.registerLanguageDictionary(EnglishLanguageDictionary());
}

const api = "https://api.dictionaryapi.dev/api/";

class EnglishLanguageDictionary implements LanguageDictionary {
  @override
  Language language = Language.english;

  @override
  Future<DictionaryEntry?> getDictionaryEntry(String word) async {
    final res = await http.get(Uri.parse("${api}entries/en/"));
    if (res.statusCode != 200) {
      return null;
    }
    final resp = (jsonDecode(res.body))[0];
    return DictionaryEntry.fromJson(word, language, resp);
  }
}
