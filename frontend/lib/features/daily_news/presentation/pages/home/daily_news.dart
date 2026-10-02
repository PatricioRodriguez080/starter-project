import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/screens/published_articles/published_articles_screen.dart';

import '../../../../../config/theme/app_skeletons.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

/// Placeholder articles drawn as a skeleton while the news are loading.
final List<ArticleEntity> _loadingArticles = List.filled(
  5,
  const ArticleEntity(
    title: 'A headline that takes about two lines of the card',
    description: 'A short summary of the news that also takes two lines of text.',
    urlToImage: '',
    publishedAt: '2026-01-01T00:00:00Z',
  ),
);

/// Home section: the news from NewsAPI and the journalists' articles, in two tabs.
/// Its tab controller is provided by the app navigation, which also owns the + button.
class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: TabBarView(
        children: [
          _buildDailyNewsTab(),
          const PublishedArticlesScreen(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: const Text('Daily News'),
      bottom: const TabBar(
        indicatorWeight: 3,
        tabs: [
          Tab(text: 'Daily News'),
          Tab(text: 'Journalists'),
        ],
      ),
    );
  }

  Widget _buildDailyNewsTab() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesLoading) {
          return AppSkeletonizer(child: _buildArticlesList(context, _loadingArticles));
        }
        if (state is RemoteArticlesError) {
          return const Center(child: Icon(Icons.refresh));
        }
        if (state is RemoteArticlesDone) {
          return _buildArticlesList(context, state.articles!);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildArticlesList(BuildContext context, List<ArticleEntity> articles) {
    // The bottom padding keeps the last article above the translucent navigation bar.
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: MediaQuery.paddingOf(context).bottom + 8),
      itemCount: articles.length,
      itemBuilder: (context, index) => ArticleWidget(
        article: articles[index],
        onArticlePressed: (article) => _onArticlePressed(context, article),
      ),
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
