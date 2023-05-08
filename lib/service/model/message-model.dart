// ignore_for_file: file_names

import 'dart:convert';

Message messageFromMap(String str) => Message.fromMap(json.decode(str));

String messageToMap(Message data) => json.encode(data.toMap());

class Message {
  Message({
    this.docId,
    this.fromId,
    this.toId,
    this.fromName,
    this.toName,
    this.fromPhoto,
    this.toPhoto,
    this.lastMessage,
    this.lastTime,
    this.lastSender,
  });

  String? docId;
  String? fromId;
  String? toId;
  String? fromName;
  String? toName;
  String? fromPhoto;
  String? toPhoto;
  String? lastMessage;
  String? lastTime;
  String? lastSender;

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        docId: json["docId"],
        fromId: json["fromId"],
        toId: json["toId"],
        fromName: json["fromName"],
        toName: json["toName"],
        fromPhoto: json["fromPhoto"],
        toPhoto: json["toPhoto"],
        lastMessage: json["lastMessage"],
        lastTime: json["lastTime"],
        lastSender: json["lastSender"],
      );

  Map<String, dynamic> toMap() => {
        "docId": docId,
        "fromId": fromId,
        "toId": toId,
        "fromName": fromName,
        "toName": toName,
        "fromPhoto": fromPhoto,
        "toPhoto": toPhoto,
        "lastMessage": lastMessage,
        "lastTime": lastTime,
        "lastSender": lastSender,
      };
}
