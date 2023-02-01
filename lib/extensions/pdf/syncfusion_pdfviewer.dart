import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/models/menus.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as sfpdf;
import 'package:syncfusion_flutter_core/theme.dart' as sfcore;

class SyncFusionPdfViewer extends FileViewer {
  late sfpdf.PdfViewerController _pdfViewerController;

  SyncFusionPdfViewer()
      : super(
          secondaryActions: [
            FileViewerAction(
                label: const Text("Copy Page As Image"),
                icon: const Icon(Icons.file_copy_rounded),
                onCall: (c, a) {}),
            FileViewerAction(
                label: const Text("Copy Page Text"),
                icon: const Icon(Icons.copy_rounded),
                onCall: (context, document) {
                  final pageNo = document.lastReadPageNo ?? 0;
                  ContributionPoint.getTextParser(DocumentType.pdf)!
                      .parse(document, pageNo)
                      .then((text) {
                    Clipboard.setData(ClipboardData(text: text));
                    Fluttertoast.showToast(
                        msg: "Copied ${text.length} letters!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                }),
          ],
          supportedDocType: DocumentType.pdf,
        );

  @override
  Widget viewDocument(BuildContext context, Document document,
      {bool invert = false, int? defaultPage, void Function()? onTap}) {
    debugPrint("Serving a file document.. $document.");

    _pdfViewerController = sfpdf.PdfViewerController();
    // restore last read page no
    _pdfViewerController.jumpToPage(document.lastReadPageNo ?? 0);

    final Widget viewer;
    if (document.isExternal) {
      viewer = network(document, context);
    } else {
      viewer = file(document, context);
    }

    Widget themedViewer = sfcore.SfPdfViewerTheme(
      data: sfcore.SfPdfViewerThemeData(
        backgroundColor:
            invert ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
        progressBarColor: Theme.of(context).iconTheme.color,
      ),
      child: viewer,
    );
    if (invert) {
      themedViewer = InvertColors(child: themedViewer);
    }

    return themedViewer;
  }

  Widget network(Document document, BuildContext context) {
    return sfpdf.SfPdfViewer.network(
      document.uri!,
      enableDoubleTapZooming: false,
      pageLayoutMode: sfpdf.PdfPageLayoutMode.single,
      scrollDirection: sfpdf.PdfScrollDirection.horizontal,
      onPageChanged: (details) =>
          Events.pageChanged(document.canonicalName(), details.newPageNumber),
      onDocumentLoaded: _onDocumentLoaded,
      onDocumentLoadFailed: _onDocumentLoadFailed,
      onTextSelectionChanged: (details) => Events.textSelectionChanged(
        context,
        TextSelectionChange(
            text: details.selectedText ?? "",
            region: details.globalSelectedRegion),
      ),
      canShowScrollHead: false,
      controller: _pdfViewerController,
    );
  }

  Widget file(Document document, BuildContext context) {
    return sfpdf.SfPdfViewer.file(
      File(document.uri!),
      enableDoubleTapZooming: false,
      pageLayoutMode: sfpdf.PdfPageLayoutMode.single,
      scrollDirection: sfpdf.PdfScrollDirection.horizontal,
      onPageChanged: (details) =>
          Events.pageChanged(document.canonicalName(), details.newPageNumber),
      onDocumentLoaded: _onDocumentLoaded,
      onDocumentLoadFailed: _onDocumentLoadFailed,
      onTextSelectionChanged: (details) => Events.textSelectionChanged(
        context,
        TextSelectionChange(
            text: details.selectedText ?? "",
            region: details.globalSelectedRegion),
      ),
      canShowScrollHead: false,
      controller: _pdfViewerController,
    );
  }

  static void _onDocumentLoaded(sfpdf.PdfDocumentLoadedDetails details) {
    debugPrint("Document ${details.toString()} loaded.");
  }

  static void _onDocumentLoadFailed(
      sfpdf.PdfDocumentLoadFailedDetails details) {
    debugPrint("Document ${details.toString()} load failed.");
  }
}
