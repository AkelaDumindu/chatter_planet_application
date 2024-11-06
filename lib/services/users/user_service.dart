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
}
