import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String fromUser;
  String userImage;
  String userName;
  String content;
  String imgUrl;
  Timestamp time;

  MessageModel({this.fromUser, this.userName, this.userImage, this.content, this.imgUrl, this.time});
}