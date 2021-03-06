import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FriendItem extends StatelessWidget {
  FriendItem({this.snapshot});

  final QueryDocumentSnapshot snapshot;

  Future<UserModel> _loadUser() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(this.snapshot.id)
        .get();

    return UserModel(
        uid: doc.id,
        username: doc.get('username'),
        imgUrl: doc.get('imageUrl'));
  }

  void _removeFriend(String id) {
    FirebaseFirestore.instance.collection('users').doc(global_User.uid).update({
      'friends': FieldValue.arrayRemove([id])
    });
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'friends': FieldValue.arrayRemove([global_User.uid])
    });

    Fluttertoast.showToast(msg: "Friend removed");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: _loadUser(),
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data.imgUrl),
                    radius: 28,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:Text(
                          snapshot.data.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),                      
                      ElevatedButton(
                        child: Text("Unfriend"),
                        onPressed: () {
                          _removeFriend(snapshot.data.uid);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(id: snapshot.data.uid)));
              });
        });
  }
}
