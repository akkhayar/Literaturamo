import 'dart:io';
import 'package:fable/models/document.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

typedef TextSelectionChangeFunc = Function(PdfTextSelectionChangedDetails);

class PdfReader {
  Widget viewDocument(BuildContext context, Document doc, bool viewAsText,
      {required TextSelectionChangeFunc onTextSelectionChange}) {
    debugPrint("Serving a file document.. $doc");
    // if (viewAsText) {
    //   return await loadTextDoc(context, doc);
    // } else {
    return loadDoc(context, doc, onTextSelectionChange);
    // }
  }

  Future<Widget> loadTextDoc(BuildContext context, Document doc) async {
    return Text(await doc.pageText(0));
  }

  Widget loadDoc(BuildContext context, Document doc,
      TextSelectionChangeFunc onTextSelectionChange) {
    if (doc.isExternal) {
      return network(doc.uri, context, onTextSelectionChange);
    } else {
      return file(doc.uri, context, onTextSelectionChange);
    }
  }

  static void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    debugPrint("Document ${details.toString()} loaded.");
  }

  static void _onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    debugPrint("Document ${details.toString()} load failed.");
  }

  Widget network(String url, BuildContext context,
      TextSelectionChangeFunc onTextSelectionChange) {
    return SfPdfViewer.network(
      url,
      scrollDirection: PdfScrollDirection.horizontal,
      onTextSelectionChanged: onTextSelectionChange,
      onDocumentLoaded: _onDocumentLoaded,
      onDocumentLoadFailed: _onDocumentLoadFailed,
      canShowScrollHead: false,
    );
  }

  Widget file(String path, BuildContext context,
      TextSelectionChangeFunc onTextSelectionChange) {
    return SfPdfViewer.file(
      File(path),
      scrollDirection: PdfScrollDirection.horizontal,
      onTextSelectionChanged: onTextSelectionChange,
      onDocumentLoaded: _onDocumentLoaded,
      onDocumentLoadFailed: _onDocumentLoadFailed,
      canShowScrollHead: false,
    );
  }
}
