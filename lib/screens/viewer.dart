import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:flutter/material.dart';

class ViewerScreen extends StatefulWidget {
  final Document _doc;
  final FileViewer _viewer;

  const ViewerScreen(this._doc, this._viewer, {Key? key}) : super(key: key);
  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  bool _tapped = true;
  bool _viewAsText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  AppBar? _appBar() {
    return _tapped
        ? AppBar(
            title: Text(widget._doc.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.category),
                onPressed: () => setState(() => _viewAsText = !_viewAsText),
              ),
            ],
          )
        : null;
  }

  Widget _body() {
    return GestureDetector(
      onTap: () {
        setState(() => _tapped = !_tapped);
      },
      child: widget._viewer.viewDocument(
        context,
        widget._doc,
        _viewAsText,
      ),
    );
  }

  Widget? _bottomNavBar() {
    return null;
  }
}
