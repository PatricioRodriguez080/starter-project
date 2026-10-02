import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/config/navigation/app_navigation_shell.dart';
import 'config/theme/app_themes.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/journalist_articles/presentation/bloc/published_articles/published_articles_cubit.dart';
import 'features/settings/domain/entities/theme_preference.dart';
import 'features/settings/presentation/bloc/theme/app_theme_mode.dart';
import 'features/settings/presentation/bloc/theme/theme_cubit.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  // Loaded before the first frame, so the app never flashes with the other theme.
  await sl<ThemeCubit>().loadTheme();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>(
          create: (context) => sl()..add(const GetArticles()),
        ),
        BlocProvider<PublishedArticlesCubit>(
          create: (context) => sl()..loadArticles(),
        ),
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, selectedTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: selectedTheme.themeMode,
          onGenerateRoute: AppRoutes.onGenerateRoutes,
          home: const AppNavigationShell(),
        ),
      ),
    );
  }
}
