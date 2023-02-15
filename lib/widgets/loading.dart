import 'package:flutter/material.dart';
import 'package:literaturamo/extensions/transcript.dart';
import 'package:literaturamo/constants.dart';

class Silhouette extends StatelessWidget {
  final double? height, width;

  const Silhouette({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: saturate(Theme.of(context).textTheme.titleMedium!.color!, -10),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
}

class LoadingTextLine extends StatelessWidget {
  const LoadingTextLine({
    Key? key,
    required this.height,
    required this.width,
    this.wordSpacing = 0.5,
    this.words = 1,
  }) : super(key: key);
  final double height, width, wordSpacing;
  final int words;

  @override
  Widget build(BuildContext context) {
    final List<Widget> snippets = [
      for (var i = 1; i <= words; i++)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: wordSpacing),
          child: Silhouette(height: height, width: width),
        )
    ];
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(children: snippets),
    );
  }
}

class LoadingTextViewer extends StatelessWidget {
  const LoadingTextViewer(
      {Key? key,
      required this.height,
      required this.width,
      required this.color,
      required this.padding})
      : super(key: key);

  final double height, width;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topRight,
        width: width,
        height: height,
        color: color,
        padding: padding,
        child: Column(
          children: const [
            LoadingTextLine(height: 10, width: 10),
            LoadingTextLine(height: 10, width: 50, words: 4),
            LoadingTextLine(height: 10, width: 50, words: 4),
            LoadingTextLine(height: 10, width: 50, words: 4),
          ],
        ));
  }
}
