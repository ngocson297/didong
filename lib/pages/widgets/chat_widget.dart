import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/chat_model.dart';
import 'package:flutter_chat_app/pages/conversation_page.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/ults/ults.dart';

class HomeChatItem extends StatelessWidget {
  HomeChatItem({this.snapshot});
  final QueryDocumentSnapshot snapshot;

  Future<ChatModel> _loadChat() async {
    ChatModel model = ChatModel(
        chatId: snapshot.id,
        chatName: snapshot.get("chatName"),
        latestMsg: snapshot.get("latestMsg"),
        time: snapshot.get("time"),
        chatImg: snapshot.get("chatImage"),
        users: snapshot.get("users")
    );

    if(model.users.length <= 2){
      var otherUser = model.users[0] == global_User.uid ? model.users[1] : model.users[0];
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUser)
          .get();
      model.chatImg = doc.data()["imageUrl"];
      model.chatName = doc.data()["username"];
    }

    return model;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatModel>(
        future: _loadChat(),
        builder: (context, AsyncSnapshot<ChatModel> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          return InkWell(
              child: ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data.chatImg), radius: 28,),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        snapshot.data.chatName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(dateTimeFormatTime(snapshot.data.time.toDate()),)
                  ],
                ),
                subtitle: Text(
                  snapshot.data.latestMsg,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ConversationPage(
                        title: snapshot.data.chatName,
                        id: snapshot.data.chatId,
                        users: snapshot.data.users))
                );
              }
          );
        }
    );
  }
}