import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_draft.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';

/// Article as it is stored in the Firestore collection `articles` (backend/docs/DB_SCHEMA.md).
class JournalistArticleModel extends JournalistArticleEntity {
  const JournalistArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.author,
    required super.thumbnailURL,
    required super.publishedAt,
  });

  /// [rawData] holds the document fields with `publishedAt` already converted to a [DateTime].
  factory JournalistArticleModel.fromRawData(String id, Map<String, dynamic> rawData) {
    return JournalistArticleModel(
      id: id,
      title: rawData['title'] as String,
      description: rawData['description'] as String,
      content: rawData['content'] as String,
      author: rawData['author'] as String,
      thumbnailURL: rawData['thumbnailURL'] as String,
      publishedAt: rawData['publishedAt'] as DateTime,
    );
  }

  /// Fields of a new article document. `publishedAt` is left out: the server sets it.
  static Map<String, dynamic> rawDataOfNewArticle(ArticleDraftEntity draft, String thumbnailURL) {
    return {
      'title': draft.title,
      'description': draft.description,
      'content': draft.content,
      'author': draft.author,
      'thumbnailURL': thumbnailURL,
    };
  }

  JournalistArticleEntity toEntity() {
    return JournalistArticleEntity(
      id: id,
      title: title,
      description: description,
      content: content,
      author: author,
      thumbnailURL: thumbnailURL,
      publishedAt: publishedAt,
    );
  }
}
