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

  // Récupère la préférence par titre
  Future<dynamic> getPreferenceByTitle(String title) async {
    try {
      final response = await supabase
          .from('preferences')
          .select('id, title, icon')
          .eq('title', title)
          .single();

      if (response.isNotEmpty) {
        return response;
      } else {
        print("Erreur lors de la récupération de la préférence");
        return null;
      }
    } catch (error) {
      print("Erreur lors de la récupération de la préférence");
      return null;
    }
  }

  // Met à jour ou insère une préférence par ID, titre et icône
  Future<void> setPreference(String id, String title, String icon) async {
    try {
      final preferenceData = {
        'id': id,
        'title': title,
        'icon': icon,
      };

      final response = await supabase
          .from('preferences')
          .upsert(preferenceData)
          .eq('id', id);

      if (response.error != null) {
        print("Erreur lors de l'insertion/mise à jour de la préférence");
      }
    } catch (error) {
      print("Erreur lors de l'insertion/mise à jour de la préférence");
    }
  }
}
