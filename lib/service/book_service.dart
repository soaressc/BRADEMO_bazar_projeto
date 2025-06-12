import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final CollectionReference<Book> booksRef = FirebaseFirestore.instance
      .collection('books')
      .withConverter<Book>(
        fromFirestore: (snap, _) => Book.fromMap(snap.data()!, id: snap.id),
        toFirestore: (book, _) => book.toMap(),
      );

  Future<void> createBook(Book book) async {
    try {
      await booksRef.doc(book.id).set(book);
      print('Livro ${book.id} criado com sucesso');
    } catch (e) {
      print('Erro ao criar livro ${book.id}: $e');
    }
  }

  Future<Book?> getBook(String id) async {
    final doc = await booksRef.doc(id).get();
    return doc.data();
  }

  Future<Map<String, Book>> fetchBookMap() async {
    final snapshot = await booksRef.get();
    return {
      for (var doc in snapshot.docs)
        doc.id: doc.data(),
    };
  }

  Future<void> updateBook(Book book) =>
      booksRef.doc(book.id).update(book.toMap());

  Future<void> deleteBook(String id) => booksRef.doc(id).delete();
}
