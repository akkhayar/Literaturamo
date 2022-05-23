import 'package:fable/utils/constants.dart';
import 'package:fable/utils/api.dart';

void main() {
  ContributionPoints.registerDictionaryProvider(LanguageDictionary(
      Languages.english,
      onGetMeaning: (String word) {},
      onGetSynonym: (String word) {}));
}
