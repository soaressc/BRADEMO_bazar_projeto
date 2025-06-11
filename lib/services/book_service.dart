import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final CollectionReference<Book> booksRef = FirebaseFirestore.instance
      .collection('books')
      .withConverter<Book>(
        fromFirestore: (snap, _) => Book.fromMap(snap.data()!),
        toFirestore: (book, _) => book.toMap(),
      );

  Future<void> createBook(Book book) => booksRef.doc(book.id).set(book);

  Future<Book?> getBook(String id) async {
    final doc = await booksRef.doc(id).get();
    return doc.data();
  }

  Future<void> updateBook(Book book) =>
      booksRef.doc(book.id).update(book.toMap());

  Future<void> deleteBook(String id) => booksRef.doc(id).delete();
}
