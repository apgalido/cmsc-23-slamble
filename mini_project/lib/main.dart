import 'package:mini_project/firebase_options.dart';
import 'package:mini_project/providers/auth_provider.dart';
import 'package:mini_project/providers/friend_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/providers/user_provider.dart';
import 'package:mini_project/screens/friends_page.dart';
import 'package:mini_project/screens/home_page.dart';
import 'package:mini_project/screens/profile_page.dart';
import 'package:mini_project/screens/signin_page.dart';
import 'package:mini_project/screens/signup_page.dart';
import 'package:mini_project/screens/slambook_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserAuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuthProvider>(
      builder: (context, userAuthProvider, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => FriendListProvider(
                userAuthProvider.user?.uid ?? '',
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => UserProvider(
                userAuthProvider.user?.uid ?? '',
              ),
            ),
          ],
          child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'Poppins',
              textTheme: const TextTheme(
                bodyLarge: TextStyle(fontFamily: 'Poppins'),
                bodyMedium: TextStyle(fontFamily: 'Poppins'),
                displayLarge: TextStyle(fontFamily: 'Poppins'),
                displayMedium: TextStyle(fontFamily: 'Poppins'),
                displaySmall: TextStyle(fontFamily: 'Poppins'),
                headlineMedium: TextStyle(fontFamily: 'Poppins'),
                headlineSmall: TextStyle(fontFamily: 'Poppins'),
                titleLarge: TextStyle(fontFamily: 'Poppins'),
                titleMedium: TextStyle(fontFamily: 'Poppins'),
                titleSmall: TextStyle(fontFamily: 'Poppins'),
                bodySmall: TextStyle(fontFamily: 'Poppins'),
                labelLarge: TextStyle(fontFamily: 'Poppins'),
                labelSmall: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const HomePage(),
              '/signin': (context) => const SignInPage(),
              '/signup': (context) => const SignUpPage(),
              '/profile': (context) => const ProfilePage(),
              '/friends': (context) => FriendsPage(
                    userId:
                        Provider.of<UserAuthProvider>(context, listen: false)
                                .user
                                ?.uid ??
                            '',
                  ),
              '/slambook': (context) => const SlambookPage(),
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => const PageNotFound(),
            ),
          ),
        );
      },
    );
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("PAGE NOT FOUND"),
      ),
    );
  }
}
