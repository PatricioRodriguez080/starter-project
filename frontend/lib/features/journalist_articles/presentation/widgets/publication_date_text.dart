import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';

/// "Oct 2, 2026 · 09:41", in the phone's time zone.
String formatPublicationDate(DateTime date) => DateFormat('MMM d, y · HH:mm').format(date.toLocal());

class PublicationDateText extends StatelessWidget {
  final DateTime publishedAt;

  const PublicationDateText({super.key, required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Icon(Icons.schedule, size: 14, color: palette.textSecondary),
        const SizedBox(width: 4),
        // Cut with an ellipsis instead of overflowing in narrow tiles or with large text sizes.
        Flexible(
          child: Text(
            formatPublicationDate(publishedAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
          ),
        ),
      ],
    );
  }
}
