import 'package:hive_flutter/hive_flutter.dart';
import 'package:literaturamo/constants.dart' as globs;
import 'dart:developer' as developer;

// Recognized library extensions
import 'package:literaturamo/extensions/dictionaries.dart' as dictionaries;
import 'package:literaturamo/extensions/epub.dart' as epub_ext;
import 'package:literaturamo/extensions/pdf.dart' as pdf_ext;
import 'package:literaturamo/extensions/txt.dart' as txt_ext;
import 'package:literaturamo/extensions/transcript.dart' as transcript_ext;
import 'package:literaturamo/extensions/menus.dart' as menus_ext;
import 'package:literaturamo/models/document.dart';

void log(String msg) => developer.log(msg, name: "literaturamo.lifecycle");

Future<void> startup() async {
  log("Calling start-up functions and registerers.");
  _loadExtensions();
  // if (Platform.isWindows) {
  //   _initDiscordRPC();
  // }
  await _registerAdapters();
  log("Finished calling start-up functions and registerers.");
}

void _initDiscordRPC() {
  // DiscordRPC.initialize();
  // globs.discordRPC = DiscordRPC(applicationId: "993126016476254220");
  // globs.discordRPC.start(autoRegister: true);
}

/// Loads registered extensions, this should only be called once.
void _loadExtensions() {
  log("Loading registered API extensions.");
  dictionaries.main();
  epub_ext.main();
  pdf_ext.main();
  txt_ext.main();
  transcript_ext.main();
  menus_ext.main();
  log("Finished loading registered API extensions.");
}

Future<void> _registerAdapters() async {
  log("Registering hive adapters.");
  await Hive.initFlutter();
  Hive.registerAdapter(DocumentAdapter());
  Hive.registerAdapter(DocumentTypeAdapter());
  final boxes = [];
  await Hive.openBox<Document>(globs.recentDocsBoxName);
  boxes.add(globs.recentDocsBoxName);
  await Hive.openBox(globs.settingsBoxName);
  boxes.add(globs.settingsBoxName);
  log("Finished registering hive adapters, opened boxes $boxes.");
}
