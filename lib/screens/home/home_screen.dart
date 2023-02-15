import 'package:file_picker/file_picker.dart';
import 'package:literaturamo/utils/responsive.dart';
import 'package:literaturamo/screens/home/views/discover.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:literaturamo/screens/home/components/sidebar.dart';
import 'package:literaturamo/screens/home/views/library.dart';
import 'package:literaturamo/screens/home/views/recents.dart';
import 'package:literaturamo/screens/viewer/viewer_screen.dart';
import 'package:literaturamo/api.dart';
import 'package:literaturamo/constants.dart';
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
  Document? lastOpened;

  late Box<Document> recentDocuments;
  late int currentPageIndex;
  late PageController pageController;

  static const desktopSidebarWidth = 230.0;
  static const mobilePageChangeDuration = 500;
  static const desktopPageChangeDuration = 1;

  @override
  void initState() {
    super.initState();
    currentPageIndex = SettingBox.get(SettingBoxOptions.defaultPageIndex) ?? 0;
    recentDocuments = Hive.box<Document>(recentDocsBoxName);
    pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final subpages = getSubpages(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: appBarToolBarHeight, // add this line
        title: const Text(
          appTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add_rounded),
            onPressed: _loadNewDocument,
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
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              HomeScreenSidebar(
                desktopSidebarWidth: desktopSidebarWidth,
                subpages: subpages,
                desktopPageChangeDuration: desktopPageChangeDuration,
                animateToSubPage: _animateToSubPage,
              ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (idx) {
                  setState(() => currentPageIndex = idx);
                  logMain("Setting homepage default page to index $idx.");
                  Hive.box(settingsBoxName)
                      .put(SettingBoxOptions.defaultPageIndex, idx);
                },
                scrollDirection: Axis.horizontal,
                children: const [RecentsView(), LibraryView(), DiscoverView()],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Responsive.isMobile(context)
          ? BottomNavigationBar(
              currentIndex: currentPageIndex,
              type: BottomNavigationBarType.fixed,
              items: getSubpages(context)
                  .map((e) => BottomNavigationBarItem(
                        icon: Icon(e.iconData),
                        label: e.label,
                      ))
                  .toList(),
              onTap: (idx) => _animateToSubPage(idx, mobilePageChangeDuration),
            )
          : null,
      floatingActionButton: !Responsive.isDesktop(context) &&
              (lastOpened != null || recentDocuments.values.toList().isNotEmpty)
          ? FloatingActionButton(
              onPressed: _openLastDocument,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.local_library_rounded,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            )
          : null,
    );
  }

  void _openLastDocument() {
    if (lastOpened == null) {
      final recentDocumentsOrdered = recentDocuments.values.toList();
      recentDocumentsOrdered.sort((a, b) => Document.compare(a, b));
      lastOpened = recentDocumentsOrdered.first;
    }
    _openDocument(lastOpened!, fromRecentDocs: true);
  }

  /// An ordered list of labelled icons for available subpages.
  static List<LabelledIcon> getSubpages(BuildContext context) => [
        LabelledIcon(
          iconData: Icons.account_balance_rounded,
          label: AppLocalizations.of(context)!.recent,
        ),
        LabelledIcon(
          iconData: Icons.import_contacts_rounded,
          label: AppLocalizations.of(context)!.library,
        ),
        LabelledIcon(
          iconData: Icons.explore_rounded,
          label: AppLocalizations.of(context)!.discover,
        ),
      ];

  void _animateToSubPage(int index, int duration) {
    currentPageIndex = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: duration),
      curve: Curves.ease,
    );
  }

  Future<void> _loadNewDocument() async {
    final picked = await FilePicker.platform.pickFiles(
      dialogTitle: "Open a Document",
      type: FileType.custom,
      allowedExtensions: ["pdf", "txt"],
      allowMultiple: false,
    );
    if (picked == null ||
        picked.files.isEmpty ||
        picked.files[0].extension == null) return;
    final file = picked.files[0];

    final preExisting = recentDocuments.values
        .firstWhereOrNull((element) => element.uri == file.path!);

    final document =
        await ContributionPoint.getDocumentRegister(picked.files[0].extension!)!
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
  }

  void _openDocument(Document doc, {bool fromRecentDocs = false}) {
    logMain("Opening new document at ${doc.uri}.");
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
}
