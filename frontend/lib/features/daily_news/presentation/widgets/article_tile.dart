import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_skeletons.dart';
import '../../../../config/theme/app_themes.dart';
import '../../../../config/theme/bookmark_button.dart';
import '../../domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  static const double _thumbnailSize = 116;

  final ArticleEntity? article;
  final bool? isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;

  const ArticleWidget({
    super.key,
    this.article,
    this.onArticlePressed,
    this.isRemovable = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: _onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          height: _thumbnailSize,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(palette),
              const SizedBox(width: 14),
              Expanded(child: _buildTitleAndDescription(palette)),
              _buildRemovableArea(),
            ],
          ),
        ),
      ),
    );
  }

  /// Without an image URL (e.g. the placeholder articles of the loading skeleton) nothing is downloaded.
  Widget _buildImage(AppPalette palette) {
    final imageUrl = article!.urlToImage ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: _thumbnailSize,
        height: _thumbnailSize,
        color: palette.imagePlaceholder,
        child: imageUrl.isEmpty
            ? null
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ImageLoadingSkeleton(),
                errorWidget: (_, __, ___) => Icon(Icons.image_outlined, color: palette.icon),
              ),
      ),
    );
  }

  /// Fills the height of the image, with the date aligned to its bottom edge.
  Widget _buildTitleAndDescription(AppPalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article!.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, height: 1.25),
        ),
        const SizedBox(height: 6),
        Text(
          article!.description ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, height: 1.4, color: palette.textSecondary),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(Icons.schedule, size: 14, color: palette.textSecondary),
            const SizedBox(width: 4),
            Text(
              _formatPublicationDate(article!.publishedAt ?? ''),
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemovableArea() {
    if (!isRemovable!) return const SizedBox.shrink();
    return BookmarkButton(isSaved: true, onPressed: _onRemove, size: 22);
  }

  /// NewsAPI dates are ISO strings ("2026-09-29T18:00:00Z"); anything else is shown as it comes.
  static String _formatPublicationDate(String publishedAt) {
    final date = DateTime.tryParse(publishedAt);
    if (date == null) return publishedAt;
    return DateFormat('MMM d, y · HH:mm').format(date.toLocal());
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed!(article!);
    }
  }

  void _onRemove() {
    if (onRemove != null) {
      onRemove!(article!);
    }
  }
}
