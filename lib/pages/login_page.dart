import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/signup_page.dart';
import 'package:flutter_chat_app/pages/widgets/login_widget.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    try {
      final user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text))
          .user;

      if (user != null) {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where("uid", isEqualTo: user.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          global_User = new UserModel(
            uid: snapshot.docs.first.id,
            username: snapshot.docs.first.get("username"),
            imgUrl: snapshot.docs.first.get("imageUrl"),
            info: snapshot.docs.first.get('info'),
          );

          Fluttertoast.showToast(msg: "Login success");

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        throw "User not found";
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            // title: Text('Login'),
            title: Align(child: Text("Login"), alignment: Alignment.center)),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 55,
                        color: Colors.deepOrange,
                        fontFamily: 'Festive',
                        shadows: [
                          Shadow(
                            color: Colors.deepOrange,
                            blurRadius: 10.0,
                            offset: Offset(5.0, 5.0),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    autofocus: true,
                    controller: _emailTextController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      icon: Icon(Icons.account_circle_rounded),
                      // border: OutlineInputBorder(),
                      fillColor: Colors.deepOrange,
                      labelText: 'User Name',
                      hintText: 'Enter Your Name',
                    ),
                    cursorColor: Colors.deepOrange,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    autofocus: true,
                    controller: _passwordTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      icon: Icon(Icons.lock_outline),
                      // border: OutlineInputBorder(),
                      fillColor: Colors.deepOrange,
                      labelText: 'Password',
                      hintText: 'Enter Password',
                    ),
                    cursorColor: Colors.deepOrange,
                  ),
                ),
                ElevatedButton(
                  child: Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: _login,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Text("Don't have Account? Sign up!"),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                )
              ],
            )));
  }
}
