import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

void main() {
  ContributionPoints.registerFileViewer(TxtViewer());
}

class TxtViewer implements FileViewer {
  @override
  DocumentType supportedType = DocumentType.txt;

  TxtViewer();

  @override
  Widget viewDocument(
    BuildContext context,
    Document doc,
    bool viewAsText,
  ) {
    Widget viewer;
    if (doc.language != null) {
      viewer = _syntaticDocumentWidget(doc);
    } else {
      viewer = _documentWidget(doc);
    }
    return viewer;
  }

  static Widget _syntaticDocumentWidget(Document doc) {
    return HighlightView("testing", language: doc.language!);
  }

  static Widget _documentWidget(Document doc) {
    return const Text("testing 123");
  }
}
