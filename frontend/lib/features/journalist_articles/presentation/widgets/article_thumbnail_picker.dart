import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/article_thumbnail.dart';

/// Shows the "Attach Image" button or, once an image is chosen, its preview.
/// Tapping the preview opens the gallery again so the image can be changed.
class ArticleThumbnailPicker extends StatelessWidget {
  final ArticleThumbnailEntity? thumbnail;
  final VoidCallback? onPick;
  final String? errorText;

  const ArticleThumbnailPicker({
    super.key,
    required this.thumbnail,
    required this.onPick,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final errorText = this.errorText;
    return Column(
      children: [
        thumbnail == null ? _buildAttachButton() : _buildPreview(thumbnail!),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildAttachButton() {
    return FilledButton.tonalIcon(
      onPressed: onPick,
      icon: const Icon(Icons.add_photo_alternate_outlined),
      label: const Text('Attach Image'),
    );
  }

  Widget _buildPreview(ArticleThumbnailEntity thumbnail) {
    return InkWell(
      onTap: onPick,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.memory(thumbnail.bytes, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }
}
