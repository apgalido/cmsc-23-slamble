import 'package:flutter/material.dart';
import 'package:mini_project/screens/home_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_page.dart';
import 'friends_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  String signInErrorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo,
                heading,
                usernameField,
                passwordField,
                if (signInErrorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      signInErrorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                submitButton,
                googleSignInButton,
                signUpButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get logo => Padding(
        padding: const EdgeInsets.only(bottom: 1, top: 0),
        child: Image.asset(
          'assets/images/slamble_logo.png',
          width: 320,
          height: 320,
        ),
      );

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 20, top: 0),
        child: Text(
          "Sign In",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
      );

  Widget get usernameField => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFFDBB27)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: "Username",
            labelStyle: const TextStyle(color: Colors.black), // Default color
            floatingLabelStyle:
                const TextStyle(color: Colors.black), // Color when focused
          ),
          onSaved: (value) => username = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your username.";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFFDBB27)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.black), // Default color
            floatingLabelStyle: const TextStyle(color: Colors.black),
          ),
          obscureText: true,
          onSaved: (value) => password = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password.";
            }
            return null;
          },
        ),
      );

  Widget get submitButton => SizedBox(
        width: 330, // Specify the desired width here
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              String message = await context
                  .read<UserAuthProvider>()
                  .authService
                  .signInWithUsername(username!, password!);

              if (mounted) {
                setState(() {
                  signInErrorMessage = message;
                });

                if (message.isEmpty) {
                  // Schedule navigation after the current build phase
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  });
                }
              }
            }
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFFFDBB27)),
          ),
          child: const Text(
            "Sign In to Slamble",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );

  Widget get signUpButton => Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No account yet?",
                style: TextStyle(
                    color: Colors.black, fontSize: 15, fontFamily: 'Poppins')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text("Sign Up",
                  style: TextStyle(
                      color: Color(0xFFFDBB27),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
            ),
          ],
        ),
      );

  Widget get googleSignInButton => SizedBox(
        width: 330,
        child: ElevatedButton(
          onPressed: () async {
            String message =
                await context.read<UserAuthProvider>().signInWithGoogle();

            if (message.isEmpty) {
              String userId = context.read<UserAuthProvider>().user!.uid;

              // Schedule navigation after the current build phase
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendsPage(userId: userId)),
                );
              });
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            }
          },
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(const Color(0xFFFDBB27))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/google_icon.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Sign In with Google",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'))
          ]),
        ),
      );
}
