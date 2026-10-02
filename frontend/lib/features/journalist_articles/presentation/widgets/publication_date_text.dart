import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';

class PublicationDateText extends StatelessWidget {
  final DateTime publishedAt;

  const PublicationDateText({super.key, required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          DateFormat('MMM d, y · HH:mm').format(publishedAt.toLocal()),
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
