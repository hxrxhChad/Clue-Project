// ignore_for_file: file_names

import 'dart:ui';

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clue/page/search-profile.dart';
import 'package:clue/service/helper/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../service/firebase/add/add-user.dart';
import '../service/firebase/add/send-message.dart';
import '../service/firebase/auth/auth.dart';
import '../service/model/msgList-model.dart';
import '../service/style/color.dart';

class MessagePage extends StatefulWidget {
  final String collId;
  final String toId;

  final String toName;
  final String toAvatar;
  final String fromId;
  final String fromName;
  final String fromAvatar;
  const MessagePage(
      {Key? key,
      required this.toId,
      required this.toName,
      required this.toAvatar,
      required this.fromId,
      required this.fromName,
      required this.fromAvatar,
      required this.collId})
      : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool sending = false;
  final TextEditingController msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isVisible = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.toAvatar), fit: BoxFit.cover),
          ),
        ),
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [darkC.withOpacity(01), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.center)),
            )),
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [darkC.withOpacity(01), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center)),
            )),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                      stream: firestore
                          .collection('message')
                          .doc(widget.collId)
                          .collection('msgList')
                          .orderBy('docId', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot = snapshot.data!;
                          List<QueryDocumentSnapshot> documents =
                              querySnapshot.docs;
                          List<MsgList> msgList = documents
                              .map((e) => MsgList(
                                    docId: e['docId'],
                                    sender: e['sender'],
                                    content: e['content'],
                                    time: e['time'],
                                  ))
                              .toList();

                          return ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: msgList.length,
                              itemBuilder: (context, index) => Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: msgList[index].sender == authId
                                              ? kPad(context) * 0.25
                                              : kPad(context) * 0.1,
                                          right: msgList[index].sender == authId
                                              ? kPad(context) * 0.1
                                              : kPad(context) * 0.25,
                                          bottom: index == 0
                                              ? kPad(context) * 0.27
                                              : 7,
                                          top: 7),
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                          extentRatio: 0.3,
                                          motion: const StretchMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) async {
                                                await firestore
                                                    .collection('message')
                                                    .doc(widget.collId)
                                                    .collection('msgList')
                                                    .doc(msgList[index].docId)
                                                    .delete();
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              icon: AntIcons.deleteFilled,
                                              backgroundColor:
                                                  Colors.red.shade300,
                                            )
                                          ],
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: kPad(context) * 0.06,
                                              vertical: kPad(context) * 0.06),
                                          decoration: BoxDecoration(
                                              color: msgList[index].sender ==
                                                      authId
                                                  ? greenC
                                                  : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(30),
                                                topRight:
                                                    const Radius.circular(30),
                                                bottomLeft: Radius.circular(
                                                    msgList[index].sender ==
                                                            authId
                                                        ? 30
                                                        : 0),
                                                bottomRight: Radius.circular(
                                                    msgList[index].sender ==
                                                            authId
                                                        ? 0
                                                        : 30),
                                              )),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    msgList[index].sender ==
                                                            authId
                                                        ? 'You'
                                                        : widget.toName,
                                                    style: style(context)
                                                        .copyWith(
                                                            color: darkC,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    msgList[index]
                                                        .time
                                                        .toString(),
                                                    style: style(context)
                                                        .copyWith(
                                                            color: darkC
                                                                .withOpacity(
                                                                    0.9),
                                                            fontSize:
                                                                kPad(context) *
                                                                    0.02),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                msgList[index].content!,
                                                style: style(context).copyWith(
                                                    color:
                                                        darkC.withOpacity(0.8)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                        } else {
                          return SizedBox(
                            height: kPad(context) * 0.01,
                          );
                        }
                      })),
            ],
          ),
        ),
        // start here -------------------------------->
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _isVisible ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: SafeArea(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kPad(context) * 0.08,
                              vertical: kPad(context) * 0.05),
                          child: InkWell(
                            onTap: () {
                              push(context,
                                  SearchProfile(searchId: widget.toId));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: kPad(context) * 0.12,
                                  width: kPad(context) * 0.12,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.toAvatar),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  width: kPad(context) * 0.05,
                                ),
                                Text(
                                  widget.toName,
                                  style: style(context).copyWith(
                                      color: green1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: kPad(context) * 0.06),
                                )
                              ],
                            ),
                          ),
                        )),
                      ))),
            )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kPad(context) * 0.08,
                vertical: kPad(context) * 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 50,
                      width: 270,
                      padding: EdgeInsets.symmetric(
                          horizontal: kPad(context) * 0.05),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white.withOpacity(0.3)),
                      child: TextFormField(
                        controller: msgController,
                        showCursor: false,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: shadowColor(context).withOpacity(0.1),
                        style: style(context).copyWith(
                            color: shadowColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 19),
                        decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: kPad(context) * 0.02,
                ),
                InkWell(
                  onTap: () async {
                    await msgListFn(
                        widget.collId, widget.fromId, msgController.text);
                    setState(() {
                      msgController.text = "";
                    });
                  },
                  child: Material(
                    color: green1,
                    shadowColor: green1.withOpacity(0.3),
                    elevation: 10,
                    shape: const CircleBorder(),
                    child: Container(
                      height: kPad(context) * 0.12,
                      width: kPad(context) * 0.12,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: green1),
                      child: sending
                          ? SizedBox(
                              height: kPad(context) * 0.05,
                              width: kPad(context) * 0.05,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircularProgressIndicator(
                                  color: shadowColor(context),
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : Icon(
                              CupertinoIcons.chevron_forward,
                              color: shadowColor(context),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
