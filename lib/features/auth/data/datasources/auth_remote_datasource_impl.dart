import 'package:flutter/material.dart';
import 'package:secvault/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;

  const AuthRemoteDatasourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> login(String? email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email!,
        password: password,
      );

      final user = userCredential.user!;

      return UserModel(
        uid: user.uid,
        email: user.email,
        name: user.displayName,
      );
    } catch (e) {
      debugPrint("Logging error: $e");
      rethrow;
    }
  }

  @override
  Future<UserModel> register(String? email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email!,
        password: password,
      );

      final user = userCredential.user!;

      return UserModel(
        email: user.email!,
        name: user.displayName,
        uid: user.uid,
      );
    } catch (e) {
      debugPrint("Registration error: $e");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      debugPrint("Logout error: $error");
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? user = _firebaseAuth.currentUser;

      if (user != null) {
        return UserModel(
          email: user.email,
          name: user.displayName,
          uid: user.uid,
        );
      }
    } catch (error) {
      debugPrint("Get current user error: $error");
      rethrow;
    }
  }
}
