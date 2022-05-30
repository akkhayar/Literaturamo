import 'package:file_picker/file_picker.dart';
import 'package:literaturamo/screens/viewer.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:literaturamo/widgets/document.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Document> recentDocuments;
  Document? lastOpened;

  @override
  void initState() {
    super.initState();
    recentDocuments = Hive.box<Document>(recentDocsBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar(),
      body: _recentDocuments(),
      bottomNavigationBar: _bottomNavBar(),
      floatingActionButton: _openRecentDocument(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        appTitle,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.restore_from_trash),
          onPressed: () => recentDocuments.clear(),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final picked = await FilePicker.platform.pickFiles(
              dialogTitle: "Open a Document",
              type: FileType.custom,
              allowedExtensions: ["pdf", "txt"],
            );
            if (picked == null ||
                picked.files.isEmpty ||
                picked.files[0].extension == null ||
                picked.files[0].path == null) return;
            final file = picked.files[0];
            final preExisting = recentDocuments.values
                .firstWhereOrNull((element) => element.uri == file.path!);
            _openDocument(
              preExisting ??
                  Document(file.name, DateTime.now().toIso8601String(), 23,
                      DocumentType.from(file.extension!), file.path!),
              fromRecentDocs: preExisting != null,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingScreen(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _recentDocuments() {
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
            onTap: (doc) => _openDocument(doc, fromRecentDocs: true),
          ),
        );
      },
    );
  }

  void _openDocument(Document doc, {bool fromRecentDocs = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewerScreen(document: doc),
      ),
    );
    if (fromRecentDocs == false &&
        recentDocuments.values
                .firstWhereOrNull((element) => element.uri == doc.uri) ==
            null) {
      recentDocuments.add(doc);
    } else {
      setState(() {
        doc.date = DateTime.now().toIso8601String();
        lastOpened = doc;
      });
    }
  }

  Widget _bottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).iconTheme.color!,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (idx) => 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_rounded),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed_rounded),
            label: "Feed",
          ),
        ],
      ),
    );
  }

  /// Recall the most recently opened document.
  Widget _openRecentDocument() {
    return FloatingActionButton(
      onPressed: () {
        if (lastOpened == null) {
          final orderedBox = recentDocuments.values.toList();
          orderedBox.sort((a, b) => Document.compare(a, b));
          lastOpened = orderedBox.first;
        }
        _openDocument(lastOpened!, fromRecentDocs: true);
      },
      backgroundColor: Theme.of(context).iconTheme.color,
      child: const Icon(
        Icons.collections_bookmark_rounded,
      ),
    );
  }
}
