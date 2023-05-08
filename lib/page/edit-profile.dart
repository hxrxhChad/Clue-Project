// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:clue/components/profile-component/lined-field.dart';
import 'package:clue/service/style/color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../service/firebase/add/add-user.dart';
import '../service/firebase/auth/auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = '';
  String bio = '';
  File? _image;
  String _downloadUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: firestore.collection('user').doc(authId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;

                return Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kPad(context) * 0.05,
                            vertical: kPad(context) * 0.1),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    AntIcons.leftOutlined,
                                    color:
                                        shadowColor(context).withOpacity(0.8),
                                  )),
                            ])),
                    SizedBox(
                      height: kPad(context) * 0.38,
                      width: kPad(context) * 0.38,
                      child: Stack(
                        children: [
                          Container(
                            height: kPad(context) * 0.38,
                            width: kPad(context) * 0.38,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(data['photoUrl']),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                              bottom: 0,
                              right: kPad(context) * 0.05,
                              child: InkWell(
                                onTap: () async {
                                  await _uploadImage();
                                  await _updateUserProfile();
                                  await updateFromIdMessagePhoto(_downloadUrl);
                                  await updateToIdMessagePhoto(_downloadUrl);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: primaryColor(context),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    AntIcons.editFilled,
                                    color: Colors.white,
                                    size: kPad(context) * 0.023,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: kPad(context) * 0.18,
                    ),
                    LinedField(
                      hint: 'Enter your name',
                      name: 'Name',
                      initialValue: data['displayName'],
                      onChanged: (value) async {
                        setState(() {
                          name = value;
                        });
                        await firestore
                            .collection('user')
                            .doc(authId)
                            .update({"displayName": name});
                        await updateFromIdMessageName(name);
                        await updateToIdMessageName(name);
                      },
                    ),
                    SizedBox(
                      height: kPad(context) * 0.08,
                    ),
                    LinedField(
                      hint: 'Enter your bio',
                      name: 'Bio',
                      initialValue: data['bio'],
                      onChanged: (value) async {
                        setState(() {
                          bio = value;
                        });
                        await firestore
                            .collection('user')
                            .doc(authId)
                            .update({"bio": bio});
                      },
                    ),
                  ],
                );
              } else {
                return Center(
                    child: SizedBox(
                  height: kPad(context) * 0.25,
                  width: kPad(context) * 0.25,
                ));
              }
            }),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      final storage = FirebaseStorage.instance;
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = storage.ref().child('profile_images/$fileName.jpg');

      final uploadTask = ref.putFile(_image!);
      await uploadTask.whenComplete(() => null);

      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        _downloadUrl = downloadUrl;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    final userRef = firestore.collection('user').doc(authId);
    await userRef.update({'photoUrl': _downloadUrl});

    // Navigate to another page or perform further actions
  }

  Future<void> updateFromIdMessageName(name) async {
    final messages = firestore.collection('message');
    final query = messages.where('fromId', isEqualTo: authId);
    final snapshot = await query.get();
    final batch = firestore.batch();

    snapshot.docs.forEach((doc) {
      final ref = messages.doc(doc.id);
      batch.update(ref, {'fromName': name});
    });

    await batch.commit();
  }

  Future<void> updateToIdMessageName(name) async {
    final messages = firestore.collection('message');
    final query = messages.where('toId', isEqualTo: authId);
    final snapshot = await query.get();
    final batch = firestore.batch();

    snapshot.docs.forEach((doc) {
      final ref = messages.doc(doc.id);
      batch.update(ref, {'toName': name});
    });

    await batch.commit();
  }

  Future<void> updateFromIdMessagePhoto(photo) async {
    final messages = firestore.collection('message');
    final query = messages.where('fromId', isEqualTo: authId);
    final snapshot = await query.get();
    final batch = firestore.batch();

    snapshot.docs.forEach((doc) {
      final ref = messages.doc(doc.id);
      batch.update(ref, {'fromPhoto': photo});
    });

    await batch.commit();
  }

  Future<void> updateToIdMessagePhoto(photo) async {
    final messages = firestore.collection('message');
    final query = messages.where('toId', isEqualTo: authId);
    final snapshot = await query.get();
    final batch = firestore.batch();

    snapshot.docs.forEach((doc) {
      final ref = messages.doc(doc.id);
      batch.update(ref, {'toPhoto': photo});
    });

    await batch.commit();
  }
}
