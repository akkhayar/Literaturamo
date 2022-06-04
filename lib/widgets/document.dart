import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:literaturamo/models/document.dart';

class RecentDocumentListTile extends StatelessWidget {
  final Document document;
  final void Function(Document doc) onTap;

  const RecentDocumentListTile(
      {Key? key, required this.document, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final openedAt = DateTime.parse(document.date);
    final openedSince = DateTime.now().difference(openedAt);
    final String formatStr;
    final String leading;

    if (openedSince.inDays <= 5) {
      if (openedSince.inDays <= 2) {
        leading = openedSince.inDays == 0 ? 'Today' : 'Yesterday';
      } else {
        leading = "${openedSince.inDays} days ago";
      }
      formatStr = "kk:mm";
    } else {
      leading = "";
      formatStr = "yyyy-MM-dd – kk:mm";
    }

    return Card(
      color: Theme.of(context).dialogBackgroundColor,
      child: ListTile(
        onTap: () => onTap(document),
        title: Text(
          document.title.trim(),
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        leading: Icon(
          Icons.book_online_rounded,
          color: Theme.of(context).iconTheme.color,
        ),
        subtitle: Text(
          "${document.totalPageNum} Pages",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        trailing: Text(
          "$leading ${DateFormat(formatStr).format(openedAt)}",
        ),
      ),
    );
  }
}
