// import 'package:fuzzy/fuzzy.dart';
import 'package:literaturamo/api.dart';
import 'package:literaturamo/constants.dart';

Future<List<String>> findClosest(Language language) async {
  final List<String> words =
      await ContributionPoint.getDefinedWords(language)!.readAsLines();
  return [];
}
