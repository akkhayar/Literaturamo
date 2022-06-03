import 'package:google_fonts/google_fonts.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:literaturamo/utils/constants.dart';

class DefinitionWidget extends StatelessWidget {
  final DictionaryEntry entry;

  const DefinitionWidget({Key? key, required this.entry}) : super(key: key);

  Widget _buildDefinition(BuildContext context, WordDefinition defined) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          defined.definition,
          softWrap: true,
          maxLines: 2,
          style: GoogleFonts.playfairDisplay(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 13,
            decoration: TextDecoration.none,
          ),
        ),
        if (defined.example != null)
          Text(
            "E.g. ${defined.example!}",
            softWrap: true,
            maxLines: 2,
            style: GoogleFonts.playfairDisplay(
              color: saturate(Theme.of(context).colorScheme.onBackground, -30),
              fontStyle: FontStyle.italic,
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          )
      ],
    );
  }

  Widget _buildMeaning(BuildContext context, WordMeaning means) {
    return Column(
      children: [
        Text(
          means.partOfSpeech,
          style: GoogleFonts.playfairDisplay(
            color: Theme.of(context).colorScheme.secondary,
            fontStyle: FontStyle.italic,
            fontSize: 15,
            decoration: TextDecoration.none,
          ),
        ),
        Column(
          children: means.definitions
              .getRange(0, 1)
              .map(
                (defined) => _buildDefinition(context, defined),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          entry.query,
          style: GoogleFonts.playfairDisplay(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        ),
        if (entry.phonetics.isNotEmpty && entry.phonetics[0].text != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              entry.phonetics[0].text!,
              style: GoogleFonts.notoSans(
                color: Theme.of(context).colorScheme.onBackground,
                fontStyle: FontStyle.italic,
                fontSize: 15,
                decoration: TextDecoration.none,
              ),
            ),
          ),
      ],
    );
    final definition = Column(
      children:
          entry.meanings.map((means) => _buildMeaning(context, means)).toList(),
    );
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [header, definition],
      ),
    );
  }
}
