import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    signInOption: SignInOption.standard,
  );
  User? _user;

  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google Sign In process...');

      // Check internet connection
      if (!await _checkInternetConnection()) {
        throw Exception('No internet connection available');
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      debugPrint('Google Sign In result: ${googleUser?.email}');

      if (googleUser == null) {
        debugPrint('Google Sign In was cancelled by user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint('Got Google Auth tokens');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      debugPrint('Created Firebase credential');

      try {
        // Sign in to Firebase with the Google credential
        final userCredential = await _auth.signInWithCredential(credential);
        debugPrint(
            'Firebase Sign In successful: ${userCredential.user?.email}');
        return userCredential;
      } catch (firebaseError) {
        debugPrint('Firebase Sign In Error: $firebaseError');

        // If we get a PigeonUserDetails error, try to get the current user
        if (firebaseError.toString().contains('PigeonUserDetails')) {
          final currentUser = _auth.currentUser;
          if (currentUser != null) {
            debugPrint('Using current user: ${currentUser.email}');
            // Since we can't create a UserCredential directly, we'll return null
            // and let the login screen handle the current user
            return null;
          }
        }
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow;
    } on SocketException catch (e) {
      debugPrint('Network Error: $e');
      throw Exception(
          'Network error occurred. Please check your internet connection.');
    } catch (e) {
      debugPrint('Error during Google Sign In: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Error during sign out: $e');
      rethrow;
    }
  }
}
