import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/widgets/login_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/ults/global.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firebaseAuth = FirebaseAuth.instance;
  bool _loading = false;

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _verifyTextController = TextEditingController();

  void _signup() async {
    return;
    setState(() {
      _loading = true;
    });

    User user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: _emailTextController.text, password: _passwordTextController.text)
        ).user;

    if(user != null) {

      var storageRef = FirebaseStorage.instance.ref();


      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("uid",isEqualTo: user.uid)
          .get();

      if(snapshot.docs.isNotEmpty){
        g_User = new UserModel(
            uid: snapshot.docs.first.id,
            username: snapshot.docs.first.data()["username"],
            imgUrl: snapshot.docs.first.data()["imageUrl"]
        );

        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomePage(title: "Chat",)));

        return;
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: _loading?
        CircularProgressIndicator()
        : Column(
          children: [
            TextField(
              controller: _nameTextController,
            ),
            TextField(
              controller: _emailTextController,
            ),
            TextField(
              controller: _passwordTextController,
              obscureText: true,
            ),
            TextField(
              controller: _verifyTextController,
              obscureText: true,
            ),
            ElevatedButton(
              child: Text("SIGNUP"),
              onPressed: _signup,
            ),
            InkWell(
              child: Text("Already have Account? Login!"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
