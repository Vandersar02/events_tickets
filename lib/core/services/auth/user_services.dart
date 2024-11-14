import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class UserServices {
  final supabase = Supabase.instance.client;

  // Crée un nouvel utilisateur dans la table `users`
  Future<void> createUserInDatabase(User? user, {String? name}) async {
    try {
      await supabase.from('users').insert({
        'user_id': user!.id,
        'name': name ?? user.userMetadata?['name'] ?? user.email?.split('@')[0],
        'date_of_birth': user.userMetadata?['avatar_url'] ?? '',
        'gender': user.userMetadata?['gender'] ?? '',
        'email': user.email,
        'profile_picture_url': user.userMetadata?['picture'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'preferences_list': [],
        'tickets_list': [],
        'posts_list': [],
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

  Future<String?> uploadUserProfileImage(File imageFile, String userId) async {
    final storage = Supabase.instance.client.storage;

    try {
      final response = await storage
          .from('avatars')
          .upload('public/$userId/avatar.png', imageFile);

      if (response.isNotEmpty) {
        // URL du fichier stocké
        final imageUrl =
            storage.from('avatars').getPublicUrl('public/$userId/avatar.png');
        return imageUrl;
      } else {
        print("Erreur lors du téléchargement de l'image:");
        return null;
      }
    } catch (e) {
      print("Erreur: $e");
      return null;
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
