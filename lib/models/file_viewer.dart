import 'package:literaturamo/models/document.dart';
import 'package:flutter/material.dart';

/// An abstract class that identifies a FileViewer.
///
/// Implemented classes of [FileViewer] can be registered into to
/// [ContributionPoints] at runtime into the associated store for
/// a specific [DocumentType] notated by the `supportedType` field
/// of the class.
///
/// ```dart
/// ContributionPoints.registerFileViewer(Viewer());
/// ```
abstract class FileViewer {
  late List<FileViewerAction> secondaryActions;
  late final DocumentType supportedDocType;
  FileViewerController? controller;

  FileViewer(
      {this.secondaryActions = const [], required this.supportedDocType});

  Widget viewDocument(BuildContext context, Document document,
      {bool invert = false, int defaultPage = 0});

  void load(Document document) {}
}

class FileViewerController {
  final int defaultPage;
  final void Function(int page) gotoPage;
  int currentPage;

  FileViewerController({required this.defaultPage, required this.gotoPage})
      : currentPage = defaultPage;
}

class FileViewerAction {
  final Icon icon;
  final Text? label;
  final Function(BuildContext context, Document doc) onCall;

  FileViewerAction({required this.icon, this.label, required this.onCall});
}
