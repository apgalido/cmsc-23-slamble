import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_project/api/firebase_auth_api.dart';
import 'package:mini_project/models/user.dart';
import 'package:flutter/material.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> userStream;
  User? user;
  UserModel? userModel;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    userStream = authService.getUserStream();
    userStream.listen((user) async {
      debugPrint("User stream listener: user = $user");
      this.user = user;
      if (user != null) {
        await _loadUserModel(user.uid);
      } else {
        userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserModel(String uid) async {
    debugPrint("Loading user model for uid: $uid");
    userModel = await authService.getUserModel(uid);
    notifyListeners();
    debugPrint("Loaded user model: $userModel");
  }

  Future<String> signInWithEmail(String email, String password) async {
    debugPrint("Signing in with email: $email");
    String message = await authService.signInWithEmail(email, password);
    user = authService.getUser();
    if (user != null) {
      await _loadUserModel(user!.uid);
    }
    notifyListeners();
    debugPrint("Signed in user: ${user?.uid}");
    return message;
  }

  Future<String> signInWithUsername(String username, String password) async {
    debugPrint("Signing in with username: $username");
    String message = await authService.signInWithUsername(username, password);
    user = authService.getUser();
    if (user != null) {
      await _loadUserModel(user!.uid);
    }
    notifyListeners();
    debugPrint("Signed in user: ${user?.uid}");
    return message;
  }

  Future<String> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    required List<String> contactNumbers,
  }) async {
    String message = await authService.signUp(
      name: name,
      username: username,
      email: email,
      password: password,
      contactNumbers: contactNumbers,
    );
    user = authService.getUser();
    if (user != null) {
      await _loadUserModel(user!.uid);
    }
    notifyListeners();
    return message;
  }

  Future<String> signInWithGoogle() async {
    String message = await authService.signInWithGoogle();
    user = authService.getUser();
    if (user != null) {
      await _loadUserModel(user!.uid);
    }
    notifyListeners();
    return message;
  }

  Future<void> signOut() async {
    debugPrint("Signing out");
    await authService.signOut();
    user = null;
    userModel = null;
    notifyListeners();
    debugPrint("Signed out successfully");
  }
}
