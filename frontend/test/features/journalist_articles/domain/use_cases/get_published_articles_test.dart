import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/use_cases/get_published_articles.dart';

void main() {
  late GetPublishedArticlesUseCase getPublishedArticles;

  setUp(() => getPublishedArticles = GetPublishedArticlesUseCase());

  test('returns the published articles', () async {
    final dataState = await getPublishedArticles();

    expect(dataState, isA<DataSuccess>());
    expect(dataState.data, isNotEmpty);
  });

  test('returns articles that are shown in the app with every field filled in', () async {
    final articles = (await getPublishedArticles()).data!;

    for (final article in articles) {
      expect(article.id, isNotEmpty);
      expect(article.title, isNotEmpty);
      expect(article.description, isNotEmpty);
      expect(article.content, isNotEmpty);
      expect(article.author, isNotEmpty);
      expect(Uri.parse(article.thumbnailURL).isAbsolute, isTrue);
    }
  });
}
