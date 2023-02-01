import 'package:literaturamo/models/menus.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:literaturamo/widgets/dictionary.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';

void main() {
  Events.onTextSelectionChanged(_showDictionaryOverlay);
}

Future<OverlayEntry?> _showDictionaryOverlay(TextSelectionChange change) async {
  final query = change.text;
  // dictionary will only work for single word selections
  if (query.isEmpty || query.contains(" ")) return null;

  debugPrint("Show dictionary called on $query");

  final dict = ContributionPoint.getLanguageDictionary(Language.english);
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
