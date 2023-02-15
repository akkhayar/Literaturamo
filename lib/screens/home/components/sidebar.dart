import 'package:flutter/material.dart';
import 'package:literaturamo/constants.dart';

class HomeScreenSidebar extends StatelessWidget {
  const HomeScreenSidebar({
    super.key,
    required this.desktopSidebarWidth,
    required this.subpages,
    required this.desktopPageChangeDuration,
    required this.animateToSubPage,
  });

  final double desktopSidebarWidth;
  final List<LabelledIcon> subpages;
  final int desktopPageChangeDuration;
  final void Function(int, int) animateToSubPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: desktopSidebarWidth,
      child: Container(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: subpages
                .map(
                  (e) => TextButton.icon(
                    onPressed: () => animateToSubPage(
                        subpages.indexOf(e), desktopPageChangeDuration),
                    icon: Icon(
                      e.iconData,
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor,
                    ),
                    label: Text(
                      e.label,
                      style: Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedLabelStyle,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
