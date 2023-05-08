// ignore_for_file: file_names

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clue/page/message-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../service/firebase/add/add-user.dart';
import '../service/firebase/auth/auth.dart';
import '../service/style/color.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [blueC.withOpacity(0.2), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.center)),
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: kPad(context) * 0.15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.1),
                child: Text(
                  'Chats',
                  style: style(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: kPad(context) * 0.1),
                ),
              ),
              StreamBuilder(
                  stream: firestore
                      .collection('message')
                      .where('toId', isEqualTo: authId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? const SizedBox(
                            height: 0,
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index].data();
                              return Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.3,
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        await firestore
                                            .collection('message')
                                            .doc(data['docId'])
                                            .delete();
                                      },
                                      icon: AntIcons.deleteFilled,
                                      backgroundColor: Colors.red.shade300,
                                    )
                                  ],
                                ),
                                child: InkWell(
                                  splashColor:
                                      primaryColor(context).withOpacity(0.1),
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MessagePage(
                                                  toId: data['fromId'],
                                                  toName: data['fromName'],
                                                  toAvatar: data['fromPhoto'],
                                                  fromId: data['toId'],
                                                  fromName: data['toName'],
                                                  fromAvatar: data['toPhoto'],
                                                  collId: data['docId'],
                                                )));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: kPad(context) * 0.08,
                                        right: kPad(context) * 0.095,
                                        top: kPad(context) * 0.05,
                                        bottom: kPad(context) * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: kPad(context) * 0.13,
                                              width: kPad(context) * 0.13,
                                              decoration: BoxDecoration(
                                                  color: darkC,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          data['fromPhoto']),
                                                      fit: BoxFit.cover)),
                                            ),
                                            SizedBox(
                                              width: kPad(context) * 0.05,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['fromName'],
                                                  style: style(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: kPad(context) * 0.55,
                                                  child: Text(
                                                    '${data['lastSender'] == authId ? 'you : ' : ''}${data['lastMessage']}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: style(context)
                                                        .copyWith(
                                                            fontSize:
                                                                kPad(context) *
                                                                    0.04,
                                                            color: shadowColor(
                                                                    context)
                                                                .withOpacity(
                                                                    0.5)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            StreamBuilder<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('user')
                                                    .doc(data['fromId'])
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  DocumentSnapshot<
                                                          Map<String, dynamic>>?
                                                      userDocument =
                                                      snapshot.data;
                                                  Map<String, dynamic>?
                                                      userData =
                                                      userDocument?.data();
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const SizedBox();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const SizedBox();
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      !snapshot.data!.exists) {
                                                    return const SizedBox();
                                                  } else {
                                                    return Text(
                                                      userData?['active']
                                                          ? 'Active Now'
                                                          : '',
                                                      style: style(context).copyWith(
                                                          fontSize:
                                                              kPad(context) *
                                                                  0.02,
                                                          color: userData?[
                                                                  'active']
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                      0.7)
                                                              : Colors.red
                                                                  .withOpacity(
                                                                      0.5),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    );
                                                  }
                                                }),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              data['lastTime'],
                                              style: style(context).copyWith(
                                                  fontSize:
                                                      kPad(context) * 0.03,
                                                  color: shadowColor(context)
                                                      .withOpacity(0.5)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                  }),
              StreamBuilder(
                  stream: firestore
                      .collection('message')
                      .where('fromId', isEqualTo: authId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? const SizedBox(
                            height: 0,
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index].data();
                              return InkWell(
                                  splashColor:
                                      primaryColor(context).withOpacity(0.1),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MessagePage(
                                                  toId: data['toId'],
                                                  toName: data['toName'],
                                                  toAvatar: data['toPhoto'],
                                                  fromId: data['fromId'],
                                                  fromName: data['fromName'],
                                                  fromAvatar: data['fromPhoto'],
                                                  collId: data['docId'],
                                                )));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: kPad(context) * 0.06,
                                        right: kPad(context) * 0.08,
                                        top: kPad(context) * 0.05,
                                        bottom: kPad(context) * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: kPad(context) * 0.12,
                                              width: kPad(context) * 0.12,
                                              decoration: BoxDecoration(
                                                  color: darkC,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          data['toPhoto']),
                                                      fit: BoxFit.cover)),
                                            ),
                                            SizedBox(
                                              width: kPad(context) * 0.04,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['toName'],
                                                  style: style(context)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: kPad(context) * 0.56,
                                                  child: Text(
                                                    '${data['lastSender'] == authId ? 'you : ' : ''}${data['lastMessage']}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: style(context)
                                                        .copyWith(
                                                            fontSize:
                                                                kPad(context) *
                                                                    0.04,
                                                            color: shadowColor(
                                                                    context)
                                                                .withOpacity(
                                                                    0.5)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            StreamBuilder<
                                                    DocumentSnapshot<
                                                        Map<String, dynamic>>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('user')
                                                    .doc(data['toId'])
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  DocumentSnapshot<
                                                          Map<String, dynamic>>?
                                                      userDocument =
                                                      snapshot.data;
                                                  Map<String, dynamic>?
                                                      userData =
                                                      userDocument?.data();
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const SizedBox();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const SizedBox();
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      !snapshot.data!.exists) {
                                                    return const SizedBox();
                                                  } else {
                                                    return Text(
                                                      userData?['active']
                                                          ? 'Active Now'
                                                          : '',
                                                      style: style(context).copyWith(
                                                          fontSize:
                                                              kPad(context) *
                                                                  0.04,
                                                          color: userData?[
                                                                  'active']
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                      0.7)
                                                              : Colors.red
                                                                  .withOpacity(
                                                                      0.5),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    );
                                                  }
                                                }),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              data['lastTime'],
                                              style: style(context).copyWith(
                                                  fontSize:
                                                      kPad(context) * 0.03,
                                                  color: shadowColor(context)
                                                      .withOpacity(0.5)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                            });
                  })
            ],
          )),
    ));
  }

  deleteChat() async {}
}
