import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class PreferencesServices {
  final supabase = Supabase.instance.client;

  // Met à jour les préférences de l'utilisateur
  Future<void> updateUserPreferences(
      String userId, List<String> preferences) async {
    try {
      await supabase
          .from('users')
          .update({'preferences': preferences}).eq('user_id', userId);
    } catch (error) {
      debugPrint(
          "Erreur lors de la mise à jour des préférences utilisateur: $error");
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
