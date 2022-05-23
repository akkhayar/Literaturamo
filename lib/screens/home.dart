import 'package:fable/utils/constants.dart';
import 'package:fable/models/document.dart';
import 'package:fable/screens/reader.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        appTitle,
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Recent documents"),
            _recentDocumentsWidgets(),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavBar() {
    return BottomNavigationBar(
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
    );
  }

  Widget _recentDocumentsWidgets() {
    return Column(
      children: Document.docList
          .map(
            (doc) => ListTile(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReaderScreen(doc),
                  ),
                ),
              },
              title: Text(doc.title),
              leading: Icon(
                Icons.picture_as_pdf,
                color: Theme.of(context).iconTheme.color,
              ),
              subtitle: Text(
                "${doc.totalPageNum} Pages",
                style: Theme.of(context).textTheme.subtitle2,
              ),
              trailing: Text(
                doc.date,
              ),
            ),
          )
          .toList(),
    );
  }
}
