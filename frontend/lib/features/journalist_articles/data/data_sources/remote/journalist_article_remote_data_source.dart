import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_clean_architecture/features/journalist_articles/data/models/journalist_article.dart';

abstract class JournalistArticleRemoteDataSource {
  /// Published articles, newest first.
  Future<List<JournalistArticleModel>> getPublishedArticles();

  /// Generates the ID of a new article without creating it, so its thumbnail can be named after it.
  String generateArticleId();

  /// Creates the article document in the name of the signed-in journalist and returns it as stored,
  /// with the publication date set by the server.
  Future<JournalistArticleModel> createArticle(String articleId, Map<String, dynamic> rawData);
}

/// Thrown when trying to publish an article while nobody is signed in.
class NoSignedInJournalistException implements Exception {
  const NoSignedInJournalistException();
}

/// Throws a [FirebaseException] when Firestore cannot complete a request.
class JournalistArticleRemoteDataSourceImpl implements JournalistArticleRemoteDataSource {
  static const String _collectionPath = 'articles';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  JournalistArticleRemoteDataSourceImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

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
    await document.set({...rawData, ..._authorRawData(), 'publishedAt': FieldValue.serverTimestamp()});
    return _toModel(await document.get());
  }

  /// The security rules only accept the account's own ID and name as the author.
  Map<String, dynamic> _authorRawData() {
    final journalist = _auth.currentUser;
    if (journalist == null) throw const NoSignedInJournalistException();
    return {'author': journalist.displayName ?? '', 'authorId': journalist.uid};
  }

  JournalistArticleModel _toModel(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final publishedAt = (data['publishedAt'] as Timestamp).toDate();
    return JournalistArticleModel.fromRawData(snapshot.id, {...data, 'publishedAt': publishedAt});
  }
}
