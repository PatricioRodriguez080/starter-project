import 'package:firebase_auth/firebase_auth.dart';

/// Thrown when trying to publish an article or a comment while nobody is signed in.
class NoSignedInJournalistException implements Exception {
  const NoSignedInJournalistException();
}

/// The author fields of a new article or comment: the ID and the name of the signed-in account,
/// the only ones the security rules accept.
Map<String, dynamic> authorRawDataOfSignedInJournalist(FirebaseAuth auth) {
  final journalist = auth.currentUser;
  if (journalist == null) throw const NoSignedInJournalistException();
  return {'author': journalist.displayName ?? '', 'authorId': journalist.uid};
}
