import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Make sure to import this
import 'package:mini_project/models/friend.dart';

class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String password;
  final List<String> contactNumbers;
  String nickname;
  int age;
  bool relationshipStatus;
  int happinessLevel;
  String superpower;
  String motto;
  final List<Friend> friends;
  String profilePhotoUrl;

  UserModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.password,
      required this.contactNumbers,
      this.nickname = '',
      this.age = 0,
      this.relationshipStatus = false,
      this.happinessLevel = 0,
      this.superpower = '',
      this.motto = '',
      this.friends = const [],
      this.profilePhotoUrl = ''});

  // Factory constructor to instantiate object from JSON format
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        contactNumbers: List<String>.from(json['contactNumbers']),
        nickname: json['nickname'],
        age: json['age'],
        relationshipStatus: json['relationshipStatus'],
        happinessLevel: json['happinessLevel'],
        superpower: json['superpower'],
        motto: json['motto'],
        friends: (json['friends'] as List<dynamic>)
            .map((friendJson) => Friend.fromJson(friendJson))
            .toList(),
        profilePhotoUrl: json['profilePhotoUrl'] ?? '');
  }

  static List<UserModel> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<UserModel>((dynamic d) => UserModel.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'contactNumbers': contactNumbers,
      'nickname': nickname,
      'age': age,
      'relationshipStatus': relationshipStatus,
      'happinessLevel': happinessLevel,
      'superpower': superpower,
      'motto': motto,
      'friends': friends.map((friend) => friend.toJson()).toList(),
      'profilePhotoUrl': profilePhotoUrl
    };
  }

  // Factory constructor to create an instance from Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        username:
            '', // Username may not be available from Firebase User, set it accordingly
        email: user.email ?? '',
        password: '', // Password is not retrievable from Firebase User
        contactNumbers: [], // Contact numbers would need to be fetched separately
        nickname: '', // Set default values or fetch from another source
        age: 0,
        relationshipStatus: false,
        happinessLevel: 0,
        superpower: '',
        motto: '',
        friends: [],
        profilePhotoUrl: '');
  }

  // Factory constructor to create an instance from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
        id: doc.id,
        name: data['name'],
        username:
            data['username'] ?? '', // Handle missing fields with default values
        email: data['email'] ?? '',
        password: data['password'] ?? '',
        contactNumbers: List<String>.from(data['contactNumbers'] ?? []),
        nickname: data['nickname'] ?? '',
        age: data['age'] ?? 0,
        relationshipStatus: data['relationshipStatus'] ?? false,
        happinessLevel: data['happinessLevel'] ?? 0,
        superpower: data['superpower'] ?? '',
        motto: data['motto'] ?? '',
        friends: (data['friends'] as List<dynamic>?)
                ?.map((friendJson) => Friend.fromJson(friendJson))
                .toList() ??
            [],
        profilePhotoUrl: data['profilePhotoUrl'] ?? '');
  }
}
