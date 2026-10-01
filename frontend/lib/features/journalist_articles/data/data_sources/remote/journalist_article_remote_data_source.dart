import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/data/models/journalist_article.dart';

abstract class JournalistArticleRemoteDataSource {
  /// Published articles, newest first.
  Future<List<JournalistArticleModel>> getPublishedArticles();

  /// Generates the ID of a new article without creating it, so its thumbnail can be named after it.
  String generateArticleId();

  /// Creates the article document and returns it as stored, with the publication date set by the server.
  Future<JournalistArticleModel> createArticle(String articleId, Map<String, dynamic> rawData);
}

/// Throws a [FirebaseException] when Firestore cannot complete a request.
class JournalistArticleRemoteDataSourceImpl implements JournalistArticleRemoteDataSource {
  static const String _collectionPath = 'articles';

  final FirebaseFirestore _firestore;

  JournalistArticleRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _articles => _firestore.collection(_collectionPath);

  @override
  Future<List<JournalistArticleModel>> getPublishedArticles() async {
    final snapshot = await _articles.orderBy('publishedAt', descending: true).get();
    return snapshot.docs.map(_toModel).toList();
  }

  @override
  String generateArticleId() => _articles.doc().id;

  @override
  Future<JournalistArticleModel> createArticle(String articleId, Map<String, dynamic> rawData) async {
    final document = _articles.doc(articleId);
    await document.set({...rawData, 'publishedAt': FieldValue.serverTimestamp()});
    return _toModel(await document.get());
  }

  JournalistArticleModel _toModel(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final publishedAt = (data['publishedAt'] as Timestamp).toDate();
    return JournalistArticleModel.fromRawData(snapshot.id, {...data, 'publishedAt': publishedAt});
  }
}
