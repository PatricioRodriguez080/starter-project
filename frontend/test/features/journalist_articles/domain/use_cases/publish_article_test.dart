import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_draft.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_thumbnail.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/use_cases/publish_article.dart';

void main() {
  late PublishArticleUseCase publishArticle;

  final validDraft = ArticleDraftEntity(
    title: 'Local startup brings clean water to 10,000 homes',
    description: 'A team of engineers has designed a low-cost filter.',
    content: 'When the first prototype was installed last spring...',
    author: 'Jane Doe',
    thumbnail: ArticleThumbnailEntity(bytes: Uint8List(1024), fileExtension: 'jpg'),
  );

  setUp(() => publishArticle = PublishArticleUseCase());

  test('publishes a valid draft keeping what the journalist wrote', () async {
    final dataState = await publishArticle(params: validDraft);

    expect(dataState, isA<DataSuccess>());
    final article = dataState.data!;
    expect(article.id, isNotEmpty);
    expect(article.title, validDraft.title);
    expect(article.description, validDraft.description);
    expect(article.content, validDraft.content);
    expect(article.author, validDraft.author);
    expect(Uri.parse(article.thumbnailURL).isAbsolute, isTrue);
  });

  test('sets the publication date when the article is published', () async {
    final before = DateTime.now().toUtc();
    final article = (await publishArticle(params: validDraft)).data!;
    final after = DateTime.now().toUtc();

    expect(article.publishedAt.isBefore(before), isFalse);
    expect(article.publishedAt.isAfter(after), isFalse);
  });

  test('refuses to publish a draft that breaks its rules', () async {
    const invalidDraft = ArticleDraftEntity(title: 'Only a title');

    final dataState = await publishArticle(params: invalidDraft);

    expect(dataState, isA<DataFailed>());
    expect(dataState.error, isA<InvalidArticleDraftException>());
    expect((dataState.error! as InvalidArticleDraftException).draft, invalidDraft);
  });
}
