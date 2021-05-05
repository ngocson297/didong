import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget{
  LoginForm({Key key, this.formKey}) : super(key: key);
  final formKey;
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(Object context) {
    return Container(
      child: Center(child: Text("login")),
    );
  }
}


class SignupForm extends StatefulWidget{
  SignupForm({Key key}) : super(key: key);
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(Object context) {
    return Container(
      child: Center(child: Text("login")),
    );
  }
}