import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_comment.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_comment_draft.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/repository/article_comment_repository.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/use_cases/add_article_comment.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/use_cases/get_article_comments.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/add_article_comment/add_article_comment_cubit.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/article_comments/article_comments_cubit.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/screens/journalist_article_detail/journalist_article_detail_screen.dart';

/// Keeps the comments in memory and writes them in the name of Jane Doe, as Firestore would for her account.
class FakeArticleCommentRepository implements ArticleCommentRepository {
  final List<ArticleCommentEntity> comments;
  bool failsToAdd = false;

  FakeArticleCommentRepository(this.comments);

  @override
  Future<DataState<List<ArticleCommentEntity>>> getComments(String articleId) async => DataSuccess([...comments]);

  @override
  Future<DataState<ArticleCommentEntity>> addComment(ArticleCommentDraftEntity draft) async {
    if (failsToAdd) return DataFailed(Exception('No connection'));
    final comment = ArticleCommentEntity(
      id: 'comment${comments.length + 1}',
      content: draft.content.trim(),
      author: 'Jane Doe',
      authorId: 'janeDoeUid',
      createdAt: DateTime.utc(2026, 10, 2, 10, 22),
    );
    comments.add(comment);
    return DataSuccess(comment);
  }
}

/// User journey "comment on an article", with the real cubits and use cases and a fake repository.
void main() {
  final article = JournalistArticleEntity(
    id: 'article1',
    title: 'Local startup brings clean water to 10,000 homes',
    description: 'A team of engineers has designed a low-cost filter.',
    content: 'When the first prototype was installed last spring...',
    author: 'Jane Doe',
    authorId: 'janeDoeUid',
    thumbnailURL: '',
    publishedAt: DateTime.utc(2026, 9, 30, 9),
  );
  final johnsComment = ArticleCommentEntity(
    id: 'comment1',
    content: 'Great news for the rural towns.',
    author: 'John Smith',
    authorId: 'johnSmithUid',
    createdAt: DateTime.utc(2026, 10, 2, 9, 41),
  );

  late FakeArticleCommentRepository repository;

  Future<void> openArticle(WidgetTester tester, {List<ArticleCommentEntity> comments = const []}) async {
    repository = FakeArticleCommentRepository([...comments]);
    // Screen of the Pixel 8 used as Android emulator (412 x 914 logical pixels).
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: lightTheme(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ArticleCommentsCubit(GetArticleCommentsUseCase(repository), article.id)..loadComments(),
          ),
          BlocProvider(create: (_) => AddArticleCommentCubit(AddArticleCommentUseCase(repository), article.id)),
        ],
        child: JournalistArticleDetailScreen(article: article),
      ),
    ));
    await tester.pumpAndSettle();
  }

  Finder commentField() => find.widgetWithText(TextField, 'Write a comment…');

  IconButton sendButton(WidgetTester tester) {
    return tester.widget<IconButton>(find.ancestor(of: find.byTooltip('Send comment'), matching: find.byType(IconButton)));
  }

  Future<void> scrollToComments(WidgetTester tester) async {
    await tester.scrollUntilVisible(find.text('Comments'), 200, scrollable: find.byType(Scrollable).first);
  }

  testWidgets('shows each comment with the initials, name and text of its author', (tester) async {
    await openArticle(tester, comments: [johnsComment]);
    await tester.scrollUntilVisible(find.text('Great news for the rural towns.'), 200,
        scrollable: find.byType(Scrollable).first);

    expect(find.text('JS'), findsOneWidget);
    expect(find.text('John Smith'), findsOneWidget);
    expect(find.text('Great news for the rural towns.'), findsOneWidget);
  });

  testWidgets('invites to write the first comment when there is none', (tester) async {
    await openArticle(tester);
    await scrollToComments(tester);

    expect(find.text('No comments yet'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('cannot send an empty comment', (tester) async {
    await openArticle(tester);

    expect(sendButton(tester).onPressed, isNull);

    await tester.enterText(commentField(), '   ');
    await tester.pump();

    expect(sendButton(tester).onPressed, isNull);
  });

  testWidgets('sends a comment, shows it at the end and empties the field', (tester) async {
    await openArticle(tester, comments: [johnsComment]);

    await tester.enterText(commentField(), 'Thanks! I will cover the next step.');
    await tester.pump();
    await tester.tap(find.byTooltip('Send comment'));
    await tester.pumpAndSettle();

    expect(find.text('Thanks! I will cover the next step.'), findsOneWidget);
    expect(find.text('JD'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
    expect(repository.comments, hasLength(2));
  });

  testWidgets('keeps the text and tells the journalist when the comment cannot be sent', (tester) async {
    await openArticle(tester);
    repository.failsToAdd = true;

    await tester.enterText(commentField(), 'Will the café stay open at night too?');
    await tester.pump();
    await tester.tap(find.byTooltip('Send comment'));
    await tester.pumpAndSettle();

    expect(find.text('Your comment could not be sent'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'Will the café stay open at night too?');
    // The toast closes by itself after a few seconds.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
