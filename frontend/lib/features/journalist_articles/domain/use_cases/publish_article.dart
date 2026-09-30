import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_draft.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';

class PublishArticleUseCase
    implements UseCase<DataState<JournalistArticleEntity>, ArticleDraftEntity> {
  @override
  Future<DataState<JournalistArticleEntity>> call({
    ArticleDraftEntity? params,
  }) async {
    final draft = params!;
    if (!draft.isValid) {
      return DataFailed(InvalidArticleDraftException(draft));
    }
    // TODO(2.3): replace the mock article with JournalistArticleRepository.publishArticle(draft).
    return DataSuccess(_buildMockPublishedArticle(draft));
  }

  JournalistArticleEntity _buildMockPublishedArticle(ArticleDraftEntity draft) {
    final publishedAt = DateTime.now().toUtc();
    return JournalistArticleEntity(
      id: 'mockArticle${publishedAt.microsecondsSinceEpoch}',
      title: draft.title,
      description: draft.description,
      content: draft.content,
      author: draft.author,
      thumbnailURL: 'https://picsum.photos/seed/${publishedAt.millisecondsSinceEpoch}/640/352',
      publishedAt: publishedAt,
    );
  }
}
