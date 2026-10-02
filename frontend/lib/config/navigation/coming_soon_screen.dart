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
    final palette = context.palette;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        shape: Border(bottom: BorderSide(color: palette.divider)),
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: palette.primarySoft),
                child: Icon(icon, size: 44, color: palette.primary),
              ),
              const SizedBox(height: 16),
              Text(heading, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5, color: palette.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
