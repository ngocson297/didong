import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/pages/widgets/friend_widget.dart';

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
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("friends",arrayContains: global_User.uid)
                  .orderBy('username').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();
                return ListView(
                    children: snapshot.data.docs
                        .map<Widget>((friend){
                      return FriendItem(snapshot: friend);
                    }).toList()
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
