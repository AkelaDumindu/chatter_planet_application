import 'package:chatter_planet_application/models/user_model.dart';
import 'package:chatter_planet_application/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
// create a collection refernce
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // save the user in the firestore database

  Future<void> saveUser(UserModel user) async {
    try {
      // create user with email and password
      final userCredential = await AuthServices()
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password);
      // Retrieve the user ID from the created user
      final userId = userCredential.user?.uid;

      if (userId != null) {
        // create new user documnet in firestore
        final userRef = _usersCollection.doc(userId);

        // Create a user map with the userId field
        final userMap = user.toMap();
        userMap['userId'] = userId;

        // set user data in firestore
        await userRef.set(userMap);

        print('User saved successfully with ID: $userId');
      } else {
        print('Error: User ID is null');
      }
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  //get user details by id
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print('Error getting user: $error');
    }
    return null;
  }

  //get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _usersCollection.get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Error getting users: $error');
      return [];
    }
  }

  //for follow users to create seperate collection

  //methode to follow user and update the user followers count

  //LOGIC EXPLANATION

  // 1. Add the current user to the followers collection of the user to follow
  // 2. Update the followers count for the user to follow
  // 3. Update the following count for the current user

  Future<void> followUser(String currentUserId, String userToFollowId) async {
    try {
      // Add the user to the followers collection
      await _usersCollection
          .doc(userToFollowId)
          .collection("followers")
          .doc(currentUserId)
          .set({
        'followedAt': Timestamp.now(),
      });

      // Update follower count for the followed user
      final followedUserRef = _usersCollection.doc(userToFollowId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final followedUserDoc = await transaction.get(followedUserRef);
        if (followedUserDoc.exists) {
          final data = followedUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followersCount'] ?? 0;
          transaction
              .update(followedUserRef, {'followersCount': currentCount + 1});
        }
      });

      //  update following count for the current user
      final currentUserRef = _usersCollection.doc(currentUserId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentUserDoc = await transaction.get(currentUserRef);
        if (currentUserDoc.exists) {
          final data = currentUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followingCount'] ?? 0;
          transaction
              .update(currentUserRef, {'followingCount': currentCount + 1});
        }
      });
      print('User followed successfully');
    } catch (e) {
      print('Error following user: $e');
    }
  }

  //methode to unfollow user and update the user followers count

  //LOGIC EXPLANATION

  // 1. Remove the current user from the followers collection of the user to unfollow
  // 2. Update the followers count for the user to unfollow
  // 3. Update the following count for the current user

  Future<void> unfollowUser(
      String currentUserId, String userToUnfollowId) async {
    try {
      // Remove the user from the followers collection
      await _usersCollection
          .doc(userToUnfollowId)
          .collection('followers')
          .doc(currentUserId)
          .delete();

      // Update follower count for the unfollowed user
      final unfollowedUserRef = _usersCollection.doc(userToUnfollowId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final unfollowedUserDoc = await transaction.get(unfollowedUserRef);
        if (unfollowedUserDoc.exists) {
          final data = unfollowedUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followersCount'] ?? 0;
          transaction
              .update(unfollowedUserRef, {'followersCount': currentCount - 1});
        }
      });

      // Update following count for the current user
      final currentUserRef = _usersCollection.doc(currentUserId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentUserDoc = await transaction.get(currentUserRef);
        if (currentUserDoc.exists) {
          final data = currentUserDoc.data() as Map<String, dynamic>;
          final currentCount = data['followingCount'] ?? 0;
          transaction
              .update(currentUserRef, {'followingCount': currentCount - 1});
        }
      });

      print('User unfollowed successfully');
    } catch (e) {
      print('Error unfollowing user: $e');
    }
  }

  //method to check if current user follow user
  Future<bool> isFollowing(String currentUserId, String userToCheckId) async {
    try {
      final docSnapshot = await _usersCollection
          .doc(userToCheckId)
          .collection('followers')
          .doc(currentUserId)
          .get();

      // Returns true if the document exists, meaning the user is following
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking follow status: $e');
      return false; // Return false if there's an error
    }
  }

  // Get the count of followers for a user
  Future<int> getUserFollowersCount(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['followersCount'] ?? 0;
      }
      return 0; // Return 0 if the document doesn't exist
    } catch (error) {
      print('Error getting user followers count: $error');
      return 0;
    }
  }

  // Get the count of users the current user is following
  Future<int> getUserFollowingCount(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['followingCount'] ?? 0;
      }
      return 0; // Return 0 if the document doesn't exist
    } catch (error) {
      print('Error getting user following count: $error');
      return 0;
    }
  }
}
