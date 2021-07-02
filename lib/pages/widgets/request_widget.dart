import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RequestItem extends StatelessWidget{
  RequestItem({this.snapshot, this.receive});

  final QueryDocumentSnapshot snapshot;
  bool receive = false;

  Future<UserModel> _loadUser() async{
    var doc;
    if(receive){
      doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(this.snapshot.get('from'))
          .get();
    }
    else{
      doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(this.snapshot.get('to'))
          .get();
    }

    return UserModel(
      uid: doc.id,
      username: doc.get('username'),
      imgUrl: doc.get('imageUrl')
    );
  }

  void _removeRequest(){
    FirebaseFirestore.instance
        .collection('requests')
        .doc(this.snapshot.id).delete();

    Fluttertoast.showToast(msg: 'Request Removed');
  }

  void _acceptRequest(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(this.snapshot.get('to'))
        .update({'friends': FieldValue.arrayUnion([this.snapshot.get('from')])});
    FirebaseFirestore.instance
        .collection('users')
        .doc(this.snapshot.get('from'))
        .update({'friends': FieldValue.arrayUnion([this.snapshot.get('to')])});

    FirebaseFirestore.instance
        .collection('requests')
        .doc(this.snapshot.id).delete();

    Fluttertoast.showToast(msg: 'Friend added');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: _loadUser(),
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          return InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                ),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data.imgUrl), radius: 24,),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snapshot.data.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            child: Text("Remove"),
                            onPressed: () {
                              _removeRequest();
                            },
                          ),
                          if(receive) SizedBox(width: 10,),
                          if(receive) ElevatedButton(
                            child: Text("Accept"),
                            onPressed: () {
                              _acceptRequest();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: (){}
          );
        }
    );
  }
}
