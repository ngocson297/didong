import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/conversation_page.dart';
import 'package:flutter_chat_app/ults/global.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  bool _isFriend = false;
  bool _isSent = false;
  bool _isReceived = false;


  Future<UserModel> _loadUser() async{
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get();

    return UserModel(
        uid: doc.id,
        username: doc.get('username'),
        imgUrl: doc.get('imageUrl'),
        info: doc.get('info'),
    );
  }

  void _openChat(UserModel user) async{
    var snapshot =  await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: global_User.uid)
        .get();
    var chat = null;
    if(snapshot.docs.isNotEmpty){
      for(var doc in snapshot.docs){
        if(doc.get('users').contains(widget.id)){
          chat = doc;
          break;
        }
      }
    }
    if(chat == null){
      chat = FirebaseFirestore.instance
          .collection('chats')
          .doc();

      chat.set({
        'chatName': '',
        'chatImage': '',
        'group': false,
        'latestMsg': '',
        'time': Timestamp(0,0),
        'users': [global_User.uid, widget.id],
      });
    }
    print(user.username);
    print(chat.id);
    print(chat.get('users'));

    Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationPage(title: user.username,id: chat.id,users: chat.get('users'))));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.black
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder<UserModel>(
          future: _loadUser(),
            builder: (context, AsyncSnapshot<UserModel> snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
              return ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width: double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(snapshot.data.imgUrl), radius: 54,),
                      SizedBox(height: 20,),
                      Text(
                        snapshot.data.username,
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 20,),
                      if(snapshot.data.info != '') Text(
                        '\"' + snapshot.data.info + '\"',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20,),
                      if(widget.id != global_User.uid) Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                            _openChat(snapshot.data);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.messenger_rounded),
                                SizedBox(height: 10,),
                                Text('Start Chat'),
                              ],
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                );
            }
        ),
    );
  }
}
