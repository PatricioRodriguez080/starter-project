import 'package:flutter/material.dart';

import '../theme/app_themes.dart';

/// Section of the app whose content will be added later (Profile, Settings).
class ComingSoonScreen extends StatelessWidget {
  final String title;
  final String heading;
  final String message;
  final IconData icon;

  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.heading,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        shape: const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primarySoft),
                child: Icon(icon, size: 44, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(heading, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
