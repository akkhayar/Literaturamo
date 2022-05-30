import 'package:invert_colors/invert_colors.dart';
import 'package:literaturamo/models/menus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:literaturamo/screens/viewer.dart';
import 'dart:io';
import 'package:syncfusion_flutter_core/theme.dart';
// class _SyncFusionPdfViewer extends FileViewer {
//   @override
//   DocumentType supportedType = DocumentType.pdf;
//   @override
//   FileViewerController? controller;
//   final PdfViewerController _pdfViewerController;

//   _SyncFusionPdfViewer() : _pdfViewerController = PdfViewerController();

//   @override
//   Widget viewDocument(BuildContext context, Document doc,
//       {bool invert = false, int defaultPage = 0}) {
//     debugPrint("Serving a file document.. $doc");
//     final Widget viewer;
//     if (doc.isExternal) {
//       viewer = network(doc.uri, context);
//     } else {
//       viewer = file(doc.uri, context);
//     }
//     Widget themedViewer = SfPdfViewerTheme(
//       data: SfPdfViewerThemeData(
//         backgroundColor:
//             invert ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
//         progressBarColor: Theme.of(context).iconTheme.color,
//       ),
//       child: viewer,
//     );
//     if (invert) {
//       themedViewer = InvertColors(child: themedViewer);
//     }
//     return themedViewer;
//   }

//   static void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
//     debugPrint("Document ${details.toString()} loaded.");
//   }

//   static void _onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
//     debugPrint("Document ${details.toString()} load failed.");
//   }

//   Widget network(String url, BuildContext context) {
//     return SfPdfViewer.network(
//       url,
//       scrollDirection: PdfScrollDirection.horizontal,
//       onDocumentLoaded: _onDocumentLoaded,
//       onDocumentLoadFailed: _onDocumentLoadFailed,
//       onTextSelectionChanged: (details) =>
//           ContributionPoints.textSelectionChanged(
//         context,
//         TextSelectionChange(
//             text: details.selectedText, region: details.globalSelectedRegion),
//       ),
//       canShowScrollHead: false,
//       controller: _pdfViewerController,
//     );
//   }

//   Widget file(String path, BuildContext context) {
//     return SfPdfViewer.file(
//       File(path),
//       scrollDirection: PdfScrollDirection.horizontal,
//       onDocumentLoaded: _onDocumentLoaded,
//       onDocumentLoadFailed: _onDocumentLoadFailed,
//       onTextSelectionChanged: (details) =>
//           ContributionPoints.textSelectionChanged(
//         context,
//         TextSelectionChange(
//             text: details.selectedText, region: details.globalSelectedRegion),
//       ),
//       canShowScrollHead: false,
//       controller: _pdfViewerController,
//     );
//   }
// }


