// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clue/service/model/album-model.dart';
import 'package:flutter/material.dart';

import '../../model/user-model.dart';
import '../auth/auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// to set user
addUser(displayName, email, photoUrl) {
  User user = User(
      active: false,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
      bio: '');

  final userRef = firestore.collection('user').doc(authId);

  user.docId = userRef.id;
  final data = user.toMap();

  try {
    userRef
        .set(data)
        .whenComplete(() => debugPrint('User data uploaded successfully'));
  } catch (e) {
    debugPrint(e.toString());
  }
}

// to set photo
addPhoto(image) {
  Album album = Album(
      image: image,
      time:
          '${DateTime.now().day} at ${DateTime.now().hour}:${DateTime.now().minute}');

  final albumRef =
      firestore.collection('user').doc(authId).collection('album').doc();

  album.docId = albumRef.id;
  final data = album.toJson();

  try {
    albumRef.set(data).whenComplete(
        () => debugPrint('Album Photo data uploaded successfully'));
  } catch (e) {
    debugPrint(e.toString());
  }
}

// to update active status
Future<void> updateActive(bool active) async {
  await firestore
      .collection('user')
      .doc(authId)
      .update({"active": active}).whenComplete(() {
    debugPrint('status is -> $active');
  });
}

// to update profile data
Future<void> updateProfile(displayName, bio, photoUrl) async {
  await firestore.collection('user').doc(authId).update({
    "displayName": displayName,
    "bio": bio,
    "photoUrl": photoUrl
  }).whenComplete(() {
    debugPrint('Profile updated');
  });
}
