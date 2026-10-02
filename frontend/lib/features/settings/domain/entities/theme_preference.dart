import 'package:equatable/equatable.dart';

enum AppTheme { light, dark, system }

/// Theme chosen by the user in Settings.
class ThemePreferenceEntity extends Equatable {
  /// Until the user chooses one, the app follows the phone's theme.
  static const ThemePreferenceEntity defaultPreference = ThemePreferenceEntity(AppTheme.system);

  final AppTheme theme;

  const ThemePreferenceEntity(this.theme);

  @override
  List<Object?> get props => [theme];
}
