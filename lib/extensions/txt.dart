import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/default.dart';
import 'package:flutter_highlight/themes/obsidian.dart';

void main() {
  ContributionPoints.registerFileViewer(_TxtViewer());
}

const text = """
import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

void main() {
  ContributionPoints.registerFileViewer(_TxtViewer());
}

class _TxtViewer implements FileViewer {
  @override
  DocumentType supportedType = DocumentType.txt;

  @override
  Widget viewDocument(
    BuildContext context,
    Document doc,
    bool viewAsText,
  ) {
    Widget viewer;
    if (doc.programmingLang != null) {
      viewer = _syntaticDocumentWidget(doc);
    } else {
      viewer = _documentWidget(doc);
    }
    debugPrint('text document loaded with');
    return Center(child: viewer);
  }

  static Widget _syntaticDocumentWidget(Document doc) {
    return HighlightView('testing', language: doc.programmingLang!);
  }

  static Widget _documentWidget(Document doc) {
    return const Text(
      'testing 123deded',
      style: TextStyle(color: Colors.white),
    );
  }
}
""";

class _TxtViewer implements FileViewer {
  @override
  DocumentType supportedType = DocumentType.txt;

  static const double verticalPad = 80;

  @override
  Widget viewDocument(BuildContext context, Document doc, bool viewAsText) {
    Widget viewer;
    if (doc.programmingLang != null) {
      viewer = _syntaticDocumentWidget(context, doc);
    } else {
      viewer = _documentWidget(context, doc);
    }
    debugPrint("text document loaded with $viewer");
    return viewer;
  }

  static Widget _syntaticDocumentWidget(BuildContext context, Document doc) {
    debugPrint("${doc.programmingLang} is the language.");
    return HighlightView(
      text,
      language: doc.programmingLang!,
      theme: obsidianTheme,
    );
  }

  static Widget _documentWidget(BuildContext context, Document doc) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          15,
          MediaQuery.of(context).padding.top + kToolbarHeight + verticalPad,
          15,
          verticalPad),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border.symmetric(
          horizontal: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
      child: const SelectableText(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
