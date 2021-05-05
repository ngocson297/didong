import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/signup_page.dart';
import 'package:flutter_config/flutter_config.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text("LOGIN"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LoginPage()));
              },
            ),
            ElevatedButton(
              child: Text("SIGNUP"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SignupPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}