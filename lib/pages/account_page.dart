import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/ults/ults.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget{
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
  
}

class _AccountPageState extends State<AccountPage> {

  TextEditingController _usernameControler = TextEditingController();
  TextEditingController _infoControler = TextEditingController();
  String _imageUrl;

  File _imageFile;

  var _menuOption = ['Take Photo','Pick Photo'];


  @override
  void initState() {
    super.initState();
      _imageUrl = global_User.imgUrl;
      _usernameControler.text = global_User.username;
      _infoControler.text = global_User.info;
  }

  Stream<bool> _changes() async* {
    yield (_imageFile != null || _usernameControler.text != global_User.username || _infoControler.text != global_User.info);
    setState((){});
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  void _selectPhoto(String choice) async{
    PickedFile pickedFile = await ImagePicker().getImage(
      source: choice == "Take Photo" ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 25,
    );
    
    if(_imageFile != null) _imageFile.delete();
    _imageFile = File(pickedFile.path);
  }

  void _cancel(){
    _imageUrl = global_User.imgUrl;
    _usernameControler.text = global_User.username;
    _infoControler.text = global_User.info;

    if(_imageFile != null){
      _imageFile.delete();
      _imageFile = null;
    }
  }

  void _saveChanges() async{
    if (_imageFile != null) {
      var storageRef = FirebaseStorage.instance.ref().child(
          'users/${global_User.uid}.jpg');

      var uploadTask = storageRef.putFile(
        _imageFile,
        SettableMetadata(customMetadata: {
          'uploaded_by': global_User.uid,
        }),
      );
      await uploadTask.whenComplete(() async {
        _imageUrl = await storageRef.getDownloadURL();
      });
    }

    var keywords = generateKeywords(_usernameControler.text);

    FirebaseFirestore.instance
        .collection('users')
        .doc(global_User.uid)
        .update({
          'username': _usernameControler.text,
          'info': _infoControler.text,
          'imageUrl': _imageUrl,
          'keywords': keywords,
        });

    global_User = UserModel(
      uid: global_User.uid,
      username: _usernameControler.text,
      imgUrl: _imageUrl,
      info: _infoControler.text,
    );

    if(_imageFile != null){
      _imageFile.delete();
      _imageFile = null;
    }

    Fluttertoast.showToast(msg: "Account Updated");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: StreamBuilder(
        stream: _changes(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) return Container();
          return ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: double.infinity,
              height: double.infinity,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if(_imageUrl != null) CircleAvatar(
                        backgroundImage: _imageFile == null ? NetworkImage(_imageUrl) : Image.file(_imageFile).image,
                        radius: 48,
                      ),
                      SizedBox(height: 10,),
                      PopupMenuButton(
                        child:  Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Text(
                            'Change Avatar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ),
                        onSelected: _selectPhoto,
                        itemBuilder: (BuildContext context) {
                          return _menuOption.map((String choice) {
                            return  PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );}
                          ).toList();
                        },
                      ),

                      SizedBox(height: 40,),
                      TextField(
                        controller: _usernameControler,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            fontSize: 14
                          ),
                          border: OutlineInputBorder(
                          ),
                          labelText: 'Username',
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: _infoControler,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            fontSize: 14
                          ),
                          border: OutlineInputBorder(
                          ),
                          labelText: 'Info',
                        ),
                      ),
                      if(snapshot.data) Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                child: Text('Cancel'),
                                onPressed: _cancel,
                              ),
                              SizedBox(width: 10,),
                              ElevatedButton(
                                child: Text('Save Changes'),
                                onPressed: _saveChanges,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          );
        },
      )

    );
  }
  
}



// class AccountPage extends StatelessWidget {
//   final String name;
//
//   const AccountPage({
//     @required this.name,
//     Key key,
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             backgroundColor: Colors.deepOrange,
//             title: Align (
//                 child: Text("Profile"),
//                 alignment: Alignment.centerLeft,
//             )
//         ),
//         body: Padding(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: TextField(
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Edit Username',
//                       hintText: 'Enter Edit',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: TextField(
//                     autofocus: true,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Password',
//                       hintText: 'Enter Edit Password',
//                     ),
//                   ),
//                 ),
//
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: TextField(
//                     autofocus: true,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Email',
//                       hintText: 'Enter Edit Email',
//                     ),
//                   ),
//                 ),
//
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: TextField(
//                     autofocus: true,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'FirstName',
//                       hintText: 'Enter Edit FirstName',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: TextField(
//                     autofocus: true,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'LastName',
//                       hintText: 'Enter Edit LastName',
//                     ),
//                   ),
//                 ),
//
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: TextField(
//                     autofocus: true,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Phone',
//                       hintText: 'Enter Edit Your Phone',
//                     ),
//                   ),
//                 ),
//
//                 ElevatedButton(
//                   child: ElevatedButton(
//                     child: Text('Update'),
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                       primary: Colors.deepOrange,
//                       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
//                       textStyle: TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold)
//                   ),
//                 ),
//               ],
//             )
//         )
//     );
//   }
// }