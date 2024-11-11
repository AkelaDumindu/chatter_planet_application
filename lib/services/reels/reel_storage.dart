import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ReelStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadVideo(
      {required File videoFile, required String userId}) async {
    try {
      // Generate a unique file name
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      // Create a reference to the video file in Firebase Storage
      Reference ref = _storage.ref().child('reel').child("$userId/$fileName");

      // Upload the file to Firebase Storage
      await ref.putFile(videoFile);

      // Get the download URL for the uploaded file
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      throw e;
    }
  }

  // Delete video from Firebase Storage
  Future<void> deleteVideo({required String videoUrl}) async {
    try {
      // Create a reference to the video file in Firebase Storage
      Reference ref = _storage.refFromURL(videoUrl);

      // Delete the file from Firebase Storage
      await ref.delete();
    } catch (e) {
      print('Error deleting video: $e');
      throw e;
    }
  }
}
