import 'package:google_fonts/google_fonts.dart';
import 'package:literaturamo/models/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:literaturamo/utils/constants.dart';

/// A floating dialog box to display dictionary related content.
class DictionaryDialog extends StatefulWidget {
  final Language language;
  final Widget onCouldNotFind;
  final Widget onSearching;
  const DictionaryDialog({
    Key? key,
    required this.language,
    required this.onSearching,
    required this.onCouldNotFind,
  }) : super(key: key);

  @override
  State<DictionaryDialog> createState() => _DictionaryDialogState();
}

class _DictionaryDialogState extends State<DictionaryDialog> {
  Future<DictionaryEntry?>? definition;
  late final LanguageDictionary dictionary;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    dictionary = ContributionPoints.getLanguageDictionary(widget.language)!;
  }

  void _setDefinition(String query) {
    if (query.length < 3 || query.contains(" ")) return;
    query = query.toLowerCase().trim();

    setState(() {
      definition = dictionary.getDictionaryEntry(query);
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        "English Dictionary",
        textAlign: TextAlign.center,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(12, 19, 12, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
          ),
          child: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: _setDefinition,
            controller: _controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () => _setDefinition(_controller.text),
                icon: const Icon(Icons.search_rounded),
              ),
              hintText: "Word..",
            ),
            autocorrect: true,
          ),
        ),
        if (definition != null)
          FutureBuilder(
            future: definition,
            builder: (context, AsyncSnapshot<DictionaryEntry?> snapshot) {
              debugPrint("Testing snapshot data ${snapshot.data}");
              if (snapshot.hasData) {
                definition = null;
                if (snapshot.data!.isValid) {
                  return DefinitionWidget(entry: snapshot.data!);
                } else {
                  return widget.onCouldNotFind;
                }
              } else {
                return widget.onSearching;
              }
            },
          )
      ],
    );
  }
}

/// A widget to display dictionary definitions.
class DefinitionWidget extends StatelessWidget {
  final DictionaryEntry entry;

  const DefinitionWidget({Key? key, required this.entry}) : super(key: key);

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
          entry.meanings.map((means) => DefintionMeaningWidget(means)).toList(),
    );
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [header, definition],
      ),
    );
  }
}

class DefintionMeaningWidget extends StatelessWidget {
  const DefintionMeaningWidget(
    this.means, {
    super.key,
  });

  final WordMeaning means;

  static Widget _buildDefinition(BuildContext context, WordDefinition defined) {
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

  @override
  Widget build(BuildContext context) {
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
}
