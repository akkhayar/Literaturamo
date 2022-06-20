import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/models/text_parser.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';

void main() {
  ContributionPoints.registerFileViewer(_TranscriptViewer());
}

/// A tarnscript viewer parses a document into text if the document type
/// has a TextParser supported, and displays the parsed text in TextViewer.
class _TranscriptViewer extends FileViewer {
  _TranscriptViewer()
      : super(
          supportedDocType: DocumentType.transcript,
        );

  final FileViewer txtViewer =
      ContributionPoints.getFileViewer(DocumentType.txt);
  late TextParser txtParser;

  @override
  void load(Document document) {
    txtParser = ContributionPoints.getTextParser(document.type)!;
  }

  @override
  Widget viewDocument(BuildContext context, Document doc,
      {bool invert = false, int? defaultPage, void Function()? onTap}) {
    debugPrint("Transcribing print as ${doc.title}");
    return PageView.builder(
      itemBuilder: (context, int no) {
        final document =
            doc.withData(txtParser.parse(doc, (defaultPage ?? 0) + no + 1));
        txtViewer.load(document);
        return Container(
            width: MediaQuery.of(context).size.width,
            color: invert ? Colors.black : Colors.white,
            padding: const EdgeInsets.fromLTRB(100, 0, 150, 50),
            child: txtViewer.viewDocument(context, document, invert: invert));
      },
      itemCount: doc.totalPageNum,
    );
  }
}
