import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserServices {
  final supabase = Supabase.instance.client;

  // Crée un nouvel utilisateur dans la table `users`
  Future<void> createUserInDatabase(User? user, {String? name}) async {
    try {
      await supabase.from('users').insert({
        'user_id': user!.id,
        'birthdate': user.userMetadata?['birthdate'] ?? '',
        'age': user.userMetadata?['age'] ?? 0,
        'gender': user.userMetadata?['gender'] ?? '',
        'email': user.email,
        'profile_picture_url': user.userMetadata?['picture'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'preferences_list': [],
        'tickets_list': [],
        'posts': [],
      });
    } catch (error) {
      debugPrint(
          "Erreur lors de l'ajout de l'utilisateur dans la base de données: $error");
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

  // Met à jour la photo de profil de l'utilisateur
  Future<void> updateUserProfilePicture(
      String userId, String profilePictureUrl) async {
    try {
      await supabase.from('users').update(
          {'profile_picture_url': profilePictureUrl}).eq('user_id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour de la photo de profil: $error");
    }
  }

  // Met à jour le nom de l'utilisateur
  Future<void> updateUserName(String userId, String name) async {
    try {
      await supabase.from('users').update({'name': name}).eq('user_id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour du nom d'utilisateur: $error");
    }
  }

  // Met à jour l'email de l'utilisateur
  Future<void> updateUserEmail(String userId, String email) async {
    try {
      await supabase
          .from('users')
          .update({'email': email}).eq('user_id', userId);
    } catch (error) {
      debugPrint(
          "Erreur lors de la mise à jour de l'email utilisateur: $error");
    }
  }
}
