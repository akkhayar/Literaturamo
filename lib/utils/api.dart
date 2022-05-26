import 'package:fable/models/dictionary.dart';
import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/models/text_parser.dart';
import 'package:fable/utils/constants.dart';
import 'package:flutter/material.dart';

// Recognized library extensions
import 'package:fable/extensions/dictionaries.dart' as dicts;
import 'package:fable/extensions/epub.dart' as epub_support;
import 'package:fable/extensions/pdf.dart' as pdf_support;
import 'package:fable/extensions/txt.dart' as txt_support;

/// Loads registered extensions.
/// This should only be called once.
void loadExtensions() {
  dicts.main();
  epub_support.main();
  pdf_support.main();
  txt_support.main();
}

/// A store for contributions that extend functionality into the App.
class ContributionPoints {
  static final Map<String, LanguageDictionary> _langDictionaries = {};
  static final Map<String, FileViewer> _fileViewers = {};
  static final Map<String, TextParser> _textParsers = {};
  static final List<SelectionContextMenu> _selectionContextMenus = [];

  static registerLanguageDictionary(LanguageDictionary provider) =>
      _langDictionaries.putIfAbsent(provider.language.code, () => provider);

  static registerFileViewer(FileViewer provider) =>
      _fileViewers.putIfAbsent(provider.supportedType.code, () => provider);

  static registerTextParser(TextParser provider) =>
      _textParsers.putIfAbsent(provider.supportedType.code, () => provider);

  static registerSelectionContextMenu(SelectionContextMenu provider) =>
      _selectionContextMenus.add(provider);

  static List<SelectionContextMenu> getSelectionContextMenus(
          Language language) =>
      _selectionContextMenus;

  static LanguageDictionary? getLanguageDictionary(Language language) =>
      _getUnderlying(language.code, _langDictionaries);

  static LanguageDictionary? getTextParser(DocumentType type) =>
      _getUnderlying(type.code, _textParsers);

  static FileViewer? getFileViewer(DocumentType type) =>
      _getUnderlying(type.code, _fileViewers);

  static dynamic _getUnderlying(String key, Map<String, dynamic> store) =>
      store.containsKey(key) ? store[key] : null;
}

class SelectionContextMenu {
  final String label;
  final Icon icon;

  SelectionContextMenu({required this.label, required this.icon});
}
