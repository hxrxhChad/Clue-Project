import 'package:clue/page/log-in-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../add/add-user.dart';

final String authId = FirebaseAuth.instance.currentUser!.uid;

class Auth {
  // auth reference variable
  FirebaseAuth auth = FirebaseAuth.instance;

  // user exists?
  Future<bool> userExists() async {
    return (await firestore.collection('user').doc(authId).get()).exists;
  }

  // google sign-in function
  Future<void> login() async {
    try {
      /*
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential = await auth
          .signInWithCredential(credential)
          .whenComplete(() => debugPrint('Login Success :)'));
      */

      //
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
      }
      //
    } catch (e) {
      debugPrint('Some Error Occurred :( ---> ${e.toString()}');
    }
  }

  // google sign out fn
  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("email");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()

            // LoginPage()

            ));
  }
}
