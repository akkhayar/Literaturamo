import 'package:fable/screens/viewer.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';

/// Types that a document can be of.
enum DocumentType {
  pdf("pdf"),
  epub("epub"),
  txt("txt");

  final String code;
  const DocumentType(this.code);
}

/// A standalone document wrapper that signifies all permissible document
/// types that are supported.
class Document {
  String title;
  String date;
  int totalPageNum;
  DocumentType type;
  String uri;
  bool isExternal;
  String? language;
  PDFDoc? _pdfDoc;
  final Map<int, String> _textCache = {};

  Document(this.title, this.date, this.totalPageNum, this.type, this.uri,
      this.isExternal,
      {this.language});

  static List<Document> docList = [
    Document(
      "Bronze and Iron Age sites in Upper Myanmar: Chindwin, Samon and Pyu",
      "21-2-2022",
      45,
      DocumentType.pdf,
      "https://www.soas.ac.uk/sbbr/editions/file64275.pdf",
      true,
    ),
    Document(
      "Artificial Intelligence and its Role in near future",
      "21-2-2022",
      11,
      DocumentType.pdf,
      "https://arxiv.org/pdf/1804.01396.pdf",
      true,
    ),
    Document(
      "Testing 12345",
      "22-4-2022",
      10,
      DocumentType.pdf,
      "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      true,
    )
  ];

  Future<PDFDoc> _loadPdfTextDoc() async {
    if (_pdfDoc == null) {
      await PDFDoc.fromPath(uri);
    }
    return _pdfDoc!;
  }

  Future<String> pageText(int page) async {
    if (_textCache.containsKey(page)) {
      return _textCache[page]!;
    }

    String text = "";
    switch (type) {
      case DocumentType.pdf:
        {
          _pdfDoc = await _loadPdfTextDoc();
          text = await _pdfDoc!.pageAt(page).text;
        }
        break;

      case DocumentType.epub:
        {}
        break;

      case DocumentType.txt:
        {}
    }
    _textCache[page] = text;
    return text;
  }

  @override
  String toString() {
    return "<Document $type '$title' ($date) @$uri@>";
  }

  Widget listTileWidget(BuildContext context) {
    final viewer = ContributionPoints.getFileViewer(type);
    if (viewer == null) {
      return Container();
    }

    return ListTile(
      shape: Border(
        bottom: BorderSide(
          color: Theme.of(context).iconTheme.color!,
          width: 0.4,
        ),
      ),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewerScreen(this, viewer),
          ),
        ),
      },
      title: Flexible(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      leading: Icon(
        Icons.book_online_rounded,
        color: Theme.of(context).iconTheme.color,
      ),
      subtitle: Text(
        "$totalPageNum Pages",
        style: Theme.of(context).textTheme.subtitle2,
      ),
      trailing: Text(
        date,
      ),
    );
  }
}
