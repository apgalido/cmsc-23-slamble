import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_project/models/friend.dart';

class FirebaseFriendAPI {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllFriends(String userId) {
    return db.collection("users").doc(userId).collection("friends").snapshots();
  }

  Future<DocumentReference> addFriend(
      String userId, Map<String, dynamic> friend) async {
    try {
      DocumentReference documentReference = await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .add(friend);
      return documentReference;
    } on FirebaseException catch (e) {
      throw Exception("Failed with error ${e.code}");
    }
  }

  Future<String> updateFriendWithId(String userId, Friend friend) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friend.id)
          .set(friend.toJson());
      return "Successfully added Friend with ID!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> deleteFriend(String userId, String friendId) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .delete();
      return "Successfully deleted Friend!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editFriendnickname(
      String userId, String friendId, String newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .update({"nickname": newValue});

      return "Successfully edited Friend's nickname!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editFriendage(
      String userId, String friendId, int newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .update({"age": newValue});

      return "Successfully edited Friend's age!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editFriendrelationshipStatus(
      String userId, String friendId, bool newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .update({"relationshipStatus": newValue});

      return "Successfully edited Friend's relationship status!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editFriendhappinessLevel(
      String userId, String friendId, int newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .update({"happinessLevel": newValue});

      return "Successfully edited Friend's happiness level!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editFriendsuperpower(
      String userId, String friendId, String newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .update({"superpower": newValue});

      return "Successfully edited Friend's supoerpower!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editFriendmotto(
      String userId, String friendId, String newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .update({"motto": newValue});

      return "Successfully edited Friend's motto!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editFriendprofilePhotoUrl(
      String userId, String friendId, String? newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .doc(friendId)
          .update({"profilePhotoUrl": newValue});

      return "Successfully edited Friend's motto!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }
}
