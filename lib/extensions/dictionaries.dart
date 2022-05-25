import 'dart:convert';
import 'package:fable/models/dictionary.dart';
import 'package:fable/utils/constants.dart';
import 'package:fable/utils/api.dart';
import 'package:http/http.dart' as http;

void main() {
  ContributionPoints.registerLanguageDictionary(
    LanguageDictionary(
      language: Language.english,
      getDictionaryEntry: _DictionaryEndpoint.getEntry,
    ),
  );
}

class _DictionaryEndpoint {
  static const String api = "https://api.dictionaryapi.dev/api/";

  static Future<DictionaryEntry?> getEntry(String word) async {
    final res = await http.get(Uri.parse("${api}entries/en/"));
    if (res.statusCode != 200) {
      return null;
    }
    final resp = (jsonDecode(res.body))[0];
    return DictionaryEntry.fromJson(word, resp);
  }
}
