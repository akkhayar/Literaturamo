import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/models/text_parser.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:literaturamo/models/menus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as sfpdf;
import 'package:syncfusion_flutter_core/theme.dart' as sfcore;
import 'package:pdf_text/pdf_text.dart' as pdfText;
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart'
    as cachedPdf;

void main() {
  ContributionPoints.registerFileViewer(_CachedPdfView());
  ContributionPoints.registerTextParser(_PdfTextParser());
  ContributionPoints.registerDocumentRegister(
      DocumentType.pdf.extension, _PdfFileRegister());
}

class _PdfFileRegister implements DocumentRegister {
  @override
  Future<Document> getDocument(PlatformFile file) async {
    final doc = await pdfText.PDFDoc.fromPath(file.path!);
    return Document(
        doc.info.title ?? file.name,
        DateTime.now().toIso8601String(),
        doc.pages.length,
        DocumentType.pdf,
        file.path!);
  }
}

class _SyncFusionPdfViewer extends FileViewer {
  sfpdf.PdfViewerController? _pdfViewerController;

  _SyncFusionPdfViewer()
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
      onTextSelectionChanged: (details) => Occurance.textSelectionChanged(
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
      onTextSelectionChanged: (details) => Occurance.textSelectionChanged(
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

class CustomTapGestureRecognizer extends OneSequenceGestureRecognizer {
  int? _selectedPointer;

  // Initial Position of selected pointer
  Offset? _initialPos;

  // Timestamp of first pointer (selected) update
  Duration? _first;

  // Timestamp of latest pointer (selected) update
  Duration? _last;

  // Signifies that the event is potentially a tap
  bool _isPotentiallyTap = false;

  // For future taps
  bool _isGoingToFire = false;

  late Function onTap;

  CustomTapGestureRecognizer()
      : _isGoingToFire = false,
        _isPotentiallyTap = false,
        _selectedPointer = null,
        _initialPos = null,
        _first = null,
        _last = null;

  // Reset everything for a new session
  void _resetState() {
    _isGoingToFire = false;
    _isPotentiallyTap = false;
    _selectedPointer = null;
    _initialPos = null;
    _first = null;
    _last = null;
  }

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    if (_selectedPointer == null) {
      // Select the first pointer that comes through
      _selectedPointer = event.pointer;
      _isPotentiallyTap = true;
    } else {
      // Multiple pointers on the screen which means it's not a tap
      _selectedPointer = null;
      _isPotentiallyTap = false;
    }

    // Accept all. Rejecting might lead to other gestures not working
    resolve(GestureDisposition.accepted);

    // If previous pointer was going to fire [onTap], stop it.
    // Used to prevent onTap being fired on multi-tap.
    if (_isGoingToFire) {
      _resetState();
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    // onPointerUp, see if it moved and see the duration of its
    // interaction on the screen. If it moved, it's not a tap.
    // If its duration is more than 125 milliseconds (default
    // Android tapTimeout), it's not a tap.
    if (!event.down && event.pointer == _selectedPointer) {
      _last = event.timeStamp;

      if (event.localPosition.distanceSquared ==
              (_initialPos?.distanceSquared ??
                  event.localPosition.distanceSquared) &&
          (_last!.inMilliseconds - _first!.inMilliseconds) <= 125) {
        _isGoingToFire = true;

        // Presenting a slight delay to consider multi-tap case
        Future.delayed(const Duration(milliseconds: 250), () {
          if (_isPotentiallyTap) {
            onTap();
          }
          _resetState();
        });
      } else {
        _resetState();
      }
    } else if (_initialPos == null) {
      // Get initialPos and time
      _initialPos = event.localPosition;
      _first = event.timeStamp;
    }
  }
}

class _CachedPdfView extends FileViewer {
  late int defaultPage;
  Document? doc;

  _CachedPdfView()
      : super(
          supportedDocType: DocumentType.pdf,
        ) {
    secondaryActions = [
      FileViewerAction(
        label: const Text("Copy Page Text"),
        icon: const Icon(Icons.copy_rounded),
        onCall: (context, doc) {
          if (controller != null) {
            job() async => Clipboard.setData(
                  ClipboardData(
                    text: await ContributionPoints.getTextParser(doc.type)!
                        .parse(doc, controller!.currentPage),
                  ),
                );
            job();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Copied Text!'),
              ),
            );
          }
        },
      ),
      FileViewerAction(
        label: const Text("Goto Page"),
        icon: const Icon(Icons.directions_rounded),
        onCall: (context, doc) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              alignment: Alignment.center,
              title: const Text("Page Number"),
              children: [
                TextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (text) {
                    if (controller != null) {
                      controller!.gotoPage(int.parse(text));
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "100..",
                    fillColor:
                        Theme.of(context).navigationBarTheme.backgroundColor,
                  ),
                  autocorrect: true,
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget viewDocument(BuildContext context, Document document,
      {bool invert = false, int? defaultPage, void Function()? onTap}) {
    Widget viewer;
    doc = document;
    this.defaultPage = defaultPage ?? document.lastReadPageNo ?? 0;
    debugPrint("Rendering view document at inversion $invert");
    final pdf = cachedPdf.PDF(
      onViewCreated: _onViewCreated,
      onRender: _onRender,
      onPageChanged: _onPageChanged,
      onError: _onError,
      swipeHorizontal: true,
      enableSwipe: true,
      gestureRecognizers: {
        if (onTap != null)
          Factory<CustomTapGestureRecognizer>(
            () => CustomTapGestureRecognizer()..onTap = onTap,
          )
      },
      defaultPage: this.defaultPage,
      fitPolicy: cachedPdf.FitPolicy.BOTH,
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

  void _onViewCreated(cachedPdf.PDFViewController controller) {
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
      Occurance.readNewPage(doc!.uri, page);
    }
  }

  static void _onError(dynamic err) {
    debugPrint("PDF View error $err");
  }
}

class _PdfTextParser implements TextParser {
  @override
  DocumentType supportedType = DocumentType.pdf;

  pdfText.PDFDoc? _pdfDoc;
  final Map<int, String> _textCache = {};

  Future<String> text(Document doc) async {
    _pdfDoc =
        _pdfDoc == null ? await pdfText.PDFDoc.fromPath(doc.uri) : _pdfDoc!;
    return await _pdfDoc!.text;
  }

  Future<String> pageText(Document doc, int page) async {
    if (_textCache.containsKey(page)) {
      return _textCache[page]!;
    }

    _pdfDoc =
        _pdfDoc == null ? await pdfText.PDFDoc.fromPath(doc.uri) : _pdfDoc!;
    final text = await _pdfDoc!.pageAt(page).text;
    _textCache[page] = text;

    return text;
  }

  @override
  Future<String> parse(Document doc, int startPageNo) {
    debugPrint("Parsing pdf page number $startPageNo");
    return pageText(doc, startPageNo);
  }
}
