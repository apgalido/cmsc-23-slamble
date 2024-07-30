import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? username;
  String? email;
  String? password;
  List<String> contactNumbers = [];

  final contactNumberController = TextEditingController();

  @override
  void dispose() {
    contactNumberController.dispose();
    super.dispose();
  }

  void addContactNumber() {
    if (contactNumberController.text.isNotEmpty) {
      setState(() {
        contactNumbers.add(contactNumberController.text);
        contactNumberController.clear();
      });
    }
  }

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
                nameField,
                usernameField,
                emailField,
                passwordField,
                contactnumbersField,
                submitButton,
                signInButton
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get logo => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Image.asset(
          'assets/images/slamble_logo.png',
          width: 320,
          height: 320,
        ),
      );

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
      );

  Widget get nameField => Padding(
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
            labelText: "Name",
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
          ),
          onSaved: (value) => setState(() => name = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your name.";
            }
            return null;
          },
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
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
          ),
          onSaved: (value) => setState(() => username = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a username.";
            }
            return null;
          },
        ),
      );

  Widget get emailField => Padding(
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
            labelText: "Email",
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
          ),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid email.";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
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
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
          ),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a password.";
            }
            return null;
          },
        ),
      );

  Widget get contactnumbersField => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: contactNumberController,
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
                      labelText: "Contact Number",
                      labelStyle: const TextStyle(color: Colors.black),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (contactNumbers.isEmpty) {
                        return "Please enter at least one contact number.";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xFFFDBB27)),
                  ),
                  onPressed: addContactNumber,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0, // Space between the chips horizontally
              runSpacing: 4.0, // Space between the chips vertically
              children: contactNumbers.map((number) {
                return Chip(
                  label: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  avatar: const Icon(Icons.phone, color: Colors.black),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.black),
                  onDeleted: () {
                    setState(() {
                      contactNumbers.remove(number);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      );

  Widget get submitButton => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await context.read<UserAuthProvider>().authService.signUp(
                name: name!,
                username: username!,
                email: email!,
                password: password!,
                contactNumbers: contactNumbers);

            // check if the widget hasn't been disposed of after an asynchronous action
            if (mounted) {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/signin');
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFFFDBB27)),
        ),
        child: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      );

  Widget get signInButton => Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?",
                style: TextStyle(
                    color: Colors.black, fontSize: 15, fontFamily: 'Poppins')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Sign In",
                  style: TextStyle(
                      color: Color(0xFFFDBB27),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
            ),
          ],
        ),
      );
}
