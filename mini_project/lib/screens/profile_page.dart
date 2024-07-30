import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mini_project/providers/user_provider.dart';
import 'package:mini_project/screens/user_modal.dart';
import 'package:provider/provider.dart';
import 'package:mini_project/providers/auth_provider.dart';
import 'package:mini_project/models/user.dart';
import 'package:mini_project/screens/qr_code_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      UserModel? userModel = context.read<UserAuthProvider>().userModel;
      if (userModel == null) return;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos/${userModel.id}.jpg');
      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        userModel.profilePhotoUrl = downloadUrl;
      });

      context
          .read<UserProvider>()
          .editUserprofilePhotoUrl(userModel, downloadUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _showImageSourceDialog() async {
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
        title: const Text('Profile',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFFDBB27),
      ),
      body: Consumer<UserAuthProvider>(
        builder: (context, userAuthProvider, child) {
          UserModel? userModel = userAuthProvider.userModel;

          if (userModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: userModel.profilePhotoUrl == ''
                          ? const AssetImage('assets/images/default_pfp.jpg')
                              as ImageProvider
                          : NetworkImage(userModel.profilePhotoUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userModel.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userModel.username,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Email',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(userModel.email),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Nickname',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(userModel.nickname),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Age',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${userModel.age}'),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Relationship Status',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(userModel.relationshipStatus
                          ? 'Single'
                          : 'Not Single'),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Happiness Level',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${userModel.happinessLevel}'),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Superpower',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(userModel.superpower),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Motto',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(userModel.motto),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      title: const Text('Contact Numbers',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(userModel.contactNumbers.isNotEmpty
                          ? userModel.contactNumbers.join(', ')
                          : 'No Contact Numbers'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await showDialog<UserModel>(
                            context: context,
                            builder: (BuildContext context) =>
                                UserModal(type: 'Edit', user: userModel),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UserModel? userModel = context.read<UserAuthProvider>().userModel;
          if (userModel != null) {
            showDialog(
              context: context,
              builder: (context) => QRCodeDialog(userModel: userModel),
            );
          }
        },
        backgroundColor: const Color(0xFFFDBB27),
        child: const Icon(
          Icons.qr_code,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
