import 'package:file_picker/file_picker.dart';
import 'package:literaturamo/extensions/pdf/cached_pdfviewer.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/api.dart';

void main() {
  ContributionPoint.registerDocumentRegister(
      DocumentType.pdf.extension, _PdfFileRegister());
  // ContributionPoint.registerFileViewer(DocumentType.pdf, SyncFusionPdfViewer());

  ContributionPoint.registerFileViewer(DocumentType.pdf, CachedPdfView());
  // ContributionPoints.registerTextParser(_PdfTextParser());
}

class _PdfFileRegister implements DocumentRegister {
  @override
  Future<Document> getDocument(PlatformFile file) async {
    return Document(
      file.name,
      "",
      DateTime.now().toIso8601String(),
      0,
      DocumentType.pdf,
      file.path!,
      uintData: file.bytes,
    );
  }
}
