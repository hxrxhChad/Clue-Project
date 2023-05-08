// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clue/page/control-page.dart';
import 'package:flutter/material.dart';

import '../firebase/auth/auth.dart';

class ActiveStatus {
  static bool isActive = false;
}

class ActiveTracker extends StatefulWidget {
  const ActiveTracker({super.key});

  @override
  _ActiveTrackerState createState() => _ActiveTrackerState();
}

class _ActiveTrackerState extends State<ActiveTracker>
    with WidgetsBindingObserver {
  late Stream<DocumentSnapshot> _userStream;
  late CollectionReference _userCollection;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userCollection = FirebaseFirestore.instance.collection('user');
    _userStream = _userCollection.doc(authId).snapshots();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed) {
        ActiveStatus.isActive = true;
      } else {
        ActiveStatus.isActive = false;
      }
    });

    updateUserActiveStatus(ActiveStatus.isActive);
  }

  Future<void> updateUserActiveStatus(bool isActive) async {
    try {
      await _userCollection.doc(authId).update({
        'active': isActive,
      });
    } catch (error) {
      debugPrint('Error updating user active status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ControlPage();
  }
}
