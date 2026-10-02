import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';

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
        Text(
          DateFormat('MMM d, y · HH:mm').format(publishedAt.toLocal()),
          style: TextStyle(fontSize: 12, color: palette.textSecondary),
        ),
      ],
    );
  }
}
