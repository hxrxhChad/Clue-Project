// ignore_for_file: file_names

import 'dart:io';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:clue/components/profile-component/photo-caurosial.dart';
import 'package:clue/components/profile-component/response-button.dart';
import 'package:clue/page/edit-profile.dart';
import 'package:clue/service/helper/navigator.dart';
import 'package:clue/service/style/color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../service/firebase/add/add-user.dart';
import '../service/firebase/auth/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  File? _image;
  String _downloadUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: firestore.collection('user').doc(authId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;

              return Stack(
                children: [
                  PageView(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data['photoUrl']),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [darkC, Colors.transparent],
                                      begin: Alignment.topCenter,
                                      end: Alignment.center)),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: -5,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [darkC, Colors.transparent],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center)),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kPad(context) * 0.056,
                                    vertical: kPad(context) * 0.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['displayName'],
                                      style: style(context).copyWith(
                                          color: Colors.white,
                                          fontSize: kPad(context) * 0.08,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: kPad(context) * 0.024,
                                    ),
                                    Text(
                                      'BIO',
                                      style: style(context).copyWith(
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    SizedBox(
                                      height: kPad(context) * 0.03,
                                    ),
                                    Text(
                                      data['bio'],
                                      style: style(context).copyWith(
                                          color: Colors.white.withOpacity(0.9)),
                                    ),
                                    SizedBox(
                                      height: kPad(context) * 0.08,
                                    ),
                                    Row(
                                      children: [
                                        ResponseButton(
                                            icon: AntIcons.editFilled,
                                            press: () {
                                              push(
                                                  context, const EditProfile());
                                            }),
                                        ResponseButton(
                                            icon: CupertinoIcons.add,
                                            press: () async {
                                              await _uploadImage();
                                              await addPhoto(_downloadUrl);
                                            }),
                                        ResponseButton(
                                            icon: AntIcons.downOutlined,
                                            press: () {
                                              _pageController.animateToPage(
                                                1, // Index of the second page
                                                duration: const Duration(
                                                    milliseconds:
                                                        500), // Animation duration
                                                curve: Curves
                                                    .easeInOut, // Animation curve
                                              );
                                            }),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: darkC,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: kPad(context) * 0.25,
                              ),
                              Text(
                                'Album',
                                style: style(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: kPad(context) * 0.08,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: kPad(context) * 0.1,
                              ),
                              PhotoCaurosial(id: authId),
                              SizedBox(
                                height: kPad(context) * 0.2,
                              ),
                              ResponseButton(
                                  icon: CupertinoIcons.add,
                                  press: () async {
                                    await _uploadImage();
                                    await addPhoto(_downloadUrl);
                                  }),
                              SizedBox(
                                height: kPad(context) * 0.13,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kPad(context) * 0.05,
                            vertical: kPad(context) * 0.13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _pageController.animateToPage(
                                    0, // Index of the second page
                                    duration: const Duration(
                                        milliseconds:
                                            500), // Animation duration
                                    curve: Curves.easeInOut, // Animation curve
                                  );
                                },
                                icon: Icon(
                                  AntIcons.upOutlined,
                                  color: Colors.white.withOpacity(0.8),
                                )),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: scaffoldColor(context),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: kPad(context) * 0.8,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    kPad(context) * 0.08),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          kPad(context) * 0.023,
                                                    ),
                                                    child: Container(
                                                      height: 5,
                                                      width:
                                                          kPad(context) * 0.13,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: shadowColor(
                                                                  context)
                                                              .withOpacity(
                                                                  0.4)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: kPad(context) * 0.08,
                                                ),
                                                Text(
                                                  'Do you really want to',
                                                  style: style(context)
                                                      .copyWith(color: blueC),
                                                ),
                                                Text(
                                                  'Log Out',
                                                  style: style(context)
                                                      .copyWith(
                                                          fontSize:
                                                              kPad(context) *
                                                                  0.13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: kPad(context) * 0.18,
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: kPad(
                                                                      context) *
                                                                  0.08,
                                                              vertical: kPad(
                                                                      context) *
                                                                  0.024),
                                                          child: Text(
                                                            'Cancel',
                                                            style: style(
                                                                    context)
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          kPad(context) * 0.25,
                                                    ),
                                                    InkWell(
                                                      onTap: () => Auth()
                                                          .signOut(context),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: blueC,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: kPad(
                                                                      context) *
                                                                  0.08,
                                                              vertical: kPad(
                                                                      context) *
                                                                  0.024),
                                                          child: Text(
                                                            'Log Out',
                                                            style: style(
                                                                    context)
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(
                                  AntIcons.disconnectOutlined,
                                  color: Colors.white.withOpacity(0.8),
                                ))
                          ],
                        ),
                      )),
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
      final ref = storage.ref().child('images/$fileName.jpg');

      final uploadTask = ref.putFile(_image!);
      await uploadTask.whenComplete(() => null);

      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        _downloadUrl = downloadUrl;
      });
    }
  }
}
