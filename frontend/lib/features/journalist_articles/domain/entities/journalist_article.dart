import 'package:equatable/equatable.dart';

/// Article published by a journalist in the app.
class JournalistArticleEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
  final String author;
  final String thumbnailURL;
  final DateTime publishedAt;

  const JournalistArticleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.thumbnailURL,
    required this.publishedAt,
  });

  @override
  List<Object?> get props =>
      [id, title, description, content, author, thumbnailURL, publishedAt];
}
