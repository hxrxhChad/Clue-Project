// ignore_for_file: file_names

import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  User({
    this.docId,
    this.active,
    this.bio,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  String? docId;
  bool? active;
  String? bio;
  String? displayName;
  String? email;
  String? photoUrl;

  factory User.fromMap(Map<String, dynamic> json) => User(
        docId: json["docId"],
        active: json["active"],
        bio: json["bio"],
        displayName: json["displayName"],
        email: json["email"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toMap() => {
        "docId": docId,
        "active": active,
        "bio": bio,
        "displayName": displayName,
        "email": email,
        "photoUrl": photoUrl,
      };
}
