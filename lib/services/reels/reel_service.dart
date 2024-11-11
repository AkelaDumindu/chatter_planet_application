import 'package:chatter_planet_application/models/reels_model.dart';
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
}
