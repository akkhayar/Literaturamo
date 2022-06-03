import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/widgets/definition.dart';

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
  bool invert = true;

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
      actions.add(
        IconButton(
          tooltip: "Extract Text",
          icon: const Icon(Icons.text_fields),
          onPressed: _transcribe,
        ),
      );
    }
    return actions;
  }

  List<Widget> _secondaryActions() {
    final List<Widget> actions = [];
    if (fileViewer.secondaryActions.isNotEmpty) {
      actions.add(
        PopupMenuButton(
          tooltip: "Other Options",
          color: Theme.of(context).scaffoldBackgroundColor,
          itemBuilder: (context) {
            return [
              for (var i = 0; i < fileViewer.secondaryActions.length; i++)
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
        ),
      );
    }
    return actions;
  }

  List<Widget> _actions() {
    return [
      IconButton(
        tooltip: "Invert Color",
        icon: const Icon(Icons.brightness_high),
        onPressed: _invertColor,
      ),
      IconButton(
        tooltip: "Dictionary",
        icon: const Icon(Icons.menu_book_rounded),
        onPressed: _displayDictionary,
      ),
      ..._conditionalActions(),
      ..._secondaryActions(),
    ];
  }

  void _invertColor() {
    setState(() => invert = !invert);
  }

  final TextEditingController _controller = TextEditingController();

  void _displayDictionary() {
    // ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
    Future<DictionaryEntry?>? definition;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              alignment: Alignment.center,
              insetPadding: const EdgeInsets.fromLTRB(25, 250, 25, 250),
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 9),
                  child: Text(
                    "English Dictionary",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(17, 19, 17, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (text) {
                      setState(() {
                        definition = ContributionPoints.getLanguageDictionary(
                                Language.english)!
                            .getDictionaryEntry(text);
                      });
                      _controller.clear();
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              definition =
                                  ContributionPoints.getLanguageDictionary(
                                          Language.english)!
                                      .getDictionaryEntry(_controller.text);
                            });
                            _controller.clear();
                          },
                          icon: const Icon(Icons.search_rounded),
                        ),
                        filled: true,
                        hintText: "Word..",
                        fillColor: Theme.of(context)
                            .navigationBarTheme
                            .backgroundColor),
                    autocorrect: true,
                  ),
                ),
                if (definition != null)
                  FutureBuilder(
                    future: definition,
                    builder:
                        (context, AsyncSnapshot<DictionaryEntry?> snapshot) {
                      if (snapshot.hasData) {
                        definition = null;
                        if (snapshot.data != null) {
                          return DefinitionWidget(entry: snapshot.data!);
                        } else {
                          return const Text(
                            "Could not find",
                            textAlign: TextAlign.center,
                          );
                        }
                      } else {
                        return const Text(
                          "Searching..",
                          textAlign: TextAlign.center,
                        );
                      }
                    },
                  )
              ],
            );
          },
        );
      },
    );
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
