import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:literaturamo/models/menus.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/obsidian.dart';

void main() {
  ContributionPoints.registerFileViewer(DocumentType.txt, _TxtViewer());
}

/// A text viewer loads a text file at a specified destination and
/// serves data procedurally.
class _TxtViewer extends FileViewer {
  _TxtViewer()
      : super(
          supportedDocType: DocumentType.txt,
        );

  Future<String>? data;
  bool? invert;

  @override
  void load(Document document) {
    if (document.data == null) {
      data = File(document.uri).readAsString();
    } else {
      data = document.data;
    }
  }

  @override
  Widget viewDocument(BuildContext context, Document doc,
      {bool invert = false, int? defaultPage, void Function()? onTap}) {
    this.invert = invert;
    Widget Function(
            Document doc, BuildContext context, AsyncSnapshot<String> snapshot)
        builder;
    builder =
        doc.programmingLang == null ? _documentWidget : _syntaticDocumentWidget;
    return FutureBuilder(
      future: data,
      builder: (context, AsyncSnapshot<String> snapshot) =>
          builder(doc, context, snapshot),
    );
  }

  Widget _syntaticDocumentWidget(
      Document doc, BuildContext context, AsyncSnapshot<String> snapshot) {
    debugPrint("${doc.programmingLang} is the language.");
    return Container(
      margin: EdgeInsets.fromLTRB(
          15, MediaQuery.of(context).padding.top + kToolbarHeight - 15, 15, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: HighlightView(
        snapshot.data ?? "Err",
        language: doc.programmingLang!,
        theme: obsidianTheme,
      ),
    );
  }

  Widget _documentWidget(
      Document doc, BuildContext context, AsyncSnapshot<String> snapshot) {
    return Container(
      color: invert == true ? Colors.black : Colors.white,
      padding: EdgeInsets.fromLTRB(
          15, MediaQuery.of(context).padding.top + kToolbarHeight, 0, 15),
      child: SelectableText(
        snapshot.data ?? "Loading..",
        toolbarOptions: const ToolbarOptions(),
        style: GoogleFonts.notoSansGeorgian(
          color: invert == true ? Colors.white : Colors.black,
          fontSize: 20,
        ),
        onSelectionChanged: (selection, cause) => Events.textSelectionChanged(
          context,
          TextSelectionChange(
            text: snapshot.data!.substring(selection.start, selection.end),
            region: Rect.fromPoints(
              const Offset(100, 200),
              const Offset(100, 200),
            ),
          ),
        ),
      ),
    );

    // SkeletonLoader(
    //   builder: LoadingTextViewer(
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height,
    //     color: saturate(Theme.of(context).scaffoldBackgroundColor, 10),
    //     padding: EdgeInsets.fromLTRB(15,
    //         kToolbarHeight - MediaQuery.of(context).padding.top, 0, 15),
    //   ),
    //   items: 1,
    //   period: const Duration(seconds: 2),
    //   highlightColor: Colors.lightBlue,
    //   direction: SkeletonDirection.ltr,
    // )
  }
}
