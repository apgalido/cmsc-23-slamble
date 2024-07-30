import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mini_project/providers/friend_provider.dart';
import 'package:mini_project/screens/friend_modal.dart';
import 'package:mini_project/models/friend.dart';
import 'package:provider/provider.dart';

class FriendDetailsPage extends StatefulWidget {
  final Friend friend;
  final String userId;

  const FriendDetailsPage(
      {super.key, required this.friend, required this.userId});

  @override
  _FriendDetailsPageState createState() => _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {
  late Friend _friend;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _friend = widget.friend;
  }

  void _updateFriend(Friend updatedFriend) {
    setState(() {
      _friend = updatedFriend;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos/${widget.userId}/${_friend.id}.jpg');
      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _friend.profilePhotoUrl = downloadUrl;
      });

      // Update the friend's profile photo URL in database
      context
          .read<FriendListProvider>()
          .editFriendprofilePhotoUrl(_friend, downloadUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              _friend.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_friend.isVerified) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                color: Colors.black,
                size: 20,
              ),
            ],
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFFDBB27),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _showImageSourceDialog(),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _friend.profilePhotoUrl != ''
                      ? NetworkImage(_friend.profilePhotoUrl)
                      : const AssetImage('assets/images/default_pfp.jpg')
                          as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: const Text('Name',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_friend.name),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: const Text('Nickname',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_friend.nickname),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: const Text('Age',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${_friend.age}'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: const Text('Relationship Status',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                    Text(_friend.relationshipStatus ? 'Single' : 'Not Single'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: const Text('Happiness Level',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${_friend.happinessLevel}'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: const Text('Superpower',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_friend.superpower),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                title: const Text('Motto',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_friend.motto),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _friend.isVerified
                      ? null
                      : () async {
                          final updatedFriend = await showDialog<Friend>(
                            context: context,
                            builder: (BuildContext context) => FriendModal(
                                type: 'Edit',
                                friend: _friend,
                                userId: widget.userId),
                          );

                          if (updatedFriend != null) {
                            _updateFriend(updatedFriend);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _friend.isVerified ? Colors.grey : Colors.black,
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        color: _friend.isVerified ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDBB27),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
