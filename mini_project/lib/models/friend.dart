import 'dart:convert';

class Friend {
  String id;
  String name;
  String nickname;
  int age;
  bool relationshipStatus;
  int happinessLevel;
  String superpower;
  String motto;
  bool isVerified;
  String profilePhotoUrl;

  Friend(
      {this.id = '',
      this.name = '',
      this.nickname = '',
      this.age = 0,
      this.relationshipStatus = false,
      this.happinessLevel = 0,
      this.superpower = '',
      this.motto = '',
      this.isVerified = false,
      this.profilePhotoUrl = ''});

  // Factory constructor to instantiate object from json format
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        name: json['name'] ?? '',
        nickname: json['nickname'] ?? '',
        age: json['age'] ?? 0,
        relationshipStatus: json['relationshipStatus'] ?? true,
        happinessLevel: json['happinessLevel'] ?? 0,
        superpower: json['superpower'] ?? '',
        motto: json['motto'] ?? '',
        isVerified: json['isVerified'] ?? true,
        profilePhotoUrl: json['profilePhotoUrl'] ?? '');
  }

  static List<Friend> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Friend>((dynamic d) => Friend.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'age': age,
      'relationshipStatus': relationshipStatus,
      'happinessLevel': happinessLevel,
      'superpower': superpower,
      'motto': motto,
      'isVerified': isVerified,
      'profilePhotoUrl': profilePhotoUrl
    };
  }
}
