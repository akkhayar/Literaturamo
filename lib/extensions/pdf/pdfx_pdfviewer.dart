import 'package:flutter/foundation.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

class PdfxPdfView extends FileViewer {
  late int defaultPage;
  Document? doc;

  PdfxPdfView()
      : super(
          supportedDocType: DocumentType.pdf,
        );

  @override
  Widget viewDocument(BuildContext context, Document document,
      {bool invert = false, int? defaultPage, void Function()? onTap}) {
    this.defaultPage = defaultPage ?? 0;
    final pdfxController = pdfx.PdfController(
        document: kIsWeb
            ? pdfx.PdfDocument.openData(document.uintData!)
            : pdfx.PdfDocument.openAsset(document.uri!));

    controller = FileViewerController(
        defaultPage: defaultPage ?? 0,
        gotoPage: (int pg) => pdfxController.jumpToPage(pg));
    return pdfx.PdfView(
      controller: pdfxController,
      onPageChanged: _onPageChanged,
    );
  }

  void _onPageChanged(int? page) {
    debugPrint("Page changed to $page ");
    if (page != null) {
      controller!.currentPage = page;
      Events.pageChanged(doc!.canonicalName(), page);
    }
  }
}
