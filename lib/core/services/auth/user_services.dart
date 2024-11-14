import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class UserServices {
  final supabase = Supabase.instance.client;

  // Crée un nouvel utilisateur dans la table `users`
  Future<void> createUserInDatabase(User? user, {String? name}) async {
    try {
      await supabase.from('users').insert({
        'user_id': user!.id,
        'name': name ?? user.userMetadata?['name'] ?? user.email?.split('@')[0],
        'email': user.email,
        'profile_picture_url': user.userMetadata?['picture'] ?? '',
        'date_of_birth': user.userMetadata?['avatar_url'] ?? '',
        'gender': user.userMetadata?['gender'] ?? '',
        'last_active': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        // 'preferences_list': [],
        // 'tickets_list': [],
        // 'posts_list': [],
      });
    } catch (error) {
      debugPrint(
          "Erreur lors de l'ajout de l'utilisateur dans la base de données: $error");
    }
  }

  Future<void> exampleOfUpdate(User? user) async {
    final userService = UserServices();

    // Exemple : mise à jour du nom
    await userService.updateUserField(user!.id, 'name', 'John Doe');

    // Exemple : mise à jour de la date de naissance
    await userService.updateUserField(user.id, 'date_of_birth', '1990-01-01');

    // Exemple : mise à jour du dernier accès
    await userService.updateUserField(
        user.id, 'last_active', DateTime.now().toIso8601String());
  }

  Future<void> updateUserField(
      String userId, String fieldName, dynamic value) async {
    try {
      final Map<String, dynamic> updateData = {fieldName: value};

      // Met à jour la colonne spécifiée dans la base de données
      await supabase.from('users').update(updateData).eq('user_id', userId);
    } catch (error) {
      debugPrint(
          "Erreur lors de la mise à jour de la colonne $fieldName: $error");
    }
  }

  // Récupère les données de l'utilisateur
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final response =
          await supabase.from('users').select().eq('user_id', userId).single();
      return response;
    } catch (error) {
      debugPrint(
          "Erreur lors de la récupération des données utilisateur: $error");
      return null;
    }
  }

  // Supprime un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      await supabase.from('users').delete().eq('user_id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la suppression de l'utilisateur: $error");
    }
  }
}
