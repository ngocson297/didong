import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/pages/friend_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/user_page.dart';
import 'package:flutter_chat_app/ults/global.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(backgroundImage: NetworkImage(g_User.imgUrl)),
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage()));
            },
          ),
          title: Text(g_User.username),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              iconSize: 32,
              onPressed: (){},
            ),
          ],
        ),
        body: TabBarView(
          children: const [
            ChatPage(),
            FriendPage(),
          ],
        ),
        bottomNavigationBar: TabBar(
          indicatorWeight: 4,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black12,
          tabs: [
            Tab(
              icon: Icon(Icons.message),
              text: "Chats",
            ),
            Tab(
              icon: Icon(Icons.people),
              text: "Friends",
            ),
          ],
        ),
      ),
    );
  }
}