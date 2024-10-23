import 'package:chatter_planet_application/exception/auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// regiter user with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error creating user: $e');
      throw Exception(e.toString());
    }
  }

  //sign in with email and password

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${mapFirebaseAuthExceptionCode(e.code)}');

      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  // Sign out

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } on FirebaseAuthException catch (e) {
      print('Error signing out: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
