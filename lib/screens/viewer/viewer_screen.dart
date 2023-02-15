import 'package:flutter/services.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:literaturamo/screens/viewer/components/bottom_drawer.dart';
import 'package:literaturamo/api.dart';
import 'package:literaturamo/constants.dart';
import 'package:literaturamo/screens/viewer/components/dictionary.dart';

class ViewerScreen extends StatefulWidget {
  final Document document;
  final int? defaultPage;
  final FileViewer? fileViewer;

  const ViewerScreen(
      {required this.document, this.defaultPage, this.fileViewer, Key? key})
      : super(key: key);

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  late final FileViewer fileViewer;
  late final bool hasTxtParser;
  late bool invert;
  bool inspect = true;
  bool drawerOpened = false;

  @override
  void initState() {
    super.initState();
    fileViewer = widget.fileViewer ??
        ContributionPoint.getFileViewer(widget.document.type);
    fileViewer.load(widget.document);
    invert =
        SettingBox.get(SettingBoxOptions.defaultFileViewerInversion) ?? false;
    hasTxtParser =
        ContributionPoint.getTextParser(fileViewer.supportedDocType) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: inspect
          ? AppBar(
              title: Text(widget.document.title),
              actions: _actions(),
            )
          : null,
      body: Stack(
        children: [
          fileViewer.viewDocument(
            context,
            widget.document,
            invert: invert,
            defaultPage: widget.defaultPage,
            onTap: () {
              setState(() {
                inspect = !inspect;
                drawerOpened = false;
              });

              if (!inspect) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
              } else {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              }
            },
          ),
          if (drawerOpened)
            const Positioned(
              left: 0,
              bottom: 0,
              child: BottomDrawer(
                  child: DictionaryDialog(
                language: Language.english,
              )),
            )
        ],
      ),
    );
  }

  List<Widget> _conditionalActions() {
    return [
      if (hasTxtParser)
        IconButton(
          tooltip: "Extract Text",
          icon: const Icon(Icons.text_fields),
          onPressed: _transcribe,
        )
    ];
  }

  List<Widget> _secondaryActions() {
    return [
      if (fileViewer.secondaryActions.isNotEmpty)
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          tooltip: "Other Options",
          color: Theme.of(context).scaffoldBackgroundColor,
          itemBuilder: (context) {
            return [
              for (var i = 0; i < fileViewer.secondaryActions.length; i++)
                PopupMenuItem<int>(
                  value: i,
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: fileViewer.secondaryActions[i].icon),
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

  _actions() {
    return [
      IconButton(
        tooltip: "Invert Color",
        icon: const Icon(Icons.brightness_high),
        onPressed: _invertColor,
      ),
      IconButton(
        tooltip: "Dictionary",
        icon: const Icon(Icons.menu_book_rounded),
        onPressed: () => setState(() {
          drawerOpened = !drawerOpened;
        }),
      ),
      ..._conditionalActions(),
      ..._secondaryActions(),
    ];
  }

  void _invertColor() {
    SettingBox.put(SettingBoxOptions.defaultFileViewerInversion, !invert);
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
                ContributionPoint.getFileViewer(DocumentType.transcript),
            defaultPage: fileViewer.controller!
                .currentPage, // CONTROLLER MAY BE NULL SOMETIMES SO FIX THIS
          );
        },
      ),
    );
  }
}
