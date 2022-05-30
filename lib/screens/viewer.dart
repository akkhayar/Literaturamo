import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:literaturamo/models/text_parser.dart';
import 'package:literaturamo/utils/api.dart';

class ViewerScreen extends StatefulWidget {
  final Document document;
  final int defaultPage;
  final FileViewer? fileViewer;

  const ViewerScreen(
      {required this.document, this.defaultPage = 0, this.fileViewer, Key? key})
      : super(key: key);

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  late final FileViewer fileViewer;
  late final bool hasTxtParser;
  bool invert = false;

  @override
  void initState() {
    super.initState();
    fileViewer = widget.fileViewer ??
        ContributionPoints.getFileViewer(widget.document.type);
    fileViewer.load(widget.document);
    hasTxtParser =
        ContributionPoints.getTextParser(fileViewer.supportedDocType) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title),
        actions: _actions(),
      ),
      body: fileViewer.viewDocument(context, widget.document, invert: invert),
    );
  }

  List<Widget> _conditionalActions() {
    final List<Widget> actions = [];
    if (hasTxtParser) {
      actions.add(IconButton(
        icon: const Icon(Icons.text_fields),
        onPressed: _transcribe,
      ));
    }
    return actions;
  }

  List<Widget> _actions() {
    return [
      IconButton(
        icon: const Icon(Icons.brightness_high),
        onPressed: _invertColor,
      ),
      ..._conditionalActions(),
      PopupMenuButton(
        color: Theme.of(context).scaffoldBackgroundColor,
        itemBuilder: (context) {
          return [
            for (var i = 0; i <= fileViewer.secondaryActions.length; i++)
              PopupMenuItem<int>(
                value: i,
                child: Row(
                  children: [
                    fileViewer.secondaryActions[i].icon,
                    fileViewer.secondaryActions[i].label!,
                  ],
                ),
              )
          ];
        },
        onSelected: (int value) {
          fileViewer.secondaryActions
              .elementAt(value)
              .onCall(context, widget.document);
        },
      )
    ];
  }

  void _invertColor() {
    setState(() => invert = !invert);
  }

  void _transcribe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ViewerScreen(
            document: widget.document,
            fileViewer:
                ContributionPoints.getFileViewer(DocumentType.transcript),
            defaultPage: fileViewer.controller!
                .currentPage, // CONTROLLER MAY BE NULL SOMETIMES SO FIX THIS
          );
        },
      ),
    );
  }
}
