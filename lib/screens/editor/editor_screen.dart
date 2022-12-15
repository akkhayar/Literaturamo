import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:literaturamo/screens/editor/components/ribbon.dart';
import 'package:literaturamo/screens/editor/components/sideview.dart';
import 'package:literaturamo/screens/editor/components/text_field.dart';
import 'package:literaturamo/utils/constants.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  bool enableSideview = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: const [
              EditorRibbon(),
              EditorTextField(),
            ],
          ),
          if (enableSideview) const EditorSideview(),
        ],
      ),
      appBar: AppBar(
        toolbarHeight: appBarToolBarHeight, // add this line
        title: Row(children: [
          const Text(
            appTitle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              "Writer's",
              style: GoogleFonts.passionsConflict(),
            ),
          )
        ]),
      ),
    );
  }
}
