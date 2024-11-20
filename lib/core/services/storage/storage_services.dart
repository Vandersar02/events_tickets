import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class StorageService {
  final supabase = Supabase.instance.client;
  final storage = Supabase.instance.client.storage;

  // Future<String?> uploadFile(File file, String fileName) async {}

  Future<String?> uploadUserProfileImage(File imageFile, String userId) async {
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

  // Upload un fichier dans Supabase Storage
  Future<String?> uploadMedia(File file, String path) async {
    try {
      final response =
          await supabase.storage.from('user_media').upload(path, file);
      return response; // Retourne l'URL du fichier
    } catch (error) {
      debugPrint("Erreur lors du téléchargement du média : $error");
      return null;
    }
  }

  // Supprimer un fichier dans Supabase Storage
  Future<bool> deleteMedia(String path) async {
    try {
      await supabase.storage.from('user_media').remove([path]);
      return true;
    } catch (error) {
      debugPrint("Erreur lors de la suppression du média : $error");
      return false;
    }
  }
}
