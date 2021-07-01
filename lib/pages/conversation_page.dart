import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/pages/widgets/conversation_widget.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:giphy_picker/giphy_picker.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:emoji_picker/emoji_picker.dart';

class ConversationPage extends StatefulWidget {
  ConversationPage({Key key, this.title, this.id, this.users}) : super(key: key);
  final String title;
  final String id;
  final List<dynamic> users;

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  int _limit = 10;
  Map _usersdetail = Map<dynamic, dynamic>();
  bool _loading = true;

  bool _showEmoji = false;

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FocusNode _textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    for(var user in widget.users) {
      var doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user)
          .get();
      _usersdetail[user] = {'name': doc.data()["username"], 'img': doc.data()["imageUrl"]};
    }
    setState(() {
      _loading = false;
    });
  }

  void _uploadMessage({String from, String to, String url, Timestamp time, String content}){
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        FirebaseFirestore.instance.collection('messages').doc(),
        {
          'from': from,
          'to': to,
          'imageUrl': url,
          'time': time,
          'content': content,
        },
      );
    });

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(
        FirebaseFirestore.instance.collection('chats').doc(widget.id),
        {
          'time': time,
          'latestMsg': content,
        },
      );
    });
  }

  void _send(){
    if(_textEditingController.text.isEmpty) return;

    var content = _textEditingController.text;
    _textEditingController.clear();

    _uploadMessage(
      from: g_User.uid,
      to: widget.id,
      url: "",
      time: Timestamp.now(),
      content: content,
    );
  }

  List<String> _photoChoices = ["Take Photo","Select Photo"];
  var imageFile;

  void _selectPhoto(String choice) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: choice == "Take Photo"? ImageSource.camera: ImageSource.gallery,
    );

    String fileName = path.basename(pickedFile.path);
    File imageFile = File(pickedFile.path);

    if (pickedFile != null) {
      var storageRef = FirebaseStorage.instance.ref().child('chats/${widget.id}/${fileName}');

      var uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(customMetadata: {
          'uploaded_by': g_User.uid,
        }),
      );
      await uploadTask.whenComplete((){
        storageRef.getDownloadURL().then((url) {
          print(url);
          _uploadMessage(
            from: g_User.uid,
            to: widget.id,
            url: url,
            time: Timestamp.now(),
            content: "Send a photo",
          );
        });
      });
    }
  }

  void _selectGif() async {
    var gif = await GiphyPicker.pickGif(
        context: context,
        apiKey: FlutterConfig.get('GIPHY_KEY')
    );

    if(gif != null){
      _uploadMessage(
        from: g_User.uid,
        to: widget.id,
        url: gif.images.original.url,
        time: Timestamp.now(),
        content: "Send a gif",
      );
    }
  }
  Widget _EmojiPicker(){
    return EmojiPicker(
      // bgColor: Colors.black,
      // indicatorColor: Colors.blue,
      // indicatorColor: Colors.blue,
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      onEmojiSelected: (emoji, category) {
        _textEditingController.text = _textEditingController.text + emoji.emoji;
      },
    );
  }

  Widget _ChatInput(){
    return Row(
      children: [
        PopupMenuButton(
          child:  Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.photo),
          ),
          onSelected: _selectPhoto,
          itemBuilder: (BuildContext context) {
            return _photoChoices.map((String choice) {
              return  PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );}
            ).toList();
          },
        ),
        IconButton(
          icon: Icon(Icons.gif),
          onPressed: _selectGif,
        ),
        IconButton(
          icon: Icon(Icons.face),
          onPressed: () {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            if(_textFieldFocus.hasFocus) _textFieldFocus.unfocus();
          }
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Enter Your Text...",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            controller: _textEditingController,
            focusNode: _textFieldFocus,
            onTap: (){
              setState(() {
                _showEmoji = false;
              });
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          splashRadius: 20,
          onPressed: _send,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading? Center( child: CircularProgressIndicator()) : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .limit(_limit)
                  .orderBy("time", descending: true)
                  .where("to", isEqualTo: widget.id).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();
                return ListView(
                  children: snapshot.data.docs
                      .map<Widget>((message){
                    return ChatMessage(
                          snapshot: message,
                          sender: _usersdetail[message.get("from")]["name"],
                          senderImg: _usersdetail[message.get("from")]["img"],
                        );
                      }).toList(),
                  reverse: true,
                  controller: _listScrollController,
                );
              },
            ),
          ),
          _showEmoji ? _EmojiPicker(): Container(),
          _ChatInput(),
        ],
      ),
    );
  }
}
