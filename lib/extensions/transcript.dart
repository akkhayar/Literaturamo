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
    return ListView.builder(
      itemBuilder: (context, int no) {
        final data = txtParser.parse(doc, defaultPage ?? 0 + no);
        final document = doc.withData(data);
        txtViewer.load(document);
        return Container(
            color: Colors.white,
            child: txtViewer.viewDocument(context, document, invert: invert));
      },
      itemCount: doc.totalPageNum,
    );
  }
}
