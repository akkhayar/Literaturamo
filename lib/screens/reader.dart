import 'package:fable/utils/constants.dart';
import 'package:fable/models/document.dart';
import 'package:fable/models/pdfreader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen(this._doc, {Key? key}) : super(key: key);
  final Document _doc;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool _tapped = true;
  bool _viewAsText = false;
  OverlayEntry? _overlayEntry;
  late PdfViewerController _pdfViewerController;
  late PdfReader _reader;

  @override
  void initState() {
    _reader = PdfReader();
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _appBar(context),
      body: _body(context),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  AppBar? _appBar(BuildContext context) {
    return _tapped
        ? AppBar(
            title: Text(widget._doc.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.category),
                onPressed: () => setState(() => _viewAsText = !_viewAsText),
              ),
            ],
          )
        : null;
  }

  Widget _body(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _tapped = !_tapped);
      },
      child: _reader.viewDocument(
        context,
        widget._doc,
        _viewAsText,
        onTextSelectionChange: _getCbOnTextSelectionChanged(context),
      ),
    );
  }

  Widget? _bottomNavBar(BuildContext context) {
    return _tapped
        ? BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_rounded),
                label: "Library",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_add),
                label: "Add",
              ),
            ],
          )
        : null;
    ;
  }

  Function(PdfTextSelectionChangedDetails) _getCbOnTextSelectionChanged(
      BuildContext context) {
    return (PdfTextSelectionChangedDetails details) {
      if (details.selectedText == null && _overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      } else if (details.selectedText != null && _overlayEntry == null) {
        _showContextMenu(context, details);
      }
    };
  }

  _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            debugPrint(
                'Text copied to clipboard: ${details.selectedText.toString()} and cleared ${_pdfViewerController.clearSelection().toString()}');
          },
          child: const Text('Copy', style: TextStyle(fontSize: 17)),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }
}
