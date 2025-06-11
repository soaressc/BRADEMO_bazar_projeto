import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/author.dart';

class AuthorService {
  final CollectionReference<Author> authorsRef = FirebaseFirestore.instance
      .collection('authors')
      .withConverter<Author>(
        fromFirestore: (snap, _) => Author.fromMap(snap.data()!),
        toFirestore: (author, _) => author.toMap(),
      );

  Future<void> createAuthor(Author author) =>
      authorsRef.doc(author.id).set(author);

  Future<Author?> getAuthor(String id) async {
    final doc = await authorsRef.doc(id).get();
    return doc.data();
  }

  Future<void> updateAuthor(Author author) =>
      authorsRef.doc(author.id).update(author.toMap());

  Future<void> deleteAuthor(String id) => authorsRef.doc(id).delete();
}
