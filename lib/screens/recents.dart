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
  late Box<Document> recentDocuments;

  @override
  void initState() {
    super.initState();
    recentDocuments = Hive.box<Document>(recentDocsBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: recentDocuments.listenable(),
      builder: (context, Box<Document> box, _) {
        if (box.values.isEmpty) {
          return const Center(child: Text("No Recent Docs"));
        }
        final orderedBox = box.values.toList();
        orderedBox.sort((a, b) => Document.compare(a, b));
        return ListView.builder(
          itemCount: recentDocuments.length,
          itemBuilder: (context, listIndex) => RecentDocumentListTile(
            document: orderedBox.elementAt(listIndex),
            onTap: (doc) => _openDocument(doc),
          ),
        );
      },
    );
  }

  void _openDocument(Document doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewerScreen(document: doc),
      ),
    );
    setState(() => doc.date = DateTime.now().toIso8601String());
  }
}
