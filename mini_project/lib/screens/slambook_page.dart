import 'dart:convert';

import 'package:mini_project/drawer.dart';
import 'package:mini_project/models/friend.dart';
import 'package:mini_project/providers/friend_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SlambookPage extends StatefulWidget {
  const SlambookPage({super.key});

  @override
  State<SlambookPage> createState() => _SlambookPageState();
}

class _SlambookPageState extends State<SlambookPage> {
  final _formKey = GlobalKey<FormState>();
  Friend friend = Friend();
  List<Widget> summary = [];

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

  void printSummary() {
    print('friend Summary:');
    print('Name: ${friend.name}');
    print('Nickname: ${friend.nickname}');
    print('Age: ${friend.age}');
    print(
        'Relationship Status: ${friend.relationshipStatus ? 'Single' : 'Not Single'}');
    print('Happiness Level: ${friend.happinessLevel}');
    print('Superpower: ${friend.superpower}');
    print('Motto: ${friend.motto}');
  }

  @override
  void initState() {
    super.initState();
    friend.superpower = _dropdownOptions.first;
    friend.motto = _motto.first;
  }

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

        Navigator.pushNamed(context, '/friends');

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
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SlambookDrawer(),
      appBar: AppBar(
        title: const Text(
          "Slambook",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFFDBB27),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              const Text(
                "My Friends' Slambook",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                    friend.name = val;
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
                    friend.nickname = val;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              friend.age = int.tryParse(val) ?? 0;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0),
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
                      ),
                    ],
                  ),
                  const SizedBox(width: 5.0),
                  Row(
                    children: [
                      const Text(
                        "Are you Single? ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: friend.relationshipStatus,
                        onChanged: (val) {
                          setState(() {
                            friend.relationshipStatus = val;
                          });
                        },
                        hoverColor: Colors.black,
                        activeColor: Colors.black,
                      ),
                    ],
                  )
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
                value: friend.happinessLevel.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: friend.happinessLevel.toString(),
                onChanged: (val) {
                  setState(() {
                    friend.happinessLevel = val.toInt();
                  });
                },
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Superpower",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text("If you were to have a superpower, what would it be?",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center),
              DropdownButtonFormField(
                value: friend.superpower.isNotEmpty
                    ? friend.superpower
                    : _dropdownOptions.first,
                items: _dropdownOptions
                    .map((String superpower) => DropdownMenuItem(
                          value: superpower,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(superpower),
                            ],
                          ),
                        ))
                    .toList(),
                focusColor: Colors.white,
                onChanged: (val) {
                  setState(() {
                    friend.superpower = val!;
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
                      groupValue: friend.motto,
                      onChanged: (val) {
                        setState(() {
                          friend.motto = val!;
                        });
                      },
                    ),
                    title: Text(
                      motto,
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20.0),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Column(
                  children: summary,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      _formKey.currentState!.reset();
                      setState(() {
                        friend = Friend();
                        friend.superpower = _dropdownOptions.first;
                        friend.motto = _motto.first;
                        summary = [];
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.black),
                    ),
                    child: const Text('Reset',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        printSummary();
                        // widget.onAddFriend(Friend(data: friend));
                        setState(() {
                          summary.add(Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Summary",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 18.0,
                                    ),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text("Name",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(friend.name,
                                                style: const TextStyle(
                                                    fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text("Nickname",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(friend.nickname,
                                                style: const TextStyle(
                                                    fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text("Age",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("${friend.age}",
                                                style: const TextStyle(
                                                    fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text("Relationship Status",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            if (friend.relationshipStatus)
                                              const Text(
                                                "Single",
                                                style: TextStyle(fontSize: 15),
                                              )
                                            else
                                              const Text(
                                                "Not Single",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text("Happiness Level",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("${friend.happinessLevel}",
                                                style: const TextStyle(
                                                    fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text("Superpower",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                        Flexible(
                                            child: Column(
                                          children: [
                                            Text(friend.superpower,
                                                style: const TextStyle(
                                                    fontSize: 15)),
                                          ],
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: Text("Motto",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ],
                                        ),
                                        Flexible(
                                            child: Column(
                                          children: [
                                            Text(friend.motto,
                                                style: const TextStyle(
                                                    fontSize: 15)),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ])));
                        });

                        context.read<FriendListProvider>().addFriend(friend);
                      } else {
                        print('Errors found in form.');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFFFDBB27)),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFDBB27),
        onPressed: scanQRCode,
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.black,
        ),
      ),
    );
  }
}
