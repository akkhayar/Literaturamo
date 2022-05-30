import 'package:literaturamo/models/document.dart';

abstract class TextParser {
  abstract DocumentType supportedType;

  Future<String> parse(Document doc, int startPageNo);
}
