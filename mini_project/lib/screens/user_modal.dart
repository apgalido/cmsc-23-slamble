import 'package:flutter/material.dart';
import 'package:mini_project/models/user.dart';
import 'package:mini_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserModal extends StatefulWidget {
  final String type;
  final UserModel user;

  const UserModal({
    super.key,
    required this.type,
    required this.user,
  });

  @override
  _UserModalState createState() => _UserModalState();
}

class _UserModalState extends State<UserModal> {
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
    // Set default superpower if not set
    if (!_dropdownOptions.contains(widget.user.superpower)) {
      widget.user.superpower = _dropdownOptions[0];
    }
  }

  Text _buildTitle() {
    switch (widget.type) {
      case 'Edit':
        return const Text("Edit Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold));
      default:
        return const Text("");
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (widget.type) {
      case 'Edit':
        {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 15.0),
                    TextFormField(
                      initialValue: widget.user.nickname,
                      decoration: const InputDecoration(
                        labelText: 'Nickname',
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
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          widget.user.nickname = val;
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
                      initialValue: (widget.user.age).toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          widget.user.age = int.tryParse(val) ?? 0;
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
                          value: widget.user.relationshipStatus,
                          onChanged: (val) {
                            setState(() {
                              widget.user.relationshipStatus = val;
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      value: widget.user.happinessLevel.toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: widget.user.happinessLevel.toString(),
                      onChanged: (val) {
                        setState(() {
                          widget.user.happinessLevel = val.toInt();
                        });
                      },
                    ),
                    const SizedBox(height: 15.0),
                    const Text(
                      "Superpower",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                        "If you were to have a superpower, what would it be?",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center),
                    DropdownButtonFormField(
                      value: widget.user.superpower.isNotEmpty
                          ? widget.user.superpower
                          : null,
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
                          widget.user.superpower = val!;
                        });
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please select a superpower!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25.0),
                    const Text(
                      "Motto",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: _motto.map((motto) {
                        return ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          leading: Radio<String>(
                            activeColor: Colors.black,
                            value: motto,
                            groupValue: widget.user.motto,
                            onChanged: (val) {
                              setState(() {
                                widget.user.motto = val!;
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
                  ],
                ),
              ),
            ),
          );
        }
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
      onPressed: () async {
        switch (widget.type) {
          case 'Edit':
            {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                context
                    .read<UserProvider>()
                    .editUsernickname(widget.user, widget.user.nickname);

                context
                    .read<UserProvider>()
                    .editUserage(widget.user, widget.user.age);

                context.read<UserProvider>().editUserrelationshipStatus(
                    widget.user, widget.user.relationshipStatus);

                context.read<UserProvider>().editUserhappinessLevel(
                    widget.user, widget.user.happinessLevel);

                context
                    .read<UserProvider>()
                    .editUsersuperpower(widget.user, widget.user.superpower);

                context
                    .read<UserProvider>()
                    .editUsermotto(widget.user, widget.user.motto);

                context.read<UserProvider>().editUserprofilePhotoUrl(
                    widget.user, widget.user.profilePhotoUrl);

                // Remove dialog after editing
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              } else {
                print('Errors found in form.');
              }
            }
            break;
          default:
            print('Unknown action type.');
            break;
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
