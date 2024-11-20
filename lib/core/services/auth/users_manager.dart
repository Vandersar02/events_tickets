import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // Singleton pattern
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final aesKey = List<int>.generate(32, (index) => index);

  // Méthode générique pour enregistrer des données dans SharedPreferences
  Future<void> savePreference(String key, dynamic value) async {
    final prefs = await _prefs;
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is Map<String, dynamic> || value is List<dynamic>) {
      await prefs.setString(key, jsonEncode(value));
    }
  }

  // Méthode générique pour récupérer des données dans SharedPreferences
  Future<dynamic> getPreference(String key) async {
    final prefs = await _prefs;
    return prefs.get(key);
  }

  // Méthode pour supprimer des données dans SharedPreferences
  Future<void> removePreference(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  // Enregistrer si l'utilisateur a vu l'onboarding
  Future<void> setHasSeenOnboarding(bool value) async {
    await savePreference(_hasSeenOnboardingKey, value);
  }

  // Vérifier si l'utilisateur a vu l'onboarding
  Future<bool> hasSeenOnboarding() async {
    return await getPreference(_hasSeenOnboardingKey) ?? false;
  }
}
