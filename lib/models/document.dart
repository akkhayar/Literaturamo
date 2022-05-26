import 'package:fable/models/file_viewer.dart';
import 'package:fable/screens/viewer.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';

enum DocumentType {
  pdf("pdf"),
  epub("epub"),
  txt("txt");

  final String code;
  const DocumentType(this.code);
}

/// A representation model of any potentially readable document of a specified
/// [DocumentType].
class Document {
  final String title;
  final String date;
  final int totalPageNum;
  final DocumentType type;
  final String uri;
  final bool isExternal;
  final String? programmingLang;
  final FileViewer? viewer;

  Document(this.title, this.date, this.totalPageNum, this.type, this.uri,
      this.isExternal,
      {this.programmingLang})
      : viewer = ContributionPoints.getFileViewer(type);

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
    ),
    Document(
      "Text Document",
      "22-4-2022",
      10,
      DocumentType.txt,
      "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      true,
    ),
    Document(
      "Python Text Document",
      "22-4-2022",
      10,
      DocumentType.txt,
      "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
      true,
      programmingLang: "dart",
    )
  ];

  @override
  String toString() {
    return "<Document $type '$title' ($date) @$uri@>";
  }

  bool isSupported() {
    return !(viewer == null);
  }

  Widget listTileWidget(BuildContext context) {
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
            builder: (context) => ViewerScreen(this, viewer!),
          ),
        ),
      },
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle1,
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
