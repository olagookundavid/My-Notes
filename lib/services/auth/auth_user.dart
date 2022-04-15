import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified, this.email);
  factory AuthUser.fromFirebase(User user) => AuthUser(
        user.emailVerified,
        user.email,
      );
}
