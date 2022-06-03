import 'dart:io';
import 'package:literaturamo/models/menus.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/models/text_parser.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:flutter/material.dart';

typedef TextSelectionChanged = Future<OverlayEntry?> Function(
    TextSelectionChange change);

/// A store for contributions that extend functionality into the App.
class ContributionPoints {
  static final Map<String, LanguageDictionary> _langDictionaries = {};
  static final Map<String, File> _definedWordsAssets = {};
  static final Map<String, FileViewer> _fileViewers = {};
  static final Map<String, TextParser> _textParsers = {};
  static final List<SelectionContextMenu> _selectionContextMenus = [];
  static final List<TextSelectionChanged> _textSelectionChangeListeners = [];
  static final List<OverlayEntry> _disposables = [];

  static registerLanguageDictionary(LanguageDictionary provider) =>
      _langDictionaries.putIfAbsent(provider.language.code, () => provider);

  static registerFileViewer(FileViewer provider) =>
      _fileViewers.putIfAbsent(provider.supportedDocType.code, () => provider);

  static registerTextParser(TextParser provider) =>
      _textParsers.putIfAbsent(provider.supportedType.code, () => provider);

  static registerSelectionContextMenu(SelectionContextMenu provider) =>
      _selectionContextMenus.add(provider);

  static registerDefinedWords(Language language, File asset) =>
      _definedWordsAssets.putIfAbsent(language.code, () => asset);

  static List<SelectionContextMenu> getSelectionContextMenus(
          Language language) =>
      _selectionContextMenus;

  static LanguageDictionary? getLanguageDictionary(Language language) =>
      _getUnderlying(language.code, _langDictionaries);

  static File? getDefinedWords(Language language) =>
      _getUnderlying(language.code, _definedWordsAssets);

  static TextParser? getTextParser(DocumentType type) =>
      _getUnderlying(type.code, _textParsers);

  static FileViewer getFileViewer(DocumentType type) =>
      _getUnderlying(type.code, _fileViewers);

  static void onTextSelectionChanged(TextSelectionChanged listener) =>
      _textSelectionChangeListeners.add(listener);

  static void textSelectionChanged(
      BuildContext context, TextSelectionChange change) {
    if (change.text.isEmpty || _disposables.isNotEmpty) {
      for (final element in _disposables) {
        element.remove();
      }
      _disposables.clear();
    } else {
      _insertOverlays(Overlay.of(context)!, change);
    }
  }

  static void _insertOverlays(
      OverlayState state, TextSelectionChange change) async {
    final List<OverlayEntry> tmpDisposes = [];
    for (final listener in _textSelectionChangeListeners) {
      final overlay = await listener(change);
      if (overlay != null) {
        tmpDisposes.add(overlay);
      }
    }
    state.insertAll(tmpDisposes);
    _disposables.addAll(tmpDisposes);
  }

  static dynamic _getUnderlying(String key, Map<String, dynamic> store) =>
      store.containsKey(key) ? store[key] : null;
}

class SelectionContextMenu {
  final String label;
  final Icon icon;

  SelectionContextMenu({required this.label, required this.icon});
}
