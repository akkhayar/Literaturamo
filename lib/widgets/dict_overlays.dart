import 'package:google_fonts/google_fonts.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:flutter/material.dart';

class DictionaryOverlay extends StatelessWidget {
  final DictionaryEntry entry;

  const DictionaryOverlay({Key? key, required this.entry}) : super(key: key);

  Widget _buildDefinition(WordDefinition defined) {
    return Text(
      defined.definition,
      softWrap: true,
      maxLines: 2,
      style: GoogleFonts.playfairDisplay(
        color: Colors.white,
        fontSize: 12,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _buildMeaning(WordMeaning means) {
    return Column(
      children: [
        Text(
          means.partOfSpeech,
          textAlign: TextAlign.left,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontSize: 15,
            decoration: TextDecoration.none,
          ),
        ),
        Column(
          children: means.definitions
              .getRange(0, 1)
              .map(
                (defined) => _buildDefinition(defined),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = Row(
      children: [
        Text(
          entry.query,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            entry.phonetics.isNotEmpty && entry.phonetics[0].text != null
                ? entry.phonetics[0].text!
                : "",
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 15,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
    final definition = Column(
      children: entry.meanings.map((means) => _buildMeaning(means)).toList(),
    );
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [header, definition],
      ),
    );
  }
}
