import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PublicationDateText extends StatelessWidget {
  final DateTime publishedAt;

  const PublicationDateText({super.key, required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16),
        const SizedBox(width: 4),
        Text(
          DateFormat.yMMMd().add_Hm().format(publishedAt.toLocal()),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
