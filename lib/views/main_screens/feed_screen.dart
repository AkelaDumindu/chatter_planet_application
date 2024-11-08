import 'package:chatter_planet_application/models/post_model.dart';
import 'package:chatter_planet_application/services/feeds/feed_service.dart';
import 'package:chatter_planet_application/utilz/colors.dart';
import 'package:chatter_planet_application/widget/main/feed/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  Future<void> _deletePost(
      String postId, String postUrl, BuildContext context) async {
    try {
      await FeedService().deletePost(
        postId: postId,
        postUrl: postUrl,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post deleted successfully'),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting post'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Post>>(
        stream: FeedService().getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Column(
                children: [
                  PostWidget(
                    post: post,
                    currentUserId: FirebaseAuth.instance.currentUser!.uid,
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  Divider(
                    color: mainWhiteColor.withOpacity(0.1),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
