import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final CollectionReference<User> usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<User>(
        fromFirestore: (snap, _) => User.fromMap(snap.id, snap.data()!),
        toFirestore: (user, _) => user.toMap(),
      );

  Future<void> createUser(User user) => usersRef.doc(user.id).set(user);

  Future<User?> getUser(String id) async {
    final doc = await usersRef.doc(id).get();
    return doc.data();
  }

  Future<void> updateUser(User user) =>
      usersRef.doc(user.id).update(user.toMap());

  Future<void> deleteUser(String id) => usersRef.doc(id).delete();
}
