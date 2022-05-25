import 'package:fable/models/document.dart';
import 'package:flutter/material.dart';

abstract class FileViewer {
  DocumentType supportedType;

  FileViewer(this.supportedType);

  Widget viewDocument(
    BuildContext context,
    Document doc,
    bool viewAsText,
  );
}
