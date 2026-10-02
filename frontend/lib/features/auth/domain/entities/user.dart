import 'package:equatable/equatable.dart';

/// Journalist signed in to the app.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserEntity({required this.id, required this.name, required this.email});

  /// Up to two letters for the avatar: "Jane Doe" → "JD", "Jane" → "J".
  /// Without a name, the first letter of the email is used.
  String get initials {
    final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return email.isEmpty ? '?' : email[0].toUpperCase();
    final firstWords = words.length == 1 ? words : [words.first, words.last];
    return firstWords.map((word) => word[0].toUpperCase()).join();
  }

  @override
  List<Object?> get props => [id, name, email];
}
