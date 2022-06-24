import 'dart:convert';

List<MessageModel> MessageModelFromJson(String str) => List<MessageModel>.from(json.decode(str).map((x) => MessageModel.fromJson(x)));

MessageModel SingleMessageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String MessageModelToJson(MessageModel data) => json.encode(data.toJson());

String SubMessageToJson(SubMessage data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    required this.mainMessage,
    required this.username,
    required this.topic,
    this.subMessages,
    this.id,
  });

  String mainMessage;
  String username;
  String topic;
  List<SubMessage>? subMessages;
  int? id;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    mainMessage: json["mainMessage"],
    username: json["username"],
    topic: json["topic"],
    subMessages: List<SubMessage>.from(json["subMessages"].map((x) => SubMessage.fromJson(x))),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "mainMessage": mainMessage,
    "username": username,
    "topic": topic,
  };
}

class SubMessage {
  SubMessage({
    this.username ="",
    this.subMessage ="",
    this.parent,
  });

  int? parent;
  String username;
  String subMessage;

  factory SubMessage.fromJson(Map<String, dynamic> json) => SubMessage(
    username: json["username"],
    subMessage: json["subMessage"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "subMessage": subMessage,
    "parent": parent,
  };
}