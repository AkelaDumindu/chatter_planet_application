class Post {
  final String postCaption;
  final Mood mood;
  final String userId;
  final String username;
  final int likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  Post(
      {required this.postCaption,
      required this.mood,
      required this.userId,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage});
}
