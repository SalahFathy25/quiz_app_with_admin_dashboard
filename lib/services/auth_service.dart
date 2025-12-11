import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/model/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final userData = await _getUserData(user.uid);
      return AppUser.fromFirebase(
        user,
        userData['role'] ?? 'user',
        userData['username'],
      );
    });
  }

  Future<AppUser> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      final userData = await _getUserData(user.uid);
      return AppUser.fromFirebase(
        user,
        userData['role'] ?? 'user',
        userData['username'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser> signUp(
    String email,
    String password,
    String role,
    String username,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await _firestore.collection('users').doc(user.uid).set({
        'role': role,
        'username': username,
      });
      return AppUser.fromFirebase(user, role, username);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() ?? {'role': 'user', 'username': 'User'};
    } catch (e) {
      return {'role': 'user', 'username': 'User'};
    }
  }
}
