import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/signup_page.dart';
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login"),
//       ),
//       body: Center(
//         child: _loading?
//         CircularProgressIndicator()
//         : Column(
//           children: [
//             TextField(
//               controller: _emailTextController,
//             ),
//             TextField(
//               controller: _passwordTextController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Password',
//
//               ),
//             ),
//             ElevatedButton(
//               child: Text("LOGIN",
//               textAlign: TextAlign.center,
//               ),
//               onPressed: _login,
//             ),
//             InkWell(
//               child: Text("Don't have Account? Sign up!"),
//               onTap: () {},
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  autofocus: true,
                  controller: _emailTextController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle_rounded),
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter Your Name',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  autofocus: true,
                  controller: _passwordTextController,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Password',
                  ),
                ),
              ),

              ElevatedButton(
                child: Text("LOGIN",
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
                onPressed: _login,
              ),
              InkWell(
                child: Text("Don't have Account? Sign up!"),
                onTap: () {},
              )
            ],
          )
      )
  );
}
}
