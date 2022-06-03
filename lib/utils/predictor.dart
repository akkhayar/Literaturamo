import 'package:fuzzy/fuzzy.dart';
import 'package:literaturamo/utils/api.dart';
import 'package:literaturamo/utils/constants.dart';

Future<List<String>> findClosest(Language language) async {
  final List<String> words =
      await ContributionPoints.getDefinedWords(language)!.readAsLines();
  final fuz = Fuzzy(words);
  return fuz.list;
}
