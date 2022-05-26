import 'package:fable/models/document.dart';
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
  abstract DocumentType supportedType;

  Widget viewDocument(BuildContext context, Document doc, bool viewAsText);
}
