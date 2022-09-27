import 'package:file_picker/file_picker.dart';
import 'package:literaturamo/responsive.dart';
import 'package:literaturamo/screens/discover.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:literaturamo/screens/library.dart';
import 'package:literaturamo/screens/recents.dart';
import 'package:literaturamo/screens/viewer.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:literaturamo/widgets/lang_picker.dart';

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

  /// An ordered list of labelled icons for available subpages.
  static List<LabelledIcon> getSubpages(BuildContext context) => [
        LabelledIcon(
          icon: const Icon(Icons.account_balance_rounded),
          label: AppLocalizations.of(context)!.recent,
        ),
        LabelledIcon(
          icon: const Icon(Icons.import_contacts_rounded),
          label: AppLocalizations.of(context)!.library,
        ),
        LabelledIcon(
          icon: const Icon(Icons.explore_rounded),
          label: AppLocalizations.of(context)!.discover,
        ),
      ];

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
      body: SafeArea(
        child: PageView(
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
      ),
      bottomNavigationBar: Responsive.isMobile(context)
          ? BottomNavigationBar(
              currentIndex: currentPageIndex,
              type: BottomNavigationBarType.fixed,
              items: getSubpages(context)
                  .map((e) => BottomNavigationBarItem(
                        icon: e.icon,
                        label: e.label,
                      ))
                  .toList(),
              onTap: (idx) {
                currentPageIndex = idx;
                pageController.animateToPage(
                  idx,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
            )
          : null,
      floatingActionButton: _openRecentDocument(),
    );
  }

  Widget _buildAtop() {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 140,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: getSubpages(context)
                    .map(
                      (e) => TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [e.icon, Text(e.label)],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: const RecentScreen(),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        appTitle,
        style: theme.appBarTheme.titleTextStyle!.copyWith(
          color: Responsive.isDesktop(context)
              ? theme.appBarTheme.backgroundColor
              : theme.appBarTheme.foregroundColor,
        ),
      ),
      backgroundColor: Responsive.isDesktop(context)
          ? theme.iconTheme.color
          : theme.colorScheme.background,
      actions: [
        IconButton(
          icon: const Icon(Icons.note_add_rounded),
          onPressed: _openNewDocument,
        ),
        const LanguagePicker(),
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

  Future<void> _openNewDocument() async {
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
    _loadDocument(
      document,
      fromRecentDocs: preExisting != null,
    );
  }

  void _loadDocument(Document doc, {bool fromRecentDocs = false}) {
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

  /// Recall the most recently opened document.
  Widget _openRecentDocument() {
    return FloatingActionButton(
      onPressed: () {
        if (lastOpened == null) {
          final orderedBox = recentDocuments.values.toList();
          orderedBox.sort((a, b) => Document.compare(a, b));
          lastOpened = orderedBox.first;
        }
        _loadDocument(lastOpened!, fromRecentDocs: true);
      },
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Icon(
        Icons.local_library_rounded,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
