import 'package:events_ticket/data/models/preference_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreferencesServices {
  final supabase = Supabase.instance.client;

  // Update user preferences
  Future<void> updateUserPreferences(
      String userId, List<String> preferenceIds) async {
    if (userId.isEmpty || preferenceIds.isEmpty) {
      print("User ID or preference IDs are empty.");
      return;
    }

    try {
      await supabase.from('user_preferences').delete().eq('user_id', userId);

      final newPreferences = preferenceIds.map((preferenceId) {
        return {'user_id': userId, 'preference_id': preferenceId};
      }).toList();

      if (newPreferences.isNotEmpty) {
        await supabase.from('user_preferences').insert(newPreferences);
      }
    } catch (error) {
      print("Error updating preferences: $error");
    }
  }

  // Get preference by title
  Future<PreferencesModel?> getPreferenceByTitle(String title) async {
    if (title.isEmpty) {
      print("Title is empty.");
      return null;
    }

    try {
      final response = await supabase
          .from('preferences')
          .select('id, title, icon')
          .eq('title', title)
          .single();

      if (response.isNotEmpty) {
        return PreferencesModel.fromMap(response);
      } else {
        print("Preference with title '$title' not found.");
        return null;
      }
    } catch (error) {
      print("Error retrieving preference: $error");
      return null;
    }
  }

  // Add or update a preference
  Future<void> setPreference(String id, String title, String icon) async {
    if (id.isEmpty || title.isEmpty) {
      print("ID or title is empty.");
      return;
    }

    try {
      final preferenceData = {
        'id': id,
        'title': title,
        'icon': icon,
      };

      await supabase.from('preferences').upsert(preferenceData);
    } catch (error) {
      print("Error inserting/updating preference: $error");
    }
  }

  // Fetch all preferences
  Future<List<PreferencesModel>> getAllPreferences() async {
    try {
      final response =
          await supabase.from('preferences').select('id, title, icon');
      if (response.isNotEmpty) {
        return (response as List<dynamic>)
            .map((data) => PreferencesModel.fromMap(data))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print("Error fetching all preferences: $error");
      return [];
    }
  }

  // Fetch user preferences
  Future<List<PreferencesModel>> getUserPreferences(String userId) async {
    if (userId.isEmpty) {
      print("User ID is empty.");
      return [];
    }

    try {
      final response = await supabase
          .from('user_preferences')
          .select('preference_id, preferences(id, title, icon)')
          .eq('user_id', userId);

      if (response.isNotEmpty) {
        return (response as List<dynamic>)
            .map((data) => PreferencesModel.fromMap(data['preferences']))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      print("Error fetching user preferences: $error");
      return [];
    }
  }
}
