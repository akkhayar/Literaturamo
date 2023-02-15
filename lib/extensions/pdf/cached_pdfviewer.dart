import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart'
    as cached_pdf;
import 'package:flutter/material.dart';
import 'package:literaturamo/api.dart';

class CustomTapGestureRecognizer extends OneSequenceGestureRecognizer {
  int? _selectedPointer;

  // Initial Position of selected pointer
  Offset? _initialPos;

  // Timestamp of first pointer (selected) update
  Duration? _first;

  // Timestamp of latest pointer (selected) updatek
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

class CachedPdfView extends FileViewer {
  late int defaultPage;
  Document? doc;

  CachedPdfView()
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
                    text: await ContributionPoint.getTextParser(doc.type)!
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
    final pdf = cached_pdf.PDF(
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
      fitPolicy: cached_pdf.FitPolicy.BOTH,
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

  void _onViewCreated(cached_pdf.PDFViewController controller) {
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
      Events.pageChanged(doc!, page);
    }
  }

  static void _onError(dynamic err) {
    debugPrint("PDF View error $err");
  }
}
