import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import '../../../../core/constants/constants.dart';

/// A news article as NewsAPI sends it, or as it is saved on the phone.
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    super.id,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  /// Parses an article from the NewsAPI response.
  factory ArticleModel.fromRawData(Map<String, dynamic> rawData) {
    final urlToImage = rawData['urlToImage'];
    return ArticleModel(
      author: rawData['author'] ?? '',
      title: rawData['title'] ?? '',
      description: rawData['description'] ?? '',
      url: rawData['url'] ?? '',
      urlToImage: urlToImage != null && urlToImage != '' ? urlToImage : kDefaultImage,
      publishedAt: rawData['publishedAt'] ?? '',
      content: rawData['content'] ?? '',
    );
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
    );
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      author: author,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
    );
  }
}
