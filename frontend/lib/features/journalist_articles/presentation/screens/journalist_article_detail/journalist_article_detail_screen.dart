import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/domain/entities/journalist_article.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/presentation/widgets/publication_date_text.dart';

class JournalistArticleDetailScreen extends StatelessWidget {
  final JournalistArticleEntity article;

  const JournalistArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Ionicons.chevronBack, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          _buildHeader(),
          _buildThumbnail(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text('By ${article.author}', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          PublicationDateText(publishedAt: article.publishedAt),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      height: 250,
      margin: const EdgeInsets.only(top: 14),
      child: CachedNetworkImage(
        imageUrl: article.thumbnailURL,
        fit: BoxFit.cover,
        width: double.maxFinite,
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.description,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Text(article.content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
