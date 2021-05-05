import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/widgets/login_widget.dart';
import 'package:flutter_chat_app/ults/global.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _firebaseAuth = FirebaseAuth.instance;
  bool _loading = false;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  void _login() async {
    setState(() {
      _loading = true;
    });

    User user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: _emailTextController.text, password: _passwordTextController.text)
        ).user;

    if(user != null) {

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
              controller: _emailTextController,
            ),
            TextField(
              controller: _passwordTextController,
              obscureText: true,
            ),
            ElevatedButton(
              child: Text("LOGIN"),
              onPressed: _login,
            ),
            InkWell(
              child: Text("Don't have Account? Sign up!"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
