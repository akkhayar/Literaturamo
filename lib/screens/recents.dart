import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/screens/viewer.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:collection/collection.dart';
import 'package:literaturamo/widgets/document.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({Key? key}) : super(key: key);

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: Text(
            "Recently Opened",
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: Hive.box<Document>(recentDocsBoxName).listenable(),
            builder: (context, Box<Document> box, _) {
              if (box.values.isEmpty) {
                return const Center(child: Text("No Recent Docs"));
              }
              final orderedBox = box.values.toList();
              orderedBox.sort((a, b) => Document.compare(a, b));
              return ListView.builder(
                itemCount: orderedBox.length,
                itemBuilder: (context, listIndex) => RecentDocumentListTile(
                  document: orderedBox.elementAt(listIndex),
                  onTap: (doc) => _openDocument(doc),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openDocument(Document doc) {
    debugPrint("Opening document ${doc.uri} at ${doc.lastReadPageNo}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewerScreen(
          document: doc,
          defaultPage: doc.lastReadPageNo ?? 0,
        ),
      ),
    );
    doc.date = DateTime.now().toIso8601String();
    doc.save();
  }
}
