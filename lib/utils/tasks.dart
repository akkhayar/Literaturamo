import 'package:literaturamo/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Recognized library extensions
import 'package:literaturamo/extensions/dictionaries.dart' as dictionaries;
import 'package:literaturamo/extensions/epub.dart' as epub_ext;
import 'package:literaturamo/extensions/pdf.dart' as pdf_ext;
import 'package:literaturamo/extensions/txt.dart' as txt_ext;
import 'package:literaturamo/extensions/transcript.dart' as transcript_ext;
import 'package:literaturamo/extensions/menus.dart' as menus_ext;
import 'package:literaturamo/models/document.dart';

Future<void> setup() async {
  _loadExtensions();
  await _registerAdapters();
}

/// Loads registered extensions.
/// This should only be called once.
void _loadExtensions() {
  dictionaries.main();
  epub_ext.main();
  pdf_ext.main();
  txt_ext.main();
  transcript_ext.main();
  menus_ext.main();
}

Future<void> _registerAdapters() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DocumentAdapter());
  Hive.registerAdapter(DocumentTypeAdapter());
  await Hive.openBox<Document>(recentDocsBoxName);
  await Hive.openBox(settingsBoxName);
}
