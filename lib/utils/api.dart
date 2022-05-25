import 'package:fable/models/dictionary.dart';
import 'package:fable/models/document.dart';
import 'package:fable/models/file_viewer.dart';
import 'package:fable/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:fable/extensions/dictionaries.dart' as dicts;

void loadExtensions() {
  dicts.main();
}

/// An application interface
class ContributionPoints {
  static final Map<String, LanguageDictionary> _langDictionaries = {};
  static final Map<String, FileViewer> _fileViewers = {};
  static final List<SelectionContextMenu> _selectionContextMenus = [];

  static registerLanguageDictionary(LanguageDictionary provider) {
    _langDictionaries.putIfAbsent(provider.language.code, () => provider);
  }

  static registerFileViewer(FileViewer provider) {
    _fileViewers.putIfAbsent(provider.supportedType.code, () => provider);
  }

  static LanguageDictionary? getLanguageDictionary(Language language) {
    return _langDictionaries.containsKey(language)
        ? _langDictionaries[language.code]
        : null;
  }

  static FileViewer? getFileViewer(DocumentType type) {
    return _fileViewers.containsKey(type) ? _fileViewers[type.code] : null;
  }

  static registerSelectionContextMenu(SelectionContextMenu provider) {
    _selectionContextMenus.add(provider);
  }

  static LanguageDictionary? getSelectionContextMenus(Language language) {
    return _langDictionaries.containsKey(language)
        ? _langDictionaries[language.code]
        : null;
  }
}

class LanguageDictionary {
  final Language language;
  final Future<DictionaryEntry?> Function(String) getDictionaryEntry;

  LanguageDictionary({
    required this.language,
    required this.getDictionaryEntry,
  });
}

class SelectionContextMenu {
  final String label;
  final Icon icon;

  SelectionContextMenu({required this.label, required this.icon});
}
