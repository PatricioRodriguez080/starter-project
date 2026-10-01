import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';

import 'publication_date_text.dart';

class JournalistArticleTile extends StatelessWidget {
  final JournalistArticleEntity article;
  final void Function(JournalistArticleEntity article) onPressed;

  const JournalistArticleTile({
    super.key,
    required this.article,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(article),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 2.2,
          child: Row(
            children: [
              _buildThumbnail(context),
              const SizedBox(width: 14),
              Expanded(child: _buildTexts()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: article.thumbnailURL,
        width: MediaQuery.of(context).size.width / 3,
        height: double.maxFinite,
        fit: BoxFit.cover,
        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
      ),
    );
  }

  Widget _buildTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        Text('By ${article.author}', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 2),
        PublicationDateText(publishedAt: article.publishedAt),
      ],
    );
  }
}
