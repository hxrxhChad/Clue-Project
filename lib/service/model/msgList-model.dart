// ignore_for_file: file_names

import 'dart:convert';

MsgList msgListFromMap(String str) => MsgList.fromMap(json.decode(str));

String msgListToMap(MsgList data) => json.encode(data.toMap());

class MsgList {
  MsgList({
    this.docId,
    this.sender,
    this.content,
    this.time,
  });

  String? docId;
  String? sender;
  String? content;
  String? time;

  factory MsgList.fromMap(Map<String, dynamic> json) => MsgList(
        docId: json["docId"],
        sender: json["sender"],
        content: json["content"],
        time: json["time"],
      );

  Map<String, dynamic> toMap() => {
        "docId": docId,
        "sender": sender,
        "content": content,
        "time": time,
      };
}
