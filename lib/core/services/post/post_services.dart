import 'package:events_ticket/data/models/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class PostServices {
  final supabase = Supabase.instance.client;

  /// Créer un nouveau post
  Future<void> createPost({
    required String userId,
    String? eventId,
    String? mediaUrl,
    required String content,
  }) async {
    try {
      final response = await supabase.from('posts').insert({
        'user_id': userId,
        'event_id': eventId,
        'media_url': mediaUrl,
        'post': content,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (response.error != null) {
        debugPrint(
            "Erreur lors de la création du post : ${response.error!.message}");
      } else {
        debugPrint("Post créé avec succès !");
      }
    } catch (error) {
      debugPrint("Erreur lors de la création du post : $error");
    }
  }

  /// Récupérer un post spécifique avec ses relations
  Future<PostModel?> getPostById(String postId) async {
    try {
      final response = await supabase
          .from('posts')
          .select('*, user:users(*), event:events(*)')
          .eq('post_id', postId)
          .single();

      if (response.isEmpty) {
        return null;
      }

      return PostModel.fromJson(response as Map<String, dynamic>);
    } catch (error) {
      debugPrint("Erreur lors de la récupération du post : $error");
      return null;
    }
  }

  /// Récupérer tous les posts disponibles
  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await supabase
          .from('posts')
          .select('*, user:users!posts_posted_by_fkey(*), event:events(*)')
          .order('posted_at', ascending: false);

      if ((response as List).isEmpty) {
        return [];
      }

      List<PostModel> posts = [];
      for (var postData in response) {
        final likes = await getPostLikes(postData['id'] as String);
        postData['likes'] = likes;
        final post = PostModel.fromJson(postData);
        posts.add(post);
      }
      return posts;
    } catch (error) {
      debugPrint("Erreur lors de la récupération des posts : $error");
      return [];
    }
  }

  // Recuperer les likes d'un post
  Future<List<String>> getPostLikes(String postId) async {
    try {
      final response = await supabase
          .from('post_likes')
          .select('user_id')
          .eq('post_id', postId);

      if (response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((likeData) => likeData['user_id'] as String)
          .toList();
    } catch (error) {
      debugPrint("Erreur lors de la récupération des likes : $error");
      return [];
    }
  }

  /// Mettre à jour un post
  Future<void> updatePost(String postId, Map<String, dynamic> updates) async {
    try {
      final response =
          await supabase.from('posts').update(updates).eq('post_id', postId);

      if (response.error != null) {
        debugPrint(
            "Erreur lors de la mise à jour du post : ${response.error!.message}");
      } else {
        debugPrint("Post mis à jour avec succès !");
      }
    } catch (error) {
      debugPrint("Erreur lors de la mise à jour du post : $error");
    }
  }

  /// Supprimer un post
  Future<void> deletePost(String postId) async {
    try {
      final response =
          await supabase.from('posts').delete().eq('post_id', postId);

      if (response.error != null) {
        debugPrint(
            "Erreur lors de la suppression du post : ${response.error!.message}");
      } else {
        debugPrint("Post supprimé avec succès !");
      }
    } catch (error) {
      debugPrint("Erreur lors de la suppression du post : $error");
    }
  }
}
