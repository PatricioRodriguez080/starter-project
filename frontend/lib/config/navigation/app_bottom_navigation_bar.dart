import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_themes.dart';

enum AppSection { home, saved, profile, settings }

/// Translucent "glass" bar of the app design: Home · Saved · + · Profile · Settings.
class AppBottomNavigationBar extends StatelessWidget {
  static const double height = 64;

  final AppSection currentSection;
  final ValueChanged<AppSection> onSectionSelected;
  final VoidCallback onCreatePressed;

  const AppBottomNavigationBar({
    super.key,
    required this.currentSection,
    required this.onSectionSelected,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.navigationBar,
            border: Border(top: BorderSide(color: AppColors.primary.withValues(alpha: 0.10))),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionButton(AppSection.home, Icons.home_outlined, Icons.home_rounded, 'Home'),
                    _buildSectionButton(AppSection.saved, Icons.bookmark_border_rounded, Icons.bookmark_rounded, 'Saved articles'),
                    _CreateButton(onPressed: onCreatePressed),
                    _buildSectionButton(AppSection.profile, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
                    _buildSectionButton(AppSection.settings, Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionButton(AppSection section, IconData icon, IconData selectedIcon, String label) {
    return _SectionButton(
      icon: icon,
      selectedIcon: selectedIcon,
      label: label,
      isSelected: section == currentSection,
      onPressed: () => onSectionSelected(section),
    );
  }
}

class _SectionButton extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _SectionButton({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.icon;
    return Semantics(
      selected: isSelected,
      child: IconButton(
        onPressed: onPressed,
        tooltip: label,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? selectedIcon : icon, size: 24, color: color),
            const SizedBox(height: 3),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CreateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: 'Publish an article',
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}
