import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_draft.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/publish_article/publish_article_cubit.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/bloc/publish_article/publish_article_state.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/widgets/article_draft_error_message.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/widgets/article_thumbnail_picker.dart';

/// Form where a journalist writes an article and publishes it.
/// When the article is published, the screen closes returning it.
class PublishArticleScreen extends StatelessWidget {
  const PublishArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublishArticleCubit, PublishArticleState>(
      listener: _onStateChanged,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Ionicons.chevronBack, color: Colors.black),
          ),
          title: const Text('Publish Article'),
        ),
        body: _ArticleForm(state: state),
        bottomNavigationBar: _PublishButton(isPublishing: state is PublishArticleInProgress),
      ),
    );
  }

  void _onStateChanged(BuildContext context, PublishArticleState state) {
    if (state is PublishArticleSuccess) {
      _showMessage(context, 'Your article has been published!');
      Navigator.pop(context, state.article);
    }
    if (state is PublishArticleFailure) {
      _showMessage(context, 'Something went wrong. Please try again.');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ArticleForm extends StatelessWidget {
  final PublishArticleState state;

  const _ArticleForm({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PublishArticleCubit>();
    final draft = state.draft;
    final isEditable = state is! PublishArticleInProgress;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DraftTextField(
          label: 'Title',
          maxLength: ArticleDraftEntity.maxTitleLength,
          errorText: _visibleError(draft.titleError),
          enabled: isEditable,
          onChanged: cubit.updateTitle,
        ),
        ArticleThumbnailPicker(
          thumbnail: draft.thumbnail,
          errorText: _visibleError(draft.thumbnailError),
          onPick: isEditable ? cubit.pickThumbnail : null,
        ),
        const SizedBox(height: 16),
        _DraftTextField(
          label: 'Description',
          maxLength: ArticleDraftEntity.maxDescriptionLength,
          maxLines: 3,
          errorText: _visibleError(draft.descriptionError),
          enabled: isEditable,
          onChanged: cubit.updateDescription,
        ),
        _DraftTextField(
          label: 'Author',
          maxLength: ArticleDraftEntity.maxAuthorLength,
          errorText: _visibleError(draft.authorError),
          enabled: isEditable,
          onChanged: cubit.updateAuthor,
        ),
        _DraftTextField(
          label: 'Article',
          maxLength: ArticleDraftEntity.maxContentLength,
          maxLines: 12,
          errorText: _visibleError(draft.contentError),
          enabled: isEditable,
          onChanged: cubit.updateContent,
        ),
      ],
    );
  }

  String? _visibleError(ArticleDraftError? error) {
    final showsErrors = state is PublishArticleEditing &&
        (state as PublishArticleEditing).showsValidationErrors;
    return showsErrors ? error?.message : null;
  }
}

class _DraftTextField extends StatelessWidget {
  final String label;
  final int maxLength;
  final int maxLines;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _DraftTextField({
    required this.label,
    required this.maxLength,
    required this.errorText,
    required this.enabled,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        maxLength: maxLength,
        minLines: 1,
        maxLines: maxLines,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _PublishButton extends StatelessWidget {
  final bool isPublishing;

  const _PublishButton({required this.isPublishing});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: isPublishing ? null : context.read<PublishArticleCubit>().publish,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          icon: isPublishing
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.login),
          label: Text(isPublishing ? 'Publishing…' : 'Publish Article'),
        ),
      ),
    );
  }
}
