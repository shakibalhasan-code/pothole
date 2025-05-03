import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // Optional: Use debugPrint for logging

class PrefHelper {
  // Get the SharedPreferences instance - needs to be awaited the first time
  // It's good practice to get this instance once if possible,
  // but getting it per method call is also common and simpler here.
  static Future<SharedPreferences> _getInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, String value) async {
    try {
      final SharedPreferences pref =
          await _getInstance(); // Get the async instance
      await pref.setString(key, value);
      // print('PrefHelper: Successfully saved key "$key"'); // Optional: for debugging
    } catch (e) {
      debugPrint('PrefHelper saveData Error for key "$key": $e');
      // Depending on requirements, you might want to re-throw the exception
      // or return a boolean indicating success/failure.
    }
  }

  static Future<String> getData(String key) async {
    try {
      final SharedPreferences pref =
          await _getInstance(); // Get the async instance
      final data = pref.getString(
        key,
      ); // getString is synchronous *after* getting the instance
      // print('PrefHelper: Retrieved data for key "$key": $data'); // Optional: for debugging
      return data ?? '';
    } catch (e) {
      debugPrint('PrefHelper getData Error for key "$key": $e');
      return ''; // Return null if an error occurs
    }
  }

  // Optional: Add methods to remove data
  static Future<void> removeData(String key) async {
    try {
      final SharedPreferences pref = await _getInstance();
      await pref.remove(key);
      // print('PrefHelper: Successfully removed key "$key"'); // Optional
    } catch (e) {
      debugPrint('PrefHelper removeData Error for key "$key": $e');
    }
  }

  // Optional: Add method to clear all data
  static Future<void> clearAllData() async {
    try {
      final SharedPreferences pref = await _getInstance();
      await pref.clear();
      // print('PrefHelper: Successfully cleared all data'); // Optional
    } catch (e) {
      debugPrint('PrefHelper clearAllData Error: $e');
    }
  }
}
