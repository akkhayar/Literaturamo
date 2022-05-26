import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/models/text_parser.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';

void main() {
  ContributionPoints.registerFileViewer(_EpubViewer());
  ContributionPoints.registerTextParser(_EpubTextParser());
}

class _EpubViewer implements FileViewer {
  @override
  DocumentType supportedType = DocumentType.epub;

  @override
  Widget viewDocument(
    BuildContext context,
    Document doc,
    bool viewAsText,
  ) {
    return Container();
  }
}

class _EpubTextParser implements TextParser {
  @override
  DocumentType supportedType = DocumentType.epub;
}
