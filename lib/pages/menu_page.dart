import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/pages/account_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/widgets/search_widget.dart';
import 'package:flutter_chat_app/ults/global.dart';
import 'package:flutter_chat_app/pages/widgets/chat_widget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
  }

  void _signOut() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  void _userProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(id: global_User.uid)));
  }

  void _userAccount(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Me"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(global_User.imgUrl),
                  radius: 54,
                ),
                SizedBox(height: 10,),
                Text(
                  global_User.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_rounded),
            title: Text("Profile"),
            onTap: _userProfile,
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text("Privacy"),
          ),
          ListTile(
            leading: Icon(Icons.help_center_outlined),
            title: Text("Help & Support"),
          ),
          ListTile(
            leading: Icon(Icons.account_circle_sharp),
            title: Text("Invite a Friend"),
          ),
          ListTile(
            leading: Icon(Icons.settings_applications_outlined),
            title: Text("Setting"),
            onTap: _userProfile,
          ),
          ListTile(
            leading: Icon(Icons.account_circle_sharp),
            title: Text("Account"),
            onTap: _userAccount,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sign Out"),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }
}
