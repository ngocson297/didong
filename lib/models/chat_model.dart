import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel{
  String chatId;
  String chatName;
  String latestMsg;
  Timestamp time;
  String chatImg;
  List<dynamic> users;

  ChatModel({this.chatId, this.chatName, this.latestMsg, this.time, this.chatImg, this.users});
}