import 'package:chatter_planet_application/models/reels_model.dart';
import 'package:chatter_planet_application/services/reels/reel_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReelService {
  final CollectionReference _reelsCollection =
      FirebaseFirestore.instance.collection('reels');

  // Save a reel in Firestore
  Future<void> saveReel(Map<String, dynamic> reelDetails) async {
    try {
      final reel = Reel(
        caption: reelDetails['caption'],
        videoUrl: reelDetails['videoUrl'],
        userId: reelDetails['userId'],
        username: reelDetails['userName'],
        reelId: '',
        datePublished: DateTime.now(),
        profileImage: reelDetails['profileImege'],
      );

      final docRef = await _reelsCollection.add(reel.toJson());
      await docRef.update({'reelId': docRef.id});
    } catch (e) {
      print(e);
    }
  }

  // Fetch reels from Firestore
  Stream<QuerySnapshot> getReels() {
    return _reelsCollection.snapshots();
  }

  // Delete a reel from Firestore
  Future<void> deleteReel(Reel reel) async {
    try {
      await _reelsCollection.doc(reel.reelId).delete();
      // Delete the reel from Firebase Storage
      await ReelStorageService().deleteVideo(videoUrl: reel.videoUrl);
    } catch (e) {
      print(e);
    }
  }
}
