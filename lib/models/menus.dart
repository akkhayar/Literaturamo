import 'dart:ui';

class TextSelectionChange {
  final String text;
  final Rect region;

  TextSelectionChange({required this.text, required this.region});
}
