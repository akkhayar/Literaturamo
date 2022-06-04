import 'package:hive/hive.dart';
import 'package:literaturamo/utils/constants.dart';

part 'document.g.dart';

@HiveType(typeId: docTypeHiveTypeId)
enum DocumentType {
  @HiveField(0)
  pdf("pdf"),
  @HiveField(1)
  epub("epub"),
  @HiveField(2)
  txt("txt"),

  /// A transcript is not a real document, but a cached transcribed document.
  transcript("transcript");

  factory DocumentType.from(String code) {
    final DocumentType type;
    if (code == pdf.extension) {
      type = pdf;
    } else if (code == epub.extension) {
      type = epub;
    } else {
      type = txt;
    }
    return type;
  }

  final String extension;
  const DocumentType(this.extension);
}

/// A representation model of any potentially readable document of a specified
/// [DocumentType].
@HiveType(typeId: docHiveTypeId)
class Document extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  String date;
  @HiveField(2)
  final int totalPageNum;
  @HiveField(3)
  final DocumentType type;
  @HiveField(4)
  final String uri;
  @HiveField(5)
  final String? programmingLang;
  @HiveField(6)
  int? lastReadPageNo;

  Future<String>? data;

  bool get isExternal {
    return uri.startsWith("http://") || uri.startsWith("https://");
  }

  Document(this.title, this.date, this.totalPageNum, this.type, this.uri,
      {this.programmingLang});

  Document withData(Future<String> data) {
    return Document(title, date, totalPageNum, type, uri,
        programmingLang: programmingLang)
      ..data = data;
  }

  Document withType(DocumentType type) {
    return Document(title, date, totalPageNum, type, uri,
        programmingLang: programmingLang);
  }

  @override
  String toString() {
    return "<Document $type '$title' ($date) @$uri@>";
  }

  static int compare(Document a, Document b) {
    if (a.date == b.date) {
      return 0;
    } else if (DateTime.parse(a.date)
            .difference(DateTime.parse(b.date))
            .inMicroseconds >=
        0) {
      return -1;
    } else {
      return 1;
    }
  }
}
