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

  // Fetch the posts as a stream
  //This methode will return a stream of list of posts , a stream is a sequence of asynchronous events ordered in time and the stream will return a list of posts.

  Stream<List<Post>> getPostsStream() {
    return _feedCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // use for that we want to create new collection like postlike, and store no of like in that collection
  // method for like post
  //[ Here the like post methode will take two parameters the post id and the user id and it will add a document to the likes subcollection and update the likes count in the post document.]
  Future<void> likePost(
      {required String postId, required String userId}) async {
    try {
      // create sub collection likes in feed, that store in postLikeRef
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);

      // Add a document to the likes subcollection(store time, userId, postId)
      await postLikesRef.set({'likedAt': Timestamp.now()});

      // Update the likes count in the post document
      final postDoc = await _feedCollection.doc(postId).get();
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      final newLikesCount = post.likes + 1;

      await _feedCollection.doc(postId).update({'likes': newLikesCount});

      print('Post liked successfully');
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  //  method for delete like

  Future<void> disLikePost(
      {required String postId, required String userId}) async {
    try {
      // create sub collection likes in feed, that store in postLikeRef
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);

      // Delete the document from the likes subcollection
      await postLikesRef.delete();

      // Update the likes count in the post document
      final postDoc = await _feedCollection.doc(postId).get();
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
      final newLikesCount = post.likes - 1;

      await _feedCollection.doc(postId).update({'likes': newLikesCount});

      print('Post unliked successfully');
    } catch (e) {
      print('Error unliking post: $e');
    }
  }

  // Check if a user has liked a post
  Future<bool> hasUserLikedPost(
      {required String postId, required String userId}) async {
    try {
      final postLikesRef =
          _feedCollection.doc(postId).collection('likes').doc(userId);
      // Check if the like document exists
      final doc = await postLikesRef.get();
      return doc.exists; //if have user like do exist like true or else false
    } catch (e) {
      print('Error checking if user liked post: $e');
      return false;
    }
  }

  // delete a post firebase databse
  Future<void> deletePost(
      {required String postId, required String postUrl}) async {
    try {
      // delete post
      await _feedCollection.doc(postId).delete();
//call deleteImage function for delete image
      await FeedStorageService().deleteImage(imageUrl: postUrl);
      print("Post deleted successfully");
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  //gets all posts of relavent user

  Future<List<String>> getUserPosts(String userId) async {
    try {
      final userPosts = await _feedCollection
          .where('userId', isEqualTo: userId)
          .get()
          .then((snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
      return userPosts.map((post) => post.postUrl).toList();
    } catch (e) {
      print('Error fetching user posts: $e');
      return [];
    }
  }
}
