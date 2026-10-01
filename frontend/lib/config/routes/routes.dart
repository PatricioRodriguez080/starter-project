import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/pages/home/daily_news.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';
import '../../features/journalist_articles/domain/entities/journalist_article.dart';
import '../../features/journalist_articles/presentation/bloc/publish_article/publish_article_cubit.dart';
import '../../features/journalist_articles/presentation/screens/journalist_article_detail/journalist_article_detail_screen.dart';
import '../../features/journalist_articles/presentation/screens/publish_article/publish_article_screen.dart';
import '../../injection_container.dart';


class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const DailyNews());

      case '/ArticleDetails':
        return _materialRoute(ArticleDetailsView(article: settings.arguments as ArticleEntity));

      case '/SavedArticles':
        return _materialRoute(const SavedArticles());

      case '/PublishArticle':
        return _materialRoute(BlocProvider(
          create: (_) => sl<PublishArticleCubit>(),
          child: const PublishArticleScreen(),
        ));

      case '/JournalistArticleDetails':
        return _materialRoute(JournalistArticleDetailScreen(
          article: settings.arguments as JournalistArticleEntity,
        ));

      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
