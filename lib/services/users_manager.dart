import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  const SessionManager();
  static const String _isLoggedInKey = 'isLoggedIn';

  // Méthode pour sauvegarder le statut de connexion
  Future<void> saveUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false; // Par défaut, retourne false
  }

  // Méthode pour supprimer le statut de connexion (déconnexion)
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }

  // Enregistrer une valeur
  Future<void> saveUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  // Récupérer une valeur
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
