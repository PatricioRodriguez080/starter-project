import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/use_cases/get_published_articles.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/published_articles/published_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/published_articles/published_articles_state.dart';

class MockGetPublishedArticlesUseCase extends Mock implements GetPublishedArticlesUseCase {}

void main() {
  late MockGetPublishedArticlesUseCase getPublishedArticles;
  late PublishedArticlesCubit cubit;

  final articles = [
    JournalistArticleEntity(
      id: 'article1',
      title: 'Local startup brings clean water to 10,000 homes',
      description: 'A team of engineers has designed a low-cost filter.',
      content: 'When the first prototype was installed last spring...',
      author: 'Jane Doe',
      thumbnailURL: 'https://example.com/thumbnail.png',
      publishedAt: DateTime.utc(2026, 9, 30),
    ),
  ];

  setUp(() {
    getPublishedArticles = MockGetPublishedArticlesUseCase();
    cubit = PublishedArticlesCubit(getPublishedArticles);
  });

  tearDown(() => cubit.close());

  test('starts loading the articles', () {
    expect(cubit.state, const PublishedArticlesInProgress());
  });

  test('shows the articles when they are loaded', () async {
    when(() => getPublishedArticles()).thenAnswer((_) async => DataSuccess(articles));

    final states = expectLater(
      cubit.stream,
      emitsInOrder([const PublishedArticlesInProgress(), PublishedArticlesSuccess(articles)]),
    );
    await cubit.loadArticles();
    await states;
  });

  test('shows a failure when the articles cannot be loaded', () async {
    final error = Exception('No connection');
    when(() => getPublishedArticles()).thenAnswer((_) async => DataFailed(error));

    final states = expectLater(
      cubit.stream,
      emitsInOrder([const PublishedArticlesInProgress(), PublishedArticlesFailure(error)]),
    );
    await cubit.loadArticles();
    await states;
  });
}
