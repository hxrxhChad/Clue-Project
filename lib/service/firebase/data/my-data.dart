// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import '../add/add-user.dart';
import '../auth/auth.dart';

// to retrieve my name
Future<String> getName() async {
  DocumentSnapshot snapshot =
      await firestore.collection('user').doc(authId).get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return data?['displayName'];
}

// to retrieve my email
Future<String> getEmail() async {
  DocumentSnapshot snapshot =
      await firestore.collection('user').doc(authId).get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return data?['email'];
}

// to retrieve my photo
Future<String> getPhoto() async {
  DocumentSnapshot snapshot =
      await firestore.collection('user').doc(authId).get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return data?['photoUrl'];
}

// to retrieve my bio
Future<String> getBio() async {
  DocumentSnapshot snapshot =
      await firestore.collection('user').doc(authId).get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return data?['bio'];
}

// to retrieve my active status
Future<bool> getActiveStatus() async {
  DocumentSnapshot snapshot =
      await firestore.collection('user').doc(authId).get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return data?['active'];
}

//------------------------------------------------------------------------------------

// to retrieve my photo
Future<String> getUserPhoto(id) async {
  DocumentSnapshot snapshot = await firestore.collection('user').doc(id).get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return data?['photoUrl'];
}

// to retrieve user's active status
UserData(id) async {
  final bool isActive = await isUserActive(id);
}

Future<bool> isUserActive(id) async {
  DocumentSnapshot snapshot = await firestore.collection('user').doc(id).get();
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  return data?['active'];
}
