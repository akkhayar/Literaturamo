import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/models/text_parser.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

void main() {
  ContributionPoints.registerFileViewer(_CachedPdfView());
  ContributionPoints.registerTextParser(_PdfTextParser());
}

typedef TextSelectionChangeFunc = dynamic Function(dynamic);

class _CachedPdfView extends FileViewer {
  late int defaultPage;
  _CachedPdfView()
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
  Widget viewDocument(BuildContext context, Document document,
      {bool invert = false, int defaultPage = 0}) {
    Widget viewer;
    this.defaultPage = defaultPage;
    final pdf = PDF(
      onViewCreated: _onViewCreated,
      onRender: _onRender,
      onPageChanged: _onPageChanged,
      onError: _onError,
      swipeHorizontal: true,
      enableSwipe: true,
      fitPolicy: FitPolicy.BOTH,
      nightMode: invert,
    );

    if (document.isExternal) {
      viewer = pdf.fromUrl(
        document.uri,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      );
    } else {
      viewer = pdf.fromPath(document.uri);
    }
    return viewer;
  }

  void _onViewCreated(PDFViewController controller) {
    debugPrint("Create view with controller $controller");
    this.controller = FileViewerController(
      defaultPage: defaultPage,
      gotoPage: (page) => controller.setPage(page),
    );
  }

  static void _onRender(int? no) {
    debugPrint("Rendered page number $no");
  }

  void _onPageChanged(int? page, int? total) {
    debugPrint("Page changed to $page ");
    if (page != null) {
      controller!.currentPage = page;
    }
  }

  static void _onError(dynamic err) {
    debugPrint("PDF View error $err");
  }
}

class _PdfTextParser implements TextParser {
  @override
  DocumentType supportedType = DocumentType.pdf;

  PDFDoc? _pdfDoc;
  final Map<int, String> _textCache = {};

  Future<String> text(Document doc) async {
    _pdfDoc = _pdfDoc == null ? await PDFDoc.fromPath(doc.uri) : _pdfDoc!;
    return await _pdfDoc!.text;
  }

  Future<String> pageText(Document doc, int page) async {
    if (_textCache.containsKey(page)) {
      return _textCache[page]!;
    }

    _pdfDoc = _pdfDoc == null ? await PDFDoc.fromPath(doc.uri) : _pdfDoc!;
    final text = await _pdfDoc!.pageAt(page).text;
    _textCache[page] = text;

    // Forward parsing
    for (int i = page; i < _pdfDoc!.pages.length && i < page + 3; i++) {
      parse(doc, i);
    }

    return text;
  }

  @override
  Future<String> parse(Document doc, int startPageNo) {
    debugPrint("Parsing pdf page number $startPageNo");
    return pageText(doc, startPageNo);
  }
}
