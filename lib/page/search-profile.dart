// ignore_for_file: file_names, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:clue/components/profile-component/photo-caurosial.dart';
import 'package:clue/page/message-page.dart';
import 'package:flutter/material.dart';

import '../components/profile-component/response-button.dart';
import '../service/firebase/add/add-user.dart';
import '../service/firebase/add/send-message.dart';
import '../service/firebase/auth/auth.dart';
import '../service/firebase/data/my-data.dart';
import '../service/style/color.dart';

class SearchProfile extends StatelessWidget {
  final String? searchId;
  SearchProfile({Key? key, required this.searchId}) : super(key: key);
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: firestore.collection('user').doc(searchId).snapshots(),
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
                                    horizontal: kPad(context) * 0.08,
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
                                      height: kPad(context) * 0.056,
                                    ),
                                    Text(
                                      'BIO',
                                      style: style(context).copyWith(
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    SizedBox(
                                      height: kPad(context) * 0.023,
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
                                            icon: AntIcons.messageOutlined,
                                            press: () async {
                                              final name = await getName();
                                              final photo = await getPhoto();
                                              final imSenderId =
                                                  await imSender(searchId);
                                              final imReceiverId =
                                                  await imReceiver(searchId);
                                              if (imSenderId != null) {
                                                // get collId
                                                final collId =
                                                    await imSender(searchId);

                                                // navigation
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessagePage(
                                                              toId:
                                                                  data['docId'],
                                                              toName: data[
                                                                  'displayName'],
                                                              toAvatar: data[
                                                                  'photoUrl'],
                                                              fromId: authId,
                                                              fromName: name,
                                                              fromAvatar: photo,
                                                              collId: collId!,
                                                            )));
                                              } else if (imReceiverId != null) {
                                                // get collId
                                                final collId =
                                                    await imReceiver(searchId);

                                                // navigation
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessagePage(
                                                              toId:
                                                                  data['docId'],
                                                              toName: data[
                                                                  'displayName'],
                                                              toAvatar: data[
                                                                  'photoUrl'],
                                                              fromId: authId,
                                                              fromName: name,
                                                              fromAvatar: photo,
                                                              collId: collId!,
                                                            )));
                                              } else {
                                                // get collId

                                                String collIdNew =
                                                    await messageFn(
                                                        authId,
                                                        name,
                                                        photo,
                                                        data['docId'],
                                                        data['displayName'],
                                                        data['photoUrl']);

                                                // navigation

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessagePage(
                                                              toId:
                                                                  data['docId'],
                                                              toName: data[
                                                                  'displayName'],
                                                              toAvatar: data[
                                                                  'photoUrl'],
                                                              fromId: authId,
                                                              fromName: name,
                                                              fromAvatar: photo,
                                                              collId: collIdNew,
                                                            )));
                                              }
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
                              PhotoCaurosial(id: data['docId']),
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
                            vertical: kPad(context) * 0.14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  AntIcons.leftOutlined,
                                  color: Colors.white.withOpacity(0.8),
                                )),
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
}

/*
 final name = await getName();
                                    final photo = await getPhoto();
                                    final imSenderId =
                                        await imSender(searchId);
                                    final imReceiverId =
                                        await imReceiver(searchId);
                                    if (imSenderId != null) {
                                      // get collId
                                      final collId =
                                          await imSender(searchId);

                                      // navigation
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MessagePage(
                                                    toId: data['docId'],
                                                    toName:
                                                        data['displayName'],
                                                    toAvatar:
                                                        data['photoUrl'],
                                                    fromId: authId,
                                                    fromName: name,
                                                    fromAvatar: photo,
                                                    collId: collId!,
                                                  )));
                                    } else if (imReceiverId != null) {
                                      // get collId
                                      final collId =
                                          await imReceiver(searchId);

                                      // navigation
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MessagePage(
                                                    toId: data['docId'],
                                                    toName:
                                                        data['displayName'],
                                                    toAvatar:
                                                        data['photoUrl'],
                                                    fromId: authId,
                                                    fromName: name,
                                                    fromAvatar: photo,
                                                    collId: collId!,
                                                  )));
                                    } else {
                                      // get collId

                                      String collIdNew = await messageFn(
                                          authId,
                                          name,
                                          photo,
                                          data['docId'],
                                          data['displayName'],
                                          data['photoUrl']);

                                      // navigation

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MessagePage(
                                                    toId: data['docId'],
                                                    toName:
                                                        data['displayName'],
                                                    toAvatar:
                                                        data['photoUrl'],
                                                    fromId: authId,
                                                    fromName: name,
                                                    fromAvatar: photo,
                                                    collId: collIdNew,
                                                  )));
                                    }
 */
