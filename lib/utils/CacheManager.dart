import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _userDataKey = 'user_data';

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_userDataKey);

      if (cachedData != null) {
        return json.decode(cachedData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cached user data: $e');
      }
      return null;
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filteredData = Map<String, dynamic>.from(userData)
        ..removeWhere((key, value) => value == null);
      if (filteredData.isEmpty) {
        // Optionally skip saving entirely if no meaningful data present
        safePrint("skipping saving cache coz its null");
        return;
      }
      filteredData['lastUpdated'] = DateTime.now().toIso8601String();
      await prefs.setString(_userDataKey, json.encode(filteredData));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user data: $e');
      }
    }
  }

  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing user data: $e');
      }
    }
  }
}
