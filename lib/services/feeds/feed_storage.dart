import 'package:firebase_storage/firebase_storage.dart';

class FeedStorageService {
//Firebase storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({required postImage, required userId}) async {
    //Create a reference to the image, here the image will be stored in the feed-images folder in the storage
    Reference ref =
        _storage.ref().child("feed-images").child("$userId/${DateTime.now()}");

    try {
      UploadTask task = ref.putFile(
        postImage,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return "";
    }
  }

  // delete image from cloud storage

  Future<void> deleteImage({required String imageUrl}) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
    } catch (e) {
      print(e);
    }
  }
}
