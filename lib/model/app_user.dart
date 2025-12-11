import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String role;
  final String username;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.username,
  });

  factory AppUser.fromFirebase(User user, String role, String? username) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      role: role,
      username: username ?? 'User',
    );
  }
}
