import 'package:flutter/material.dart';
import 'package:mini_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SlambookDrawer extends StatelessWidget {
  const SlambookDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // DrawerHeader
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Image.asset(
              'assets/images/slamble_logo.png',
              width: 200,
              height: 200,
            ),
          ),
          // List of navigation items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  title: const Text(
                    "Friends",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/friends');
                  },
                ),
                ListTile(
                  title: const Text(
                    "Slambook",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/slambook',
                    );
                  },
                ),
              ],
            ),
          ),
          // Logout button at the bottom
          ListTile(
            title: const Text(
              "Logout",
              style: TextStyle(
                  color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              // context.read<UserAuthProvider>().signOut();
              // Navigator.pop(context);

              // // Pop until the sign-in route is at the top of the stack
              // Navigator.popUntil(context, ModalRoute.withName('/signin'));
              // // Push the sign-in route
              // Navigator.pushReplacementNamed(context, '/signin');

              await context.read<UserAuthProvider>().signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              // Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
    );
  }
}
