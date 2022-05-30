import 'dart:ui';

import 'package:literaturamo/models/menus.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:literaturamo/widgets/dict_overlays.dart';
import 'package:literaturamo/utils/constants.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:flutter/material.dart';

void main() {
  ContributionPoints.onTextSelectionChanged(_showDictionaryOverlay);
}

// Function(PdfTextSelectionChangedDetails) _getCbOnTextSelectionChanged(
//     BuildContext context) {
//   return (PdfTextSelectionChangedDetails details) {
//     if (details.selectedText == null && _overlayEntry != null) {
//       _overlayEntry!.remove();
//       _overlayEntry = null;
//       _lastSelectedText = null;
//     } else if (details.selectedText != null &&
//         _overlayEntry == null &&
//         _lastValidSelectedText != details.selectedText) {
//       _lastSelectedText = details.selectedText;
//       _lastValidSelectedText = _lastSelectedText;
//       _showContextMenu(context, details);
//     }
//   };
// }

Future<OverlayEntry?> _showDictionaryOverlay(BuildContext context,
    OverlayState overlayState, TextSelectionChange change) async {
  if (change.text.isEmpty) return null;

  debugPrint("Show dictionary called on ${change.text}");

  final dict = ContributionPoints.getLanguageDictionary(Language.english);
  if (dict == null) return null;

  final DictionaryEntry? entry;
  entry = await dict.getDictionaryEntry(change.text);
  if (entry == null) return null;
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: change.region.center.dy - 75,
      left: change.region.bottomLeft.dx,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: DictionaryOverlay(entry: entry!),
      ),
    ),
  );
  overlayState.insert(overlayEntry);
  return overlayEntry;
}
