import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'features/journalist_articles/data/data_sources/local/article_thumbnail_gallery_data_source.dart';
import 'features/journalist_articles/data/data_sources/remote/article_thumbnail_remote_data_source.dart';
import 'features/journalist_articles/data/data_sources/remote/firebase_emulators.dart';
import 'features/journalist_articles/data/data_sources/remote/journalist_article_remote_data_source.dart';
import 'features/journalist_articles/data/repository/article_thumbnail_repository_impl.dart';
import 'features/journalist_articles/data/repository/journalist_article_repository_impl.dart';
import 'features/journalist_articles/domain/repository/article_thumbnail_repository.dart';
import 'features/journalist_articles/domain/repository/journalist_article_repository.dart';
import 'features/journalist_articles/domain/use_cases/get_published_articles.dart';
import 'features/journalist_articles/domain/use_cases/pick_article_thumbnail.dart';
import 'features/journalist_articles/domain/use_cases/publish_article.dart';
import 'features/journalist_articles/presentation/bloc/publish_article/publish_article_cubit.dart';
import 'features/journalist_articles/presentation/bloc/published_articles/published_articles_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);
  
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Dependencies
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(),sl())
  );
  
  //UseCases
  sl.registerSingleton<GetArticleUseCase>(
    GetArticleUseCase(sl())
  );

  sl.registerSingleton<GetSavedArticleUseCase>(
    GetSavedArticleUseCase(sl())
  );

  sl.registerSingleton<SaveArticleUseCase>(
    SaveArticleUseCase(sl())
  );
  
  sl.registerSingleton<RemoveArticleUseCase>(
    RemoveArticleUseCase(sl())
  );


  //Blocs
  sl.registerFactory<RemoteArticlesBloc>(
    ()=> RemoteArticlesBloc(sl())
  );

  sl.registerFactory<LocalArticleBloc>(
    ()=> LocalArticleBloc(sl(),sl(),sl())
  );

  await _initializeJournalistArticlesDependencies();
}

Future<void> _initializeJournalistArticlesDependencies() async {
  await connectToFirebaseEmulatorsIfEnabled();

  //Data sources
  sl.registerSingleton<JournalistArticleRemoteDataSource>(JournalistArticleRemoteDataSourceImpl());
  sl.registerSingleton<ArticleThumbnailRemoteDataSource>(ArticleThumbnailRemoteDataSourceImpl());
  sl.registerSingleton<ArticleThumbnailGalleryDataSource>(ArticleThumbnailGalleryDataSourceImpl());

  //Repositories
  sl.registerSingleton<JournalistArticleRepository>(JournalistArticleRepositoryImpl(sl(), sl()));
  sl.registerSingleton<ArticleThumbnailRepository>(ArticleThumbnailRepositoryImpl(sl()));

  //UseCases
  sl.registerSingleton<GetPublishedArticlesUseCase>(GetPublishedArticlesUseCase(sl()));
  sl.registerSingleton<PublishArticleUseCase>(PublishArticleUseCase(sl()));
  sl.registerSingleton<PickArticleThumbnailUseCase>(PickArticleThumbnailUseCase(sl()));

  //Cubits
  sl.registerFactory<PublishedArticlesCubit>(() => PublishedArticlesCubit(sl()));
  sl.registerFactory<PublishArticleCubit>(() => PublishArticleCubit(sl(), sl()));
}