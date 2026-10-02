import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../config/theme/app_skeletons.dart';
import '../../../../../config/theme/app_toasts.dart';
import '../../../../../config/theme/bookmark_button.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/bookmark/article_bookmark_cubit.dart';
import '../../bloc/article/bookmark/article_bookmark_state.dart';

class ArticleDetailsView extends HookWidget {
  final ArticleEntity? article;

  const ArticleDetailsView({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonTapped(context),
          child: const Icon(Ionicons.chevronBack),
        ),
      ),
      actions: [_buildBookmark(), const SizedBox(width: 4)],
    );
  }

  Widget _buildBookmark() {
    return BlocConsumer<ArticleBookmarkCubit, ArticleBookmarkState>(
      listener: _onBookmarkChanged,
      listenWhen: (previous, current) => current is ArticleBookmarkChanged,
      builder: (context, state) => BookmarkButton(
        isSaved: state.isSaved,
        onPressed: state is ArticleBookmarkInProgress ? null : context.read<ArticleBookmarkCubit>().toggleBookmark,
      ),
    );
  }

  void _onBookmarkChanged(BuildContext context, ArticleBookmarkState state) {
    final toast = state.isSaved
        ? const AppToast.success('Article saved', description: 'Find it in Saved.')
        : const AppToast.info('Removed from saved');
    showAppToast(context, toast);
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildArticleTitleAndDate(),
          _buildArticleImage(),
          _buildArticleDescription(),
        ],
      ),
    );
  }

  Widget _buildArticleTitleAndDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article!.title!,
            style: const TextStyle(
                fontFamily: 'Butler',
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 14),
          // DateTime
          Row(
            children: [
              const Icon(Ionicons.timeOutline, size: 16),
              const SizedBox(width: 4),
              Text(
                article!.publishedAt!,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleImage() {
    return Container(
      width: double.maxFinite,
      height: 250,
      margin: const EdgeInsets.only(top: 14),
      child: CachedNetworkImage(
        imageUrl: article!.urlToImage!,
        fit: BoxFit.cover,
        placeholder: (_, __) => const ImageLoadingSkeleton(),
        errorWidget: (_, __, ___) => const Icon(Icons.image_outlined),
      ),
    );
  }

  Widget _buildArticleDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Text(
        '${article!.description ?? ''}\n\n${article!.content ?? ''}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

}
