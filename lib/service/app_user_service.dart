import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AppUserService {
  final CollectionReference<AppUser> usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<AppUser>(
        fromFirestore: (snap, _) => AppUser.fromMap(snap.id, snap.data()!),
        toFirestore: (user, _) => user.toMap(),
      );

  Future<AppUser?> getUser(String id) async {
    final doc = await usersRef.doc(id).get();
    return doc.data();
  }

  Future<void> createUser(AppUser user) => usersRef.doc(user.id).set(user);

  Future<void> updateUser(AppUser user) =>
      usersRef.doc(user.id).update(user.toMap());

  Future<void> deleteUser(String id) => usersRef.doc(id).delete();
}
