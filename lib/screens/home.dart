import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:literaturamo/screens/discover.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:literaturamo/screens/library.dart';
import 'package:literaturamo/screens/recents.dart';
import 'package:literaturamo/screens/viewer.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Document> recentDocuments;
  Document? lastOpened;
  late int currentPageIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentPageIndex = SettingBox.get(SettingBoxOptions.defaultPageIndex) ?? 0;
    recentDocuments = Hive.box<Document>(recentDocsBoxName);
    pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar(),
      body: PageView(
        controller: pageController,
        onPageChanged: (idx) {
          setState(() => currentPageIndex = idx);
          debugPrint("Setting default page to $idx");
          Hive.box(settingsBoxName)
              .put(SettingBoxOptions.defaultPageIndex, idx);
        },
        scrollDirection: Axis.horizontal,
        children: const [RecentScreen(), LibraryScreen(), DiscoverScreen()],
      ),
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
          icon: const Icon(Icons.note_add_rounded),
          onPressed: () async {
            final picked = await FilePicker.platform.pickFiles(
              dialogTitle: "Open a Document",
              type: FileType.custom,
              allowedExtensions: ["pdf", "txt"],
              allowMultiple: false,
            );
            if (picked == null ||
                picked.files.isEmpty ||
                picked.files[0].extension == null ||
                picked.files[0].path == null) return;
            final file = picked.files[0];

            final preExisting = recentDocuments.values
                .firstWhereOrNull((element) => element.uri == file.path!);

            final document = await ContributionPoints.getDocumentRegister(
                    picked.files[0].extension!)!
                .getDocument(picked.files[0]);
            if (preExisting != null) {
              recentDocuments.put(
                recentDocuments.values.toList().indexOf(preExisting),
                document,
              );
            }
            _openDocument(
              document,
              fromRecentDocs: preExisting != null,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          tooltip: "Settings",
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
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      onTap: (idx) {
        currentPageIndex = idx;
        pageController.animateToPage(
          idx,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_rounded),
          label: "Recent",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.import_contacts_rounded),
          label: "Library",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_rounded),
          label: "Discover",
        ),
      ],
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        Icons.local_library_rounded,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
