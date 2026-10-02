import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

import '../../../../domain/use_cases/get_saved_article.dart';
import '../../../../domain/use_cases/remove_article.dart';
import '../../../../domain/use_cases/save_article.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent,LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase
  ) : super(const LocalArticlesLoading()){
    on <GetSavedArticles> (onGetSavedArticles);
    on <RemoveArticle> (onRemoveArticle);
    on <SaveArticle> (onSaveArticle);
  }


  void onGetSavedArticles(GetSavedArticles event,Emitter<LocalArticlesState> emit) async {
    emit(await _readSavedArticles());
  }
  
  void onRemoveArticle(RemoveArticle removeArticle,Emitter<LocalArticlesState> emit) async {
    await _removeArticleUseCase(params: removeArticle.article);
    emit(await _readSavedArticles());
  }

  void onSaveArticle(SaveArticle saveArticle,Emitter<LocalArticlesState> emit) async {
    await _saveArticleUseCase(params: saveArticle.article);
    emit(await _readSavedArticles());
  }

  Future<LocalArticlesState> _readSavedArticles() async {
    final dataState = await _getSavedArticleUseCase();
    if (dataState is DataSuccess) return LocalArticlesDone(dataState.data!);
    return LocalArticlesError(dataState.error!);
  }
}
