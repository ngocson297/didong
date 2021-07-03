import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/widgets/login_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    if(_loading) return
    setState(() {
      _loading = true;
    });

    try{
      if(_passwordTextController.text != _verifyTextController.text) throw "Password not match";

      final user = (await _firebaseAuth.createUserWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text)
      ).user;

      if(user != null) {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where("uid", isEqualTo: user.uid)
            .get();

        if (snapshot.docs.isEmpty) {
          FirebaseFirestore.instance
              .collection('users')
              .doc()
              .set({
            'uid': user.uid,
            'username': _nameTextController.text,
            'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/mndd-44ec5.appspot.com/o/default_avatar.png?alt=media&token=36f3e70d-7605-4936-b4b3-5a3602934ff8',
            'info': '',
            'chats': [],
            'friends': [],
          });

          global_User = new UserModel(
              uid: user.uid,
              username: _nameTextController.text,
              imgUrl: 'https://firebasestorage.googleapis.com/v0/b/mndd-44ec5.appspot.com/o/default_avatar.png?alt=media&token=36f3e70d-7605-4936-b4b3-5a3602934ff8'
          );

          Fluttertoast.showToast(msg: "Sign up success");

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => HomePage()));

          return;
        }
      }
      else{
        throw "User already exist";
      }
    }
    catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }
    finally{
      setState(() {
        _loading = false;
      });
    }
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
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => LoginPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
