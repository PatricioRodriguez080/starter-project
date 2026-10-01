import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/published_articles/published_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/screens/published_articles/published_articles_screen.dart';

import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: TabBarView(
          children: [
            _buildDailyNewsTab(),
            const PublishedArticlesScreen(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (tabContext) => FloatingActionButton(
            onPressed: () => _onAddArticlePressed(tabContext),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Daily News',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () => _onShowSavedArticlesViewTapped(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.bookmark, color: Colors.black),
          ),
        ),
      ],
      bottom: const TabBar(
        labelColor: Colors.black,
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
          return const Center(child: CupertinoActivityIndicator());
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

  Widget _buildArticlesList(
      BuildContext context, List<ArticleEntity> articles) {
    List<Widget> articleWidgets = [];
    for (var article in articles) {
      articleWidgets.add(ArticleWidget(
        article: article,
        onArticlePressed: (article) => _onArticlePressed(context, article),
      ));
    }

    return ListView(
      children: articleWidgets,
    );
  }

  /// Opens the form to publish an article and, once it is published,
  /// reloads the journalists' articles and shows their tab.
  Future<void> _onAddArticlePressed(BuildContext tabContext) async {
    final publishedArticle = await Navigator.pushNamed(tabContext, '/PublishArticle');
    if (publishedArticle == null || !tabContext.mounted) return;
    tabContext.read<PublishedArticlesCubit>().loadArticles();
    DefaultTabController.of(tabContext).animateTo(1);
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }
}
