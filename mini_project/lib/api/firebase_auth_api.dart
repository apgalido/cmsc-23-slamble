import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_project/models/user.dart';

class FirebaseAuthAPI {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User?> getUserStream() {
    return auth.authStateChanges();
  }

  User? getUser() {
    return auth.currentUser;
  }

  Future<UserModel?> getUserModel(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Future<String> signInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully signed in!";
    } on FirebaseAuthException catch (e) {
      return "Failed at error ${e.code}";
    }
  }

  Future<String> signInWithUsername(String username, String password) async {
    try {
      var querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return "Username not found.";
      }

      var userDoc = querySnapshot.docs.first;
      var email = userDoc.get('email');

      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully signed in!";
    } on FirebaseAuthException catch (e) {
      return "Failed at error ${e.code}";
    }
  }

  Future<String> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    required List<String> contactNumbers,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        UserModel newUser = UserModel(
          id: user.uid,
          name: name,
          username: username,
          email: email,
          password: password,
          contactNumbers: contactNumbers,
        );

        await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return "Successfully signed up!";
      } else {
        return "Failed to create user.";
      }
    } on FirebaseAuthException catch (e) {
      return "Failed at error ${e.code}";
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return "Google sign in aborted by user";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Check if the user is already in Firestore
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // Add the user to Firestore if not present
          UserModel newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'Anonymous',
            username: user.email!.split('@')[0],
            email: user.email!,
            contactNumbers: [],
            password: '',
          );
          await firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toJson());
        }
        return "Successfully signed in with Google!";
      } else {
        return "Failed to sign in with Google";
      }
    } on FirebaseAuthException catch (e) {
      return "Failed at error ${e.code}";
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
