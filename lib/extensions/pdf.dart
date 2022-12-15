import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:literaturamo/extensions/pdf/pdfx_pdfviewer.dart';
import 'package:literaturamo/extensions/pdf/syncfusion_pdfviewer.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:literaturamo/utils/constants.dart';
import 'dart:io';

void main() {
  ContributionPoints.registerFileViewer(
      DocumentType.pdf, SyncFusionPdfViewer());

  // ContributionPoints.registerFileViewer(DocumentType.pdf, PdfxPdfView());
  // ContributionPoints.registerTextParser(_PdfTextParser());

  ContributionPoints.registerDocumentRegister(
      DocumentType.pdf.extension, _PdfFileRegister());
  Events.onOpenDocument(_onOpenPDFDocument);
}

void _onOpenPDFDocument(Document doc) {
  // discordRPC.updatePresence(
  //   DiscordPresence(
  //     state: 'Reading "${doc.title}" by ${doc.authorName ?? "Unknown"} ',
  //     details: "Page ${doc.lastReadPageNo}/${doc.totalPageNum}",
  //     startTimeStamp: DateTime.now().millisecondsSinceEpoch,
  //     largeImageKey: "library",
  //     largeImageText: "Library Picture",
  //     smallImageKey: "reading-book",
  //     smallImageText: "Library Picture",
  //   ),
  // );
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
