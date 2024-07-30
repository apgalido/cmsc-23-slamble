import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/screens/friends_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;

    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error encountered! ${snapshot.error}"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData) {
            return const SignInPage();
          }

          // If the user is logged in, extract the userId and pass it to FriendsPage
          User? user = snapshot.data;
          String userId = user!.uid;

          // if user is logged in, display the scaffold containing the streambuilder for the todos
          print("User is logged in, navigating to FriendsPage!");
          return FriendsPage(userId: userId);
        });
  }
}
