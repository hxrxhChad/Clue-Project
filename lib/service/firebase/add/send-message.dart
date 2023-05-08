// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clue/service/firebase/add/add-user.dart';
import 'package:flutter/material.dart';

import '../../model/message-model.dart';
import '../../model/msgList-model.dart';
import '../auth/auth.dart';

// to set message detail
Future<String> messageFn(
  fromId,
  fromName,
  fromPhoto,
  toId,
  toName,
  toPhoto,
) async {
  Message message = Message(
      fromId: fromId,
      fromName: fromName,
      fromPhoto: fromPhoto,
      toId: toId,
      toName: toName,
      toPhoto: toPhoto,
      lastMessage: '',
      lastTime: '',
      lastSender: '');

  final messageRef = firestore
      .collection('message')
      .doc(DateTime.now().millisecondsSinceEpoch.toString());

  message.docId = messageRef.id;
  final data = message.toMap();

  await messageRef
      .set(data)
      .whenComplete(() => debugPrint('Message data uploaded successfully'));

  return messageRef.id;
}

// to update message detail
Future<void> updateLastMsg(lastMessage, lastTime, lastSender, collId) async {
  await firestore.collection('message').doc(collId).update({
    "lastMessage": lastMessage,
    "lastSender": lastSender,
    "lastTime": lastTime
  }).whenComplete(() {
    debugPrint('Message updated');
  });
}

// to set message
Future<void> msgListFn(collId, sender, content) async {
  MsgList msgList = MsgList(
      sender: sender,
      time: '${DateTime.now().hour}:${DateTime.now().minute}',
      content: content);
  final msgListRef = firestore
      .collection('message')
      .doc(collId)
      .collection('msgList')
      .doc('${DateTime.now().millisecondsSinceEpoch}');

  msgList.docId = msgListRef.id;
  final data = msgList.toMap();

  try {
    await msgListRef
        .set(data)
        .whenComplete(
            () => debugPrint('MessageList data uploaded successfully'))
        .whenComplete(() {
      updateLastMsg(content, '${DateTime.now().hour}:${DateTime.now().minute}',
          sender, collId);
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}

/*

...if chat exist -> get collId -> open Message...

1. if fromId = authId && toId == toId -> get collId
2. else toId = authId && fromId == toId -> get collId
3. open Message...done

...if above situation doesn't exists -> create collId -> open Message...done

 */

Future<String?> imSender(id) async {
  final QuerySnapshot snapshot = await firestore
      .collection('message')
      .where('fromId', isEqualTo: authId)
      .where('toId', isEqualTo: id)
      .get();
  final docs = snapshot.docs;

  if (docs.isNotEmpty) {
    return docs.first.id;
  } else {
    return null;
  }
}

Future<String?> imReceiver(id) async {
  final QuerySnapshot snapshot = await firestore
      .collection('message')
      .where('toId', isEqualTo: authId)
      .where('fromId', isEqualTo: id)
      .get();

  final docs = snapshot.docs;
  if (docs.isNotEmpty) {
    return docs.first.id;
  } else {
    return null;
  }
}
