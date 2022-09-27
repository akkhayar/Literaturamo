import 'dart:io';

import 'package:invert_colors/invert_colors.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/models/menus.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as sfpdf;
import 'package:syncfusion_flutter_core/theme.dart' as sfcore;
import 'package:flutter/material.dart';

class SyncFusionPdfViewer extends FileViewer {
  sfpdf.PdfViewerController? _pdfViewerController;

  SyncFusionPdfViewer()
      : super(
          secondaryActions: [
            FileViewerAction(
                label: const Text("Copy Page As Image"),
                icon: const Icon(Icons.copy_rounded),
                onCall: (c, a) {}),
            FileViewerAction(
                label: const Text("Some Other Setting"),
                icon: const Icon(Icons.settings_brightness),
                onCall: (c, a) {}),
          ],
          supportedDocType: DocumentType.pdf,
        );

  @override
  Widget viewDocument(BuildContext context, Document doc,
      {bool invert = false, int? defaultPage, void Function()? onTap}) {
    debugPrint("Serving a file document.. $doc.");
    _pdfViewerController = sfpdf.PdfViewerController();
    final Widget viewer;
    if (doc.isExternal) {
      viewer = network(doc.uri, context);
    } else {
      viewer = file(doc.uri, context);
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

  Widget network(String url, BuildContext context) {
    return sfpdf.SfPdfViewer.network(
      url,
      enableDoubleTapZooming: false,
      pageLayoutMode: sfpdf.PdfPageLayoutMode.single,
      scrollDirection: sfpdf.PdfScrollDirection.horizontal,
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

  Widget file(String path, BuildContext context) {
    // /data/user/0/com.example.Literaturamo/cache/file_picker/Fyodor Dostoyevsky Translators_ Richard Pevear & Larissa Volokhonsky - Crime and Punishment-E-BooksDirectory.com (1993).pdf
    return sfpdf.SfPdfViewer.file(
      File(path),
      enableDoubleTapZooming: false,
      pageLayoutMode: sfpdf.PdfPageLayoutMode.single,
      scrollDirection: sfpdf.PdfScrollDirection.horizontal,
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
