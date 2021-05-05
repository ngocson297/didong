import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/ults/ults.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({Key key,this.snapshot, this.sender, this.senderImg}) : super(key: key);
  final QueryDocumentSnapshot snapshot;
  final String sender;
  final String senderImg;

  @override
  State<StatefulWidget> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage>{
  bool _showTime = false;

  Future<MessageModel> _loadMessage() async {
    return MessageModel(
      fromUser: widget.snapshot.data()["from"],
      userName: widget.sender,
      userImage: widget.senderImg,
      content: widget.snapshot.data()["content"],
      imgUrl: widget.snapshot.data()["imageUrl"],
      time: widget.snapshot.data()["time"],
    );
  }


  Widget _chatBubble(bool isUser, String content){
    return InkWell(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue: Colors.black26,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(isUser ? 0 : 20),
            topLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Text(
          content,
          textAlign: TextAlign.justify,
          style: TextStyle(color: isUser ? Colors.white: Colors.black,),
        ),
      ),
      onTap: (){
        setState(() {
          _showTime = !_showTime;
        });
      },
    );
  }
  
  Widget _imageBubble(String url){
    return InkWell(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(url),
        ),
      ),
      onTap: (){
        setState(() {
          _showTime = !_showTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MessageModel>(
        future: _loadMessage(),
        builder: (context, AsyncSnapshot<MessageModel> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          bool isUser = snapshot.data.fromUser == g_User.uid;
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: !isUser ? MainAxisAlignment.start: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !isUser ? CircleAvatar(backgroundImage: NetworkImage(snapshot.data.userImage), radius: 24,)
                    : Container(),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: !isUser ? CrossAxisAlignment.start: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        snapshot.data.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    snapshot.data.imgUrl.isEmpty ?
                    _chatBubble(isUser, snapshot.data.content)
                    : _imageBubble(snapshot.data.imgUrl),
                    if (_showTime) Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(dateTimeFormatTime(snapshot.data.time.toDate()),),
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}