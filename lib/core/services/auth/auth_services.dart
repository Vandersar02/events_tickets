import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Vérifie si un utilisateur existe dans la table `users`
  Future<bool> userExists(String userId) async {
    try {
      final response =
          await supabase.from('users').select().eq('user_id', userId).single();
      return response.isNotEmpty;
    } catch (error) {
      debugPrint(
          "Erreur lors de la vérification de l'existence de l'utilisateur: $error");
      return false;
    }
  }

  // Crée un nouvel utilisateur dans la table `users`
  Future<void> createUserInDatabase(User? user, {String? name}) async {
    try {
      await supabase.from('users').insert({
        'user_id': user!.id,
        'name': name ?? user.email!.split('@')[0],
        'email': user.email,
        'profile_picture_url': user.userMetadata?['picture'] ?? '',
        'is_organiser': false,
        'is_online': true,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
        'preferences': [],
        'groups': [],
        'chat_rooms': [],
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
      // return response.data;
      return response;
    } catch (error) {
      debugPrint(
          "Erreur lors de la récupération des données utilisateur: $error");
      return null;
    }
  }

  // Met à jour le statut en ligne de l'utilisateur
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      await supabase
          .from('users')
          .update({'is_online': isOnline}).eq('user_id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour du statut en ligne: $error");
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

  // Met à jour les informations de profil de l'utilisateur
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await supabase.from('users').update(data).eq('user_id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour du profil utilisateur: $error");
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
}
