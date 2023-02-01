import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:literaturamo/extensions/pdf/pdfx_pdfviewer.dart';
import 'package:literaturamo/extensions/pdf/syncfusion_pdfviewer.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/utils/api.dart';

void main() {
  ContributionPoint.registerDocumentRegister(
      DocumentType.pdf.extension, _PdfFileRegister());
  // ContributionPoint.registerFileViewer(DocumentType.pdf, SyncFusionPdfViewer());

  ContributionPoint.registerFileViewer(DocumentType.pdf, PdfxPdfView());
  // ContributionPoints.registerTextParser(_PdfTextParser());
}

class _PdfFileRegister implements DocumentRegister {
  @override
  Future<Document> getDocument(PlatformFile file) async {
    final String? docTitle;
    final String? docAuthor;
    final int docPages;

    // final doc = await pdf_text.PDFDoc.fromPath(file.path!);
    // docTitle = doc.info.title;
    // docAuthor = doc.info.author;
    // docPages = doc.pages.length;
    docTitle = "Title";
    docAuthor = "Author";
    docPages = 0;

    return Document(file.name, docAuthor, DateTime.now().toIso8601String(),
        docPages, DocumentType.pdf, kIsWeb ? null : file.path!,
        uintData: kIsWeb ? file.bytes : null);
  }
}
