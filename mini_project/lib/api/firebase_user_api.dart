import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserApi {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> getUser(String userId) {
    return db.collection("users").doc(userId).snapshots();
  }

  Future<String> editUsernickname(String userId, String newValue) async {
    try {
      await db.collection("users").doc(userId).update({"nickname": newValue});

      return "Successfully edited nickname!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editUserage(String userId, int newValue) async {
    try {
      await db.collection("users").doc(userId).update({"age": newValue});

      return "Successfully edited age!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editUserrelationshipStatus(
      String userId, bool newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .update({"relationshipStatus": newValue});

      return "Successfully edited relationship status!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editUserhappinessLevel(String userId, int newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .update({"happinessLevel": newValue});

      return "Successfully edited happiness level!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editUsersuperpower(String userId, String newValue) async {
    try {
      await db.collection("users").doc(userId).update({"superpower": newValue});

      return "Successfully edited supoerpower!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editUsermotto(String userId, String newValue) async {
    try {
      await db.collection("users").doc(userId).update({"motto": newValue});

      return "Successfully edited motto!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> editUserProfilePhotoUrl(
      String userId, String? newValue) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .update({"profilePhotoUrl": newValue});

      return "Successfully edited profile photo!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }
}
