import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

void main() {
  ContributionPoints.registerFileViewer(PdfViewer());
}

typedef TextSelectionChangeFunc = dynamic Function(dynamic);

class PdfViewer implements FileViewer {
  @override
  DocumentType supportedType = DocumentType.pdf;

  PdfViewer();

  @override
  Widget viewDocument(
    BuildContext context,
    Document doc,
    bool viewAsText,
  ) {
    Widget viewer;
    if (doc.isExternal) {
      viewer = network(doc.uri, context);
    } else {
      viewer = file(doc.uri, context);
    }
    final bg = Theme.of(context).scaffoldBackgroundColor;
    const L = 10;
    return viewer;
  }

  static void _onViewCreated(PDFViewController controller) {
    debugPrint("Create view with controller $controller");
  }

  static void _onRender(int? no) {
    debugPrint("Rendered page number $no");
  }

  static void _onPageChanged(int? fromNo, int? toNo) {
    debugPrint("Page changed from $fromNo to $toNo");
  }

  static void _onError(dynamic err) {
    debugPrint("PDF View error $err");
  }

  Widget network(String url, BuildContext context) {
    return const PDF(
      onViewCreated: _onViewCreated,
      onRender: _onRender,
      onPageChanged: _onPageChanged,
      onError: _onError,
      swipeHorizontal: true,
      enableSwipe: true,
    ).fromUrl(
      url,
      placeholder: (double progress) => Center(child: Text('$progress %')),
      errorWidget: (dynamic error) => Center(child: Text(error.toString())),
    );
  }

  dynamic file(String path, BuildContext context) {
    return null;
  }
}
