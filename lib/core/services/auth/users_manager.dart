import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // Singleton pattern
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Marquer l'utilisateur comme connecté
  Future<void> setUserLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_isLoggedInKey, value);
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isUserLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Marquer l'utilisateur comme ayant vu l'onboarding
  Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_hasSeenOnboardingKey, value);
  }

  // Vérifier si l'utilisateur a vu l'onboarding
  Future<bool> hasSeenOnboarding() async {
    final prefs = await _prefs;
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  // Effacer les données de session de l'utilisateur
  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_hasSeenOnboardingKey);
  }
}
