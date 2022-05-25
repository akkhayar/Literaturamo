import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';

void main() {
  ContributionPoints.registerFileViewer(EpubViewer());
}

class EpubViewer implements FileViewer {
  @override
  DocumentType supportedType = DocumentType.epub;

  EpubViewer();

  @override
  Widget viewDocument(
    BuildContext context,
    Document doc,
    bool viewAsText,
  ) {
    return Container();
  }
}
