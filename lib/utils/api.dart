import 'package:fable/utils/constants.dart';
import 'package:flutter/material.dart';

class ContributionPoints {
  static final Map<String, LanguageDictionary> _langDictionaries = {};
  static final List<SelectionContextMenu> _selectionContextMenus = [];

  static registerLanguageDictionary(LanguageDictionary provider) {
    _langDictionaries.putIfAbsent(provider.language.code, () => provider);
  }

  static registerSelectionContextMenu(SelectionContextMenu provider) {
    _selectionContextMenus.add(provider);
  }
}

class LanguageDictionary {
  final Languages language;
  final Function(String) onGetMeaning;
  final Function(String) onGetSynonym;

  LanguageDictionary(
      {required this.language,
      required this.onGetMeaning,
      required this.onGetSynonym});
}

class SelectionContextMenu {
  final String label;
  final Icon icon;

  SelectionContextMenu({required this.label, required this.icon});
}
