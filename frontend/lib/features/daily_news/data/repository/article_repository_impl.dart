import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;
  ArticleRepositoryImpl(this._newsApiService,this._appDatabase);
  
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
   try {
    final articles = await _newsApiService.getNewsArticles(
      apiKey:newsAPIKey,
      country:countryQuery,
      category:categoryQuery,
    );
    return DataSuccess(articles);
   } on DioException catch(e){
    return DataFailed(e);
   }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _appDatabase.articleDAO.getArticles();
  }

  /// Removed by its URL, so it also works for an article that comes from NewsAPI (without a local ID).
  @override
  Future<void> removeArticle(ArticleEntity article) {
    final url = article.url;
    if (url == null) return _appDatabase.articleDAO.deleteArticle(ArticleModel.fromEntity(article));
    return _appDatabase.articleDAO.deleteArticleByUrl(url);
  }

  /// An article that is already saved is not saved again.
  @override
  Future<void> saveArticle(ArticleEntity article) async {
    final url = article.url;
    if (url != null && await _appDatabase.articleDAO.findArticleByUrl(url) != null) return;
    await _appDatabase.articleDAO.insertArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<DataState<bool>> isArticleSaved(ArticleEntity article) async {
    try {
      final savedArticle = await _appDatabase.articleDAO.findArticleByUrl(article.url ?? '');
      return DataSuccess(savedArticle != null);
    } on Exception catch (error) {
      return DataFailed(error);
    }
  }

}