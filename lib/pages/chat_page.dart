import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/pages/widgets/search_widget.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/pages/widgets/chat_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  int _limit = 10;

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
          SearchBar(),
          SizedBox(height: 10,),
          Expanded(
            child:StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .limit(_limit)
                  .where("users", arrayContains: g_User.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();
                return ListView(
                    children: snapshot.data.docs
                        .map<Widget>((chat){
                      return HomeChatItem(snapshot: chat);
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
