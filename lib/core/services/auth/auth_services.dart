import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Création d'un nouvel utilisateur dans la base de données
  Future<void> createUserInDatabase(User user, String email) async {
    try {
      await supabase.from('users').insert({
        'id': user.id,
        'email': email,
        'profilePictureUrl': '',
        'isOnline': true,
        'isOrganizer': false,
        'isActive': true,
        'created_at': DateTime.now().toIso8601String(),
        'lastActive': null,
        'preferences': [],
        'groups': [],
        'chatRooms': [],
      });
    } catch (error) {
      debugPrint(
          "Erreur lors de l'ajout de l'utilisateur dans la base de données: $error");
    }
  }

  // Récupérer les données utilisateur
  // Future<Map<String, dynamic>?> getUserData(String userId) async {
  //   try {
  //     final response =
  //         await supabase.from('users').select().eq('id', userId).single();
  //     if (response.isNotEmpty) {
  //       debugPrint(
  //           "Erreur lors de la récupération des données utilisateur: ${response.error!.message}");
  //       return null;
  //     }
  //     return response.values.first;
  //   } catch (error) {
  //     debugPrint(
  //         "Erreur lors de la récupération des données utilisateur: $error");
  //     return null;
  //   }
  // }

  // Mettre à jour le statut en ligne de l'utilisateur
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      await supabase
          .from('users')
          .update({'isOnline': isOnline}).eq('id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour du statut en ligne: $error");
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      await supabase.from('users').delete().eq('id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la suppression de l'utilisateur: $error");
    }
  }

  // Mettre à jour les informations de profil de l'utilisateur
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await supabase.from('users').update(data).eq('id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour du profil utilisateur: $error");
    }
  }

  // Mettre à jour la photo de profil de l'utilisateur
  Future<void> updateUserProfilePicture(
      String userId, String profilePictureUrl) async {
    try {
      await supabase
          .from('users')
          .update({'profilePictureUrl': profilePictureUrl}).eq('id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour de la photo de profil: $error");
    }
  }

  // Mettre à jour le nom de l'utilisateur
  Future<void> updateUserName(String userId, String name) async {
    try {
      await supabase.from('users').update({'name': name}).eq('id', userId);
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour du nom d'utilisateur: $error");
    }
  }

  // Mettre à jour l'email de l'utilisateur
  Future<void> updateUserEmail(String userId, String email) async {
    try {
      await supabase.from('users').update({'email': email}).eq('id', userId);
    } catch (error) {
      debugPrint(
          "Erreur lors de la mise à jour de l'email utilisateur: $error");
    }
  }

  // Mettre à jour les préférences de l'utilisateur
  Future<void> updateUserPreferences(
      String userId, List<String> preferences) async {
    try {
      await supabase
          .from('users')
          .update({'preferences': preferences}).eq('id', userId);
    } catch (error) {
      debugPrint(
          "Erreur lors de la mise à jour des préférences utilisateur: $error");
    }
  }
}
