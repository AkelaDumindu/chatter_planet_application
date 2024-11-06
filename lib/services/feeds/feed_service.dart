import 'dart:io';

import 'package:chatter_planet_application/models/post_model.dart';
import 'package:chatter_planet_application/services/feeds/feed_storage.dart';
import 'package:chatter_planet_application/utilz/functions/mood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedService {
  // Create a collection reference
  final CollectionReference _feedCollection =
      FirebaseFirestore.instance.collection('feed');

  // Save the post in the Firestore database
  Future<void> savePost(Map<String, dynamic> postDetails) async {
    try {
      String? postUrl;

      // Check if the post has an image
      if (postDetails['postImage'] != null &&
          postDetails['postImage'] is File) {
        postUrl = await FeedStorageService().uploadImage(
          postImage: postDetails['postImage'] as File,
          userId: postDetails['userId'] as String,
        );
      }

      // Create a new Post object
      final Post post = Post(
        postCaption: postDetails['postCaption'] as String? ?? '',
        mood: MoodExtension.fromString(postDetails['mood'] ?? 'happy'),
        userId: postDetails['userId'] as String? ?? '',
        username: postDetails['username'] as String? ?? '',
        likes: 0,
        postId: '', // This will be updated after adding to Firestore
        datePublished: DateTime.now(),
        postUrl: postUrl ?? '',
        profImage: postDetails['profImage'] as String? ?? '',
      );

      // Add the post to the collection
      final docRef = await _feedCollection.add(post.toJson());
      await docRef.update({'postId': docRef.id});
    } catch (error) {
      print('Error saving post: $error');
    }
  }
}
