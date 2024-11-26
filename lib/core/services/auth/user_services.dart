import 'package:events_ticket/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class UserServices {
  final supabase = Supabase.instance.client;

  // Crée un nouvel utilisateur dans la table `users`
  Future<void> createUserInDatabase(UserModel userModel) async {
    try {
      await supabase.from('users').insert(userModel.toJson());
    } catch (error) {
      debugPrint(
          "Erreur lors de l'ajout de l'utilisateur dans la base de données: $error");
    }
  }

  /// Met à jour les données de l'utilisateur
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

  Future<void> updateUserData(String userId, UserModel user) async {
    try {
      await supabase.from("users").update(user.toJson()).eq("user_id", userId);
    } catch (e) {
      debugPrint("$e");
    }
  }

  // Récupère les données de l'utilisateur
  Future<UserModel?> getUserData(String userId) async {
    try {
      final response =
          await supabase.from('users').select().eq('user_id', userId).single();
      return UserModel.fromJson(response);
    } catch (error) {
      debugPrint(
          "Erreur lors de la récupération des données utilisateur: $error");
      return null;
    }
  }

  // Supprime un utilisateur
  Future<bool> deleteUser(String userId) async {
    try {
      await supabase
          .from('users')
          .update({'is_active': false}).eq('user_id', userId);
      return true;
    } catch (error) {
      debugPrint("Erreur lors de la désactivation de l'utilisateur : $error");
      return false;
    }
  }
}
