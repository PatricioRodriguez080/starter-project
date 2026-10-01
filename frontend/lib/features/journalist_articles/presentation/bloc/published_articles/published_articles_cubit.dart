import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/use_cases/get_published_articles.dart';

import 'published_articles_state.dart';

class PublishedArticlesCubit extends Cubit<PublishedArticlesState> {
  final GetPublishedArticlesUseCase _getPublishedArticlesUseCase;

  PublishedArticlesCubit(this._getPublishedArticlesUseCase)
      : super(const PublishedArticlesInProgress());

  Future<void> loadArticles() async {
    emit(const PublishedArticlesInProgress());
    final dataState = await _getPublishedArticlesUseCase();
    if (dataState is DataSuccess) {
      emit(PublishedArticlesSuccess(dataState.data!));
      return;
    }
    emit(PublishedArticlesFailure(dataState.error!));
  }
}
