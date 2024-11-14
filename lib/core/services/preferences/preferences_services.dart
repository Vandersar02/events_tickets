import 'package:supabase_flutter/supabase_flutter.dart';

class PreferencesServices {
  final supabase = Supabase.instance.client;

  // Fonction pour mettre à jour les préférences utilisateur
  Future<void> updateUserPreferences(
      String userId, List<String> preferenceIds) async {
    try {
      // Supprime toutes les préférences existantes pour l'utilisateur
      await supabase.from('user_preferences').delete().eq('user_id', userId);

      // Crée une liste d'entrées pour les nouvelles préférences
      final newPreferences = preferenceIds.map((preferenceId) {
        return {'user_id': userId, 'preference_id': preferenceId};
      }).toList();

      // Insère les nouvelles préférences
      await supabase.from('user_preferences').insert(newPreferences);
    } catch (error) {
      print("Erreur lors de la mise à jour des préférences: $error");
    }
  }

  Future<dynamic> getPreference(String key) async {
    return await supabase
        .from('preferences')
        .select('value')
        .eq('key', key)
        .single();
  }

  Future<dynamic> setPreference(String key, dynamic value) async {
    return await supabase
        .from('preferences')
        .upsert({'key': key, 'value': value});
  }
}
