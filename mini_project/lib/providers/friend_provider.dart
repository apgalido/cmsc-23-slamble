// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/api/firebase_friend_api.dart';
import 'package:mini_project/models/friend.dart';

class FriendListProvider with ChangeNotifier {
  Stream<QuerySnapshot>? _friendsStream;
  final FirebaseFriendAPI firebaseService = FirebaseFriendAPI();
  final String userId;

  FriendListProvider(this.userId) {
    fetchFriends(userId);
  }

  // Getter
  Stream<QuerySnapshot>? get friends => _friendsStream;

  // Fetch all friends from Firestore
  void fetchFriends(String userId) {
    _friendsStream = firebaseService.getAllFriends(userId);
    // notifyListeners();
  }

  // Add a new friend and store it in Firestore
  void addFriend(Friend friend) {
    firebaseService
        .addFriend(userId, friend.toJson())
        .then((documentReference) {
      // Retrieve the auto-generated ID
      String generatedId = documentReference.id;

      // Update the Friend object with the auto-generated ID
      friend.id = generatedId;

      // Save the updated Friend object back to Firestore
      firebaseService.updateFriendWithId(userId, friend).then((message) {
        print(message);
        notifyListeners();
      });
    }).catchError((error) {
      print("Failed to add friend: $error");
    });
  }

  // Friend: edit a Friend friend and update it in Firestore
  void editFriendnickname(Friend friend, String newValue) {
    firebaseService
        .editFriendnickname(userId, friend.id, newValue)
        .then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editFriendage(Friend friend, int newValue) {
    firebaseService.editFriendage(userId, friend.id, newValue).then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editFriendrelationshipStatus(Friend friend, bool newValue) {
    firebaseService
        .editFriendrelationshipStatus(userId, friend.id, newValue)
        .then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editFriendhappinessLevel(Friend friend, int newValue) {
    firebaseService
        .editFriendhappinessLevel(userId, friend.id, newValue)
        .then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editFriendsuperpower(Friend friend, String newValue) {
    firebaseService
        .editFriendsuperpower(userId, friend.id, newValue)
        .then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editFriendmotto(Friend friend, String newValue) {
    firebaseService
        .editFriendmotto(userId, friend.id, newValue)
        .then((message) {
      print(message);
    });
    notifyListeners();
  }

  void editFriendprofilePhotoUrl(Friend friend, String? url) {
    firebaseService
        .editFriendprofilePhotoUrl(userId, friend.id, url)
        .then((message) {
      print(message);
    });
    notifyListeners();
  }

  // Delete a friend and remove it from Firestore
  Future<void> deleteFriend(Friend friend) async {
    String message = await firebaseService.deleteFriend(userId, friend.id);
    print(message);
    notifyListeners();
  }
}
