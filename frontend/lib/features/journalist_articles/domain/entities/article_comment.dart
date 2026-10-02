import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/util/initials.dart';

/// Comment written by a journalist on a published article.
class ArticleCommentEntity extends Equatable {
  final String id;
  final String content;
  final String author;
  final String authorId;
  final DateTime createdAt;

  const ArticleCommentEntity({
    required this.id,
    required this.content,
    required this.author,
    required this.authorId,
    required this.createdAt,
  });

  /// Letters shown in the avatar of the comment's author.
  String get authorInitials {
    final initials = initialsOf(author);
    return initials.isEmpty ? '?' : initials;
  }

  @override
  List<Object?> get props => [id, content, author, authorId, createdAt];
}
