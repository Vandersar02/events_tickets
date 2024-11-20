import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:flutter/material.dart';

class PostServices {
  final supabase = Supabase.instance.client;

  Future<void> createPost(User? user, String post) async {
    try {
      await supabase.from('posts').insert({
        'user_id': user!.id,
        'post': post,
      });
    } catch (error) {
      debugPrint(
          "Erreur lors de l'ajout du post dans la base de données: $error");
    }
  }

  // Ajoute un post à l'utilisateur
  Future<void> addUserPost(String userId, String postId) async {
    try {
      final userData = await UserServices().getUserData(userId);
      if (userData != null) {
        List<dynamic> currentPosts = userData['posts'];
        currentPosts.add(postId);

        await supabase
            .from('users')
            .update({'posts': currentPosts}).eq('user_id', userId);
      }
    } catch (error) {
      debugPrint("Erreur lors de l'ajout du post à l'utilisateur: $error");
    }
  }
}
