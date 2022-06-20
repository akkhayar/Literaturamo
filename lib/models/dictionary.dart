import 'package:literaturamo/utils/constants.dart';

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
  final String? origin;
  final Language language;
  final List<PhoneticRecord> phonetics;
  final List<WordMeaning> meanings;

  bool _isValid = true;

  DictionaryEntry(
      {required this.language,
      required this.query,
      required this.phonetics,
      this.origin,
      required this.meanings});

  static final invalid = DictionaryEntry(
      language: Language.english, query: "", phonetics: [], meanings: [])
    .._isValid = false;

  get isValid {
    return _isValid;
  }

  factory DictionaryEntry.fromJson(
      String word, Language lang, Map<String, dynamic> json) {
    return DictionaryEntry(
      language: lang,
      query: word,
      phonetics: (json["phonetics"] as List<dynamic>)
          .map(
            (phonetic) => PhoneticRecord.fromJson(phonetic),
          )
          .toList(),
      origin: json["origin"],
      meanings: (json["meanings"] as List<dynamic>)
          .map(
            (meaning) => WordMeaning.fromJson(meaning),
          )
          .toList(),
    );
  }
}

/// A phonetic sampling of a word in the International Phonetic Alphabet
/// and an optional audio URL that vocalizes it.
class PhoneticRecord {
  final String? text;
  final String? audioUrl;

  PhoneticRecord({required this.text, required this.audioUrl});

  factory PhoneticRecord.fromJson(json) {
    return PhoneticRecord(
      text: json["text"],
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

  factory WordMeaning.fromJson(json) {
    return WordMeaning(
        partOfSpeech: json["partOfSpeech"]!,
        definitions: (json["definitions"] as List<dynamic>)
            .map(
              (def) => WordDefinition.fromJson(def),
            )
            .toList());
  }
}

class WordDefinition {
  final String definition;
  final String? example;
  final List<dynamic> synonyms;
  final List<dynamic> antonyms;

  WordDefinition({
    required this.definition,
    this.example,
    required this.synonyms,
    required this.antonyms,
  });

  factory WordDefinition.fromJson(json) {
    return WordDefinition(
      definition: json["definition"]!,
      example: json["example"],
      synonyms: json["synonyms"],
      antonyms: json["antonyms"],
    );
  }
}
