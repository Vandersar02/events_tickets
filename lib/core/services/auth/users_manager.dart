import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  final _storage = const FlutterSecureStorage();
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // Singleton pattern
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Méthode générique pour enregistrer des données sécurisées
  Future<void> saveSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Méthode générique pour récupérer des données sécurisées
  Future<String?> getSecureData(String key) async {
    return await _storage.read(key: key);
  }

  // Méthode générique pour supprimer des données sécurisées
  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

// ============================================================================
// Méthodes pour les préférences
// ============================================================================

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

  // Enregistrer l'ID de l'utilisateur
  Future<void> saveUserId(String userId) async {
    await saveSecureData('user_id', userId);
  }

  // Récupérer l'ID de l'utilisateur
  Future<String?> getUserId() async {
    return await getSecureData('user_id');
  }

  // Effacer l'ID de l'utilisateur
  Future<void> clearUserId() async {
    await deleteSecureData('user_id');
  }

  // Enregistrer si l'utilisateur a vu l'onboarding
  Future<void> setHasSeenOnboarding(bool value) async {
    await savePreference(_hasSeenOnboardingKey, value);
  }

  // Vérifier si l'utilisateur a vu l'onboarding
  Future<bool> hasSeenOnboarding() async {
    return await getPreference(_hasSeenOnboardingKey) ?? false;
  }

  // Effacer les données de l'onboarding
  Future<void> clearOnboardingData() async {
    await removePreference(_hasSeenOnboardingKey);
  }

// ============================================================================
// Méthodes pour la supression de toutes les données de session sauf l'onboarding et l'utilisateur
// ============================================================================

  // Supprimer toutes les données de session sauf l'onboarding
  Future<void> clearSession() async {
    // Supprimer toutes les données sécurisées sauf celles liées à l'onboarding
    final allKeys = await _storage.readAll();
    for (var key in allKeys.keys) {
      if (key != 'user_id') {
        // Ne pas supprimer l'ID utilisateur
        await _storage.delete(key: key);
      }
    }

    // Supprimer toutes les données dans SharedPreferences sauf celles liées à l'onboarding
    final prefs = await _prefs;
    final allPrefsKeys = prefs.getKeys();
    for (var key in allPrefsKeys) {
      if (key != _hasSeenOnboardingKey) {
        await prefs.remove(key);
      }
    }
  }
}
