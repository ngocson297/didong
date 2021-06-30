import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/welcome_page.dart';
// import 'package:flutter_chat_app/pages/login_page.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomePage(),
    );
  }
}