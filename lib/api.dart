import 'dart:io';
import 'package:literaturamo/models/menus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:literaturamo/models/document.dart';
import 'package:literaturamo/models/file_viewer.dart';
import 'package:literaturamo/models/text_parser.dart';
import 'package:literaturamo/constants.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

void log(String msg) => developer.log(msg, name: "literaturamo.api");

typedef TextSelectionChanged = Future<OverlayEntry?> Function(
    TextSelectionChange change);

/// A store for contributions that extend functionality into the App.
class ContributionPoint {
  static final Map<String, LanguageDictionary> _langDictionaries = {};
  static final Map<String, File> _definedWordsAssets = {};
  static final Map<String, FileViewer> _fileViewers = {};
  static final Map<String, TextParser> _textParsers = {};
  static final List<ContextMenu> _selectionContextMenus = [];
  static final Map<String, DocumentRegister> _documentRegisters = {};

  static registerLanguageDictionary(LanguageDictionary provider) {
    _langDictionaries.putIfAbsent(provider.language.code, () => provider);
    log("Registered ${provider.language} language dictionary provider $provider.");
  }

  static registerFileViewer(DocumentType type, FileViewer provider) {
    if (type == provider.supportedDocType) {
      _fileViewers.putIfAbsent(type.extension, () => provider);
    } else {
      throw ("${provider.supportedDocType} does not match $type to register as file viewer.");
    }
    log("Registered $type document view provider $provider.");
  }

  static registerTextParser(TextParser provider) {
    _textParsers.putIfAbsent(provider.supportedType.extension, () => provider);
    log("Registered ${provider.supportedType} text parser $provider");
  }

  static registerSelectionContextMenu(ContextMenu provider) {
    _selectionContextMenus.add(provider);
    log("Registered selection context menu $provider.");
  }

  static registerDefinedWords(Language language, File asset) {
    _definedWordsAssets.putIfAbsent(language.code, () => asset);
    log("Registered $language language defined words asset $asset.");
  }

  static registerDocumentRegister(String ext, DocumentRegister register) {
    _documentRegisters.putIfAbsent(ext, () => register);
    log("Registered $ext extension document registerer $register.");
  }

  static List<ContextMenu> getSelectionContextMenus(Language language) =>
      _selectionContextMenus;

  static LanguageDictionary? getLanguageDictionary(Language language) =>
      _getUnderlying(language.code, _langDictionaries);

  static File? getDefinedWords(Language language) =>
      _getUnderlying(language.code, _definedWordsAssets);

  static DocumentRegister? getDocumentRegister(String ext) =>
      _getUnderlying(ext, _documentRegisters);

  static TextParser? getTextParser(DocumentType type) =>
      _getUnderlying(type.extension, _textParsers);

  static FileViewer getFileViewer(DocumentType type) =>
      _getUnderlying(type.extension, _fileViewers);

  static dynamic _getUnderlying(String key, Map<String, dynamic> store) =>
      store.containsKey(key) ? store[key] : null;
}

/// A wrapper around global events that can be invoked and hooked.
class Events {
  static final List<TextSelectionChanged> _textSelectionChangeListeners = [];
  static final List<OverlayEntry> _disposables = [];
  static final List<void Function(int pageNo)> _readNewPageListeners = [];
  static final List<void Function(Document doc)> _openDocumentListeners = [];

  static void onTextSelectionChanged(TextSelectionChanged listener) =>
      _textSelectionChangeListeners.add(listener);

  static void onOpenDocument(void Function(Document doc) listener) =>
      _openDocumentListeners.add(listener);

  static void onReadNewPage(void Function(int pageNo) listener) =>
      _readNewPageListeners.add(listener);

  static void openedDocument(Document doc) =>
      _openDocumentListeners.map((element) => element(doc)).toList();

  static Future<void> pageChanged(Document document, int lastReadPageNo) async {
    document.lastReadPageNo = lastReadPageNo;
    await document.save();

    log("Event pageChanged triggered: '${document.canonicalName()}' lastReadPageNo set to $lastReadPageNo.");

    for (final listener in _readNewPageListeners) {
      listener(lastReadPageNo);
    }
  }

  static void textSelectionChanged(
      BuildContext context, TextSelectionChange change) {
    if (change.text.isEmpty || _disposables.isNotEmpty) {
      for (final element in _disposables) {
        element.remove();
      }
      _disposables.clear();
    } else {
      _insertOverlays(Overlay.of(context), change);
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
}

abstract class DocumentRegister {
  Future<Document> getDocument(PlatformFile file);
}

abstract class ContextMenu {
  final String label;
  final Icon icon;

  ContextMenu({required this.label, required this.icon});
}

class SettingBox {
  SettingBox._();

  static dynamic get(String option) => Hive.box(settingsBoxName).get(option);
  static dynamic put(String option, dynamic value) =>
      Hive.box(settingsBoxName).put(option, value);
}
