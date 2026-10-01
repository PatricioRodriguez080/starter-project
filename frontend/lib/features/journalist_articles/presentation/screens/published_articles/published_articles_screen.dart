import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/published_articles/published_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/published_articles/published_articles_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/widgets/journalist_article_tile.dart';

/// List of the articles published by journalists, shown inside a tab of the home screen.
class PublishedArticlesScreen extends StatelessWidget {
  const PublishedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublishedArticlesCubit, PublishedArticlesState>(
      builder: (context, state) {
        if (state is PublishedArticlesSuccess) return _buildArticles(context, state.articles);
        if (state is PublishedArticlesFailure) return _buildFailure(context);
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildArticles(BuildContext context, List<JournalistArticleEntity> articles) {
    return RefreshIndicator(
      onRefresh: () => context.read<PublishedArticlesCubit>().loadArticles(),
      child: articles.isEmpty
          ? ListView(children: const [_EmptyArticlesMessage()])
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) => JournalistArticleTile(
                article: articles[index],
                onPressed: (article) => _onArticlePressed(context, article),
              ),
            ),
    );
  }

  Widget _buildFailure(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('The articles could not be loaded.'),
          TextButton.icon(
            onPressed: () => context.read<PublishedArticlesCubit>().loadArticles(),
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  void _onArticlePressed(BuildContext context, JournalistArticleEntity article) {
    Navigator.pushNamed(context, '/JournalistArticleDetails', arguments: article);
  }
}

class _EmptyArticlesMessage extends StatelessWidget {
  const _EmptyArticlesMessage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'No journalist has published an article yet. Tap + to write the first one!',
        textAlign: TextAlign.center,
      ),
    );
  }
}
