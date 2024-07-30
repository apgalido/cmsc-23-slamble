import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mini_project/providers/friend_provider.dart';
import 'package:mini_project/screens/friend_modal.dart';
import 'package:mini_project/models/friend.dart';
import 'package:mini_project/screens/friend_details_page.dart';
import 'package:mini_project/drawer.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  final String userId;

  const FriendsPage({super.key, required this.userId});

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  Future<void> scanQRCode() async {
    String qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    if (qrCode != '-1') {
      try {
        // Decode the JSON string into a Map<String, dynamic>
        final Map<String, dynamic> decodedJson = jsonDecode(qrCode);

        print('Decoded JSON: $decodedJson');

        // Create a Friend object from the decoded JSON
        Friend newFriend = Friend.fromJson(decodedJson);
        newFriend.isVerified = true;

        // Add the new friend to the provider
        setState(() {
          context.read<FriendListProvider>().addFriend(newFriend);
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verified friend added!'),
          ),
        );
      } catch (e) {
        // Handle JSON decoding errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to parse QR code: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch friends for the specific user
    context.read<FriendListProvider>().fetchFriends(widget.userId);

    Stream<QuerySnapshot>? friendsStream =
        context.watch<FriendListProvider>().friends;

    return Scaffold(
      drawer: const SlambookDrawer(),
      appBar: AppBar(
        title: const Text(
          'Friends',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFFDBB27),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: friendsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people),
                  const Text('No friends added yet.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/slambook',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDBB27),
                    ),
                    child: const Text(
                      'Go to Slambook',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ElevatedButton(
                    onPressed: scanQRCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDBB27),
                    ),
                    child: const Text(
                      'Add a Friend via QR',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          List<Friend> friends = snapshot.data!.docs.map((doc) {
            Friend friend = Friend.fromJson(doc.data() as Map<String, dynamic>);
            friend.id = doc.id;
            return friend;
          }).toList();

          return Swiper(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              Friend friend = friends[index];
              return Padding(
                padding: const EdgeInsets.only(
                    top: 40, bottom: 40), // Uniform padding around each card
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: const EdgeInsets.all(0), // Remove margin if any
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: friend.profilePhotoUrl.isNotEmpty
                            ? NetworkImage(friend.profilePhotoUrl)
                            : const AssetImage('assets/images/default_pfp.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${friend.name}, ${friend.age}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (friend.isVerified) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFFFDBB27),
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FriendDetailsPage(
                                        friend: friend, userId: widget.userId),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    const Color(0xFFFDBB27)),
                              ),
                              child: const Text(
                                "View Details",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      FriendModal(
                                    type: 'Delete',
                                    friend: friend,
                                    userId: widget.userId,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            viewportFraction:
                0.9, // Adjust to change the width of visible cards
            scale: 0.8, // Adjust to change the scale of non-centered cards
          );
        },
      ),
    );
  }
}
