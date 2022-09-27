// import 'package:literaturamo/models/text_parser.dart';
// import 'package:pdf_text/pdf_text.dart' as pdf_text;

// class _PdfTextParser implements TextParser {
//   @override
//   DocumentType supportedType = DocumentType.pdf;

//   pdf_text.PDFDoc? _pdfDoc;
//   String? lastOpenedUri;
//   int? lastOpenedPage;
//   final Map<int, String> _textCache = {};

//   Future<String> text(Document doc) async {
//     _pdfDoc =
//         _pdfDoc == null ? await pdf_text.PDFDoc.fromPath(doc.uri) : _pdfDoc!;
//     return await _pdfDoc!.text;
//   }

//   Future<String> pageText(Document doc, int page) async {
//     _pdfDoc = _pdfDoc == null || lastOpenedUri != doc.uri
//         ? await pdf_text.PDFDoc.fromPath(doc.uri)
//         : _pdfDoc!;

//     lastOpenedPage = page;
//     lastOpenedUri = doc.uri;

//     final text = await _pdfDoc!.pageAt(page).text;
//     _textCache.putIfAbsent(page, () => text);
//     return text;
//   }

//   @override
//   Future<String> parse(Document doc, int page) async {
//     if (_textCache.containsKey(page)) {
//       return _textCache[page]!;
//     }
//     if (_textCache.length > 5) {
//       _textCache.remove(_textCache.keys.first);
//     }
//     pageText(doc, page + 2);
//     pageText(doc, page + 1);
//     return pageText(doc, page);
//   }
// }
