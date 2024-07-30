// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/api/firebase_user_api.dart';
import 'package:mini_project/models/user.dart';

class UserProvider with ChangeNotifier {
  Stream<DocumentSnapshot>? _userStream;
  final FirebaseUserApi firebaseService = FirebaseUserApi();
  final String userId;

  UserProvider(this.userId) {
    fetchUser(userId);
  }

  // Getter
  Stream<DocumentSnapshot>? get user => _userStream;

  // Fetch current User from Firestore
  void fetchUser(String userId) {
    _userStream = firebaseService.getUser(userId);
    notifyListeners();
  }

  // User: edit a User User and update it in Firestore
  void editUsernickname(UserModel user, String newValue) {
    firebaseService.editUsernickname(userId, newValue).then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editUserage(UserModel user, int newValue) {
    firebaseService.editUserage(userId, newValue).then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editUserrelationshipStatus(UserModel user, bool newValue) {
    firebaseService
        .editUserrelationshipStatus(userId, newValue)
        .then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editUserhappinessLevel(UserModel user, int newValue) {
    firebaseService.editUserhappinessLevel(userId, newValue).then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editUsersuperpower(UserModel user, String newValue) {
    firebaseService.editUsersuperpower(userId, newValue).then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editUsermotto(UserModel user, String newValue) {
    firebaseService.editUsermotto(userId, newValue).then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editUserprofilePhotoUrl(UserModel user, String? url) {
    // user.profilePhotoUrl = url;
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user.id)
    //     .update({'profilePhotoUrl': url});
    // notifyListeners();
    firebaseService.editUserProfilePhotoUrl(userId, url).then((message) {
      print(message);
    });
    notifyListeners();
  }
}
