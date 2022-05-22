import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReader {
  static Widget network(String url) {
    return SfPdfViewer.network(
      url,
      scrollDirection: PdfScrollDirection.horizontal,
    );
  }

  static Widget file(String path) {
    return SfPdfViewer.file(
      File(path),
      scrollDirection: PdfScrollDirection.horizontal,
    );
  }
}
