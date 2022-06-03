import 'package:flutter/material.dart';
import 'package:literaturamo/utils/constants.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "$appTitle Library",
      ),
    );
  }
}
