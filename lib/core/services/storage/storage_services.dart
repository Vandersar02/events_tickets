import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}
