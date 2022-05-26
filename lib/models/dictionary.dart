import 'package:fable/utils/constants.dart';

typedef StrMap = Map<String, String>;

/// An abstract class that identifies a LanguageDictionary.
///
/// Implemented classes of [LanguageDictionary] can be registered into to
/// [ContributionPoints] at runtime into the associated store for
/// a specific [Language] notated by the `language` field
/// of the class.
///
/// ```dart
/// ContributionPoints.registerLanguageDictionary(Dictionary());
/// ```
abstract class LanguageDictionary {
  abstract Language language;

  Future<DictionaryEntry?> getDictionaryEntry(String word);
}

/// A resultant dictionary entry when a word is queried for meaning.
class DictionaryEntry {
  final String query;
  final String origin;
  final Language language;
  final List<PhoneticRecord> phonetics;
  final List<WordMeaning> meanings;

  DictionaryEntry(
      {required this.language,
      required this.query,
      required this.phonetics,
      required this.origin,
      required this.meanings});

  factory DictionaryEntry.fromJson(
      String word, Language lang, Map<String, dynamic> json) {
    return DictionaryEntry(
      language: lang,
      query: word,
      phonetics: (json["phonetics"] as List<StrMap>)
          .map(
            (StrMap phonetic) => PhoneticRecord.fromJson(phonetic),
          )
          .toList(),
      origin: json["origin"]!,
      meanings: (json["meanings"] as List<StrMap>)
          .map(
            (StrMap meaning) => WordMeaning.fromJson(meaning),
          )
          .toList(),
    );
  }
}

/// A phonetic sampling of a word in the International Phonetic Alphabet
/// and an optional audio URL that vocalizes it.
class PhoneticRecord {
  final String text;
  final String? audioUrl;

  PhoneticRecord({required this.text, required this.audioUrl});

  factory PhoneticRecord.fromJson(StrMap json) {
    return PhoneticRecord(
      text: json["text"]!,
      audioUrl: json["audio"],
    );
  }
}

class WordMeaning {
  final String partOfSpeech;
  final List<WordDefinition> definitions;

  WordMeaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory WordMeaning.fromJson(StrMap json) {
    return WordMeaning(
        partOfSpeech: json["partOfSpeech"]!,
        definitions: (json["definitions"] as List<StrMap>)
            .map(
              (Map<String, dynamic> def) => WordDefinition.fromJson(def),
            )
            .toList());
  }
}

class WordDefinition {
  final String definition;
  final String example;
  final List<String> synonyms;
  final List<String> antonyms;

  WordDefinition({
    required this.definition,
    required this.example,
    required this.synonyms,
    required this.antonyms,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    return WordDefinition(
      definition: json["definition"]!,
      example: json["example"]!,
      synonyms: json["synonyms"],
      antonyms: json["antonyms"],
    );
  }
}
