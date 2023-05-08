import 'dart:math' as math;

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clue/service/firebase/auth/auth.dart';
import 'package:clue/service/helper/navigator.dart';
import 'package:clue/service/style/color.dart';
import 'package:flutter/material.dart';

import '../../service/firebase/add/add-user.dart';
import '../../service/model/album-model.dart';

class PhotoCaurosial extends StatefulWidget {
  final String id;
  const PhotoCaurosial({super.key, required this.id});

  @override
  State<PhotoCaurosial> createState() => _PhotoCaurosialState();
}

class _PhotoCaurosialState extends State<PhotoCaurosial> {
  late PageController _pageController;
  int initialPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
      // by default our movie poster
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kPad(context) * 0.06),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(widget.id)
              .collection('album')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final albumList = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Album(
                image: data['Image'] ?? '',
                docId: doc.id,
                time: data['time'] ?? '',
              );
            }).toList();

            return AspectRatio(
                aspectRatio: 0.85,
                child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        initialPage = value;
                      });
                    },
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: albumList.length, //
                    itemBuilder: (context, index) {
                      final album = albumList[index];
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 0;
                          if (_pageController.position.haveDimensions) {
                            value = index - _pageController.page!;
                            // We use 0.038 because 180*0.038 = 7 almost and we need to rotate our poster 7 degree
                            // we use clamp so that our value vary from -1 to 1
                            value = (value * 0.038).clamp(-1, 1);
                          }
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 350),
                            opacity: initialPage == index ? 1 : 0.4,
                            child: Transform.rotate(
                              angle: math.pi * value,
                              child: InkWell(
                                onTap: () {
                                  push(
                                      context,
                                      SizedBox(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: Image.network(
                                          album.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ));
                                },
                                child: Container(
                                  height: kPad(context) * 0.8,
                                  width: kPad(context) * 0.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          kPad(context) * 0.05),
                                      image: DecorationImage(
                                          image: NetworkImage(album.image),
                                          fit: BoxFit.cover)),
                                  child: widget.id == authId
                                      ? Padding(
                                          padding: EdgeInsets.all(
                                              kPad(context) * 0.08),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () async {
                                                // // Delete image from Firebase Storage
                                                // try {
                                                //   final storage =
                                                //       FirebaseStorage.instance;
                                                //   await storage
                                                //       .ref()
                                                //       .child(album.image)
                                                //       .delete();
                                                // } catch (e) {
                                                //   return;
                                                // }
                                                await firestore
                                                    .collection('user')
                                                    .doc(authId)
                                                    .collection('album')
                                                    .doc(album.docId)
                                                    .delete();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        primaryColor(context),
                                                    shape: BoxShape.circle),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      kPad(context) * 0.03),
                                                  child: Icon(
                                                    AntIcons.deleteFilled,
                                                    color: Colors.white,
                                                    size: kPad(context) * 0.05,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                      : const SizedBox(
                                          height: 0,
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }));
          }),
    );
  }
}
