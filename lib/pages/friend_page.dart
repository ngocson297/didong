import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/pages/widgets/chat_widget.dart';
import 'package:flutter_chat_app/pages/widgets/search_widget.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key key}) : super(key: key);

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          //SearchBar(),
          SizedBox(height: 10,),
          Expanded(child: Center()),
        ],
      ),
    );
  }
}
