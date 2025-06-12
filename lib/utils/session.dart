// lib/utils/session.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/service/app_user_service.dart';
import 'package:myapp/models/app_user.dart';

class Session {
  static Future<AppUser?> getCurrentAppUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userService = AppUserService();
    return await userService.getUser(user.uid);
  }
}
