import 'package:literaturamo/models/menus.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:literaturamo/widgets/definition.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';

void main() {
  ContributionPoints.onTextSelectionChanged(_showDictionaryOverlay);
}

Future<OverlayEntry?> _showDictionaryOverlay(TextSelectionChange change) async {
  if (change.text.isEmpty) return null;

  debugPrint("Show dictionary called on ${change.text}");

  final dict = ContributionPoints.getLanguageDictionary(Language.english);
  if (dict == null) return null;

  final DictionaryEntry? entry;
  entry = await dict.getDictionaryEntry(change.text);
  if (entry == null) return null;
  return OverlayEntry(
    builder: (context) => Positioned(
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DefinitionWidget(entry: entry!),
      ),
    ),
  );
}
