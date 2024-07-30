// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mini_project/screens/friend_details_page.dart';
import 'package:provider/provider.dart';
import '../models/friend.dart';
import '../providers/friend_provider.dart';

class FriendModal extends StatefulWidget {
  final String type;
  final Friend friend;
  final String userId;

  const FriendModal(
      {super.key,
      required this.type,
      required this.friend,
      required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _FriendModalState createState() => _FriendModalState();
}

class _FriendModalState extends State<FriendModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _formFieldController = TextEditingController();

  final List<String> _dropdownOptions = [
    "Makalipad",
    "Maging Invisible",
    "Mapaibig siya",
    "Mapabago ang isip niya",
    "Mapalimot siya",
    "Mabalik ang nakaraan",
    "Mapaghiwalay sila",
    "Makarma siya",
    "Mapasagasaan siya sa pison",
    "Mapaitim ang tuhod ng iniibig niya"
  ];

  final List<String> _motto = [
    "Haters gonna hate",
    "Bakers gonna Bake",
    "If cannot be, borrow one from three",
    "Less is more, more or less",
    "Better late than sorry",
    "Don't talk to strangers when your mouth is full",
    "Let's burn the bridge when we get there"
  ];

  @override
  void initState() {
    super.initState();
  }

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (widget.type) {
      case 'Edit':
        return const Text("Edit Friend's Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold));
      case 'Delete':
        return const Text("Delete Friend",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold));
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (widget.type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${widget.friend.name}'?",
          );
        }
      case 'Edit':
        {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 15.0),
                  TextFormField(
                    initialValue: widget.friend.nickname,
                    decoration: const InputDecoration(
                      labelText: 'Nickname',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        widget.friend.nickname = val;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    initialValue: (widget.friend.age).toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        widget.friend.age = int.tryParse(val) ?? 0;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Age is required!';
                      }
                      try {
                        int age = int.parse(val);
                        if (age <= 0) {
                          return 'Age must be a positive number!';
                        }
                        return null;
                      } catch (e) {
                        return 'Invalid Age!';
                      }
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Are you Single? ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: widget.friend.relationshipStatus,
                        onChanged: (val) {
                          setState(() {
                            widget.friend.relationshipStatus = val;
                          });
                        },
                        hoverColor: Colors.black,
                        activeColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  const Text(
                    "Happiness Level",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      "On a scale of 0 (Hopeless) to 10 (Very Happy), how would you rate your current lifestyle?",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center),
                  Slider(
                    thumbColor: Colors.black,
                    activeColor: Colors.black,
                    value: widget.friend.happinessLevel.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: widget.friend.happinessLevel.toString(),
                    onChanged: (val) {
                      setState(() {
                        widget.friend.happinessLevel = val.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    "Superpower",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      "If you were to have a superpower, what would it be?",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center),
                  DropdownButtonFormField(
                    value: widget.friend.superpower,
                    items: _dropdownOptions
                        .map((String superpower) => DropdownMenuItem(
                              value: superpower,
                              child: Row(
                                children: [
                                  const SizedBox(width: 5),
                                  Text(superpower,
                                      style: const TextStyle(fontSize: 11))
                                ],
                              ),
                            ))
                        .toList(),
                    focusColor: Colors.white,
                    onChanged: (val) {
                      setState(() {
                        widget.friend.superpower = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 25.0),
                  const Text(
                    "Motto",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: _motto.map((motto) {
                      return ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        leading: Radio<String>(
                          activeColor: Colors.black,
                          value: motto,
                          groupValue: widget.friend.motto,
                          onChanged: (val) {
                            setState(() {
                              widget.friend.motto = val!;
                            });
                          },
                        ),
                        title: Text(
                          motto,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
              ),
            ),
          );
        }

      // Edit and add will have input field in them
      default:
        return TextField(
          controller: _formFieldController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (widget.type) {
          case 'Edit':
            {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                context
                    .read<FriendListProvider>()
                    .editFriendnickname(widget.friend, widget.friend.nickname);

                context
                    .read<FriendListProvider>()
                    .editFriendage(widget.friend, widget.friend.age);

                context.read<FriendListProvider>().editFriendrelationshipStatus(
                    widget.friend, widget.friend.relationshipStatus);

                context.read<FriendListProvider>().editFriendhappinessLevel(
                    widget.friend, widget.friend.happinessLevel);

                context.read<FriendListProvider>().editFriendsuperpower(
                    widget.friend, widget.friend.superpower);

                context
                    .read<FriendListProvider>()
                    .editFriendmotto(widget.friend, widget.friend.motto);

                // Remove dialog after editing
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendDetailsPage(
                        friend: widget.friend, userId: widget.userId),
                  ),
                );
                break;
              } else {
                print('Errors found in form.');
              }
            }
          case 'Delete':
            {
              context.read<FriendListProvider>().deleteFriend(widget.friend);

              // Remove dialog after editing
              Navigator.of(context).pop();
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/');
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(widget.type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
              textStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          child: const Text("Cancel",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
