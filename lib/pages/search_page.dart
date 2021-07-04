import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/pages/widgets/search_widget.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/pages/widgets/chat_widget.dart';
import 'package:flutter_chat_app/ults/ults.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _limit = 10;

  String query = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          autofocus: true,
          onSubmitted: (value){
            if(value.length < 3){
              Fluttertoast.showToast(msg: "Keyword must contain 3 or more characters");
              return;
            }
            setState(() {
              query = value;
            });
          },
        ),
      ),
      body: Column(
        children:
        [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .limit(_limit)
                  .where("keywords", arrayContains: query).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();
                return ListView(
                    children: snapshot.data.docs
                        .map<Widget>((user){
                          if(user.id == global_User.uid) return Container();
                      return SearchItem(snapshot: user);
                    }).toList()
                );
              },
            ),
          ),
        ]
      )
    );
  }
}
