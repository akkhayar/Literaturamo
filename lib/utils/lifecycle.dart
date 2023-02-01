import 'package:hive_flutter/hive_flutter.dart';
import 'package:literaturamo/utils/constants.dart' as globs;

// Recognized library extensions
// SENSITIVE AREA +-+-+-+-+-+-+-+-
import 'package:literaturamo/extensions/dictionaries.dart' as dictionaries;
import 'package:literaturamo/extensions/epub.dart' as epub_ext;
import 'package:literaturamo/extensions/pdf.dart' as pdf_ext;
import 'package:literaturamo/extensions/txt.dart' as txt_ext;
import 'package:literaturamo/extensions/transcript.dart' as transcript_ext;
import 'package:literaturamo/extensions/menus.dart' as menus_ext;
import 'package:literaturamo/models/document.dart';
// SENSITIVE AREA +-+-+-+-+-+-+-+-

Future<void> startup() async {
  _loadExtensions();
  // if (Platform.isWindows) {
  //   _initDiscordRPC();
  // }
  await _registerAdapters();
}

void _initDiscordRPC() {
  // DiscordRPC.initialize();
  // globs.discordRPC = DiscordRPC(applicationId: "993126016476254220");
  // globs.discordRPC.start(autoRegister: true);
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
  await Hive.openBox<Document>(globs.recentDocsBoxName);
  await Hive.openBox(globs.settingsBoxName);
}
