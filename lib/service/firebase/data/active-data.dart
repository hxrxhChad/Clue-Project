// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDocument(
    String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return snapshot;
  } catch (e) {
    debugPrint('Error getting user document: $e');
    return null;
  }
}

Future<bool> fetchUserDocument(userId) async {
  DocumentSnapshot<Map<String, dynamic>>? document =
      await getUserDocument(userId);

  if (document != null && document.exists) {
    // Document exists, you can access its data
    Map<String, dynamic>? data = document.data();
    // Access specific fields using data['fieldName']
    print('User name: ${data!['name']}');
    print('User email: ${data['email']}');
    // ...

    return data['active'];
  } else {
    // Document doesn't exist or an error occurred
    print('User document does not exist.');
    return false;
  }
}
