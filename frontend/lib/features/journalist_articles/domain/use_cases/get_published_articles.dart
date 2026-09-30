import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';

class GetPublishedArticlesUseCase
    implements UseCase<DataState<List<JournalistArticleEntity>>, void> {
  // TODO(2.3): replace the mock data with JournalistArticleRepository.getPublishedArticles().
  @override
  Future<DataState<List<JournalistArticleEntity>>> call({void params}) async {
    return DataSuccess(_mockPublishedArticles);
  }
}

final List<JournalistArticleEntity> _mockPublishedArticles = [
  JournalistArticleEntity(
    id: 'mockArticle1',
    title: 'Local startup brings clean water to 10,000 homes',
    description:
        'A team of engineers has designed a low-cost filter that is already running in three rural towns.',
    content:
        'When the first prototype was installed last spring, nobody expected it to last through the summer.\n\n'
        'Six months later, the filter has processed more than two million litres of water.',
    author: 'Jane Doe',
    thumbnailURL: 'https://picsum.photos/seed/clean-water/640/352',
    publishedAt: DateTime.utc(2026, 9, 30, 9),
  ),
  JournalistArticleEntity(
    id: 'mockArticle2',
    title: 'The city library opens its doors 24 hours a day',
    description:
        'After a two-month pilot, the central library will stay open around the clock during the exam season.',
    content:
        'Students queued outside the central library at midnight on Monday to celebrate the new schedule.\n\n'
        'The pilot showed that almost a third of the visits happened between 10 p.m. and 6 a.m.',
    author: 'John Smith',
    thumbnailURL: 'https://picsum.photos/seed/city-library/640/352',
    publishedAt: DateTime.utc(2026, 9, 29, 16, 30),
  ),
  JournalistArticleEntity(
    id: 'mockArticle3',
    title: 'Community gardens double in size across the region',
    description:
        'More than 400 neighbours now grow their own vegetables in plots that used to be empty lots.',
    content:
        'What started as a single garden behind a school has become a network of forty plots.\n\n'
        'The gardens are managed by the neighbours, who share tools, seeds and a rota for watering.',
    author: 'Jane Doe',
    thumbnailURL: 'https://picsum.photos/seed/community-gardens/640/352',
    publishedAt: DateTime.utc(2026, 9, 28, 11, 15),
  ),
];
