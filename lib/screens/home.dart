import 'package:fable/constants.dart';
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
      appBar: AppBar(
        title: const Text(
          appTitle,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: _scaffoldBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (idx) => 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
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

  Widget _scaffoldBody() {
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
