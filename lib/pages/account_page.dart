import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountPage extends StatefulWidget{
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
  
}

class _AccountPageState extends State<AccountPage> {

  TextEditingController _usernameControler = TextEditingController();
  TextEditingController _infoControler = TextEditingController();
  String _imageUrl;



  @override
  void initState() {
    super.initState();
      _imageUrl = global_User.imgUrl;
      _usernameControler.text = global_User.username;
      _infoControler.text = global_User.info;
  }

  Stream<bool> _changes() async* {
    setState((){});
    yield (_imageUrl != global_User.imgUrl || _usernameControler.text != global_User.username || _infoControler.text != global_User.info);
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  void _cancel(){
    _imageUrl = global_User.imgUrl;
    _usernameControler.text = global_User.username;
    _infoControler.text = global_User.info;
  }

  void _saveChanges() async{
    FirebaseFirestore.instance
        .collection('users')
        .doc(global_User.uid)
        .update({
          'username': _usernameControler.text,
          'info': _infoControler.text,
          'imageUrl': _imageUrl,
        });

    global_User = UserModel(
      uid: global_User.uid,
      username: _usernameControler.text,
      imgUrl: _imageUrl,
      info: _infoControler.text,
    );

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
          if (snapshot.hasError) return Container();
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
                        backgroundImage: NetworkImage(_imageUrl),
                        radius: 48,
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        child: Text('Change Avatar'),
                        onPressed: (){},
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