/// Types that a document can be of.
enum DocumentType {
  pdf,
  epub,
  txt,
}

/// A standalone document wrapper that signifies all permissible document
/// types that are supported.
class Document {
  String title;
  String date;
  int totalPageNum;
  DocumentType type;
  String? url;

  Document(this.title, this.date, this.totalPageNum, this.type, this.url);

  static List<Document> docList = [
    Document(
      "Bronze and Iron Age sites in Upper Myanmar: Chindwin, Samon and Pyu",
      "21-2-2022",
      45,
      DocumentType.pdf,
      "https://www.soas.ac.uk/sbbr/editions/file64275.pdf",
    ),
    Document(
      "Artificial Intelligence and its Role in near future",
      "21-2-2022",
      11,
      DocumentType.pdf,
      "https://arxiv.org/pdf/1804.01396.pdf",
    )
  ];
}
