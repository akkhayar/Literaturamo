typedef StrMap = Map<String, String>;

class DictionaryEntry {
  final String query;
  final String origin;
  final List<PhoneticRecord> phonetics;
  final List<WordMeaning> meanings;

  DictionaryEntry(
      {required this.query,
      required this.phonetics,
      required this.origin,
      required this.meanings});

  factory DictionaryEntry.fromJson(String word, Map<String, dynamic> json) {
    return DictionaryEntry(
      query: word,
      phonetics: (json["phonetics"] as List<StrMap>)
          .map(
            (StrMap record) => PhoneticRecord.fromJson(record),
          )
          .toList(),
      origin: json["origin"]!,
      meanings: (json["meanings"] as List<StrMap>)
          .map(
            (StrMap record) => WordMeaning.fromJson(record),
          )
          .toList(),
    );
  }
}

class PhoneticRecord {
  final String text;
  final String? audioUrl;

  PhoneticRecord({required this.text, required this.audioUrl});

  factory PhoneticRecord.fromJson(StrMap record) {
    return PhoneticRecord(
      text: record["text"]!,
      audioUrl: record["audio"],
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

  factory WordMeaning.fromJson(StrMap record) {
    return WordMeaning(
        partOfSpeech: record["partOfSpeech"]!,
        definitions: (record["definitions"] as List<StrMap>)
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

  factory WordDefinition.fromJson(Map<String, dynamic> def) {
    return WordDefinition(
      definition: def["definition"]!,
      example: def["example"]!,
      synonyms: def["synonyms"],
      antonyms: def["antonyms"],
    );
  }
}
