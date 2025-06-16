import 'package:shared_preferences/shared_preferences.dart';

class FavoriteStorage {
  static const _prefix = 'favorite_';

  static Future<bool> isFavorite(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$bookId') ?? false;
  }

  static Future<bool> toggleFavorite(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getBool('$_prefix$bookId') ?? false;
    final newValue = !current;
    await prefs.setBool('$_prefix$bookId', newValue);
    return newValue;
  }

  static Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith(_prefix)) {
        await prefs.remove(key);
      }
    }
  }

  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    return keys
        .where((key) => key.startsWith(_prefix) && prefs.getBool(key) == true)
        .map((key) => key.replaceFirst(_prefix, ''))
        .toList();
  }
}
